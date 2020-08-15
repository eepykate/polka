#
#   ,=,e
#   zshrc
#

bindkey '^a'       beginning-of-line      # Ctrl-A
bindkey '^e'       end-of-line            # Ctrl-E
bindkey '^[[3~'    delete-char            # Delete
bindkey '^[[1;5C'  forward-word           # Ctrl-RightArrow
bindkey '^[[1;5D'  backward-word          # Ctrl-LeftArrow
bindkey '^[^M'     self-insert-unmeta     # Alt-Return
bindkey '^[[Z'     reverse-menu-complete  # Shift-Tab
bindkey '^r'       history-incremental-search-backward  # Ctrl-E

# edit current command in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^f' edit-command-line

#
#   History
#
HISTSIZE=999999
SAVEHIST=999999
HISTFILE="${XDG_CONFIG_HOME:-~/.config}/sh/zsh_history"
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
autoload -U compinit && compinit -C

#
#   Miscellaneous
#
set -k                     # Allow comments in shell
setopt auto_cd             # cd by just typing the directory name
unsetopt flowcontrol       # Disable Ctrl-S + Ctrl-Q
setopt SHwordsplit
. "$ZDOTDIR/aliases"       # Aliases

kgs() { echo; clear; gs; zle redisplay; }
zle -N kgs; bindkey ^j kgs

kls() { echo; clear; ls; zle redisplay; }
zle -N kls; bindkey ^k kls

# fancy prompts
command_not_found_handler() {
	echo -e "not found:\e[38;05;16m $0\e[0m"
	return 127
}
export SUDO_PROMPT=$'pass for\e[38;05;16m %u\e[0m '
PROMPT=$' %1~%F{%(?.16.17)} %(!.|./) %f'

[ "$TERM" = linux ] &&
	PROMPT=$' %1~%F{%(?.4.1)} %(!.|./) %f'


printf '%7s@%s\n' "$USER" "$HOST"
printf '  \033[7m\033[91m▅▅\033[92m▅▅\033[93m▅▅'
printf '\033[94m▅▅\033[95m▅▅\033[96m▅▅\033[0m\n'
# vim: ft=bash
