#!/usr/bin/env bash

players="$(playerctl -l)"
chosen_player="$(echo -e "$players" | dmenu -i )"
echo "player=\"$chosen_player\"" > /tmp/player