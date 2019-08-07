xrdb ~/.Xresources &
synclient TouchpadOff=1
compton &
/usr/bin/xset r rate 200 60 &
/usr/bin/sxhkd &
if [[ ! "$DBUS_SESSION_BUS_ADDRESS" ]]; then
	dbus-launch --exit-with-session ~/.xinitrc "$@" &
fi
dunst &
~/.fehbg
xsetroot -cursor_name left_ptr
tabbed -r 2 -n "drop-down-st" st -w '' &
xautolock -time 10 -locker ~/bin/lock &
command -v screen.sh &>/dev/null && screen.sh
mpd
mpDris2 &
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi
exec /usr/local/bin/bspwm
