#!/usr/bin/env bash

desktop="$(xdotool get_desktop)"

switch() {
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
}


move() {
	if [[ $((${desktop} -1)) = -1 ]]; then
	    desktops="$(($(xdotool get_num_desktops) -1))"
	    case $1 in 
	        next) xdotool getwindowfocus set_desktop_for_window $((${desktop} +1));;
	        previous) xdotool getwindowfocus set_desktop_for_window ${desktops};;
	    esac
	elif [[ $((${desktop} +1)) = $(xdotool get_num_desktops) ]]; then
	    case $1 in 
	        next) xdotool getwindowfocus set_desktop_for_window 1;;
	        previous) xdotool getwindowfocus set_desktop_for_window $((${desktop} -1));;
	    esac
	else
	    case $1 in 
	        next) xdotool getwindowfocus set_desktop_for_window $((${desktop} +1));;
	        previous) xdotool getwindowfocus set_desktop_for_window $((${desktop} -1));;
	    esac
	fi
}

case $1 in 
	move) move $2; switch $2; shift;;
	switch) switch $2;  shift;;
esac
