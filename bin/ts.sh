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

themes="Winter\nCoral\nxd\nSnow\nla" # List of themes
if [[ -z $theme ]]; then
	theme="$(echo -e "$themes" | rofi -dmenu -i -p "What theme would you like to use?")" \
		|| exit
fi
[[ -n $wallpaper ]] && wallpaper="$(ls $HOME/Wallpapers/*.png | sed 's/.*\///' | rofi -dmenu -i -p "Which Wallpaper?")" # Find png wallpapers in ~/Wallpapers

# Define the colours in the theme (for rofi, startpage, firefox, dunst, etc)
if [[ $theme = Coral ]]; then

	accentn="5"
	bgdark="#111c23"
	bglight="#17242c"
	bglighter="#1c2d37"

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
	bgdark="#f7f9ff"
	bglight="#eef0f5"
	bglighter="#e1e4ea"

	fgdark="#7c8899"
	fglight="#43566f"

	disabled="#595959"
	accent="#cd5e6f"
	button="#43566f1a"
	border="#b0b4bb"
	red="#e09b70"
	hover="#ffffff"

elif [[ $theme = la ]]; then

	accentn="5"
	bgdark="#232836"
	bglight="#282e3f"
	bglighter="#2f364a"

	fgdark="#8686a4"
	fglight="#ccccfa"

	disabled="#696969"
	accent="#c68edf"
	button="#ccccfa1a"
	border="$bglighter"
	red="#dc8189"
	hover="#000000"

elif [[ $theme = Winter ]]; then

	accentn="4"
	bgdark="#232731"
	bglight="#282d39"
	bglighter="#303644"

	fgdark="#8888a0"
	fglight="#ccccee"

	disabled="#696969"
	accent="#97aae3"
	button="#ccccee1a"
	border="#262c42"
	red="#dc8189"
	hover="#000000"

elif [[ $theme = xd ]]; then

	accentn="4"
	bgdark="#1a1f2e"
	bglight="#202537"
	bglighter="#272e44"

	fgdark="#8888a0"
	fglight="#ccccee"

	disabled="#696969"
	accent="#85acff"
	button="#cbe3f122"
	border="#262c42"
	red="#f75e6f"
	hover="#000000"

else
	echo "Invalid theme; exiting"; exit
fi

# Remove the `#` from the variables so it doesn't completely fuck up the colours in the css files in case of missing colour
bgdark="${bgdark#?}"
bglight="${bglight#?}"
bglighter="${bglighter#?}"
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
	sed --follow-symlinks -i "s/gtk-theme-name=\".*\"/gtk-theme-name=\"$theme\"/g" ~/.gtkrc-2.0
	sed --follow-symlinks -i "s/gtk-theme-name=.*/gtk-theme-name=$theme/g" ~/.config/gtk-3.0/settings.ini

	#kvantummanager --set "$theme" &>/dev/null # Set Kvantum theme

	# if ~/.config/Xres.<theme> exists, replace the `#include` line in ~/.Xresources to use that theme
	[[ -f ~/.config/Xres.$theme ]] &&
		sed --follow-symlinks -i "s/#include \".config\/Xres\..*\"/#include \".config\/Xres.$theme\"/" ~/.Xresources

	# Reload terminal colours using Xresources
	rc

	# Replace the accent colour in my zsh prompt
	[[ -n $accentn ]] &&
		sed --follow-symlinks -i "s/color=\".*\"/color=\"$accentn\"/" ~/.zshrc

	# Change the colour variables in firefox and my startpage
	# $HOME/.startpage/style.css
	echo "$HOME/.mozilla/firefox/gauge.gauge/chrome/userChrome.css
$HOME/.mozilla/firefox/gauge.gauge/chrome/userContent.css
$HOME/.startpage/style.css" | \
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
		-e "s/background = \".*\"/background = \"#$bglighter\"/" \
		-e "s/foreground = \".*\"/foreground = \"#$fglight\"/"  \
		~/.config/dunst/dunstrc

	# Make urgent notifications have a different colour
	dunst_urgent="$(( $(awk '/urgency_critical/ {print NR}' ~/.config/dunst/dunstrc) + 1 ))"
	sed --follow-symlinks -i "${dunst_urgent}s/background = \".*\"/background = \"#$fglight\"/" ~/.config/dunst/dunstrc
	sed --follow-symlinks -i "$(( ${dunst_urgent} + 1 ))s/foreground = \".*\"/foreground = \"#$bglight\"/" ~/.config/dunst/dunstrc

	pkill -9 dunst; dunst &>/dev/null &!

	# Change the theme in rofi
	sed --follow-symlinks -i -e "s/bg:.*#.*;/bg:         #${bgdark}aa;/g" \
		-e "s/fg:.*#.*;/fg:         #$fglight;/" \
		-e "s/accent:.*#.*;/accent:     #$accent;/"\
		-e "s/sel:.*#.*;/sel:     #$button;/"\
		~/.config/rofi/theme.rasi

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
		-e "s/normal_border_color \"#.*\"/normal_border_color \"#$bglighter\"/g" \
		~/.config/bspwm/bspwmrc
	wm restart

	# Change qview colours
	sed --follow-symlinks -i \
		-e "s/bgcolor=.*/bgcolor=#$bgdark/" \
		~/.config/qView/qView.conf

	walgen "#$bglighter"

	sleep 0.1
	notify-send "Theme changed to $theme"

fi
