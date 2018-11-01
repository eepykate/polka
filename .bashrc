#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias blur="xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0"
alias ls='ls --color=auto'
alias ..='cd ..'
alias pu='sudo pacman -Syyu'
alias upd='sudo pacman -Syyu'
alias dt='cd /home/gauge/Desktop'
alias dm='cd /home/gauge/Documents'
alias dl='cd /home/gauge/Downloads'
alias mc='cd /home/gauge/Music'
alias pt='cd /home/gauge/Pictures'
alias vd='cd /home/gauge/Videos'
alias ot='cd "/home/gauge/Documents/Linux Distros/Other"'
alias hm='cd /home/gauge/'
alias ins='sudo pacman -S'
alias rems='sudo pacman -Rs'
alias rem='sudo pacman -R'
alias p='sudo pacman'
alias insa='yaourt -S'
alias csdl="sudo /home/gauge/linux-csgo-downloadfixer/csgo_downloadfixer"
alias bashrc='nano /home/gauge/.bashrc'
alias update-grub="grub-mkconfig -o /boot/grub/grub.cfg"

export PS1="\[$(tput sgr0)\]\[\033[\033[38;5;49m\][\W] \\$ \[$(tput sgr0)\]"

#export THEME=$HOME/.bash/themes/agnoster-bash/agnoster.bash
#
#if [[ -f $THEME ]]; then
#    export DEFAULT_USER=`whoami`
#    source $THEME
#fi

EDITOR=/usr/bin/nano
#eval $(dircolors -b $HOME/.dircolors)

#export XDG_CURRENT_DESKTOP=KDE
