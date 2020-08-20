#!/bin/sh

echo "player='$(playerctl -l | menu)'" > /tmp/player
