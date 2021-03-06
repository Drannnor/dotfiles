
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

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000
setopt appendhistory beep nomatch notify correct promptsubst
unsetopt autocd extendedglob
bindkey -e
# End of lines configured by zsh-newuser-install

zstyle ':completion:*' rehash true

if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if which ruby >/dev/null && which gem >/dev/null; then
    export PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

if [ -d $HOME/bin ]; then
	export PATH=$HOME/bin:$PATH
fi

# Replace useless Pause Break key with Zenkaku_Hankaku

xmodmap -e 'keycode 127 = Zenkaku_Hankaku'

export VISUAL=vim
export EDITOR=$VISUAL

# Fix the home, end, ctrl+right and ctrl+left keys
bindkey ';5D' emacs-backward-word
bindkey ';5C' emacs-forward-word

if [ -f /usr/share/doc/pkgfile/command-not-found.zsh ]; then
	source /usr/share/doc/pkgfile/command-not-found.zsh
fi

# GIT_PROMPT_EXECUTABLE="haskell"
# ZSH_THEME_GIT_PROMPT_CACHE="yes"
source /usr/lib/zsh-git-prompt/zshrc.sh

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-dwim/init.zsh

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
export XIM_PROGRAM=/usr/bin/ibus-daemon 

setopt histignorespace
setopt HIST_IGNORE_ALL_DUPS

if [ -f ~/.pystartup ]; then
    export PYTHONSTARTUP=~/.pystartup
fi


