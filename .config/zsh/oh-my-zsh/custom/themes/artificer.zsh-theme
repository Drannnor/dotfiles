# Required for ${VAR} in PROMPT
setopt PROMPT_SUBST

# Cache values so prompt draw is cheap and doesn't interfere with hooks
typeset -g SIMPLERICH_IP=""

_simplerich_update_ip() {
  local ip

  if command -v ifconfig >/dev/null 2>&1 && ifconfig tun0 >/dev/null 2>&1; then
    ip="$(ifconfig tun0 2>/dev/null | awk '/inet / {print $2; exit}')"
    SIMPLERICH_IP="%F{blue}${ip}%f"
  else
    ip="$(ip -4 -o addr show scope global 2>/dev/null | awk '{print $4}' | cut -d/ -f1 | head -n1)"
    if [[ -n "$ip" ]]; then
      SIMPLERICH_IP="%F{green} ${ip}%f"
    else
      SIMPLERICH_IP="%F{red}No IP%f"
    fi
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _simplerich_update_ip

PROMPT='╭─[${SIMPLERICH_IP}][%F{red}%m%f]
╰─[%F{blue}%~%f]➜ '

RPROMPT='%F{yellow}[%*]%f'
