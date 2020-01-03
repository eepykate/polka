#!/bin/sh

players="$(playerctl -l)"
chosen_player="$(echo "$players" | rofi -dmenu -i)"
echo "player='$chosen_player'" > /tmp/player
