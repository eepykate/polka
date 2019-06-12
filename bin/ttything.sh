#!/usr/bin/env zsh

template="echo -en \"\\e]P0xd\"  # black
echo -en \"\\e]P1xd\"  # darkred
echo -en \"\\e]P2xd\"  # darkgreen
echo -en \"\\e]P3xd\"  # brown
echo -en \"\\e]P4xd\"  # darkblue
echo -en \"\\e]P5xd\"  # darkmagenta
echo -en \"\\e]P6xd\"  # darkcyan
echo -en \"\\e]P7xd\"  # lightgrey
echo -en \"\\e]P8xd\"  # darkgrey
echo -en \"\\e]P9xd\"  # red
echo -en \"\\e]PAxd\"  # green
echo -en \"\\e]PBxd\"  # yellow
echo -en \"\\e]PCxd\"  # blue
echo -en \"\\e]PDxd\"  # magenta
echo -en \"\\e]PExd\"  # cyan
echo -en \"\\e]PFxd\"  # white"

colours=($(xrdb -query | \
grep \*color | \
sed -e 's/\*//' -e 's/color//' -e 's/\://' -e 's/#//' | \
sort -n | \
awk '{print $2}'))

for i in {1..16}; do
	sed -e "${i}!d" -e "s/xd/${colours[${i}]}/" <<< $template
done  >$HOME/.config/tty-colours.sh
