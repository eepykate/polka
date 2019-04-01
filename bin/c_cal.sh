#!/usr/bin/env bash

day="$(date +%d | sed -e 's/^0/ /')"
calsh="$(cal | sed -e 's/$/ /g' -e 's/^/ /' )"
cal="$(echo "$calsh" | sed  -e "s/ $day / \<span color=\'#02a4fc\'\>\<b\>$day\<\/b\>\<\/span\> /" -e '1d' -e '8d' -e 's/ $//g' -e 's/ <\/b><\/span>$/<\/b><\/span>/' -e 's/$/​/' -e 's/^ //')"
top="$(echo "$calsh" | sed '1!d')"
cal1="$(echo "$calsh" | sed -e "s/ $day / \\\\e\\[1;34m$day\\\\e\\[0m /" -e '8d' -e 's/ $//' -e 's/ $//' -e 's/ \\e\[0m$/\\e\[0m/' -e 's/$/​/' -e 's/^ //')"

printf "$cal1\n" 

notify-send "$top" "$cal"
