#ZSH stuff
export ZSH="/usr/share/oh-my-zsh"
ZSH_THEME="agnoster"
source $ZSH/oh-my-zsh.sh
#Syntax Hightlighting in shell
source /usr/share/zsh/plugins/fasy-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

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

#Disable Ctrl-S && Ctrl-Q
stty -ixon

#Default GUI text editor
export VISUAL='code'

#Upload to transfer.sh
transfer() { if [ $# -eq 0 ]; then echo -e "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; } 

#Aliases
source ~/.aliases
