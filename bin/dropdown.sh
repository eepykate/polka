#!/usr/bin/env bash
# tabbed -r 2 st -w '' -n "drop-down-st"
#set -x

[[ -f /tmp/tabbed-status ]] || touch /tmp/tabbed-status

if [[ $(command cat /tmp/tabbed-status) = windowunmap ]]; then
	thing="windowmap" &&
	echo "windowmap" > /tmp/tabbed-status
else
	thing="windowunmap" &&
	echo "windowunmap" > /tmp/tabbed-status
fi

xdotool search --classname "drop-down-st" $thing

## Move to the center of the screen -- Credit to https://askubuntu.com/a/571711
# Get screen height and width
IFS='x' read screenWidth screenHeight < <(xdpyinfo | grep dimensions | grep -o '[0-9x]*' | head -n1)
width=$(xdotool getactivewindow getwindowgeometry --shell | head -4 | tail -1 | sed 's/[^0-9]*//')
height=$(xdotool getactivewindow getwindowgeometry --shell | head -5 | tail -1 | sed 's/[^0-9]*//')

# Get the middle of the primary screen
xrandr -q --current | grep -i 'primary' &>/dev/null || xd="single"
if [[ $xd = single ]]; then
	newPosX=$((screenWidth/2-width/2))
	newPosY=$((screenHeight/2-height/2))
else
	primary="$(xrandr -q --current | grep -i 'primary' | awk '{print $4}')"
	primary="$(echo $primary | awk '{gsub("x", " "); gsub("+", " "); print}')"
	offsetX="$(($(echo $primary | awk '{print $3}') / 2 ))"
	offsetY="$(($(echo $primary | awk '{print $4}') / 2 ))"

	newPosX=$((screenWidth/2-width/2+$offsetX))
	newPosY=$((screenHeight/2-height/2+$offsetY))
fi

xdotool search --classname "drop-down-st" windowmove "$newPosX" "$newPosY"
