#!/bin/bash
day="$(date +%d)"
cal="$(cal | sed -e "s/$day/\<span color=\'#4d9de0\'\>\<b\>$day\<\/b\>\<\/span\>/" -e '1d' -e '8d' -e 's/$/​/')"
top="$(cal | sed '1!d')"

notify-send "$top" "$cal"
