#!/bin/sh -e
#  move cursor to focused window
exit

# pipe then read for clean variable names
{ wmp; wattr whxyb "$(pfw)"; } | {
	read -r mx my
	read -r w h x y b

	# check if the pointer is on the window
	# horizontal
	[ "$((mx >= x+b && mx <= w+x+b))" = 0 ] ||
	# vertical
	[ "$((my >= y+b && my <= h+y+b))" = 0 ]

	# move cursor
	wmp $((x+b + w/2)) $((y+b + h/2))
}
