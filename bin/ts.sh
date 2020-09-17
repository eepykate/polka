#!/bin/sh

while [ "$1" ]; do
	case "$1" in
		-t|--theme) theme="$2"; shift 2;;
		*) break;;
	esac
done

c=${XDG_CONFIG_HOME:=$HOME/.config}
themes="$(ls -1 "$c/colours/" | grep -iv 'current\|meta')" # List of themes
[ "$theme" ] || theme="$(printf %b "$themes" | menu -i -p "Theme?")"
ln -sf "$theme" "$c/colours/current"

# Define the colours in the theme (for rofi, startpage, firefox, dunst, etc)
[ -f "$c/colours/$theme" ] &&
	. "$c/colours/$theme" ||
	{ echo "Invalid theme '$theme'; exiting"; exit; }

. "$c/colours/meta"

echo "Theme chosen: $theme"

echo "Changing colours in:"

echo " - firefox"
# Change the colour variables in firefox and my startpage
cat << EOF > "$HOME/etc/.mozilla/firefox/main/chrome/colours.css"
:root {
	/*  ----  */
	--bg0:      #$bg0;
	--bg1:      #$bg1;
	--bg2:      #$bg2;
	--bg3:      #$bg3;
	--bg4:      #$bg4;
	--button:   #${fg1}20;
	--black:    #$black;
	/*  ----  */
	--fg1:      #$fg1;
	--fg2:      #$fg2;
	--fg1o:     #${fg1}88;
	--fg2o:     #${fg2}99;
	--disabled: #$disabled;
	/*  ----  */
	--accent:   #$accent;
	--accento:  #${accent}66;
	--accent2:  #$accent2;
	--contrast: #$contrast;
	/*  ----  */
	--red:      #$red;
	--yellow:   #$yellow;
	--green:    #$green;
	--cyan:     #$cyan;
	--blue:     #$blue;
	--purple:   #$purple;
	/*  ----  */

	--font:     "$font";
	--font-size: ${fontsize}px;
	--font-weight: $fontweight;

	--font2:     "$font2";
	--font2-size: ${font2size}px;
	--font2-weight: $font2weight;
}
EOF

echo " - xresources"
cat << EOF > "$c/xorg/res.col"
st.font:  $font:pixelsize=$fontsize:style=$fontweight

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


tabbed.selbgcolor:   #$bg1
tabbed.selfgcolor:   #$fg1
tabbed.normfgcolor:  #$fg2
tabbed.normbgcolor:  #$bg3
EOF

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

#echo " - gtk context menus"
#sed --follow-symlinks -i \
#	-e "s|^	background-color: #.*|	background-color: #$bg3;|" \
#	-e "s|^	color: #.*|	color: #$fg1;|" \
#	"$c/gtk-3.0/menus.css"

echo " - gtk [phocus]"
cd ~/src/phocus && {
	cat << EOF > scss/gtk-3.0/_colors.scss
\$background-1: #$bg1;
\$background-2: #$bg2;
\$background-3: #$bg3;

\$accent-1: #$red;
\$accent-2: #$yellow;
\$accent-3: #$yellow;
\$accent-4: #$green;
\$accent-5: #$cyan;
\$accent-6: #$blue;
\$accent-7: #$purple;
\$accent-8: #$purple;

\$primary-accent: #$accent;
\$secondary-accent: #$accent2;

\$foreground-color: #$fg1;

// TODO: is there a better way to do this? this is for example used in gnome-calculator for the result top-border
@define-color borders #{"" +\$background-2};
EOF
	make
}

echo " - icons"
h='[a-zA-Z0-9]'
h=$h$h$h$h$h$h
sed -i --follow-symlinks \
	-e "s/\"fill:#[a-zA-Z0-9]\+/\"fill:#$accent/" \
	~/usr/icons/Papirus/16x16/places/folder-blue.svg

sed -i --follow-symlinks \
	-e "3s/#$h/#$(darken "$accent" 0.9)/" \
	-e "6s/#$h/#$accent/" \
	~/usr/icons/Papirus/*/places/folder-blue.svg

sed -i --follow-symlinks \
	-e "s/#$h/#$bg1/" \
	~/usr/icons/Papirus/16x16/places/folder.svg


echo " - Changing wallpaper"
if [ -f "$HOME/src/walls/$wall" ]; then
	wallthing="feh --bg-fill --no-fehbg '$HOME/src/walls/$wall'"
	eval $wallthing
else
	walgen "#$wall" 08
	wallthing="feh --bg-tile --no-fehbg '$HOME/src/walls/tile.png'"
	sleep 0.6
fi

echo "#!/bin/sh
$wallthing" > ~/bin/pap

notify-send "Theme changed to $theme"
