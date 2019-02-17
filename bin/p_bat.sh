#!/bin/sh
# Give a battery name (e.g. BAT0) as an argument.

# get xresources colors
for x in "$(xrdb -query | grep color | sed "s/.*\./export /g;s/:\s*/=\"/g;s/$/\"/g" | sed 's/\*//g')"; do 
    eval "$x"; 
done

capacity=$(cat /sys/class/power_supply/"$1"/capacity) || exit
status=$(cat /sys/class/power_supply/"$1"/status)

if [ "$capacity" -ge 75 ]; then
	color="$color10"
elif [ "$capacity" -ge 50 ]; then
	color="$color15"
elif [ "$capacity" -ge 25 ]; then
	color="$color11"
else
	color="$color9"
	warn="! "
fi

[ -z $warn ] && warn=""

[ "$status" = "Charging" ] && color="$color15"

printf "⚡︎ <span color='%s'>%s%s</span>"  "$color"  "$warn"  "$(echo "$capacity" | sed -e 's/$/%/')"
