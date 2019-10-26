#!/bin/sh

cp ~/opt/Wallpapers/swirls.svg ~/opt/Wallpapers/pap.svg
sed --follow-symlinks -i \
	-e "s/000000/$bg4/g" \
	-e "s/222222/$bg2/g" \
	~/opt/Wallpapers/pap.svg
inkscape -e ~/opt/Wallpapers/pap.png ~/opt/Wallpapers/pap.svg
feh --bg-tile --no-fehbg ~/opt/Wallpapers/pap.png
