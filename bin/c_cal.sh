#!/usr/bin/env bash

day="$(date +%d)"
cal="$(cal | sed -e "s/$day/\<span color=\'#4d9de0\'\>\<b\>$day\<\/b\>\<\/span\>/" -e '1d' -e '8d' -e 's/$/​/')"
top="$(cal | sed '1!d')"
cal1="$(cal | sed -e "s/$day/\\\\e\\[1;34m$day\\\\e\\[0m/" -e '8d' -e 's/$/​/')"

printf "$cal1\n" 

notify-send "$top" "$cal"
