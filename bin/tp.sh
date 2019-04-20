#!/usr/bin/env bash

if [[ $(command cat /tmp/panelstatus) = windowunmap ]]; then
	thing="windowmap" &&
	echo "windowmap" > /tmp/panelstatus
else
	thing="windowunmap" &&
	echo "windowunmap" > /tmp/panelstatus
fi

ids=$(xdotool search --name "tint2")
for aaa in ${ids[@]}; do
	xdotool $(printf $thing) $aaa
done

