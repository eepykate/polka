#!/bin/sh
# Originally by github.com/windelicato
#   modified by github.com/6gk

size=${2:-'40'}
dir=$1

transplanter() { bspc node "$dir" -p south && bspc node -n "$dir"; }
northplanter() { bspc node north -p north && bspc node -n north; }

rootplanter() {
	bspc node @/ -p "$dir" && bspc node -n @/ || bspc node -s next.local && bspc node -n @/
	bspc node @/ -p cancel
}

# Find current window mode
# If the window is floating, move it
if bspc query -T -n | grep -q '"state":"floating"'; then
	# only parse input if window is floating,tiled windows accept input as is
	case "$dir" in
		west) switch="-x"; sign="-";;
		east) switch="-x"; sign="+";;
		north) switch="-y"; sign="-";;
		*) switch="-y"; sign="+";;
	esac
	xdo move $switch "$sign$size"
else  # Otherwise, window is tiled: switch with window in given direction
	if [ "$(bspc query -N -n .local.\!floating | wc -l)" != 2 ]; then
		case "$dir" in
			north) northplanter || rootplanter;;
			*) transplanter || rootplanter
		esac
	else
		case "$dir" in
			east)  set -- east  west south;;
			west)  set -- west  east north;;
			south) set -- south north west;;
			north) set -- north south west 270 90;;
		esac
	fi

	bspc node -s "$1" || bspc query -N -n "$2".local ||
	if bspc query -N -n "$3".local ; then
		bspc node @/ -R "${4:-90}"
	else
		bspc node @/ -R "${5:-270}"
	fi
fi
