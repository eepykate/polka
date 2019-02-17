#!/bin/bash

pactl="$(pulseaudio-ctl full-status)"
vol="$(echo ${pactl}  | awk '{print $1 "%"}')"
mute="$(echo ${pactl} | awk '{print $2}')"

if [ $mute = yes ]; then
    output="🔇 Muted"
elif [ $mute = no ]; then
    output="🔊 ${vol}"
fi

##           🔊    🔇    

echo "$output"
