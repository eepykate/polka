#!/usr/bin/env bash

opts="$(getopt -o t:w --long theme:,wallpaper -- "$@")"
eval set -- "$opts"
while true; do
	case $1 in
		-t|--theme) theme="$2"; shift 2;;   # Select theme without using rofi
		-w|--wallpaper) wallpaper="sure"; shift;;   # use rofi to select a wallpaper
		--) shift; break;;
	esac
done

themes="$(ls -1 ~/etc/colours/)" # List of themes
if [[ -z $theme ]]; then
	theme="$(echo -e "$themes" | rofi -dmenu -i -p "What theme would you like to use?")" \
		|| exit
fi
[[ -n $wallpaper ]] && wallpaper="$(ls $HOME/Wallpapers/*.png | sed 's/.*\///' | rofi -dmenu -i -p "Which Wallpaper?")" # Find png wallpapers in ~/Wallpapers
ext() {
	echo "Invalid theme ($theme); exiting"; exit
}

# Define the colours in the theme (for rofi, startpage, firefox, dunst, etc)
[[ -f "${XDG_CONFIG_HOME:-~/.config}/colours/$theme" ]] &&
	. "${XDG_CONFIG_HOME:-~/.config}/colours/$theme" ||
	ext

echo -e "Theme chosen: $theme\n"

echo "Changing colours in:"

echo " - xresources"

cat << EOF > ${XDG_CONFIG_HOME:-~/.config}/Xres
*.background:   #$bg1
*.foreground:   #$fg1
*.cursorColor:  #$fg1

*.color0:       #$bg1
*.color8:       #$black

*.color1:       #$red
*.color9:       #$red

*.color2:       #$green
*.color10:      #$green

*.color3:       #$yellow
*.color11:      #$yellow

*.color4:       #$blue
*.color12:      #$blue

*.color5:       #$purple
*.color13:      #$purple

*.color6:       #$cyan
*.color14:      #$cyan

*.color7:       #$fg2
*.color15:      #$fg1

*.color16:      #$accent
*.color17:      #$false
EOF

sed --follow-symlinks -i \
	-e "s/normbgcolor.*/normbgcolor: #$bg3/" \
	-e "s/normfgcolor.*/normfgcolor: #$fg2/" \
	-e "s/selbgcolor.*/selbgcolor:  #$bg1/" \
	-e "s/selfgcolor.*/selfgcolor:  #$fg1/" \
	${XDG_CONFIG_HOME:-~/.config}/Xresources

echo "   * Reloading tabbed and st"
# Reload terminal colours using Xresources
rc

echo " - borders"
sed --follow-symlinks -i               \
	-e "s/outer=.*/outer='0x$bg1'   # outer/"      \
	-e "s/inner1=.*/inner1='0x$accent'  # focused/"      \
	-e "s/inner2=.*/inner2='0x$false'  # normal/"      \
	~/bin/wm/borders

echo " - firefox"
# Change the colour variables in firefox and my startpage
sed --follow-symlinks -i \
	-e "s/--bg0:.*#.*\;/--bg0:      #$bg0\;/" \
	-e "s/--bg1:.*#.*\;/--bg1:      #$bg1\;/" \
	-e "s/--bg2:.*#.*\;/--bg2:      #$bg2\;/" \
	-e "s/--bg3:.*#.*\;/--bg3:      #$bg3\;/" \
	-e "s/--bg4:.*#.*\;/--bg4:      #$bg4\;/" \
	-e "s/--fg2:.*#.*\;/--fg2:      #$fg2\;/" \
	-e "s/--fg1:.*#.*\;/--fg1:      #$fg1\;/" \
	-e "s/--accent:.*#.*\;/--accent:   #$accent\;/" \
	-e "s/--false:.*#.*\;/--false:    #$false\;/" \
	-e "s/--border:.*#.*\;/--border:   #$border\;/" \
	-e "s/--button:.*#.*\;/--button:   #$button\;/" \
	-e "s/--hover:.*#.*\;/--hover:    #$hover\;/" \
	-e "s/--red:.*#.*\;/--red:      #$red\;/" \
	-e "s/--disabled:.*#.*\;/--disabled: #$disabled\;/" \
	${XDG_CONFIG_HOME:-~/.config}/.mozilla/firefox/main/chrome/userChrome.css \
	${XDG_CONFIG_HOME:-~/.config}/.mozilla/firefox/main/chrome/userContent.css

echo " - dunst"
# Replace colours in dunst
# urgent notifications
dunst_urgent="$(( $(awk '/urgency_critical/ {print NR}' ${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc) + 1 ))"

# low priority notifications
dunst_low="$(( $(awk '/urgency_low/ {print NR}' ${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc) + 1 ))"


sed --follow-symlinks -i \
	-e "s/background.*/background          = \"#$bg1\"/" \
	-e "s/foreground.*/foreground          = \"#$fg1\"/"  \
	-e "s/frame_color.*/frame_color         = \"#$accent\"/" \
	${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc

sed --follow-symlinks -i \
	\
	-e "${dunst_urgent}s/background.*/background          = \"#$bg1\"/" \
	-e "$(( ${dunst_urgent} + 1 ))s/foreground.*/foreground          = \"#$fg1\"/" \
	-e "$(( ${dunst_urgent} + 2 ))s/frame_color.*/frame_color         = \"#$false\"/" \
	\
	-e "${dunst_low}s/background.*/background          = \"#$bg1\"/" \
	-e "$(( ${dunst_low} + 1 ))s/foreground.*/foreground          = \"#$fg1\"/" \
	-e "$(( ${dunst_low} + 2 ))s/frame_color.*/frame_color         = \"#$fg1\"/" \
	\
	${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc

echo " - rofi"
# Change the theme in rofi
sed --follow-symlinks -i \
	-e "s/bg:.*#.*;/bg:         #$bg3;/g" \
	-e "s/fg:.*#.*;/fg:         #$fg1;/" \
	-e "s/accent:.*#.*;/accent:     #$accent;/"\
	-e "s/sel:.*#.*;/sel:        #$button;/"\
	-e "s/hover:.*#.*;/hover:      #$hover;/"\
	${XDG_CONFIG_HOME:-~/.config}/rofi/theme.rasi

echo " - bspwm"
# -e "s/focused_border_color \"#.*\"/focused_border_color \"#$accent\"/g" \
# Change bspwm colours
sed --follow-symlinks -i \
	-e "s/normal_border_color \"#.*\"/normal_border_color \"#$bg1\"/g" \
	-e "s/focused_border_color \"#.*\"/focused_border_color \"#$bg1\"/g" \
	${XDG_CONFIG_HOME:-~/.config}/bspwm/bspwmrc
wm restart

echo " - gtk context menus"
sed --follow-symlinks -i \
	-e "s|^	background-color: #.*|	background-color: #$bg3;|" \
	-e "s|^	color: #.*|	color: #$fg1;|" \
	${XDG_CONFIG_HOME:-~/.config}/gtk-3.0/menus.css


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

echo -e "\nChanging wallpaper"
	if [[ -f "$HOME/opt/git/Wallpapers/$wall" ]]; then
	wallthing="feh --bg-fill --no-fehbg \"$HOME/opt/git/Wallpapers/$wall\""
	eval $wallthing
else
	walgen1 "#$wall"
	wallthing="feh --bg-fill --no-fehbg \"$HOME/opt/git/Wallpapers/tile.png\""
	sleep 0.6
fi

echo "#!/bin/sh
$wallthing" > ~/bin/x/pap

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


echo -e "\nSending a notification"
notify-send "Theme changed to $theme"
