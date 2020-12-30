#!/bin/sh

while [ "$1" ]; do
	case "$1" in
		-t|--theme) theme="$2"; shift 2;;
		*) break;;
	esac
done

c=${XDG_CONFIG_HOME:=$HOME/.config}
themes="$(ls -1 "$c/colours/" | grep -iv 'current\|meta')" # List of themes
[ "$theme" ] || theme="$(printf %b "$themes" | menu -p "Theme?")"
ln -sf "$theme" "$c/colours/current"

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

#echo " - xresources"
#cat << EOF > "$c/xorg/res.col"
#st.font:  $font:pixelsize=$fontsize:style=$fontweight
#
#*.background:   #$bg1
#*.foreground:   #$fg1
#*.cursorColor:  #$fg1
#
#*.color0:       #$bg1
#*.color8:       #$black
#
#*.color1:       #$red
#*.color9:       #$red
#
#*.color2:       #$yellow
#*.color10:      #$yellow
#
#*.color3:       #$green
#*.color11:      #$green
#
#*.color4:       #$cyan
#*.color12:      #$cyan
#
#*.color5:       #$blue
#*.color13:      #$blue
#
#*.color6:       #$purple
#*.color14:      #$purple
#
#*.color7:       #$fg2
#*.color15:      #$fg1
#
#*.color16:      #$accent
#*.color17:      #$accent2
#*.color18:      #$contrast
#
#
#tabbed.selbgcolor:   #$bg1
#tabbed.selfgcolor:   #$fg1
#tabbed.normfgcolor:  #$fg2
#tabbed.normbgcolor:  #$bg3
#EOF

cd "$HOME/src/st" 2>/dev/null && {
	echo " - st"

cat << EOF > generated.h
/*
 * appearance
 *
 * font: see http://freedesktop.org/software/fontconfig/fontconfig-user.html
 */

static char *font = "$font:pixelsize=$fontsize:style=$fontweight";

/* Terminal colors (16 first used in escape sequence) */
static const char *colorname[] = {
	/* 8 normal colors */
	"#$bg1",
	"#$red",
	"#$yellow",
	"#$green",
	"#$cyan",
	"#$blue",
	"#$purple",
	"#$fg2",

	/* 8 bright colors */
	"#$black",
	"#$red",
	"#$yellow",
	"#$green",
	"#$cyan",
	"#$blue",
	"#$purple",
	"#$fg1",

	/* annaisms :) */
	"#$accent",
	"#$accent2",
	"#$contrast",

	[255] = 0,

	/* more colors can be added after 255 to use with DefaultXX */
	"#$bg1",
	"#$fg1"
};
EOF

	sudo make clean install >/dev/null 2>&1
} &

cd "$HOME/src/dmenu" 2>/dev/null && {
	echo " - dmenu"

	sed -i --follow-symlinks \
		-e "s/\(fonts\[\] *= *{ \)[^}]*/\1\"$font:pixelsize=$(echo "$fontsize*1.2" | bc):style=$fontweight\", \"Blobmoji:pixelsize=$(echo "$fontsize*1.2" | bc)\" /" \
		-e "s/\(SchemeNorm\] *= *{ \)[^}]*/\1\"#$fg2\", \"#$bg1\" /" \
		-e "s/\(SchemeSel\] *= *{ \)[^}]*/\1\"#$fg1\", \"#$bg3\" /"  \
		`# fuzzy highlight` \
		-e "s/\(SchemeSelHighlight\] *= *{ \)[^}]*/\1\"#$fg1\", \"#$bg3\" /"  \
		-e "s/\(SchemeNormHighlight\] *= *{ \)[^}]*/\1\"#$fg1\", \"#$bg1\" /"  \
		config.h

	sudo make clean install >/dev/null 2>&1
} &


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
	-e "s/\(foreground.*\)=.*/\1= \"#${fg1}cf\"/" \
	-e "s/\(background.*\)=.*/\1= \"#$bg1\"/" \
	-e "s/\(frame_color.*\)=.*/\1= \"#$bg3\"/" \
	"$c/dunst/dunstrc")"

printf '%s\n' "$var" | while IFS='' read -r l; do
	case $l in
		*font*=*) l="${l%%=*}= $font $fontweight ${fontsize}px";;
		"[mike]") mike=H;;
		"[mic]") mic=H;;
		"[urgency_low]") low=H;;
		"[urgency_critical]") crit=H;;
		\[*) low=; crit=;;
		*background*)
			[ "$mike" ] && l="${l%%#*}#$blue\"" && unset mike
			[ "$mic" ] && l="${l%%#*}#$red\"" && unset mic;;
		*foreground*)
			[ "$crit" ] && l="${l%%#*}#$fg1\""
			[ "$low"  ] && l="${l%%#*}#${fg2}bb\""
	esac
	printf '%s\n' "$l"
done > "$c/dunst/dunstrc"

wm -r &

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

echo " - gtk [config (font)]"
cat << EOF > ${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini
[Settings]
gtk-application-prefer-dark-theme=0
gtk-button-images=1
gtk-cursor-theme-name=cursor
gtk-cursor-theme-size=0
gtk-decoration-layout=icon:minimize,maximize,close
gtk-enable-animations=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-font-name=$font2, $((font2size*8/10))
gtk-icon-theme-name=Papirus-Dark
gtk-menu-images=1
gtk-primary-button-warps-slider=0
gtk-theme-name=phocus
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
gtk-xft-rgba=rgb
EOF

command -v sass >/dev/null && cd ~/src/phocus && {
	echo " - gtk [phocus]"
	cat << EOF > scss/gtk-3.0/_colors.scss
\$background-1: #$bg1;
\$background-2: #$bg3;
\$background-3: #$bg1;
\$chromebg: #${chrome:-$bg4};

\$contrast: #$contrast;
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
	make >/dev/null 2>&1
} &

[ -e "$HOME/usr/icons/Papirus" ] && {
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
}


echo " - Changing wallpaper"
if [ -f "$HOME/src/walls/$wall" ]; then
	wallthing="feh --bg-fill --no-fehbg '$HOME/src/walls/$wall'"
	$wallthing
else
	mkdir -p ~/src/walls
	walgen "#$wall" 08
	wallthing="feh --bg-tile --no-fehbg '$HOME/src/walls/tile.png'"
	sleep 0.6
fi &

echo "#!/bin/sh
$wallthing" > ~/bin/pap

wait
notify-send "Theme changed to $theme"
