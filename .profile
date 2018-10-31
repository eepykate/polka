if [[ $DESKTOP_SESSION="openbox" ]]; then
export DESKTOP_SESSION="kde"
export XDG_CURRENT_DESKTOP="KDE" 
fi

xset r rate 250 30 &

export PATH="$PATH:$HOME/bin"
export EDITOR="vim"
export TERMINAL="konsole"
export BROWSER="firefox"
export TRUEBROWSER="firefox"




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
