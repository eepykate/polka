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

themes="Winter\nCoral\nSnow\nla\nla-1" # List of themes
if [[ -z $theme ]]; then
	theme="$(echo -e "$themes" | rofi -dmenu -i -p "What theme would you like to use?")" \
		|| exit
fi
[[ -n $wallpaper ]] && wallpaper="$(ls $HOME/Wallpapers/*.png | sed 's/.*\///' | rofi -dmenu -i -p "Which Wallpaper?")" # Find png wallpapers in ~/Wallpapers

# Define the colours in the theme (for rofi, startpage, firefox, dunst, etc)
if [[ $theme = Coral ]]; then

	accentn="5"
	false="#8ac4ba"
	bgdark="#111c23"
	bglight="#17242c"
	bglighter="#1c2d37"
	bglightest="#203440"

	fgdark="#999ba0"
	fglight="#edeef0"

	disabled="#595959"
	accent="#f6b2b6"
	button="#edeef01a"
	border="#242e35"
	red="#d48398"
	hover="#000000"

elif [[ $theme = Snow ]]; then

	accentn="1"
	false="#7bb854"
	bgdark="#f7f9ff"
	bglight="#eef0f5"
	bglighter="#e1e4ea"
	bglightest="#D8DBE0"

	fgdark="#909cad"
	fglight="#43566f"

	disabled="#595959"
	accent="#cd5e79"
	button="#43566f1a"
	border="#b0b4bb"
	red="#e09b70"
	hover="#ffffff"

elif [[ $theme = la ]]; then

	accentn="5"
	false="#82a3e7"
	bgdark="#232836"
	bglight="#282e3f"
	bglighter="#2f364a"
	bglightest="#343C52"

	fgdark="#8686a4"
	fglight="#ccccfa"

	disabled="#696969"
	accent="#d86880"
	button="#ccccfa1a"
	border="$bglighter"
	red="#dc8189"
	hover="#ffffff"

elif [[ $theme = la-1 ]]; then

	accentn="5"
	false="#d86880"
	bgdark="#232836"
	bglight="#282e3f"
	bglighter="#2f364a"
	bglightest="#343C52"

	fgdark="#8686a4"
	fglight="#ccccfa"

	disabled="#696969"
	accent="#82a3e7"
	button="#ccccfa1a"
	border="$bglighter"
	red="#dc8189"
	hover="#ffffff"

elif [[ $theme = Winter ]]; then

	accentn="4"
	false="#dc8195"
	bgdark="#232731"
	bglight="#282d39"
	bglighter="#303644"
	bglightest="#363D4D"

	fgdark="#8888a0"
	fglight="#ccccee"

	disabled="#696969"
	accent="#97aae3"
	button="#ccccee1a"
	border="#262c42"
	red="#dc8189"
	hover="#ffffff"

else
	echo "Invalid theme; exiting"; exit
fi

# Remove the `#` from the variables so it doesn't completely fuck up the colours in the css files in case of missing colour
bgdark="${bgdark#?}"
false="${false#?}"
bglight="${bglight#?}"
bglighter="${bglighter#?}"
bglightest="${bglightest#?}"
fgdark="${fgdark#?}"
fglight="${fglight#?}"
disabled="${disabled#?}"
accent="${accent#?}"
button="${button#?}"
border="${border#?}"
hover="${hover#?}"
red="${red#?}"

if [[ -n "$theme" ]]; then
	#xfconf-query -c xsettings -p /Net/ThemeName -s "$theme" # Set GTK theme (In Xfce)
	#xfconf-query -c xfwm4 -p /general/theme -s "$theme"
	# Manually change gtk theme
	sed --follow-symlinks -i "s/gtk-theme-name=\".*\"/gtk-theme-name=\"$theme\"/g" ~/.config/gtk-2.0/gtkrc-2.0
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
		-e "s/.*--bgdark:.*#.*\;/--bgdark: #$bgdark\;/" \
		-e "s/.*--bglight:.*#.*\;/--bglight: #$bglight\;/" \
		-e "s/.*--bglighter:.*#.*\;/--bglighter: #$bglighter\;/" \
		-e "s/.*--fgdark:.*#.*\;/--fgdark: #$fgdark\;/" \
		-e "s/.*--fglight:.*#.*\;/--fglight: #$fglight\;/" \
		-e "s/.*--accent:.*#.*\;/--accent: #$accent\;/" \
		-e "s/.*--border:.*#.*\;/--border: #$border\;/" \
		-e "s/.*--button:.*#.*\;/--button: #$button\;/" \
		-e "s/.*--hover:.*#.*\;/--hover: #$hover\;/" \
		-e "s/.*--disabled:.*#.*\;/--disabled: #$disabled\;/"

	# Replace colours in dunst
	sed --follow-symlinks -i \
		-e "s/frame_color = \".*\"/frame_color = \"#$accent\"/" \
		-e "s/background = \".*\"/background = \"#$accent\"/" \
		-e "s/foreground = \".*\"/foreground = \"#$hover\"/"  \
		${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc

	# Make urgent notifications have a different colour
	dunst_urgent="$(( $(awk '/urgency_critical/ {print NR}' ${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc) + 1 ))"
	sed --follow-symlinks -i "${dunst_urgent}s/background = \".*\"/background = \"#$fglight\"/" ${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc
	sed --follow-symlinks -i "$(( ${dunst_urgent} + 1 ))s/foreground = \".*\"/foreground = \"#$bglight\"/" ${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc

	pkill -9 dunst; dunst &>/dev/null &!

	# Change the theme in rofi
	sed --follow-symlinks -i -e "s/bg:.*#.*;/bg:         #${bgdark};/g" \
		-e "s/fg:.*#.*;/fg:         #$fglight;/" \
		-e "s/accent:.*#.*;/accent:     #$accent;/"\
		-e "s/sel:.*#.*;/sel:        #$button;/"\
		${XDG_CONFIG_HOME:-~/.config}/rofi/theme.rasi

	# Change the wallpaper
	[[ -n $wallpaper ]] &&
		[[ -f ~/Wallpapers/$wallpaper ]] &&
		cp ~/Wallpapers/$wallpaper ~/Wallpapers/Wallpaper.png

	# Change lemonbar colours
	sed --follow-symlinks -i \
		-e "s/bg=\".*\"/bg=\"$bgdark\"/" \
		-e "s/bl=\".*\"/bl=\"$bglight\"/" \
		-e "s/blr=\".*\"/blr=\"$bglighter\"/" \
		-e "s/fg=\".*\"/fg=\"$fglight\"/" \
		-e "s/fd=\".*\"/fd=\"$fgdark\"/" \
		-e "s/ac=\".*\"/ac=\"$accent\"/" \
		~/bin/bar
	# bar &!         # This is now in my bspwmrc

# -e "s/focused_border_color \"#.*\"/focused_border_color \"#$accent\"/g" \
	# Change bspwm colours
	sed --follow-symlinks -i \
		-e "s/normal_border_color \"#.*\"/normal_border_color \"#$accent\"/g" \
		${XDG_CONFIG_HOME:-~/.config}/bspwm/bspwmrc
	wm restart

	# Change qview colours
	sed --follow-symlinks -i \
		-e "s/bgcolor=.*/bgcolor=#$bgdark/" \
		${XDG_CONFIG_HOME:-~/.config}/qView/qView.conf

	#walgen "#$bglighter"

	[[ -d ~/git/usr/icons/$theme/ ]] &&
		[[ -d ~/usr/icons/Papirus-Dark ]] &&
		cp -f ~/git/usr/icons/$theme/* ~/usr/icons/Papirus-Dark/32x32/places/


	for f in devices/drive-harddisk.svg places/folder.svg; do
	sed -i --follow-symlinks \
		"s/fill:#[[a-zA-Z0-9][a-zA-Z0-9]*/fill:#$hover/" \
		${XDG_DATA_HOME:-~/.local/share}/icons/Papirus-Dark/16x16/$f
	done


	cp ~/opt/Wallpapers/swirls.svg ~/opt/Wallpapers/tile.svg
	sed --follow-symlinks -i \
		-e "s/000000/$bglightest/g" \
		-e "s/222222/$bglighter/g" \
		~/opt/Wallpapers/tile.svg
	inkscape -e ~/opt/Wallpapers/tile.png ~/opt/Wallpapers/tile.svg
	feh --bg-tile --no-fehbg ~/opt/Wallpapers/tile.png


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


	#walgen "#$bglighter"

	notify-send "Theme changed to $theme"

fi
