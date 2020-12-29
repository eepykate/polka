#!/bin/sh

xrandr --output DVI-D-0 --off

xcalib -c
xcalib -v -red 1 4.3 100 -green 1 4.3 97 -blue 1 4.5 96 -alter

# X is weird
xrandr --output DVI-D-0 --mode 1440x900 --pos 0x0 --rotate normal --output HDMI-0 --primary --mode 1920x1080 --pos 1440x0 --rotate normal --output DP-0 --off --output DP-1 --off

redshift -o -l 0:0 -m randr:crtc=1 -P -t 7000:7000 -g 0.9:1:1.0 -b 0.65
