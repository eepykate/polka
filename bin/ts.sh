#!/bin/sh
set -x

while [ "$1" ]; do
	case "$1" in
		-t|--theme) theme="$2"; shift 2;;
		*) break;;
	esac
done

c=${XDG_CONFIG_HOME:=$HOME/.config}
themes="$(ls -1 "$c/colours/" | grep -iv 'current')" # List of themes
[ "$theme" ] || theme="$(printf %b "$themes" | menu -i -p "Theme?")"
ln -sf "$theme" "$c/colours/current"

# Define the colours in the theme (for rofi, startpage, firefox, dunst, etc)
[ -f "$c/colours/$theme" ] &&
	. "$c/colours/$theme" ||
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
	-e "s/--fg1:.*#.*\;/--fg1:      #$fg1\;/" \
	-e "s/--fg1o:.*#.*\;/--fg1o:     #${fg1}88\;/" \
	-e "s/--fg2o:.*#.*\;/--fg2o:     #${fg2}99\;/" \
	-e "s/--fg2:.*#.*\;/--fg2:      #$fg2\;/" \
	-e "s/--accent:.*#.*\;/--accent:   #$accent\;/" \
	-e "s/--accento:.*#.*\;/--accento:  #${accent}66\;/" \
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
	"$c/.mozilla/firefox/main/chrome/userChrome.css" \
	"$c/.mozilla/firefox/main/chrome/userContent.css"


echo " - xresources"
cat << EOF > "$c/Xres"
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
	"$c/Xresources"

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
	"$c/bspwm/bspwmrc"

echo " - dunst"
var="$(sed --follow-symlinks \
	-e "s/foreground.*/foreground          = \"#$fg1\"/" \
	-e "s/background.*/background          = \"#$bg1\"/" \
	-e "s/frame_color.*/frame_color         = \"#$accent\"/" \
	"$c/dunst/dunstrc")"

printf '%s\n' "$var" | while IFS='' read -r l; do
	case $l in
		"[urgency_low]") low=H;;
		"[urgency_critical]") crit=H;;
		\[*) low=; crit=;;
		*frame_color*)
			[ "$crit" ] && l="${l%%#*}#$accent2\""
			[ "$low" ] && l="${l%%#*}#$fg1\""
	esac
	printf '%s\n' "$l"
done > "$c/dunst/dunstrc"

wm -r

#echo " - dmenu"
#cd ~/opt/git/dmenu
#sed --follow-symlinks -i \
#	-e "s/Norm].*/Norm] = { \"#$fg2\", \"#$bg1\" },/" \
#	-e "s/Sel].*/Sel] = { \"#$fg1\", \"#$bg4\" },/" \
#	config.h
#make
#cp dmenu ~/bin/bin/dmenu

echo " - gtk context menus"
sed --follow-symlinks -i \
	-e "s|^	background-color: #.*|	background-color: #$bg3;|" \
	-e "s|^	color: #.*|	color: #$fg1;|" \
	"$c/gtk-3.0/menus.css"


printf '\n%s\n' "Changing wallpaper"
if [ -f "$HOME/opt/git/Wallpapers/$wall" ]; then
	wallthing="feh --bg-fill --no-fehbg \"$HOME/opt/git/Wallpapers/$wall\""
	eval $wallthing
else
	walgen "#$wall" "0.08"
	wallthing="feh --bg-tile --no-fehbg \"$HOME/opt/git/Wallpapers/tile.png\""
	sleep 0.6
fi

echo "#!/bin/sh
$wallthing" > ~/bin/pap

notify-send "Theme changed to $theme"
