xrdb ~/.Xresources &
transmission-daemon
synclient TouchpadOff=1
dunst &
compton &
/usr/bin/xset r rate 200 60 &
/usr/bin/sxhkd &
if [[ ! "$DBUS_SESSION_BUS_ADDRESS" ]]; then
	exec dbus-launch --exit-with-session ~/.xinitrc "$@" &
fi
~/.fehbg
xsetroot -cursor_name left_ptr
bar &
start-dropdown.sh &
xautolock -time 10 -locker ~/bin/lock &
command -v screen.sh &>/dev/null && screen.sh
nohup python3 -m http.server --directory ~/.startpage 8200 &>/dev/null &
exec /usr/local/bin/bspwm
