#!/usr/bin/env bash

if [[ $(command cat /tmp/panelstatus) = windowunmap ]]; then
	thing="windowmap" &&
	echo "windowmap" > /tmp/panelstatus
	bspc config -m HDMI-0 top_padding 38
else
	thing="windowunmap" &&
	echo "windowunmap" > /tmp/panelstatus
	bspc config -m HDMI-0 top_padding 0
fi

ids=$(xdotool search --name "polybar")
for aaa in ${ids[@]}; do
	xdotool $(printf $thing) $aaa
done
