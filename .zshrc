#ZSH stuff
export ZSH="/home/gauge/.oh-my-zsh"
ZSH_THEME="agnoster"
source $ZSH/oh-my-zsh.sh

#Allow binaries from /home/gauge/bin to be used as commands
path+=('/home/gauge/bin')

##More GTK support for global menus
export GTK_MODULES="appmenu-gtk-module"
export UBUNTU_MENUPROXY

#Default GUI text editor
export VISUAL='code'

#Default terminal text editor
export EDITOR='vim'

#KDE as current Xorg desktop session (For Window Managers)
#export XDG_CURRENT_DESKTOP=KDE

#mkdir and cd
function mc {
  if [ ! -n "$1" ]; then
    echo "Enter a directory name"
  elif [ -d $1 ]; then
    echo "\`$1' already exists"
  else
    mkdir $1 && cd $1
  fi
}

#Powerline sudo prompt
export SUDO_PROMPT="$(tput setaf 4) sudo $(tput setab 4)$(tput setaf 0)$(echo "\uE0B0")$(tput setab 4)$(tput setaf 0) password for %p $(tput sgr0)$(tput setaf 4)$(echo "\uE0B0")$(tput sgr0) "

#Aliases
alias gl="git diff --no-commit-id --name-only"
alias gaa="git add -A"
alias gc="git commit -a "
alias gp="git push -f"
alias gs="git status"
alias ins="sudo pacman -S"
alias insa="yay -S"
alias upd="sudo pacman -Syu"
alias rem="sudo pacman -R"
alias rems="sudo pacman -Rs"
alias src="sudo pacman -Ss"
alias lst="pacman -Q|cut -f 1 -d ' '"
alias p="sudo pacman"
alias SU="sudo zsh"
alias mat="cmatrix -C blue"
alias ls="ls_extended"
alias l="ls_extended"
alias LS="/usr/bin/ls"
alias fuck="killall -9 $1"
alias song="instantmusic -s "
alias songs="instantmusic -l "
alias kills="kill -9 -1"
alias rms="echo I\'d just like to interject for a moment.  What you\'re referring to as Linux, is in fact, GNU/Linux, or as I\'ve recently taken to calling it, GNU plus Linux. Linux is not an operating system unto itself, but rather another free component of a fully functioning GNU system made useful by the GNU corelibs, shell utilities and vital system components comprising a full OS as defined by POSIX.
echo 
echo Many computer users run a modified version of the GNU system every day, without realizing it.  Through a peculiar turn of events, the version of GNU which is widely used today is often called \"Linux\", and many of its users are not aware that it is basically the GNU system, developed by the GNU Project.
echo 
echo There really is a Linux, and these people are using it, but it is just a part of the system they use.  Linux is the kernel: the program in the system that allocates the machine\'s resources to the other programs that you run. The kernel is an essential part of an operating system, but useless by itself\; it can only function in the context of a complete operating system.  Linux is normally used in combination with the GNU operating system: the whole system is basically GNU with Linux added, or GNU/Linux.  All the so-called \"Linux\" distributions are really distributions of GNU/Linux."
