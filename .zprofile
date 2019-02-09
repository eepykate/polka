#     ~/.zprofile     #
source ~/.profile

bindkey '^[[P' delete-char
bindkey '^[[1;5C' forward-word                        # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word                       # [Ctrl-LeftArrow] - move backward one word
bindkey '^r' history-incremental-search-backward      # [Ctrl-r] - Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.

autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search

autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search


bindkey '^[[5~' up-line-or-history       # [PageUp] - Up a line of history
bindkey '^[[6~' down-line-or-history     # [PageDown] - Down a line of history

setopt auto_menu         # show completion menu on successive tab press
setopt complete_in_word
setopt always_to_end

bindkey '^[[Z' reverse-menu-complete   # [Shift-Tab] - move through the completion menu backwards

HISTFILE="$HOME/.zsh_history"

HISTSIZE=420690
SAVEHIST=420690

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on successive tab press
setopt complete_in_word
setopt always_to_end


setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

zstyle ':completion:*:*:*:*:*' menu select

ZSH_CACHE_DIR=$HOME/.cache/zsh

zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR

autoload -U compinit && compinit

setopt auto_cd

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

