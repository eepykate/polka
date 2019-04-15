#!/usr/bin/env bash

opts="$(getopt -o h,u --long hide,unhide -- "$@")"
eval set -- "$opts"

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

