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

fi

#[[ $theme = Pure  ]] && accent="4" && foreground="d8eefa"
#[[ $theme = Berry ]] && accent="5" && foreground="f3d6fb"

if [[ -n "$theme" ]]; then
	xfconf-query -c xsettings -p /Net/ThemeName -s "$theme"
	xfconf-query -c xfwm4 -p /general/theme -s "$theme"
	kvantummanager --set "$theme"
	[[ -f ~/.Xresources.${theme} ]] && 
		mv ~/.Xresources ~/.config/.Xresources.${time} && 
		cp ~/.Xresources.${theme} ~/.Xresources && 
		xrdb ~/.Xresources &&
		echo "~/.Xresources has been moved to ~/.config/.Xresources.${time}"
	[[ -n $accentn ]] && 
		sed "s/color=\".\"/color=\"$accentn\"/" -i ~/bin/slight.zsh
	[[ -f $HOME/Wallpapers/Midnight-${theme}.png ]] && 
		cp $HOME/Wallpapers/Midnight-${theme}.png $HOME/Wallpapers/Wallpaper.png

	[[ -f ~/.conkyrc ]] && [[ -n $fglight ]] && sed "s/\${color ......}/\${color $fglight}/" -i ~/.conkyrc &&
		pkill -9 conky && 
		conky &>/dev/null &!

	sed "s/theme=\".*\"/theme=\"$theme\"/" -i ~/bin/tint; tint

	echo "$HOME/.mozilla/firefox/gauge.gauge/chrome/userChrome.css
$HOME/.mozilla/firefox/gauge.gauge/chrome/userContent.css
$HOME/.startpage/style.css" | \
		xargs sed -i -e "s/.*--bgdark:.*#.*\;/--bgdark: $bgdark\;/" \
		-e "s/.*--bglight:.*#.*\;/--bglight: $bglight\;/" \
		-e "s/.*--bglighter:.*#.*\;/--bglighter: $bglighter\;/" \
		-e "s/.*--fgdark:.*#.*\;/--fgdark: $fgdark\;/" \
		-e "s/.*--fglight:.*#.*\;/--fglight: $fglight\;/" \
		-e "s/.*--accent:.*#.*\;/--accent: $accent\;/" \
		-e "s/.*--border:.*#.*\;/--border: $border\;/" \
		-e "s/.*--button:.*#.*\;/--fgdark: $button\;/" \
		-e "s/.*--disabled:.*#.*\;/--disabled: $disabled\;/" 

	sed "s/    frame_color = \".*\"/    frame_color = \"$accent\"/" -i ~/.config/dunst/dunstrc
	sed "s/    background = \".*\"/    background = \"$bgdark\"/"  -i ~/.config/dunst/dunstrc
	sed "s/    foreground = \".*\"/    foreground = \"$fglight\"/"  -i ~/.config/dunst/dunstrc
	pkill dunst &&
	dunst &>/dev/null &!


	true
fi
