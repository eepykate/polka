#ZSH stuff
export ZSH="/usr/share/oh-my-zsh"
ZSH_THEME="agnoster"
source $ZSH/oh-my-zsh.sh

#Default terminal text editor
export EDITOR='vim'

#Execute commands from ~/.zprofile when zsh is opened
source ~/.zprofile

#Correct wrong commands
setopt CORRECT

#Powerline sudo prompt
export SUDO_PROMPT="$(/home/$USER/bin/bee)
$(tput setaf 4) sudo $(tput setab 4)$(tput setaf 0)$(echo "\uE0B0")$(tput setab 4)$(tput setaf 0) password for %p $(tput sgr0)$(tput setaf 4)$(echo "\uE0B0")$(tput sgr0) " 

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

#Default GUI text editor
export VISUAL='code'

#Aliases
#Emojis from ~/.emoji file
alias emoji="cat ~/.emoji | grep "
#git - List changed files since last commit
alias gl="git diff --no-commit-id --name-only"
#git - Add all unstaged files to staging area
alias gaa="git add -A"
#git - Commit, add -m "message" after, or --amend
alias gc="git commit"
#git - Push commits to remote repository
alias gp="git push -f"
#git - view status
alias gs="git status"
#Pacman/yay aliases
alias ins="sudo pacman -S"
alias insa="yay -S"
alias upd="sudo pacman -Syu"
alias rem="sudo pacman -R"
alias rems="sudo pacman -Rs"
alias src="sudo pacman -Ss"
alias lst="pacman -Q|cut -f 1 -d ' '"
alias p="sudo pacman"
#Reconfigure openbox
alias obr="openbox --reconfigure"
#Open ZSH shell as root
alias SU="sudo zsh"
#Open blue matrix-like application in current shell
alias mat="cmatrix -C blue"
#ls with icons
alias ls="ls_extended"
alias l="ls_extended"
#Normal ls
alias LS="/usr/bin/ls"
#Kill window (Name of window needed after, like firefox, or vlc)
alias fuck="killall -9"
#Download songs from terminals (https://github.com/yask123/Instant-Music-Downloader)
alias song="instantmusic -s "
alias songs="instantmusic -l "
#Kill current session
alias kills="kill -9 -1"
#Clear cache
alias cc="echo 3 | sudo tee /proc/sys/vm/drop_caches"
#GNU/Linux interjection copypasta
alias rms="echo 'I'\''d just like to interject for a moment.  What you'\''re referring to as Linux,
is in fact, GNU/Linux, or as I'\''ve recently taken to calling it, GNU plus Linux.
Linux is not an operating system unto itself, but rather another free component
of a fully functioning GNU system made useful by the GNU corelibs, shell
utilities and vital system components comprising a full OS as defined by POSIX.

Many computer users run a modified version of the GNU system every day,
without realizing it.  Through a peculiar turn of events, the version of GNU
which is widely used today is often called \"Linux\", and many of its users are
not aware that it is basically the GNU system, developed by the GNU Project.

There really is a Linux, and these people are using it, but it is just a
part of the system they use.  Linux is the kernel: the program in the system
that allocates the machine'\''s resources to the other programs that you run.
The kernel is an essential part of an operating system, but useless by itself;
it can only function in the context of a complete operating system.  Linux is
normally used in combination with the GNU operating system: the whole system
is basically GNU with Linux added, or GNU/Linux.  All the so-called \"Linux\"
distributions are really distributions of GNU/Linux.'"
