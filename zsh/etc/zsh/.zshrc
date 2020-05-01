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
set -k                     # Allow comments in shell
setopt auto_cd             # cd by just typing the directory name
unsetopt flowcontrol       # Disable Ctrl-S + Ctrl-Q
. "$ZDOTDIR/aliases"       # Aliases

# custom keybinds
:> "$XDG_CACHE_HOME/zshbinds"
bind() {
	echo "$3() { echo; $2; zle redisplay; }" >> "$XDG_CACHE_HOME/zshbinds"
	echo "zle -N $3; bindkey $1 $3" >> "$XDG_CACHE_HOME/zshbinds"
	unset temp
	. "$XDG_CACHE_HOME/zshbinds"
}

bind ^k "clear; ls" kls
bind ^j "clear; gs" kgs


command_not_found_handler() {
	echo "Attempt to run bad software detected: '$0' (command not found)"
	return 1
}

# fancy prompt
setopt prompt_subst
prompt() {
	unset col char
	git rev-parse --git-dir &>/dev/null && {
		gout="$(git status --porcelain | cut -d' ' -f 1,2)"
		# default git char
		char='!';
		# new file
		[[ "$gout" = *\?\?* ]] && char="?"
		[[ "$gout" = *A* ]]    && char="?"
		# modified, unstaged
		[[ "$gout" = *\ M* ]] && col="1"
		# modified, staged
		[[ "$gout" = *M\ * ]] && col="3"
		# modified, staged & unstaged
		[[ "$gout" = *MM*  ]] && col="2"
	}
	echo "%(?.%F{${col:-16}}.%F{17})%(!.#.${char:-|}) %f"
}
PROMPT=$'$(prompt)'

# vim: ft=bash
