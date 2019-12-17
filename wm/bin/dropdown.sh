#!/bin/sh
#
# Requires
# - xdotool
# - disputils
# - wmutils
#

[ -f /tmp/tabbed-status ] || touch /tmp/tabbed-status

# query wether to hide or show the term
if [ "$(cat /tmp/tabbed-status)" = windowunmap ]; then
	thing="windowmap" &&
	echo "windowmap" > /tmp/tabbed-status
else
	thing="windowunmap" &&
	echo "windowunmap" > /tmp/tabbed-status
fi

# Get screen height and width
sw="$(dattr w "$(pfd)")"
sh="$(dattr h "$(pfd)")"
sx="$(dattr x "$(pfd)")"
sy="$(dattr y "$(pfd)")"

# un/hide the window
xdotool search --classname "drop-down-st" $thing

# get width and height of the focused window
ww="$(wattr w "$(pfw)")"
wh="$(wattr h "$(pfw)")"

# Get the middle of the primary screen
newPosX=
newPosY=

# move the window to the center of the screen
xdotool search --classname "drop-down-st" \
	windowmove "$((sw + sx - $((sw / 2)) - $((ww / 2))))" \
	"$((sh + sy - $((sh / 2)) - $((wh / 2))))"
