#!/usr/bin/env bash
set -x

while [ "$1" ]; do
	case "$1" in
		-t|--theme) theme="$2"; shift 2;;
		*) break;;
	esac
done

themes="$(ls -1 ~/etc/colours/ | grep -iv 'current\|css')" # List of themes
if [[ -z $theme ]]; then
	theme="$(echo -e "$themes" | menu -i -p "Theme?")" \
		|| exit
fi
ext() {
	echo "Invalid theme ($theme); exiting"; exit
}

# Define the colours in the theme (for rofi, startpage, firefox, dunst, etc)
[[ -f "${XDG_CONFIG_HOME:-~/.config}/colours/$theme" ]] &&
	. "${XDG_CONFIG_HOME:-~/.config}/colours/$theme" ||
	{ echo "Invalid theme '$theme'; exiting"; exit; }

echo -e "Theme chosen: $theme\n"

echo "Changing colours in:"

echo " - firefox"
# Change the colour variables in firefox and my startpage
sed --follow-symlinks -i \
	-e "s/--bg0:.*#.*\;/--bg0:      #$bg0\;/" \
	-e "s/--bg1:.*#.*\;/--bg1:      #$bg1\;/" \
	-e "s/--bg2:.*#.*\;/--bg2:      #$bg2\;/" \
	-e "s/--bg3:.*#.*\;/--bg3:      #$bg3\;/" \
	-e "s/--bg4:.*#.*\;/--bg4:      #$bg4\;/" \
	-e "s/--black:.*#.*\;/--black:    #$black\;/" \
	-e "s/--fg2:.*#.*\;/--fg2:      #$fg2\;/" \
	-e "s/--fg1:.*#.*\;/--fg1:      #$fg1\;/" \
	-e "s/--accent:.*#.*\;/--accent:   #$accent\;/" \
	-e "s/--accent2:.*#.*\;/--accent2:  #$accent2\;/" \
	-e "s/--border:.*#.*\;/--border:   #$border\;/" \
	-e "s/--button:.*#.*\;/--button:   #$button\;/" \
	-e "s/--contrast:.*#.*\;/--contrast: #$contrast\;/" \
	-e "s/--red:.*#.*\;/--red:         #$red\;/" \
	-e "s/--green:.*#.*\;/--green:       #$green\;/" \
	-e "s/--yellow:.*#.*\;/--yellow:      #$yellow\;/" \
	-e "s/--blue:.*#.*\;/--blue:        #$blue\;/" \
	-e "s/--cyan:.*#.*\;/--cyan:        #$cyan\;/" \
	-e "s/--purple:.*#.*\;/--purple:      #$purple\;/" \
	-e "s/--disabled:.*#.*\;/--disabled: #$disabled\;/" \
	${XDG_CONFIG_HOME:-~/.config}/.mozilla/firefox/main/chrome/userChrome.css \
	${XDG_CONFIG_HOME:-~/.config}/.mozilla/firefox/main/chrome/userContent.css

# ripcord

cat << EOF > ~/opt/ripcord.json
{
    "alternate_base": "#$bg1",
    "base": "#$bg1",
    "button": "#$bg4",
    "chat_timestamp": "#$black",
    "disabled_button": "#$bg1",
    "disabled_icon": "#$disabled",
    "disabled_text": "#$disabled",
    "highlight": "#$fg1",
    "highlighted_text": "#$bg1",
    "icon": "#$fg1",
    "text": "#$fg1",
    "unread_badge": "#$bg1",
    "unread_badge_text": "#$fg1",
    "window": "#$bg2"
}
EOF

echo " - xresources"

cat << EOF > ${XDG_CONFIG_HOME:-~/.config}/Xres
*.background:   #$bg1
*.foreground:   #$fg1
*.cursorColor:  #$fg1

*.color0:       #$bg3
*.color8:       #$black

*.color1:       #$red
*.color9:       #$red

*.color2:       #$yellow
*.color10:      #$yellow

*.color3:       #$green
*.color11:      #$green

*.color4:       #$cyan
*.color12:      #$cyan

*.color5:       #$blue
*.color13:      #$blue

*.color6:       #$purple
*.color14:      #$purple

*.color7:       #$fg2
*.color15:      #$fg1

*.color16:      #$accent
*.color17:      #$accent2
*.color18:      #$contrast
EOF

sed --follow-symlinks -i \
	-e "s/normbgcolor.*/normbgcolor: #$bg3/" \
	-e "s/normfgcolor.*/normfgcolor: #$fg2/" \
	-e "s/selbgcolor.*/selbgcolor:  #$bg1/" \
	-e "s/selfgcolor.*/selfgcolor:  #$fg1/" \
	${XDG_CONFIG_HOME:-~/.config}/Xresources

echo "   * Reloading tabbed and st"
rc

echo " - bspwm"
sed --follow-symlinks -i               \
	-e "s/outer=.*/outer='0x$bg1'   # outer/"      \
	-e "s/inner1=.*/inner1='0x$accent'  # focused/"      \
	-e "s/inner2=.*/inner2='0x$black'  # normal/"      \
	~/bin/borders

sed --follow-symlinks -i  \
	-e "s/border_color.*/border_color       '#$bg1'/" \
	-e "s/d_border_color.*/d_border_color      '#$bg1'/" \
	"${XDG_CONFIG_HOME:-~/.config}/bspwm/bspwmrc"
wm -r

#echo " - openbox"
#sed --follow-symlinks -i \
#	-e "s/\(text\.color: \).*/\\1#$contrast/" \
#	-e "s/\(bg\.color: \).*/\\1#$fg1/" \
#	-e "s/\(image\.color: \).*/\\1#$bg1/" \
#	-e "s/\(inactive.*bg\.color: \).*/\\1#$fg2/" \
#	-e "s/\(inactive.*image\.color: \).*/\\1#$fg2/" \
#	-e "s/\(menu.*color: \).*/\\1#$bg1/" \
#	-e "s/\(menu.*text.color: \).*/\\1#$fg2/" \
#	-e "s/\(menu.*active\.bg\.color: \).*/\\1#$bg4/" \
#	~/usr/themes/ob/openbox-3/themerc
#
#openbox --reconfigure

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
	-e "$(( ${dunst_urgent} + 2 ))s/frame_color.*/frame_color         = \"#$accent2\"/" \
	\
	-e "${dunst_low}s/background.*/background          = \"#$bg1\"/" \
	-e "$(( ${dunst_low} + 1 ))s/foreground.*/foreground          = \"#$fg1\"/" \
	-e "$(( ${dunst_low} + 2 ))s/frame_color.*/frame_color         = \"#$fg1\"/" \
	\
	${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc

pkill -9 dunst
sleep 0.1
dunst & disown

#wm -r

echo " - dmenu"
cd ~/opt/git/dmenu
sed --follow-symlinks -i \
	-e "s/Norm].*/Norm] = { \"#$fg2\", \"#$bg1\" },/" \
	-e "s/Sel].*/Sel] = { \"#$fg1\", \"#$bg4\" },/" \
	config.h
make
cp dmenu ~/bin/bin/dmenu

echo " - gtk context menus"
sed --follow-symlinks -i \
	-e "s|^	background-color: #.*|	background-color: #$bg3;|" \
	-e "s|^	color: #.*|	color: #$fg1;|" \
	${XDG_CONFIG_HOME:-~/.config}/gtk-3.0/menus.css


echo -e "\nChanging wallpaper"
	if [[ -f "$HOME/opt/git/Wallpapers/$wall" ]]; then
	wallthing="feh --bg-fill --no-fehbg \"$HOME/opt/git/Wallpapers/$wall\""
	eval $wallthing
else
	walgen "#$wall"
	wallthing="feh --bg-tile --no-fehbg \"$HOME/opt/git/Wallpapers/tile.png\""
	sleep 0.6
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

echo -e "\nSending a notification"
notify-send "Theme changed to $theme"
