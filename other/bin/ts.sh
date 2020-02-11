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

sed --follow-symlinks -i                      \
	                                            \
	-e "s/background:.*/background:   #$bg1/"   \
	-e "s/foreground:.*/foreground:   #$fg1/"   \
	-e "s/cursorColor:.*/cursorColor:  #$fg1/"  \
	                                            \
	-e "s/color0:.*/color0:       #$bg1/"       \
	-e "s/color8:.*/color8:       #$black/"     \
	-e "s/color1:.*/color1:       #$red/"       \
	-e "s/color9:.*/color9:       #$red/"       \
	-e "s/color2:.*/color2:       #$green/"     \
	-e "s/color3:.*/color3:       #$yellow/"    \
	-e "s/color4:.*/color4:       #$blue/"      \
	-e "s/color5:.*/color5:       #$purple/"    \
	-e "s/color6:.*/color6:       #$cyan/"      \
	-e "s/color7:.*/color7:       #$fg2/"       \
	-e "s/color10:.*/color10:      #$green/"    \
	-e "s/color11:.*/color11:      #$yellow/"   \
	-e "s/color12:.*/color12:      #$blue/"     \
	-e "s/color13:.*/color13:      #$purple/"   \
	-e "s/color14:.*/color14:      #$cyan/"     \
	-e "s/color15:.*/color15:      #$fg1/"      \
	                                            \
	-e "s/color16:.*/color16:      #$accent/"   \
	-e "s/color17:.*/color17:      #$false/"    \
	${XDG_CONFIG_HOME:-~/.config}/Xres

sed --follow-symlinks -i \
	-e "s/normbgcolor.*/normbgcolor: #$bg4/" \
	-e "s/normfgcolor.*/normfgcolor: #$fg2/" \
	-e "s/selbgcolor.*/selbgcolor:  #$bg1/" \
	-e "s/selfgcolor.*/selfgcolor:  #$fg1/" \
	${XDG_CONFIG_HOME:-~/.config}/Xresources

echo "   * Reloading tabbed and st"
# Reload terminal colours using Xresources
rc

echo " - firefox"
# Change the colour variables in firefox and my startpage
# $HOME/.startpage/style.css
sed --follow-symlinks -i \
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
	-e "s/--disabled:.*#.*\;/--disabled: #$disabled\;/" \
	${XDG_CONFIG_HOME:-~/.config}/.mozilla/firefox/main/chrome/userChrome.css \
	${XDG_CONFIG_HOME:-~/.config}/.mozilla/firefox/main/chrome/userContent.css \
	${XDG_DATA_HOME:-~/.local/share}/startpage/style.css

echo " - dunst"
# Replace colours in dunst
# urgent notifications
dunst_urgent="$(( $(awk '/urgency_critical/ {print NR}' ${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc) + 1 ))"

# low priority notifications
dunst_low="$(( $(awk '/urgency_low/ {print NR}' ${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc) + 1 ))"


sed --follow-symlinks -i \
	-e "s/frame_color.*/frame_color         = \"#$fg1\"/" \
	-e "s/background.*/background          = \"#$fg1\"/" \
	-e "s/foreground.*/foreground          = \"#$bg1\"/"  \
	${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc

sed --follow-symlinks -i \
	\
	-e "${dunst_urgent}s/background.*/background          = \"#$accent\"/" \
	-e "$(( ${dunst_urgent} + 1 ))s/foreground.*/foreground          = \"#$hover\"/" \
	\
	-e "${dunst_low}s/background.*/background          = \"#$bg4\"/" \
	-e "$(( ${dunst_low} + 1 ))s/foreground.*/foreground          = \"#$fg1\"/" \
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
	-e "s/normal_border_color \"#.*\"/normal_border_color \"#$bg2\"/g" \
	-e "s/focused_border_color \"#.*\"/focused_border_color \"#$bg4\"/g" \
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
