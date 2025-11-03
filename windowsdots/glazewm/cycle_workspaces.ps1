# restore_all_alt_tab_windows.ps1
param(
    [int]$DelayMs = 60,
    [int]$TotalWorkspaces = 13,
    [switch]$VerboseLog
)

function Write-Log($msg) { if ($VerboseLog) { Write-Host $msg } }

# ---------- Snapshot: array of displayed workspace names ----------
$startWs = @(
    (glazewm query workspaces | ConvertFrom-Json).data.workspaces |
    Where-Object { $_.isDisplayed } |
    ForEach-Object { [string]$_.name }
)
Write-Log ("[Snapshot] displayed workspaces: " + ($startWs -join ", "))

# ---------- Win32 helper (compatible C#) ----------
if (-not ("AltTabActivator" -as [type])) {
    Add-Type @"
using System;
using System.Text;
using System.Runtime.InteropServices;
using System.Collections.Generic;

public class AltTabActivator {
    private delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    [DllImport("user32.dll")] private static extern bool EnumWindows(EnumWindowsProc cb, IntPtr lp);
    [DllImport("user32.dll")] private static extern bool IsWindowVisible(IntPtr hWnd);
    [DllImport("user32.dll", SetLastError=true)] private static extern int GetWindowText(IntPtr hWnd, StringBuilder sb, int maxCount);
    [DllImport("user32.dll")] private static extern int GetWindowTextLength(IntPtr hWnd);
    [DllImport("user32.dll")] private static extern IntPtr GetShellWindow();
    [DllImport("user32.dll")] private static extern int GetWindowLong(IntPtr hWnd, int nIndex);
    [DllImport("user32.dll")] private static extern bool IsIconic(IntPtr hWnd);
    [DllImport("user32.dll")] private static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")] private static extern bool SetForegroundWindow(IntPtr hWnd);
    [DllImport("user32.dll")] private static extern bool BringWindowToTop(IntPtr hWnd);
    [DllImport("user32.dll")] private static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] private static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint pid);
    [DllImport("kernel32.dll")] private static extern uint GetCurrentThreadId();
    [DllImport("user32.dll")] private static extern bool AttachThreadInput(uint idAttach, uint idAttachTo, bool fAttach);
    [DllImport("user32.dll")] private static extern IntPtr SendMessage(IntPtr hWnd, uint msg, IntPtr wParam, IntPtr lParam);
    [DllImport("user32.dll", SetLastError=true)] private static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
    [DllImport("user32.dll")] private static extern IntPtr SetActiveWindow(IntPtr hWnd);

    private const int GWL_EXSTYLE = -20;
    private const int WS_EX_TOOLWINDOW = 0x00000080;

    private const int SW_RESTORE = 9;
    private const int SW_SHOW = 5;
    private const int SW_SHOWNORMAL = 1;

    private const uint WM_SYSCOMMAND = 0x0112;
    private const int SC_RESTORE = 0xF120;

    private static readonly IntPtr HWND_TOP = IntPtr.Zero;
    private const uint SWP_NOSIZE = 0x0001;
    private const uint SWP_NOMOVE = 0x0002;
    private const uint SWP_SHOWWINDOW = 0x0040;

    public class WinInfo {
        public IntPtr Handle;
        public long HandleLong;
        public string Title;
    }

    private static bool IsAltTabCandidate(IntPtr hWnd) {
        if (hWnd == GetShellWindow()) return false;
        if (!IsWindowVisible(hWnd)) return false;
        int len = GetWindowTextLength(hWnd);
        if (len <= 0) return false;
        int ex = GetWindowLong(hWnd, GWL_EXSTYLE);
        if ((ex & WS_EX_TOOLWINDOW) != 0) return false;
        return true;
    }

    public static List<WinInfo> GetAltTabWindows() {
        var list = new List<WinInfo>();
        EnumWindows(delegate (IntPtr hWnd, IntPtr lParam) {
            if (!IsAltTabCandidate(hWnd)) return true;
            int len = GetWindowTextLength(hWnd);
            StringBuilder sb = new StringBuilder(len + 1);
            GetWindowText(hWnd, sb, sb.Capacity);
            string title = sb.ToString();
            if (!string.IsNullOrWhiteSpace(title)) {
                list.Add(new WinInfo { Handle = hWnd, HandleLong = hWnd.ToInt64(), Title = title });
            }
            return true;
        }, IntPtr.Zero);
        return list;
    }

    public static bool ForceActivate(IntPtr hWnd) {
        if (IsIconic(hWnd)) { ShowWindowAsync(hWnd, SW_RESTORE); }
        else { ShowWindowAsync(hWnd, SW_SHOWNORMAL); ShowWindowAsync(hWnd, SW_SHOW); }

        SetWindowPos(hWnd, HWND_TOP, 0,0,0,0, SWP_NOMOVE | SWP_NOSIZE | SWP_SHOWWINDOW);

        IntPtr fg = GetForegroundWindow();
        uint targetPid; uint targetThread = GetWindowThreadProcessId(hWnd, out targetPid);
        uint fgPid = 0; uint fgThread = fg != IntPtr.Zero ? GetWindowThreadProcessId(fg, out fgPid) : 0;
        uint curThread = GetCurrentThreadId();
        bool attached1 = false, attached2 = false;

        try {
            if (targetThread != 0 && curThread != 0 && targetThread != curThread) {
                attached1 = AttachThreadInput(curThread, targetThread, true);
            }
            if (targetThread != 0 && fgThread != 0 && targetThread != fgThread) {
                attached2 = AttachThreadInput(fgThread, targetThread, true);
            }
            BringWindowToTop(hWnd);
            SetActiveWindow(hWnd);
            SetForegroundWindow(hWnd);
            SendMessage(hWnd, WM_SYSCOMMAND, (IntPtr)SC_RESTORE, IntPtr.Zero);
            return true;
        } finally {
            if (attached1) AttachThreadInput(curThread, targetThread, false);
            if (attached2) AttachThreadInput(fgThread, targetThread, false);
        }
    }
}
"@
}

# ---------- Collect Alt+Tab + GlazeWM-known ----------
$altTab = [AltTabActivator]::GetAltTabWindows()
Write-Host "Alt+Tab candidates: $($altTab.Count)"

$gwNow   = (glazewm query windows | ConvertFrom-Json).data.windows
$gwKnown = @{}
foreach ($w in @($gwNow)) {
    if ($null -ne $w.handle) { $gwKnown[[long]$w.handle] = $w }
}
Write-Host "GlazeWM currently tracks: $($gwKnown.Count) windows"

# ---------- Win32-first for unknowns ----------
$unknown = $altTab | Where-Object { -not $gwKnown.ContainsKey([long]$_.HandleLong) }
[int]$forced = 0
foreach ($w in $unknown) {
    Write-Log ("[Win32] Force-activate HWND={0} '{1}'" -f $w.HandleLong, $w.Title)
    [void][AltTabActivator]::ForceActivate($w.Handle)
    $forced++
    if ($DelayMs -gt 0) { Start-Sleep -Milliseconds $DelayMs }
}

# Let GlazeWM ingest
Start-Sleep -Milliseconds 150

# ---------- Single GlazeWM pass ----------
[int]$gwRestored = 0
$gw2 = (glazewm query windows | ConvertFrom-Json).data.windows
foreach ($w in @($gw2)) {
    if ($w.displayState -ne "shown" -or ($w.state -and $w.state.type -eq "minimized") -or ($w.prevState -and $w.prevState.type -eq "minimized")) {
        Write-Log ("[GlazeWM] focus id={0} title='{1}'" -f $w.id, $w.title)
        glazewm command focus --container-id $w.id | Out-Null
        $gwRestored++
        if ($DelayMs -gt 0) { Start-Sleep -Milliseconds $DelayMs }
    }
}

# ---------- Cycle through all workspaces 1..TotalWorkspaces (re-tiles to avoid stacked max) ----------
for ($wsn = 1; $wsn -le $TotalWorkspaces; $wsn++) {
    glazewm command focus --workspace $wsn | Out-Null
    if ($DelayMs -gt 0) { Start-Sleep -Milliseconds $DelayMs }
}

# ---------- Restore: just focus each workspace we had displayed at the start ----------
foreach ($wsName in $startWs) {
    glazewm command focus --workspace $wsName | Out-Null
    if ($DelayMs -gt 0) { Start-Sleep -Milliseconds $DelayMs }
}

Write-Host "— Summary —"
Write-Host "  Win32 force-activated (unknown to GlazeWM): $forced"
Write-Host "  GlazeWM focused/minimized->shown: $gwRestored"
Write-Host "  Workspaces cycled: $TotalWorkspaces"
Write-Host "  Workspaces restored: $($startWs.Count)"
Write-Host "✅ Done."