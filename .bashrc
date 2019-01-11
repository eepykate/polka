#
# ~/.bashrc
#

source ~/.aliases

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PS1="\[$(tput sgr0)\]\[\033[\033[38;5;49m\][\W] \\$ \[$(tput sgr0)\]"

#export THEME=$HOME/.bash/themes/agnoster-bash/agnoster.bash
#
#if [[ -f $THEME ]]; then
#    export DEFAULT_USER=`whoami`
#    source $THEME
#fi

EDITOR=/usr/bin/nvim
#eval $(dircolors -b $HOME/.dircolors)

#export XDG_CURRENT_DESKTOP=KDE
