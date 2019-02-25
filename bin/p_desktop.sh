#!/usr/bin/env bash

desktop="$(xdotool get_desktop)"

if [[ $((${desktop} -1)) = -1 ]]; then
    desktops="$(($(xdotool get_num_desktops) -1))"
    case $1 in 
        next) xdotool set_desktop $((${desktop} +1));;
        previous) xdotool set_desktop ${desktops};;
    esac
elif [[ $((${desktop} +1)) = $(xdotool get_num_desktops) ]]; then
    case $1 in 
        next) xdotool set_desktop 0;;
        previous) xdotool set_desktop $((${desktop} -1));;
    esac
else
    case $1 in 
        next) xdotool set_desktop $((${desktop} +1));;
        previous) xdotool set_desktop $((${desktop} -1));;
    esac
fi

hr_desktop="$(($(xdotool get_desktop) +1 ))"

printf " ${hr_desktop}\n"
