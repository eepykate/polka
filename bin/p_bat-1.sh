#!/bin/sh
# Give a battery name (e.g. BAT0) as an argument.

# get xresources colors
for x in "$(xrdb -query | grep color | sed "s/.*\./export /g;s/:\s*/=\"/g;s/$/\"/g" | sed 's/\*//g')"; do 
    eval "$x"; 
done

capacity=$(cat /sys/class/power_supply/"$1"/capacity) || exit
status=$(cat /sys/class/power_supply/"$1"/status)

case "$capacity" in
    [0-9]|1[0-9])         bat="" ;;
    2[0-9])               bat="" ;;
    3[0-9])               bat="" ;;
    4[0-9])               bat="" ;;
    5[0-9])               bat="" ;;
    6[0-9])               bat="" ;;
    7[0-9])               bat="" ;;
    8[0-9])               bat="" ;;
    9[0-9])               bat="" ;;
    *)                    bat="" ;;
esac

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

printf "${warn}${bat}"
