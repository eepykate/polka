#!/usr/bin/env zsh
#  ~/etc/sh/zshrc

set -k                   # allow comments in shell
setopt auto_cd           # cd by just typing the directory name
unsetopt flowcontrol     # disable ^s/^q
. "$ZDOTDIR/aliases"     # aliases
setopt SHwordsplit       # disable zsh's stupid variable auto-quoting

#
#  keybinds
#

bindkey '^a'       beginning-of-line      # ^a
bindkey '^e'       end-of-line            # ^e
bindkey '^[[3~'    delete-char            # delete
bindkey '^[[1;5C'  forward-word           # ^right
bindkey '^[[1;5D'  backward-word          # ^left
bindkey '^[^M'     self-insert-unmeta     # alt-return
bindkey '^[[Z'     reverse-menu-complete  # shift-tab
bindkey '^r'       history-incremental-search-backward  # ^e

load() { autoload -U "$1"; zle -N "$1"; bindkey "$2" "$1"; }

nop() { :; }
load nop '^[[O'

# open current command in EDITOR
load edit-command-line '^f'

# arrow keys search history
load  up-line-or-beginning-search  '^[[A'
load down-line-or-beginning-search '^[[B'

# git status on ^j
kgs() { clear; git status -sb; zle redisplay; }
zle -N kgs; bindkey ^j kgs

# ls on ^k
kls() { clear; ls -A; zle redisplay; }
zle -N kls; bindkey ^k kls

#
#  history
#

HISTSIZE=999999
SAVEHIST=999999
HISTFILE="${ZDOTDIR:-$HOME}/zsh_history"
setopt histignorespace
setopt extended_history  # record timestamp of command in HISTFILE
setopt hist_ignore_dups  # ignore duplicated commands in history
setopt share_history     # save/reload command history without exiting the shell

#
#  autocompletion
#

setopt NO_NOMATCH   # disable "no matching glob" error
setopt complete_in_word
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' matcher-list \
	'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -U compinit && compinit -C

#
#  prompt
#

setopt prompt_subst  # enable command execution in prompt
[ "$SSH_CLIENT" ] && export TERM=linux DISPLAY=:0

topdir() {
	## display dir in top-right
	[ "$PWD" = "$HOME" ] && v='~' || v=${PWD##*/}
	op=${OLDPWD##*/}

	# save cursor pos, move cursor to the top-right
	# then delete the previous contents
	# then print the new dir and restore cursor pos
	printf '%b%b%b' \
		"\033[s\033[0;9999H" \
		"\033[${#op}D\033[K" \
		"\033[999C\033[${#v}D$v\033[u"
}

# fancy prompts
command_not_found_handler() {
	printf 'not found:\033[38;05;%sm %s\033[0m\n' "$acc" "$0" >&2
	return 127
}

export SUDO_PROMPT=$'pass for\033[38;05;${acc}m %u\033[0m '

case $TERM in
	linux) acc=4  acc2=1  PROMPT=' %1~%F{%(?.4.1)} %(!.|./) %f';;
	*)     acc=16 acc2=17 PROMPT=$'%{\e[?25h\e[4 q%}%{$(topdir)%}%F{%(?.$acc.$acc2)} > %f'
esac
