#!/usr/bin/env bash

amix="$(amixer -D pulse get Master | grep -i "\[off\]\|\[on\]" | sed -e '1!d' -e 's/\[//g' -e 's/\]//g')"
#pactl="$(pulseaudio-ctl full-status)"
vol="$(echo ${amix}  | awk '{print $5}')"
mute="$(echo ${amix} | awk '{print $6}')"

if [ $mute = off ]; then
    output="♪ Muted"
elif [ $mute = on ]; then
    output="♪ ${vol}"
fi

##           🔊    🔇    

echo "$output"
