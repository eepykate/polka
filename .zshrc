#ZSH stuff
export ZSH="/usr/share/oh-my-zsh"
ZSH_THEME="agnoster"
source $ZSH/oh-my-zsh.sh
#Syntax Hightlighting in shell
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#Default terminal text editor
export EDITOR='vim'

#Execute commands from ~/.zprofile when zsh is opened
source ~/.zprofile

#Correct wrong commands
setopt CORRECT

#Powerline sudo prompt
export SUDO_PROMPT="$($HOME/bin/bee)
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

#Upload to transfer.sh
transfer() { if [ $# -eq 0 ]; then echo -e "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; } 

#Aliases
#Start openbox (from tty)
alias so="startx openbox-session"
#Emojis from ~/.emoji file
alias emoji="cat ~/.emoji | grep -i "
#git - better git log
alias gl="git log --all --decorate --oneline --graph"
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
