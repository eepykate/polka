#!/usr/bin/env bash

#set -x
#name="Template-gen"

# -----Colour scheme for the template----- #

#fglight="fafcff"
#fgdark="4d5565"
#bgdark="000000"
#bgmid="111111"
#bglight="222222"
#bglighter="444444"
#border="333333"
#accent="0000ff"
#accent2="0069aa"
#button_press_light="556670"
#button_press_dark="445560"
#textbox_underline="474747"
#textbox="202020"
#link="0066ff"
#link_visited="00ff66"
#red="ff0000"

# ---------------------------------------- #

name="aaaaa1"

## Change this to your colour scheme
fglight="4d4d4c"
fgdark="4d4d4c"
bgdark="f3f3f3"
bgmid="f3f3f3"
bglight="ebebeb"
bglighter="ebebeb"
border="333333"
accent="ff2050"
accent2="5390db"
button_press_light="a3a3a3"
button_press_dark="797979"
textbox_underline="cccccc"
textbox="e7e7e7"
link="5390db"
link_visited="19c762"
red="ff2050"

#[[ -z $name    ]] && printf "name "   && read name
#[[ -z $fglight ]] && printf "fglight "   && read fglight
#[[ -z $fgdark  ]] && printf "fgdark "    && read fgdark
#[[ -z $bgdark  ]] && printf "bgdark "    && read bgdark
#[[ -z $bgmid   ]] && printf "bgmid "     && read bgmid
#[[ -z $bglight ]] && printf "bglight "   && read bglight
#[[ -z $bglighter ]] && printf "bglighter " && read bglighter
#[[ -z $border  ]] && printf "border "    && read border
#[[ -z $accent  ]] && printf "accent "    && read accent
#[[ -z $accent2 ]] && printf "accent2 "   && read accent2
#[[ -z $textbox ]] && printf "textbox "   && read textbox
#[[ -z $link    ]] && printf "link "      && read link
#[[ -z $link_visited ]] && printf "link_visited " && read link_visited
#[[ -z $red     ]] && printf "red "       && read red
#[[ -z $textbox_underline ]] && printf "textbox_underline " && read fglight
#[[ -z $button_press_dark ]] && printf "button_press_dark " && read button_press_dark
#[[ -z $button_press_light ]] && printf "button_press_light " && read button_press_light

gen_oomox() {

	[[ -n $name ]] && \
	[[ -n $fglight ]] && \
	[[ -n $bglight ]] && \
	[[ -n $bgdark ]] && \
	[[ -n $accent ]] ||	return

	[[ -d ~/.themes/$name ]] && return && echo "A GTK theme with your name already exists."
	[[ -f ~/.config/oomox/colors/Template ]] || return
	cp ~/.config/oomox/colors/Template ~/.config/oomox/colors/$name || return

	sed --follow-symlinks -i \
	-e "s/000000/$bgdark/" \
	-e "s/222222/$bglight/" \
	-e "s/0000ff/$accent/" \
	-e "s/fafcff/$fglight/" \
	-e "s/Template/$name/"\
	~/.config/oomox/colors/$name
	
	/opt/oomox/plugins/theme_materia/materia-theme/change_color.sh \
	$HOME/.config/oomox/colors/$name &&
	mv ~/.themes/oomox-$name/xfwm4/ ~/.themes/oomox-$name/xfwm4-old &&
	cp -r ~/.themes/oomox-$name ~/.themes/$name &&
	echo -e "\n\n# ---Your GTK theme has been generated using oomox--- #\n\n"

}

genkvantum() {
	[[ -n $name ]] && \
	[[ -n $bgdark ]] && \
	[[ -n $bgmid ]] && \
	[[ -n $bglight ]] && \
	[[ -n $bglighter ]] && \
	[[ -n $textbox_underline ]] && \
	[[ -n $textbox ]] && \
	[[ -n $accent ]] && \
	[[ -n $accent2 ]] && \
	[[ -n $red ]] && \
	[[ -n $link ]] && \
	[[ -n $link_visited ]] ||  return

	[[ -d ~/.config/Kvantum/$name ]] && return && echo "A Kvantum theme with your name already exists."
	[[ -d ~/.config/Kvantum/Template ]] || return
	cp -r ~/.config/Kvantum/Template/ ~/.config/Kvantum/$name && \
	mv ~/.config/Kvantum/$name/Template.svg ~/.config/Kvantum/$name/$name.svg && \
	mv ~/.config/Kvantum/$name/Template.kvconfig ~/.config/Kvantum/$name/$name.kvconfig || return

	sed -i --follow-symlinks \
		-e "s/000000/$bgdark/" \
		-e "s/111111/$bgmid/" \
		-e "s/222222/$bglight/" \
		-e "s/444444/$bglighter/" \
		-e "s/fafcff/$fglight/" \
		-e "s/474747/$textbox_underline/" \
		-e "s/202020/$textbox/" \
		-e "s/0000ff/$accent/" \
		-e "s/0069aa/$accent2/" \
		-e "s/ff0000/$red/" \
		-e "s/0066ff/$link/" \
		-e "s/00ff66/$link_visited/" \
		~/.config/Kvantum/$name/*  &&

	echo "Your Kvantum theme has been generated"

}


genxfwm4() {

	[[ -d ~/.themes/$name/xfwm4/ ]] && return && echo "An XFWM theme with your name already exists."
	[[ -n $name ]] && \
	[[ -n $bgdark ]] && \
	[[ -n $accent ]] && \
	[[ -n $button_press_light ]] && \
	[[ -n $button_press_dark ]] && \
	[[ -n $fglight ]] && \
	[[ -n $fgdark ]] && \
	[[ -n $border ]] || return

	[[ -d ~/.themes/Template ]] || return
	cp -r ~/.themes/Template/xfwm4/ ~/.themes/$name/xfwm4/ || return

	sed -i --follow-symlinks \
	-e "s/000000/$bgdark/" \
	-e "s/0000ff/$accent/" \
	-e "s/556670/$button_press_light/" \
	-e "s/445560/$button_press_dark/" \
	-e "s/fafcff/$fglight/" \
	-e "s/4d5565/$fgdark/" \
	-e "s/333333/$border/" \
	~/.themes/$name/xfwm4/assets/* &&

	echo -e "\n\n# ---Your Xfwm4 theme has been generated--- #\n\n"

}

opts="$(getopt -o xko --long disable-xfwm,disable-kvantum,disable-oomox -- "$@")"
eval set -- "$opts"

while true; do 
	case $1 in
		-x|--xfwm) xfwm="no"; shift;;
		-k|--kvantum) kvantum="no"; shift;;
		-o|--oomox) oomox="no"; shift;;
		--) shift; break;;
	esac
done

[[ $kvantum != no ]] && genkvantum
[[ $oomox != no ]] && gen_oomox
[[ $xfwm != no ]] && genxfwm4

