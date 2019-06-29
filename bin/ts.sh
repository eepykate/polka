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

themes="Pure\nasdf\nxd\nca-aa-blue\nca-aa-pink\nca-aa\naa\naa-blue\naa-purple\naa-red\naa-white\nPure-Pink\nPure-Pink-1\nFrost\nFrost-Purple\nBerry" # List of themes
if [[ -z $theme ]]; then
	theme="$(echo -e "$themes" | rofi -dmenu -i -p "What theme would you like to use?")" \
		|| exit
fi
[[ -n $wallpaper ]] && wallpaper="$(ls $HOME/Wallpapers/*.png | sed 's/.*\///' | rofi -dmenu -i -p "Which Wallpaper?")" # Find png wallpapers in ~/Wallpapers

# Define the colours in the theme (for rofi, startpage, firefox, dunst, etc)
if [[ $theme = Pure ]]; then 
	accentn="4"
	bgdark="#12151a"
	bglight="#171a24"
	bglighter="#222631"

	fgdark="#808fa1"
	fglight="#afc4dc"

	disabled="#696969"
	accent="#02a4fc"
	button="#cbe3f122"
	border="#1e2130"
	red="#f0185a"
	hover="$bgdark"

elif [[ $theme = asdf ]]; then 
	accentn="4"
	bgdark="#232731"
	bglight="#282d39"
	bglighter="#303644"

	fgdark="#8888a0"
	fglight="#ccccee"

	disabled="#696969"
	accent="#9ab2dc"
	button="#cbe3f122"
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

elif [[ $theme = aa-red ]]; then 
	accentn="1"
	bgdark="#1a1f2e"
	bglight="#202537"
	bglighter="#272e44"

	fgdark="#8888a0"
	fglight="#ccccee"

	disabled="#696969"
	accent="#be405d"
	button="#cbe3f122"
	border="#262c42"
	red="#ee0055"
	hover="#ffffff"

elif [[ $theme = aa-white ]]; then 
	accentn="7"
	bgdark="#1a1f2e"
	bglight="#202537"
	bglighter="#272e44"

	fgdark="#8888a0"
	fglight="#ccccee"

	disabled="#696969"
	accent="#eeeeee"
	button="#cbe3f122"
	border="#262c42"
	red="#ee0055"
	hover="#000000"

elif [[ $theme = aa-purple ]]; then 
	accentn="5"
	bgdark="#1a1f2e"
	bglight="#202537"
	bglighter="#272e44"

	fgdark="#8888a0"
	fglight="#ccccee"

	disabled="#696969"
	accent="#8866cc"
	button="#cbe3f122"
	border="#262c42"
	red="#ee0055"
	hover="#ffffff"

elif [[ $theme = aa-blue ]]; then 
	accentn="4"
	bgdark="#1a1f2e"
	bglight="#202537"
	bglighter="#272e44"

	fgdark="#8888a0"
	fglight="#ccccee"

	disabled="#696969"
	accent="#447bbe"
	button="#cbe3f122"
	border="#262c42"
	red="#ee0055"
	hover="#ffffff"

elif [[ $theme = aa ]]; then 
	accentn="5"
	bgdark="#1a1f2e"
	bglight="#202537"
	bglighter="#272e44"

	fgdark="#8888a0"
	fglight="#ccccee"

	disabled="#696969"
	accent="#8866cc"
	button="#cbe3f122"
	border="#262c42"
	red="#ee0055"
	hover="$bgdark"

elif [[ $theme = ca-aa ]]; then 
	accentn="2"
	bgdark="#191d2a"
	bglight="#1e2232"
	bglighter="#2c334c"

	fgdark="#8888a0"
	fglight="#ccccee"

	disabled="#696969"
	accent="#00ee80"
	button="#cbe3f122"
	border="#262c42"
	red="#ee0055"
	hover="$bgdark"

elif [[ $theme = ca-aa-blue ]]; then 
	accentn="4"
	bgdark="#191d2a"
	bglight="#1e2232"
	bglighter="#2c334c"

	fgdark="#8888a0"
	fglight="#ccccee"

	disabled="#696969"
	accent="#0099ff"
	button="#cbe3f122"
	border="#262c42"
	red="#ee0055"
	hover="$bgdark"

elif [[ $theme = ca-aa-pink ]]; then 
	accentn="5"
	bgdark="#191d2a"
	bglight="#1e2232"
	bglighter="#2c334c"

	fgdark="#8888a0"
	fglight="#ccccee"

	disabled="#696969"
	accent="#ee99ff"
	button="#cbe3f122"
	border="#262c42"
	red="#ee0055"
	hover="$bgdark"

elif [[ $theme = Pure-Pink ]]; then 
	accentn="5"
	bgdark="#12151a"
	bglight="#171a24"
	bglighter="#222631"

	fgdark="#808fa1"
	fglight="#afc4dc"

	disabled="#696969"
	accent="#ef57e8"
	button="#cbe3f122"
	border="#1e2130"
	red="#f0185a"
	hover="$bgdark"

elif [[ $theme = Pure-Pink-1 ]]; then 
	accentn="5"
	bgdark="#12151a"
	bglight="#171a24"
	bglighter="#222631"

	fgdark="#808fa1"
	fglight="#afc4dc"

	disabled="#696969"
	accent="#db7ff9"
	button="#cbe3f122"
	border="#1e2130"
	red="#f0185a"
	hover="$bgdark"

elif [[ $theme = Berry ]]; then 
	accentn="5"
	bgdark="#141117"
	bglight="#19141e"
	bglighter="#342036"

	fgdark="#987ea2"
	fglight="#f3d6fb"
	
	disabled="#696969"
	accent="#ab32c1"
	button="#f3d6fb22"
	border="#342036"
	red="#cb1f62"
	hover="$bgdark"

elif [[ $theme = Frost ]]; then
	
	accentn="3"
	bgdark="#232a35"
	bglight="#29303d"
	bglighter="#343a48"

	fgdark="#92a1ae"
	fglight="#92a1ae"
	
	disabled="#696969"
	accent="#ecac87"
	button="#7790a722"
	border="#303848"
	red="#c05863"
	hover="$bgdark"

elif [[ $theme = Frost-Purple ]]; then
	
	accentn="5"
	bgdark="#232a35"
	bglight="#29303d"
	bglighter="#343a48"

	fgdark="#92a1ae"
	fglight="#92a1ae"
	
	disabled="#696969"
	accent="#a469b4"
	button="#7790a722"
	border="#303848"
	red="#c05863"
	hover="$bgdark"

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

	kvantummanager --set "$theme" &>/dev/null # Set Kvantum theme

	# if ~/.config/Xres.<theme> exists, replace the `#include` line in ~/.Xresources to use that theme
	[[ -f ~/.config/Xres.$theme ]] &&
		sed --follow-symlinks -i "s/#include \".config\/Xres\..*\"/#include \".config\/Xres.$theme\"/" ~/.Xresources

	# Reload Xresources
	xrdb $HOME/.Xresources 
	rc

	# Replace the accent colour in slight.zsh
	[[ -n $accentn ]] && 
		sed --follow-symlinks -i "s/color=\".*\"/color=\"$accentn\"/" ~/.zshrc

	# Change foreground colour in conky
	[[ -f ~/.conkyrc ]] && [[ -n $fglight ]] && sed "s/\${color ......}/\${color $fglight}/" -i ~/.conkyrc
	# Reload conky
	pkill -9 conky && 
	conky &>/dev/null &! 

	# Change the colour variables in firefox and my startpage
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
	#sed --follow-symlinks -i "s/    frame_color = \".*\"/    frame_color = \"#$accent\"/" ~/.config/dunst/dunstrc
	#sed --follow-symlinks -i "s/    background = \".*\"/    background = \"#$bgdark\"/"   ~/.config/dunst/dunstrc
	#sed --follow-symlinks -i "s/    foreground = \".*\"/    foreground = \"#$fglight\"/"  ~/.config/dunst/dunstrc
	# Make urgent notifications in dunst have a red border
	#dunst_red_last_linenum="$(( $(awk '/urgency_critical/ {print NR}' ~/.config/dunst/dunstrc) + 3 ))"
	#sed --follow-symlinks -i "${dunst_red_last_linenum}s/    frame_color = \".*\"/    frame_color = \"#$red\"/" ~/.config/dunst/dunstrc
	## Reload dunst
	#killall -9 dunst &> /dev/null;
	#dunst &>/dev/null &!

	# Change theme name in tint (Wrapper script) then run it again, replacing the panel
	sed --follow-symlinks -i "s/theme=\".*\"/theme=\"$theme\"/" ~/bin/tint; 
	#tint &>/dev/null &! 

	# Change the theme in rofi
	sed --follow-symlinks -i -e "s/.*bg:.*#.*;/bg:         #${bgdark}bb;/g" \
		-e "s/.*fg:.*#.*;/  fg:         #$fglight;/" \
		-e "s/.*accent:.*#.*;/  accent:     #$accent;/"\
		~/.config/rofi/theme.rasi

	# Change accent colour in gtk.css 
	#sed --follow-symlinks -i "s/background-color: #.*;/background-color: #$bglight;/g" ~/.config/gtk-3.0/gtk.css

	# Change the wallpaper
	[[ -n $wallpaper ]] &&
		[[ -f ~/Wallpapers/$wallpaper ]] &&
		cp ~/Wallpapers/$wallpaper ~/Wallpapers/Wallpaper.png


	# Change bspwm colours
	sed --follow-symlinks -i \
		-e "s/focused_border_color \"#.*\"/focused_border_color \"#$accent\"/g" \
		-e "s/normal_border_color \"#.*\"/normal_border_color \"#$bgdark\"/g" \
		~/.config/bspwm/bspwmrc
	bspc wm -r

	# Change polybar colours
	#sed --follow-symlinks -i \
	#	-e "s/bg = #.*/bg = #$bgdark/" \
	#		-e "s/fg = #.*/fg = #$fglight/" \
	#		-e "s/accent = #.*/accent = #$accent/" \
	#		~/.config/polybar/config
	#	polybar.sh &!

	# Change lemonbar colours
	sed --follow-symlinks -i \
		-e "s/bg=\".*\"/bg=\"$bgdark\"/" \
		-e "s/blr=\".*\"/blr=\"$bglighter\"/" \
		-e "s/bl=\".*\"/bl=\"$bglight\"/" \
		-e "s/fg=\".*\"/fg=\"$fglight\"/" \
		-e "s/ac=\".*\"/ac=\"$accent\"/" \
		~/bin/bar
	bar &!

	sed --follow-symlinks -i \
		-e "s/accent=\"#.*\"/accent=\"#$accent\"/g" \
		-e "s/fg=\"#.*\"/fglight=\"#$fglight\"/g" \
		~/bin/asda


	true
fi
