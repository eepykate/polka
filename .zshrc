#     ~/.zshrc     #
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh   # Syntax Hightlighting in shell
export SUDO_PROMPT="$(tput setaf 4)[sudo]$(tput setaf 3) password for %p:$(tput setaf 7) "   # Colourful sudo prompt
autoload -U promptinit; promptinit   # Start shell theme daemon
prompt pure                          # Shell theme
source ~/.zprofile                   # Execute commands from ~/.zprofile when zsh is opened
source ~/.aliases                    # Aliases
stty -ixon                           # Disable Ctrl-S && Ctrl-Q
