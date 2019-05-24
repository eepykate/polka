#!/bin/sh
#
# draw terminals

# take borders into account
b=$(bspc config border_width)

slop -f '%w %h %x %y' | {
    read -r w h x y

    w=$((w - 2 * b))
    h=$((h - 2 * b))

    # make the newly spawned window floating and with the right geometry
    bspc rule -a \* -o state=floating rectangle="${w}x${h}+${x}+${y}"
}

st
