#     ~/.bashrc     #
shopt -s autocd          # Cd into directory without physically typing "cd"
source ~/.profile        # source ~/.profile when bash is opened
source ~/.aliases        # Aliases
stty -ixon               # Disable Ctrl-S && Ctrl-Q

# Colourful sudo prompt
export SUDO_PROMPT="$(tput setaf 4)[sudo]$(tput setaf 3) password for %p:$(tput setaf 7) "

# Bash prompt theme
export PS1="\[$(tput sgr0)\]\[\033[\033[38;5;49m\]$(tput setaf 4)\W $(tput setaf 3)\\$ \[$(tput sgr0)\]"
