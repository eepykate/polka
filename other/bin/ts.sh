#!/usr/bin/env bash

set -x

opts="$(getopt -o t:w --long theme:,wallpaper -- "$@")"
eval set -- "$opts"
while true; do
	case $1 in
		-t|--theme) theme="$2"; shift 2;;   # Select theme without using rofi
		-w|--wallpaper) wallpaper="sure"; shift;;   # use rofi to select a wallpaper
		--) shift; break;;
	esac
done

themes="Frost\nCoral\nCoal\nnh\nSnow\nWithered" # List of themes
if [[ -z $theme ]]; then
	theme="$(echo -e "$themes" | rofi -dmenu -i -p "What theme would you like to use?")" \
		|| exit
fi
[[ -n $wallpaper ]] && wallpaper="$(ls $HOME/Wallpapers/*.png | sed 's/.*\///' | rofi -dmenu -i -p "Which Wallpaper?")" # Find png wallpapers in ~/Wallpapers

# Define the colours in the theme (for rofi, startpage, firefox, dunst, etc)
if [[ $theme = Coral ]]; then

	#   -----
	bg0="0E171C"
	bg1="111c23"
	bg2="17242c"
	bg3="1c2d37"
	bg4="$(darken $bg3 1.1)"
	button="edeef01a"
	#   -----
	fg1="edeef0"
	fg2="999ba0"
	disabled="595959"
	#   -----
	accent="f6b2b6"
	false="8ac4ba"
	hover="000000"
	red="d48398"
	#   -----
	wall="$bg0"
	#   -----

elif [[ $theme = Frost ]]; then

	#   -----
	bg0="20242E"
	bg1="232836"
	bg2="282e3f"
	bg3="2f364a"
	bg4="$(darken $bg3 1.1)"
	button="ccccfa1a"
	#   -----
	fg1="ccccfa"
	fg2="8686a4"
	disabled="696969"
	#   -----
	accent="8da4eb"
	false="e9799b"
	hover="ffffff"
	red="e9799b"
	#   -----
	wall="$bg0"
	#   -----

elif [[ $theme = Coal ]]; then

	#   -----
	bg0="151517"
	bg1="18191c"
	bg2="1C1D21"
	bg3="1F2126"
	bg4="262930"
	button="daddee1a"
	#   -----
	fg1="daddee"
	fg2="a6a9b7"
	disabled="696969"
	#   -----
	accent="7baae8"
	false="c488ec"
	hover="ffffff"
	red="e56f92"
	#   -----
	wall="grey_annie-spratt-JsOK6ko9SUo-unsplash.jpg"
	#   -----

elif [[ $theme = nh ]]; then

	#   -----
	bg0="000000"
	bg1="0D0D0D"
	bg2="141414"
	bg3="1A1A1A"
	bg4="1F1F1F"
	button="d9d9d91a"
	#   -----
	fg1="d9d9d9"
	fg2="a9a9a9"
	disabled="696969"
	#   -----
	accent="ed2553"
	false="ff920c"
	hover="ffffff"
	red="ed2553"
	#   -----
	wall="$bg2"
	#   -----

elif [[ $theme = Withered ]]; then

	#   -----
	bg0="FFF6EF"
	bg1="f8efe8"
	bg2="F2E9E3"
	bg3="E6DDD6"
	bg4="$(darken $bg3 0.97)"
	button="4D4D4D16"
	#   -----
	fg1="4D4D4D"
	fg2="999999"
	disabled="595959"
	#   -----
	accent="c48b66"
	false="7bb854"
	hover="f8efe8"
	red="be6767"
	#   -----
	wall="$bg0"
	#   -----

elif [[ $theme = Snow ]]; then

	#   -----
	bg0="ffffff"
	bg1="f8f9fc"
	bg2="F0F2F7"
	bg3="EBEEF5"
	bg4="E3E6ED"
	button="43566f1a"
	#   -----
	fg1="314053"
	fg2="7d8998"
	disabled="595959"
	#   -----
	accent="6796e1"
	false="c185da"
	hover="ffffff"
	red="cd5e79"
	#   -----
	wall="$bg0"
	#   -----

else
	echo "Invalid theme; exiting"; exit
fi


# if ${XDG_CONFIG_HOME:-~/.config}/Xres.<theme> exists, replace the `#include` line in ~/.Xresources to use that theme
[[ -f ${XDG_CONFIG_HOME:-~/.config}/Xres.$theme ]] &&
	sed --follow-symlinks -i "s/#include \"Xres.*\"/#include \"Xres.$theme\"/" ${XDG_CONFIG_HOME:-~/.config}/Xresources

# Reload terminal colours using Xresources
rc

# Change the colour variables in firefox and my startpage
# $HOME/.startpage/style.css
echo "${XDG_CONFIG_HOME:-~/.config}/.mozilla/firefox/gauge.gauge/chrome/userChrome.css
${XDG_CONFIG_HOME:-~/.config}/.mozilla/firefox/gauge.gauge/chrome/userContent.css
${XDG_DATA_HOME:-~/.local/share}/startpage/style.css" | \
	xargs sed --follow-symlinks -i \
	-e "s/--bg0:.*#.*\;/--bg0: #$bg0\;/" \
	-e "s/--bg1:.*#.*\;/--bg1: #$bg1\;/" \
	-e "s/--bg2:.*#.*\;/--bg2: #$bg2\;/" \
	-e "s/--bg3:.*#.*\;/--bg3: #$bg3\;/" \
	-e "s/--bg4:.*#.*\;/--bg4: #$bg4\;/" \
	-e "s/--fg2:.*#.*\;/--fg2: #$fg2\;/" \
	-e "s/--fg1:.*#.*\;/--fg1: #$fg1\;/" \
	-e "s/--accent:.*#.*\;/--accent: #$accent\;/" \
	-e "s/--false:.*#.*\;/--false: #$false\;/" \
	-e "s/--border:.*#.*\;/--border: #$border\;/" \
	-e "s/--button:.*#.*\;/--button: #$button\;/" \
	-e "s/--hover:.*#.*\;/--hover: #$hover\;/" \
	-e "s/--red:.*#.*\;/--red: #$red\;/" \
	-e "s/--disabled:.*#.*\;/--disabled: #$disabled\;/"

# Replace colours in dunst
# urgent notifications
dunst_urgent="$(( $(awk '/urgency_critical/ {print NR}' ${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc) + 1 ))"

# low priority notifications
dunst_low="$(( $(awk '/urgency_low/ {print NR}' ${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc) + 1 ))"


sed --follow-symlinks -i \
	-e "s/frame_color = \".*\"/frame_color = \"#$fg1\"/" \
	-e "s/background = \".*\"/background = \"#$fg1\"/" \
	-e "s/foreground = \".*\"/foreground = \"#$bg1\"/"  \
	${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc

sed --follow-symlinks -i \
	\
	-e "${dunst_urgent}s/background = \".*\"/background = \"#$accent\"/" \
	-e "$(( ${dunst_urgent} + 1 ))s/foreground = \".*\"/foreground = \"#$hover\"/" \
	\
	-e "${dunst_low}s/background = \".*\"/background = \"#$bg4\"/" \
	-e "$(( ${dunst_low} + 1 ))s/foreground = \".*\"/foreground = \"#$fg1\"/" \
	\
	${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc

pkill -9 dunst; dunst &>/dev/null &!

# Change the theme in rofi
sed --follow-symlinks -i \
	-e "s/bg:.*#.*;/bg:         #$bg3;/g" \
	-e "s/fg:.*#.*;/fg:         #$fg1;/" \
	-e "s/accent:.*#.*;/accent:     #$accent;/"\
	-e "s/sel:.*#.*;/sel:        #$button;/"\
	-e "s/hover:.*#.*;/hover:      #$hover;/"\
	${XDG_CONFIG_HOME:-~/.config}/rofi/theme.rasi

# Change lemonbar colours
sed --follow-symlinks -i \
	-e "s/bg=\".*\"/bg=\"$bg1\"/" \
	-e "s/bl=\".*\"/bl=\"$bg2\"/" \
	-e "s/blr=\".*\"/blr=\"$bg3\"/" \
	-e "s/fg=\".*\"/fg=\"$fg1\"/" \
	-e "s/fd=\".*\"/fd=\"$fg2\"/" \
	-e "s/ac=\".*\"/ac=\"$accent\"/" \
	~/bin/bar
# bar &!         # This is now in my bspwmrc

# -e "s/focused_border_color \"#.*\"/focused_border_color \"#$accent\"/g" \
# Change bspwm colours
sed --follow-symlinks -i \
	-e "s/normal_border_color \"#.*\"/normal_border_color \"#$bg2\"/g" \
	-e "s/focused_border_color \"#.*\"/focused_border_color \"#$bg4\"/g" \
	${XDG_CONFIG_HOME:-~/.config}/bspwm/bspwmrc
wm restart

# Change qview colours
sed --follow-symlinks -i \
	-e "s/bgcolor=.*/bgcolor=#$bg1/" \
	${XDG_CONFIG_HOME:-~/.config}/qView/qView.conf

#sed --follow-symlinks -i \
#	-e "s/color [a-zA-Z0-9][a-zA-Z0-9]*/color $bg1/g" \
#	-e "s/color [a-zA-Z0-9][a-zA-Z0-9]*/color $fg2/" \
#	~/etc/conky

#walgen "#$bg3"

#	[[ -d ~/git/usr/icons/$theme/ ]] &&
#		[[ -d ~/usr/icons/Papirus-Dark ]] &&
#		cp -f ~/git/usr/icons/$theme/* ~/usr/icons/Papirus-Dark/32x32/places/

#cp $HOME/usr/icons/folder-blue.svg $HOME/usr/icons/Papirus-Dark/32x32/places/
#sed -i --follow-symlinks \
#	-e "s|000000|$fg2|g" \
#	-e "s|222222|$(darken $fg2 0.9)|g" \
#	$HOME/usr/icons/Papirus-Dark/32x32/places/folder-blue.svg


#cp -rf ~/usr/icons/16x16/ ~/usr/icons/Papirus-Dark/
#cp -r ~/usr/icons/22x22/emblems/* ~/usr/icons/Papirus-Dark/22x22/emblems/
#for f in \
#	16x16/devices/drive-harddisk.svg \
#	16x16/devices/drive-harddisk.svg \
#	16x16/places/folder.svg \
#	16x16/devices/drive-removable-media-usb.svg \
#	16x16/actions/media-eject.svg \
#	22x22/emblems/emblem-symbolic-link.svg \
#	22x22/emblems/emblem-unreadable.svg;
#do
#	sed -i --follow-symlinks \
#		-e "s/fill:#[[a-zA-Z0-9][a-zA-Z0-9]*/fill:#$accent/" \
#		-e "s/stroke:#[[a-zA-Z0-9][a-zA-Z0-9]*/stroke:#$accent/" \
#		${XDG_DATA_HOME:-~/.local/share}/icons/Papirus-Dark/$f
#done

#. swirls.sh

if [[ -f "$HOME/opt/Wallpapers/$wall" ]]; then
	wallthing="feh --bg-fill --no-fehbg \"$HOME/opt/Wallpapers/$wall\""
	eval $wallthing
	sed --follow-symlinks -i \
		-e "s/separator_height.*/separator_height = 0/" \
		-e "s/frame_width.*/frame_width = 0/" \
		${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc
else
	walgen1 "#$wall"
	wallthing="feh --bg-fill --no-fehbg \"$HOME/opt/Wallpapers/tile.png\""
	sed --follow-symlinks -i \
		-e "s/frame_color.*/frame_color = \"#$wall\"/" \
		-e "s/separator_height.*/separator_height = 8/" \
		-e "s/frame_width.*/frame_width = 1/" \
		${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc
fi

echo "#!/bin/sh
$wallthing" > ~/bin/pap

#
# tbf I use like 1 gtk app, this doesn't matter
#

# Reload gtk theme - probably a major hack
#temp="$(mktemp)"
#temp2="$(mktemp)"
#echo "Net/IconThemeName \"Blank\"" > $temp2
#xsettingsd -c $temp2 &
#xse2=$!
#sleep 0.08; kill $xse2

#echo "Net/ThemeName \"$theme\"" > $temp
#echo "Net/IconThemeName \"Papirus-Dark\"" >> $temp
#xsettingsd -c $temp &
#xse=$!
#sleep 0.2; kill $xse
#rm $temp $temp2

# Manually change gtk theme
#sed --follow-symlinks -i "s/gtk-theme-name=\".*\"/gtk-theme-name=\"$theme\"/g" ${XDG_CONFIG_HOME:-~/.config}/gtk-2.0/gtkrc-2.0
#sed --follow-symlinks -i "s/gtk-theme-name=.*/gtk-theme-name=$theme/g" ${XDG_CONFIG_HOME:-~/.config}/gtk-3.0/settings.ini


# tabbed
[[ -e "$HOME/opt/git/tabbed" ]] &&
	cd $HOME/opt/git/tabbed &&
	sed -i \
		-e "s/normbgcolor *=.*/normbgcolor  = \"#$bg4\";/" \
		-e "s/normfgcolor *=.*/normfgcolor  = \"#$fg2\";/" \
		-e "s/selbgcolor *=.*/selbgcolor  = \"#$bg1\";/" \
		-e "s/selfgcolor *=.*/selfgcolor  = \"#$fg1\";/" \
		config.h &&
	sudo make clean install


notify-send "Theme changed to $theme"
