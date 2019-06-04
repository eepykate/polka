xrdb ~/.Xresources &

dunst &
compton & 
/usr/bin/xset r rate 200 60 &
/usr/bin/sxhkd &
if [ ! "$DBUS_SESSION_BUS_ADDRESS" ] && have dbus-launch; then
	exec dbus-launch --exit-with-session ~/.xinitrc "$@" || exit
fi
~/.fehbg
xsetroot -cursor_name left_ptr
bar1 &
start-dropdown.sh &
xautolock -time 10 -locker ~/bin/lock &
exec /usr/bin/bspwm
