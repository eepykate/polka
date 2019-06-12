#!/usr/bin/env zsh

colours=($(xrdb -query | \
grep \*color | \
sed -e 's/\*//' -e 's/color//' -e 's/\://' -e 's/#//' | \
sort -n | \
awk '{print $2}'))

for i in {1..16}; do
	sed -e "${i}!d" -e "s/xd/${colours[${i}]}/" <$HOME/.config/tty-colours-template.sh
done  >$HOME/.config/tty-colours.sh
