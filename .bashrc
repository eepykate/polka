#
# ~/.bashrc
#

shopt -s autocd

source ~/.profile
source ~/.aliases

export PS1="\[$(tput sgr0)\]\[\033[\033[38;5;49m\][\W] \\$ \[$(tput sgr0)\]"

EDITOR=/usr/bin/nvim
