#!/usr/bin/env bash

opts="$(getopt -o t: --long theme: -- "$@")"
eval set -- "$opts"
while true; do
	case $1 in
		-t|--theme) theme="$2"; shift 2;;
		--) shift; break;;
	esac
done

time="$(date "+%Y-%m-%d_%H:%M:%S")"
themes="Berry\nPure"
[[ -z $theme ]] && theme="$(echo -e "$themes" | dmenu -i -p "What theme would you like to use?")"

if [[ $theme = Pure ]]; then 
	accentn="4"
	bgdark="#12151a"
  bglight="#161720"
  bglighter="#222631"

  fgdark="#9aafc4"
	fglight="#d8eefa"

	disabled="#696969"
	accent="#02a4fc"
	button="#cbe3f122"
	border="#1a1b26"
	red="#f0185a"

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

fi

if [[ -n "$theme" ]]; then
	xfconf-query -c xsettings -p /Net/ThemeName -s "$theme"
	xfconf-query -c xfwm4 -p /general/theme -s "$theme"
	kvantummanager --set "$theme" &>/dev/null
	[[ -f ~/.config/Xres.$theme ]] && 
		sed --follow-symlinks -i "s/#include \".config\/Xres\..*\"/#include \".config\/Xres.$theme\"/" ~/.Xresources &&
		xrdb $HOME/.Xresources

	[[ -n $accentn ]] && 
		sed --follow-symlinks -i "s/color=\".\"/color=\"$accentn\"/" -i ~/bin/slight.zsh
	[[ -f $HOME/Wallpapers/Midnight-${theme}.png ]] && 
		cp $HOME/Wallpapers/Midnight-${theme}.png $HOME/Wallpapers/Wallpaper.png

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



	true
fi
