#!/usr/bin/env bash

opts="$(getopt -o t:w: --long theme:,wallpaper: -- "$@")"
eval set -- "$opts"
while true; do
	case $1 in
		-t|--theme) theme="$2"; shift 2;;
		-w|--wallpaper) wallpaper="$2"; shift 2;;
		--) shift; break;;
	esac
done

time="$(date "+%Y-%m-%d_%H:%M:%S")"
themes="Pure\nca-aa\nPure-Pink\nPure-Pink-1\nFrost\nFrost-Purple\nBerry"
[[ -z $theme ]] && theme="$(echo -e "$themes" | dmenu -i -p "What theme would you like to use?")"

if [[ $theme = Pure ]]; then 
	accentn="34"
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

elif [[ $theme = ca-aa ]]; then 
	accentn="32"
	bgdark="#191d2a"
	bglight="#1e2232"
	bglighter="#3c4566"

	fgdark="#aaaac8"
	fglight="#ccccee"

	disabled="#696969"
	accent="#00ee80"
	button="#cbe3f122"
	border="#1e2130"
	red="#ee0055"

elif [[ $theme = Pure-Pink ]]; then 
	accentn="95"
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

elif [[ $theme = Pure-Pink-1 ]]; then 
	accentn="95"
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

elif [[ $theme = Berry ]]; then 
	accentn="35"
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

elif [[ $theme = Frost ]]; then
	
	accentn="33"
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

elif [[ $theme = Frost-Purple ]]; then
	
	accentn="35"
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
		
fi

if [[ -n "$theme" ]]; then
	xfconf-query -c xsettings -p /Net/ThemeName -s "$theme"
	xfconf-query -c xfwm4 -p /general/theme -s "$theme"
	kvantummanager --set "$theme" &>/dev/null
	[[ -f ~/.config/Xres.$theme ]] && 
		sed --follow-symlinks -i "s/#include \".config\/Xres\..*\"/#include \".config\/Xres.$theme\"/" ~/.Xresources &&
		xrdb $HOME/.Xresources

	[[ -n $accentn ]] && 
		sed --follow-symlinks -i "s/color=\"..\"/color=\"$accentn\"/" -i ~/bin/slight.zsh
	#[[ -f $HOME/Wallpapers/Midnight-${theme}.png ]] && 
		#cp $HOME/Wallpapers/Midnight-${theme}.png $HOME/Wallpapers/Wallpaper.png

	[[ -f ~/.conkyrc ]] && [[ -n $fglight ]] && sed "s/\${color ......}/\${color $fglight}/" -i ~/.conkyrc &&
		pkill -9 conky && 
		conky &>/dev/null &!

	echo "$HOME/.mozilla/firefox/gauge.gauge/chrome/userChrome.css
$HOME/.mozilla/firefox/gauge.gauge/chrome/userContent.css
$HOME/.startpage/style.css" | \
		xargs sed --follow-symlinks -i \
		-e "s/.*--bgdark:.*#.*\;/--bgdark: $bgdark\;/" \
		-e "s/.*--bglight:.*#.*\;/--bglight: $bglight\;/" \
		-e "s/.*--bglighter:.*#.*\;/--bglighter: $bglighter\;/" \
		-e "s/.*--fgdark:.*#.*\;/--fgdark: $fgdark\;/" \
		-e "s/.*--fglight:.*#.*\;/--fglight: $fglight\;/" \
		-e "s/.*--accent:.*#.*\;/--accent: $accent\;/" \
		-e "s/.*--border:.*#.*\;/--border: $border\;/" \
		-e "s/.*--button:.*#.*\;/--fgdark: $button\;/" \
		-e "s/.*--disabled:.*#.*\;/--disabled: $disabled\;/" 

	#sed -E 's/(.*):/\1-/'
	sed --follow-symlinks -i "s/    frame_color = \".*\"/    frame_color = \"$accent\"/" ~/.config/dunst/dunstrc
	sed --follow-symlinks -i "s/    background = \".*\"/    background = \"$bgdark\"/"   ~/.config/dunst/dunstrc
	sed --follow-symlinks -i "s/    foreground = \".*\"/    foreground = \"$fglight\"/"  ~/.config/dunst/dunstrc
	dunst_red_last_linenum="$(( $(awk '/urgency_critical/ {print NR}' ~/.config/dunst/dunstrc) + 3 ))"
	sed --follow-symlinks -i "${dunst_red_last_linenum}s/    frame_color = \".*\"/    frame_color = \"$red\"/" ~/.config/dunst/dunstrc
	killall -9 dunst &> /dev/null;
	dunst &>/dev/null &!

	sed --follow-symlinks -i "s/theme=\".*\"/theme=\"$theme\"/" ~/bin/tint; 
	tint &>/dev/null &! 

	rc

	sed --follow-symlinks -i "s/color: #.*;/color: $accent;/g" ~/.config/gtk-3.0/gtk.css

	[[ -n $wallpaper ]] &&
		[[ -f ~/Wallpapers/$wallpaper-$theme.png ]] &&
			cp ~/Wallpapers/$wallpaper-$theme.png ~/Wallpapers/Wallpaper.png

	true
fi
