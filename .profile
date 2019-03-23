#     ~/.profile     #
export QT_QPA_PLATFORMTHEME="qt5ct"  # Qt themes for non-Qt DEs/WMs
xset r rate 200 60                   # Faster keyboard repeat rate
# Default programs                   # Default programs
export EDITOR="nvim"                 # Terminal text editor
export VISUAL="$EDITOR"              # Graphical text editor 
export TERMINAL="st"                 # Terminal
export BROWSER="firefox"             # Web Browser
export FILE="dolphin"                # File manager
export FZF_DEFAULT_OPTS="--layout=reverse --height 60%"

# Custom ls colours
eval "$(dircolors ~/.config/dircolors)" 

# Default user - mainly to hide the user@hostname with agnoster zsh theme
#export DEFAULT_USER="gauge" 

# Places where binaries/scripts go so you dont have to type the whole path to run them
export PATH="$PATH:$HOME/bin:$HOME/.local/bin"

# less/man colors
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m' # reset underline

#if [ "$TTY" = "/dev/tty1" ]; then
#	pgrep -x openbox || exec startx
#fi


if [ "$TERM" = "linux" ]  || [ "$TERM" = "fbterm" ]; then
    echo -en "\e]P012151a" #black
    echo -en "\e]P81f212e" #darkgrey
    echo -en "\e]P1f0185a" #darkred
    echo -en "\e]P9ff4551" #red
    echo -en "\e]P212e689" #darkgreen
    echo -en "\e]PA3aff93" #green
    echo -en "\e]P3ffa463" #brown
    echo -en "\e]PBffdd74" #yellow
    echo -en "\e]P402a4fc" #darkblue
    echo -en "\e]PC34b0fd" #blue
    echo -en "\e]P5ef2ca5" #darkmagenta
    echo -en "\e]PDef5ad7" #magenta
    echo -en "\e]P626c5ff" #darkcyan
    echo -en "\e]PE26c5ff" #cyan
    echo -en "\e]P7aab5c6" #lightgrey
    echo -en "\e]PFd6e5fb" #white
    clear #for background artifacting
fi
