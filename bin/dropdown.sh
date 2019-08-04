#!/usr/bin/env bash
#set -x
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
xrandr="$(xrandr -q)"
# Get screen height and width
IFS='x' read screenWidth screenHeight < <(xdpyinfo | grep dimensions | grep -o '[0-9x]*' | head -n1)
width=$(xdotool getactivewindow getwindowgeometry --shell | head -4 | tail -1 | sed 's/[^0-9]*//')
height=$(xdotool getactivewindow getwindowgeometry --shell | head -5 | tail -1 | sed 's/[^0-9]*//')

cur=( $(xdotool getmouselocation | grep -o '[0-9][0-9]*' ) )

#xrandr=( $(xrandr --query | grep ' connected' | grep -o '[0-9][0-9]*x[0-9][0-9]*+[0-9][0-9]*' | sed 's/[x+]/ /g') )
#xrandr=""
for x in $(grep -i ' connected' <<< $xrandr | awk '{print $1}'); do
	xr=( $(grep -e "$x"  <<< $xrandr | grep ' connected' | grep -o '[0-9][0-9]*x[0-9][0-9]*+[0-9][0-9]*+[0-9][0-9]*' | sed 's/[x+]/ /g') )
	[[ ${cur[1]} -le $(( ${xr[1]} + ${xr[3]} )) ]] &&
	[[ ${cur[0]} -le $(( ${xr[0]} + ${xr[2]} )) ]] &&
		break
done

# Get the middle of the primary screen
# xrandr -q --current | grep -i 'primary' &>/dev/null || xd="single"
#primary="$(grep -i "$x" <<< $xrandr | grep -o '[0-9][0-9]*x[0-9][0-9]*+[0-9][0-9]*+[0-9][0-9]*' | sed 's/[x+]/ /g')"
#offsetX="$(($(echo $primary | awk '{print $3}') / 2 ))"
#offsetY="$(($(echo $primary | awk '{print $4}') / 2 ))"

#newPosX=$((screenWidth/2-width/2+$offsetX))
#newPosY=$((screenHeight/2-height/2+$offsetY))

newPosX="$(( ${xr[0]} + ${xr[2]} - $((${xr[0]} / 2)) - $(($width / 2)) ))"
newPosY="$(( ${xr[1]} + ${xr[3]} - $((${xr[1]} / 2)) - $(($height / 2 )) ))"


xdotool search --classname "drop-down-st" windowmove "$newPosX" "$newPosY"
