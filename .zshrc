#     ~/.zshrc     #
#
#oh-my-zsh
export ZSH="/usr/share/oh-my-zsh"
#ZSH_THEME="agnoster"
source $ZSH/oh-my-zsh.sh
#
#Syntax Hightlighting in shell
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

#Shell theme
autoload -U promptinit; promptinit
prompt pure

#Default terminal text editor
export EDITOR='vim'

#Execute commands from ~/.zprofile when zsh is opened
source ~/.zprofile

#Correct wrong commands
#setopt CORRECT

export SUDO_PROMPT="$(tput setaf 4)[sudo]$(tput setaf 3) password for %p: "


#Disable Ctrl-S && Ctrl-Q
stty -ixon

#Default GUI text editor
export VISUAL='code'

#Aliases
source ~/.aliases
