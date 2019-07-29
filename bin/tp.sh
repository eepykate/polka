#!/usr/bin/env zsh

monitor="$(xrandr -q | grep primary | awk '{print $1}')"
height="40"
cur="$(bspc config -m $monitor top_padding)"

[[ -z $stat ]] && stat="$(cat /tmp/panelstatus)"

if [[ $stat = windowunmap ]]; then
	thing="windowmap" &&
	if [[ $cur -ge 1 ]]; then
		bspc config -m $monitor top_padding $(( $height + $cur ))
	else
		bspc config -m $monitor top_padding $height
	fi
else
	thing="windowunmap" &&
	if [[ $cur -gt $height ]]; then
		bspc config -m $monitor top_padding $(( $cur - $height ))
	else
		bspc config -m $monitor top_padding 0
	fi
fi
echo "$thing" > /tmp/panelstatus

IFS=$'\n' ids=( $(xdotool search --classname "Bar") )
for aaa in ${ids[@]}; do
	xdotool $(printf $thing) $aaa
done
