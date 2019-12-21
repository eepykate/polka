#     ---
#    zshrc
#     ---
bindkey '^E' end-of-line              # Ctrl-E
bindkey '^[[P' delete-char            # Delete
bindkey '^A' beginning-of-line        # Ctrl-A
bindkey '^[[1;5C' forward-word        # Ctrl-RightArrow
bindkey '^[[1;5D' backward-word       # Ctrl-LeftArrow
bindkey '^[[H' beginning-of-line      # Home
bindkey '^[^M' self-insert-unmeta     # Alt-Return
bindkey '^[[Z' reverse-menu-complete  # Shift-Tab
bindkey '^r' history-incremental-search-backward  # Ctrl-E

#     ---
#   History
#     ---
HISTSIZE=999999
SAVEHIST=999999
HISTFILE="${XDG_CONFIG_HOME:-~/.config}/zsh_history"
setopt extended_history        # Record timestamp of command in HISTFILE
setopt hist_ignore_dups        # Ignore duplicated commands history list
setopt share_history           # Share command history data

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
setopt NO_NOMATCH        # Disable globbing
setopt complete_in_word
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
autoload -U compinit &&
	compinit -u -d ${XDG_CACHE_HOME:-~/.cache}/zsh/zcompdump-$ZSH_VERSION

#       ---
#   Shell Theme
#       ---
PROMPT=$'%(?.%{\e[38;05;16m%}.%{\e[38;05;17m%})%(!.#.>>)%{\e[0m%} '

#        ---
#   Miscellaneous
#        ---
set -k                     # Allow comments in shell
setopt auto_cd             # cd by just typing the directory name
unsetopt flowcontrol       # Disable Ctrl-S + Ctrl-Q
source ${XDG_CONFIG_HOME:-~/.config}/aliases   # Aliases

# vim: ft=sh
