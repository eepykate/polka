#     ~/.zshrc     # 
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh      # Syntax Hightlighting in shell
export SUDO_PROMPT="$(tput setaf 4)[sudo]$(tput setaf 3) password for %p:$(tput setaf 7) "      # Colourful sudo prompt
export ZSH="/usr/share/oh-my-zsh"        # oh-my-zsh location
source $ZSH/oh-my-zsh.sh                 # start oh-my-zsh
autoload -U promptinit; promptinit       # Start shell theme daemon 
prompt pure                              # Shell theme
export VISUAL='code'     # Default GUI text editor
export EDITOR='vim'      # Default terminal text editor
#ZSH_THEME="agnoster"    # oh-my-zsh theme
#setopt CORRECT          # Correct wrong commands
source ~/.zprofile       # Execute commands from ~/.zprofile when zsh is opened
source ~/.aliases        # Aliases
stty -ixon               # Disable Ctrl-S && Ctrl-Q
