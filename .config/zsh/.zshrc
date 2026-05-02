# ALEX ZSH CONFIG

# zsh completion
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _ignored _match _correct _approximate _prefix
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' menu select=5
zstyle ':completion:*' prompt 'Possible corrections (%e errors)'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' substitute 1
zstyle ':completion:*' verbose true
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000
# End of lines configured by zsh-newuser-install

zstyle ':completion:*' rehash true

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode reminder

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 10

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$HOME/.config/zsh/oh-my-zsh/custom

plugins=(
    aliases
    fzf
    themes
    tldr
    zoxide
    zsh-autosuggestions
    zsh-interactive-cd
    zsh-syntax-highlighting
    zsh-vi-mode
)

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'

# User configuration
eval "$(pay-respects zsh --alias f)"

alias uzsh='source $HOME/.zshrc'
alias ezsh='nvim $HOME/.zshrc'

alias ls='exa --icons --group-directories-last  -A'
alias tree='exa --icons --group-directories-last  --tree -A'
alias treel='exa --icons --group-directories-last  --tree -lA'
alias treed='exa --icons --group-directories-last  --tree -dA'

eval "$(zoxide init zsh)"

# P4V 
export P4PORT='p4p-dakar2.saber3d.net:1666'
export P4EDITOR='nvim'
export P4USER='achicharo'
export P4CONFIG=.p4config

# GIT
alias gt='git status'
alias ga='git add'
alias gc='git commit -m'

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# MAN
export MANPATH="/usr/share/man"

#PATH UPDATE
export PATH="$HOME/.local/bin:$PATH"

#MARKER
[[ -s "$HOME/.local/share/marker/marker.sh" ]] && source "$HOME/.local/share/marker/marker.sh"

yayfzf() {
    yay -Ss "${*:-}" \
        | awk '/^[^[:space:]]/ {short=$1; sub(/^[^/]+\//,"",short); print short "\t" $1}' \
        | fzf --delimiter=$'\t' --with-nth=1 \
        --preview 'yay -Sii {2} 2>/dev/null || yay -Qi {1} 2>/dev/null' \
        --preview-window='right,70%,wrap' \
        --bind 'enter:become(yay -S -- {1})'
    }

#tmux
tmux-which-key() { tmux show-wk-menu-root ; }
zle -N tmux-which-key
bindkey -M vicmd " " tmux-which-key

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

source /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh
eval "$(starship init zsh)"
