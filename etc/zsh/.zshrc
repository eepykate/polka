#     ---
#    zshrc
#     ---
bindkey '^E' end-of-line              # Ctrl-E
bindkey '^[[P' delete-char            # Delete
bindkey '^[[4~' end-of-line           # End
bindkey '^[[3~' delete-char           # Delete
bindkey '^A' beginning-of-line        # Ctrl-A
bindkey '^[[1;5C' forward-word        # Ctrl-RightArrow
bindkey '^[[1;5D' backward-word       # Ctrl-LeftArrow
bindkey '^[[H' beginning-of-line      # Home
bindkey '^?' backward-delete-char     # Backspace
bindkey '^[[5~' up-line-or-history    # PageUp
bindkey '^[[6~' down-line-or-history  # PageDown
bindkey '^[[Z' reverse-menu-complete  # Shift-Tab
bindkey '^r' history-incremental-search-backward  # Ctrl-E

#     ---
#   History
#     ---
HISTSIZE=999999
SAVEHIST=999999
HISTFILE="${XDG_CONFIG_HOME:-~/.config}/zsh_history"
setopt hist_verify             # Show command with history expansion to user before running it
setopt share_history           # Share command history data
setopt extended_history        # Record timestamp of command in HISTFILE
setopt hist_ignore_dups        # Ignore duplicated commands history list
setopt inc_append_history      # Add commands to HISTFILE in order of execution
setopt hist_expire_dups_first  # Delete duplicates first when HISTFILE size exceeds HISTSIZE

# Arrow keys search history
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

#        ---
#   Autocompletion
#        ---
setopt auto_menu         # Show completion menu on successive tab press
setopt always_to_end     # Move cursor to end of word if completed in-word
setopt complete_in_word
ZSH_CACHE_DIR=$HOME/.cache/zsh
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR
autoload -U compinit && compinit -u -d ${XDG_CACHE_HOME:-~/.cache}/zsh/zcompdump-$ZSH_VERSION

#       ---
#   Shell Theme
#       ---
setopt prompt_subst
#PROMPT=$'%(?.%{\e[38;05;16m%}.%{\e[38;05;17m%})%(!.].|)%{\e[0m%} '
PROMPT=$'%{\e[37m%}%2~
%(?.%{\e[38;05;16m%}.%{\e[38;05;17m%})>>%{\e[0m%} '

#        ---
#   Miscellaneous
#        ---
set -k                     # Allow comments in shell
setopt auto_cd             # cd by just typing the directory name
unsetopt flowcontrol       # Disable Ctrl-S + Ctrl-Q
unsetopt menu_complete     # Do not autoselect the first completion entry
source ${XDG_CONFIG_HOME:-~/.config}/aliases   # Aliases
ac="#7baae8"
fa="#c488ec"
echo -ne "\033]4;16;$ac\007"
echo -ne "\033]4;17;$fa\007"

# vim: ft=sh
