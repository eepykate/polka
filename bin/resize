#!/bin/sh
#  resize window

case $1 in
	# dimension  direction  fallback-dir  sign
	west)  set -- width right left -;;
	east)  set -- width right left +;;
	north) set -- height bottom top -;;
	south) set -- height bottom top +
esac

# 5% of monitor res
#set -- "$@" "$4$(($(mattr ${1%%[ie]*} "$(pfm)") * 5 / 100 ))"
set -- "$@" "${4}40"

[ "$1" = width  ] && { x=$5; y=0; }
[ "$1" = height ] && { y=$5; x=0; }

# try to resize in one direction
# fall back to the other if it fails
bspc node -z "$2" "$x" "$y" || bspc node -z "$3" "$x" "$y"
