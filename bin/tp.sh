#!/usr/bin/env zsh

monitor="$(xrandr -q | grep primary | awk '{print $1}')"

if [[ $(command cat /tmp/panelstatus) = windowunmap ]]; then
	thing="windowmap" &&
	echo "windowmap" > /tmp/panelstatus
	#bspc config -m HDMI-0 top_padding 3
	bspc config -m $monitor top_padding 3
else
	thing="windowunmap" &&
	echo "windowunmap" > /tmp/panelstatus
	#bspc config -m HDMI-0 top_monocle_padding 0
	bspc config -m $monitor top_padding 0
fi

IFS=$'\n' ids=( $(xdotool search --name "lemonbar") )
for aaa in ${ids[@]}; do
	xdotool $(printf $thing) $aaa
done
