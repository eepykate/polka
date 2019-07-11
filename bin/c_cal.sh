#!/usr/bin/env bash

day="$(date +%d | sed -e 's/^0/ /')"
calsh="$(cal | sed -e 's/$/ /g' -e 's/^/ /' )"
cal="$(echo "$calsh" | sed  \
	-e "s/ $day / \<span color=\'#02a4fc\'\>\<b\>$day\<\/b\>\<\/span\> /" \
	-e '1d' \
	-e '8d' \
	-e 's/ <\/b><\/span>$/<\/b><\/span>/' \
	-e 's/ $//g' \
	-e 's/^ //g' \
	-e 's/$/​/')"
top="$(echo "$calsh" | sed \
	-e '1!d' \
	-e 's/ //g' \
	-e 's/[0-9][0-9]*/ &/')"

notify-send "$top" "$cal"
