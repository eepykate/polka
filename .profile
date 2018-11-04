#KDE as Desktop Session for openbox, for Qt themes
if [[ $DESKTOP_SESSION="openbox" ]]; then
export DESKTOP_SESSION="kde"
export XDG_CURRENT_DESKTOP="KDE" 
fi

#Faster keyboard repeat rate
xset r rate 250 30 &

#Allow binaries/scripts from ~/bin to be used in shells without absolute path
export PATH="$PATH:$HOME/bin"
#Default terminal editor
export EDITOR="vim"
#Default terminal
export TERMINAL="konsole"
#Default browser
export BROWSER="firefox"
export TRUEBROWSER="firefox"
#10 mins until monitors turn off



#GTK Global menu
if [ -n "$GTK_MODULES" ]; then
    GTK_MODULES="${GTK_MODULES}:appmenu-gtk-module"
else
    GTK_MODULES="appmenu-gtk-module"
fi

if [ -z "$UBUNTU_MENUPROXY" ]; then
    UBUNTU_MENUPROXY=1
fi

export GTK_MODULES
export UBUNTU_MENUPROXY
