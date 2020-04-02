#!/bin/sh

echo "player='$(playerctl -l | rofi -dmenu -i)'" > /tmp/player
