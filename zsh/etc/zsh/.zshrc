#
#   zshrc
#

bindkey '^a'       beginning-of-line      # Ctrl-A
bindkey '^e'       end-of-line            # Ctrl-E
bindkey '^[[P'     delete-char            # Delete
bindkey '^[[1;5C'  forward-word           # Ctrl-RightArrow
bindkey '^[[1;5D'  backward-word          # Ctrl-LeftArrow
bindkey '^[^M'     self-insert-unmeta     # Alt-Return
bindkey '^[[Z'     reverse-menu-complete  # Shift-Tab
bindkey '^r'       history-incremental-search-backward  # Ctrl-E

#
#   History
#
HISTSIZE=999999
SAVEHIST=999999
HISTFILE="${XDG_CONFIG_HOME:-~/.config}/zsh/zsh_history"
setopt extended_history   # Record timestamp of command in HISTFILE
setopt hist_ignore_dups   # Ignore duplicated commands history list
setopt share_history      # Share command history data

# Arrow keys search history
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

#
#   Autocompletion
#
setopt NO_NOMATCH        # disable globbing
setopt complete_in_word
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' matcher-list \
	'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -U compinit && compinit -u

#
#   Miscellaneous
#
set +x                     # disable ^z
set -k                     # Allow comments in shell
setopt auto_cd             # cd by just typing the directory name
unsetopt flowcontrol       # Disable Ctrl-S + Ctrl-Q
source "${XDG_CONFIG_HOME:-~/.config}/zsh/aliases"   # Aliases

PROMPT=$'%(?.%F{16m}.%F{17})%(!.#.⊱) %f'

# custom keybinds
:> $XDG_CACHE_HOME/zshbinds
bind() {
	echo "$3() { echo; $2; zle redisplay; }" >> $XDG_CACHE_HOME/zshbinds
	echo "zle -N $3; bindkey $1 $3" >> $XDG_CACHE_HOME/zshbinds
	unset temp
}

bind ^k "clear; ls" kls
bind ^j "clear; gs" kgs

. $XDG_CACHE_HOME/zshbinds

# shellcheck disable=SC1090
# vim: ft=sh
