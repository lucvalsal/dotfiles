# Source shell profile
[ -f "$XDG_CONFIG_HOME/shell/profile" ] && source "$XDG_CONFIG_HOME/shell/profile"
# Source global shell alias
[ -f "$XDG_CONFIG_HOME/shell/aliasrc" ] && source "$XDG_CONFIG_HOME/shell/aliasrc"

PLUGINS_DIR="$XDG_DATA_HOME/zsh/plugins"

# Load modules
autoload -U compinit && compinit
autoload -U colors && colors

PS1="%F{2}%B[%n@%m%b %1~]%f$ "

stty stop undef # Disable ctrl-s which freezes the terminal

# History options
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=1000
SAVEHIST=1000
HISTCONTROL=ignoreboth

zstyle ':completion:*' menu select
zmodload zsh/complist

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vi navigation keys in menu completion 
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

tmux_mode() {
  ~/.local/bin/tmux-toggle
}

lfcd() {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

lfcd_hidden() {
  lfcd --command "set hidden" >/dev/null 2>&1
}

# Open fzf selected file in editor and bind it to ctrl-f
fzfe() {
  local file
	file=$(fzf --tmux 100%,80% --layout=reverse --preview-window=right:70% --exact --highlight-line --preview="bat --color=always {} 2>/dev/null || cat {}")
	[[ -n "$file" ]] && ${EDITOR: -vim} "$file"
}

# Binds
bindkey '^L' clear-screen
bindkey '^A' beginning-of-line

bindkey -s '^o' '^Ulfcd\n'
bindkey -s '[^o' '^Ulfcd_hidden\n'

bindkey -s '^f' '^Ufzfe\n'

autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

bindkey -s '^t' '^Utmux_mode\n'

# Completion dump
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

source "$PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
