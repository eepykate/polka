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

themes="Frost\nCoral\nCoal\nCherry\nAsh\nSnow\nWithered" # List of themes
if [[ -z $theme ]]; then
	theme="$(echo -e "$themes" | rofi -dmenu -i -p "What theme would you like to use?")" \
		|| exit
fi
[[ -n $wallpaper ]] && wallpaper="$(ls $HOME/Wallpapers/*.png | sed 's/.*\///' | rofi -dmenu -i -p "Which Wallpaper?")" # Find png wallpapers in ~/Wallpapers

# Define the colours in the theme (for rofi, startpage, firefox, dunst, etc)
if [[ $theme = Coral ]]; then

	#   -----
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

elif [[ $theme = Frost ]]; then

	#   -----
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

elif [[ $theme = Coal ]]; then

	#   -----
	bg1="18191c"
	bg2="1C1E21"
	bg3="202326"
	bg4="232629"
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

elif [[ $theme = Ash ]]; then

	#   -----
	bg1="1b1b1b"
	bg2="1f1f1f"
	bg3="242424"
	bg4="292929"
	button="bbbbbb16"
	#   -----
	fg1="bbbbbb"
	fg2="888888"
	disabled="888888"
	#   -----
	accent="a8afd7"
	false="dd908d"
	hover="222222"
	red="dd908d"
	#   -----

elif [[ $theme = Cherry ]]; then

	#   -----
	bg1="eeeeee"
	bg2="E8E8E8"
	bg3="E3E3E3"
	bg4="$(darken $bg3 0.95)"
	button="4D4D4D16"
	#   -----
	fg1="4b4e53"
	fg2="70747c"
	disabled="595959"
	#   -----
	accent="c882ca"
	false="8abc6a"
	hover="ffffff"
	red="c96d83"
	#   -----

elif [[ $theme = Withered ]]; then

	#   -----
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

elif [[ $theme = Snow ]]; then

	#   -----
	bg1="f7f9ff"
	bg2="EDF1FA"
	bg3="E6EAF5"
	bg4="DADFED"
	button="43566f1a"
	#   -----
	fg1="43566f"
	fg2="909cad"
	disabled="595959"
	#   -----
	accent="cd5e79"
	false="7bb854"
	hover="ffffff"
	red="cd5e79"
	#   -----

else
	echo "Invalid theme; exiting"; exit
fi


#sed --follow-symlinks -i \
#	-e "s/active.title.bg.color.*/active.title.bg.color: #$fg1/" \
#	-e "s/active.label.bg.color.*/active.label.bg.color: #$fg1/" \
#	-e "s/inactive.title.bg.color.*/inactive.title.bg.color: #$bg1/" \
#	-e "s/inactive.label.bg.color.*/inactive.label.bg.color: #$bg1/" \
#	-e "s/active.label.text.color.*/active.label.text.color: #$bg1/" \
#	-e "s/inactive.label.text.color.*/inactive.label.text.color: #$fg2/" \
#	~/git/.themes/ob/openbox-3/themerc

#openbox --reconfigure

#xfconf-query -c xsettings -p /Net/ThemeName -s "$theme" # Set GTK theme (In Xfce)
#xfconf-query -c xfwm4 -p /general/theme -s "$theme"
# Manually change gtk theme
sed --follow-symlinks -i "s/gtk-theme-name=\".*\"/gtk-theme-name=\"$theme\"/g" ${XDG_CONFIG_HOME:-~/.config}/gtk-2.0/gtkrc-2.0
sed --follow-symlinks -i "s/gtk-theme-name=.*/gtk-theme-name=$theme/g" ${XDG_CONFIG_HOME:-~/.config}/gtk-3.0/settings.ini

#kvantummanager --set "$theme" &>/dev/null # Set Kvantum theme

# if ${XDG_CONFIG_HOME:-~/.config}/Xres.<theme> exists, replace the `#include` line in ~/.Xresources to use that theme
[[ -f ${XDG_CONFIG_HOME:-~/.config}/Xres.$theme ]] &&
	sed --follow-symlinks -i "s/#include \"Xres.*\"/#include \"Xres.$theme\"/" ${XDG_CONFIG_HOME:-~/.config}/.Xresources

sed --follow-symlinks -i \
	-e "s/ac=\".*\"/ac=\"#$accent\"/" \
	-e "s/fa=\".*\"/fa=\"#$false\"/" \
	${XDG_CONFIG_HOME:-~/.config}/zsh/.zshrc
sed --follow-symlinks -i \
	-e "s/ac=\".*\"/ac=\"#$accent\"/" \
	-e "s/fa=\".*\"/fa=\"#$false\"/" \
	~/bin/rc

# Reload terminal colours using Xresources
rc

# Change the colour variables in firefox and my startpage
# $HOME/.startpage/style.css
echo "${XDG_CONFIG_HOME:-~/.config}/.mozilla/firefox/gauge.gauge/chrome/userChrome.css
${XDG_CONFIG_HOME:-~/.config}/.mozilla/firefox/gauge.gauge/chrome/userContent.css
${XDG_DATA_HOME:-~/.local/share}/startpage/style.css" | \
	xargs sed --follow-symlinks -i \
	-e "s/--bg1:.*#.*\;/--bg1: #$bg1\;/" \
	-e "s/--bg2:.*#.*\;/--bg2: #$bg2\;/" \
	-e "s/--bg3:.*#.*\;/--bg3: #$bg3\;/" \
	-e "s/--fg2:.*#.*\;/--fg2: #$fg2\;/" \
	-e "s/--fg1:.*#.*\;/--fg1: #$fg1\;/" \
	-e "s/--accent:.*#.*\;/--accent: #$accent\;/" \
	-e "s/--border:.*#.*\;/--border: #$border\;/" \
	-e "s/--button:.*#.*\;/--button: #$button\;/" \
	-e "s/--hover:.*#.*\;/--hover: #$hover\;/" \
	-e "s/--red:.*#.*\;/--red: #$red\;/" \
	-e "s/--disabled:.*#.*\;/--disabled: #$disabled\;/"

# Replace colours in dunst
sed --follow-symlinks -i \
	-e "s/frame_color = \".*\"/frame_color = \"#$fg2\"/" \
	-e "s/background = \".*\"/background = \"#$bg1\"/" \
	-e "s/foreground = \".*\"/foreground = \"#$fg1\"/"  \
	${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc

# Make urgent notifications have a different colour
#dunst_urgent="$(( $(awk '/urgency_critical/ {print NR}' ${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc) + 1 ))"
#sed --follow-symlinks -i "${dunst_urgent}s/background = \".*\"/background = \"#$fg1\"/" ${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc
#sed --follow-symlinks -i "$(( ${dunst_urgent} + 1 ))s/foreground = \".*\"/foreground = \"#$bg2\"/" ${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc

pkill -9 dunst; dunst &>/dev/null &!

# Change the theme in rofi
sed --follow-symlinks -i -e "s/bg:.*#.*;/bg:         #${bg1};/g" \
	-e "s/fg:.*#.*;/fg:         #$fg1;/" \
	-e "s/accent:.*#.*;/accent:     #$accent;/"\
	-e "s/sel:.*#.*;/sel:        #$button;/"\
	${XDG_CONFIG_HOME:-~/.config}/rofi/theme.rasi

# Change the wallpaper
[[ -n $wallpaper ]] &&
	[[ -f ~/Wallpapers/$wallpaper ]] &&
	cp ~/Wallpapers/$wallpaper ~/Wallpapers/Wallpaper.png

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
	-e "s/normal_border_color \"#.*\"/normal_border_color \"#$fg2\"/g" \
	-e "s/focused_border_color \"#.*\"/focused_border_color \"#$fg1\"/g" \
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

cp $HOME/usr/icons/folder-blue.svg $HOME/usr/icons/Papirus-Dark/32x32/places/
sed -i --follow-symlinks \
	-e "s|000000|$fg2|g" \
	-e "s|222222|$(darken $fg2 0.9)|g" \
	$HOME/usr/icons/Papirus-Dark/32x32/places/folder-blue.svg


cp -rf ~/usr/icons/16x16/ ~/usr/icons/Papirus-Dark/
cp -r ~/usr/icons/22x22/emblems/* ~/usr/icons/Papirus-Dark/22x22/emblems/
for f in \
	16x16/devices/drive-harddisk.svg \
	16x16/devices/drive-harddisk.svg \
	16x16/places/folder.svg \
	16x16/devices/drive-removable-media-usb.svg \
	16x16/actions/media-eject.svg \
	22x22/emblems/emblem-symbolic-link.svg \
	22x22/emblems/emblem-unreadable.svg;
do
	sed -i --follow-symlinks \
		-e "s/fill:#[[a-zA-Z0-9][a-zA-Z0-9]*/fill:#$accent/" \
		-e "s/stroke:#[[a-zA-Z0-9][a-zA-Z0-9]*/stroke:#$accent/" \
		${XDG_DATA_HOME:-~/.local/share}/icons/Papirus-Dark/$f
done


#cp ~/opt/Wallpapers/mnml_crcl.svg ~/opt/Wallpapers/pap.svg
#sed --follow-symlinks -i \
#	-e "s/000000/$bg4/g" \
#	-e "s/ffffff/$fg2/g" \
#	~/opt/Wallpapers/pap.svg
#inkscape -e ~/opt/Wallpapers/pap.png ~/opt/Wallpapers/pap.svg
#feh --bg-fill --no-fehbg ~/opt/Wallpapers/pap.png

walgen1 "#$bg4"


# Reload gtk theme - probably a major hack
temp="$(mktemp)"
temp2="$(mktemp)"
echo "Net/IconThemeName \"Blank\"" > $temp2
xsettingsd -c $temp2 &
xse2=$!
sleep 0.08; kill $xse2

echo "Net/ThemeName \"$theme\"" > $temp
echo "Net/IconThemeName \"Papirus-Dark\"" >> $temp
xsettingsd -c $temp &
xse=$!
sleep 0.2; kill $xse
rm $temp $temp2
#refresh


#walgen "#$bg3"

notify-send "Theme changed to $theme"
