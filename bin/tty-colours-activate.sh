for tty in /dev/tty[0-9]; do
	[[ -w $tty ]] &&
		eval /usr/local/bin/tty-colours.sh > $tty
done
clear
