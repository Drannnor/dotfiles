return {
    "scottmckendry/cyberdream.nvim",
    lazy = true,
    config = function(_, opts)
        require('cyberdream').setup(opts)
    end,
    opts = {
        transparent = true, -- Enable transparent background
        italic_comments = true, -- Enable italics comments
        hide_fillchars = true, -- Replace all fillchars with ' ' for the ultimate clean look
        borderless_pickers = true, -- Apply a modern borderless look to pickers like Telescope, Snacks Picker & Fzf-Lua
        terminal_colors = true, -- Set terminal colors used in `:terminal`
        cache = true, -- Improve start up time by caching highlights. Generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache
    }
}
