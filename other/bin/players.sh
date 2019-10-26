#!/usr/bin/env bash

players="$(playerctl -l)"
chosen_player="$(echo -e "$players" | rofi -dmenu -i )"
echo "player=\"$chosen_player\"" > /tmp/player
