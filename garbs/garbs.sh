#!/bin/bash


# Based off Luke Smith's LARBS - https://github.com/LukeSmithxyz/LARBS
# Gauge's Auto Rice Boostrapping Script (GARBS)
# by Gauge Krahe

## Luke's Auto Rice Boostrapping Script (LARBS)
## by Luke Smith <luke@lukesmith.xyz>
# License: GNU GPLv3

# You can provide a custom repository with -r or a custom programs csv with -p.
# Otherwise, the script will use my defaults.

### DEPENDENCIES: git and make. Make sure these either are among the first in the progs.csv file or installed manually beforehand.

###
### OPTIONS AND VARIABLES ###
###6

while getopts ":a:r:p:h" o; do case "${o}" in
	h) echo -e "Optional arguments for custom use:\\n  -r: Dotfiles repository (local file or url)\\n  -p: Dependencies and programs csv (local file or url)\\n  -a: AUR helper (must have pacman-like syntax)\\n  -h: Show this message" && exit ;;
	r) dotfilesrepo=${OPTARG} && git ls-remote "$dotfilesrepo" || exit ;;
	p) progsfile=${OPTARG} ;;
	a) aurhelper=${OPTARG} ;;
	*) echo "-$OPTARG is not a valid option." && exit ;;
esac done

# DEFAULTS:
[ -z ${dotfilesrepo+x} ] && dotfilesrepo="https://gitlab.com/GaugeK/dots.git"
[ -z ${progsfile+x} ] && progsfile="https://gitlab.com/GaugeK/dots/raw/master/garbs/progs.csv"
[ -z ${aurhelper+x} ] && aurhelper="yay"

###
### FUNCTIONS ###
###

initialcheck() { pacman -S --noconfirm --needed dialog || { echo "Are you sure you're running this as the root user? Does the root user have sudoers permissions? Are you sure you're using an Arch-based distro? ;-) Are you sure you have an internet connection?"; exit; } ;}

#ins_ls_extended() { # Installs ls_extended manually if not installed. 
#	[[ -f /usr/bin/ls_extended ]] || (
#	dialog --infobox "Installing ls_extended, (ls with icons and colours...)" 8 50
#	cd /tmp
#	rm -rf /tmp/ls_extended*
#	git clone https://aur.archlinux.org/ls_extended.git &>/dev/null &&
#	chmod a+rw /tmp/ls_extended
#	cd "ls_extended" &&
#	sed -i '16,$d' .SRCINFO &&
#	sudo -u $name makepkg --noconfirm -si &>/dev/null
#	cd /tmp) ;}

preinstallmsg() { \
	dialog --title "Let's get this party started!" --yes-label "Let's go!" --no-label "No, nevermind!" --yesno "The rest of the installation will now be totally automated, so you can sit back and relax.\\n\\nIt will take some time, but when done, you can relax even more with your complete system.\\n\\nNow just press <Let's go!> and the system will begin installation!" 13 60 || { clear; exit; }
	}

welcomemsg() { \
	dialog --title "Welcome!" --msgbox "Welcome to Gauge's Auto-Rice Bootstrapping Script!\\n\\nThis script will automatically install a fully-featured openbox Arch Linux desktop, which I use as my main machine.\\n\\n-Gauge" 10 60
	}

refreshkeys() { \
	dialog --infobox "Refreshing Arch Keyring..." 4 40
	pacman --noconfirm -Sy archlinux-keyring  &>/dev/null
	}

getuserandpass() { \
	# Prompts user for new username an password.
	# Checks if username is valid and confirms passwd.
	name=$(dialog --inputbox "First, please enter a name for the user account." 10 60 3>&1 1>&2 2>&3 3>&1) || exit
	namere="^[a-z_][a-z0-9_-]*$"
	while ! [[ "${name}" =~ ${namere} ]]; do
		name=$(dialog --no-cancel --inputbox "Username not valid. Give a username beginning with a letter, with only lowercase letters, - or _." 10 60 3>&1 1>&2 2>&3 3>&1)
	done
	pass1=$(dialog --no-cancel --passwordbox "Enter a password for that user." 10 60 3>&1 1>&2 2>&3 3>&1)
	pass2=$(dialog --no-cancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
	while ! [[ ${pass1} == ${pass2} ]]; do
		unset pass2
		pass1=$(dialog --no-cancel --passwordbox "Passwords do not match.\\n\\nEnter password again." 10 60 3>&1 1>&2 2>&3 3>&1)
		pass2=$(dialog --no-cancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
	done ;}

usercheck() { \
	! (id -u $name &>/dev/null) ||
	dialog --colors --title "WARNING!" --yes-label "CONTINUE" --no-label "No wait..." --yesno "The user \`$name\` already exists on this system. GARBS can install for a user already existing, but it will \\Zboverwrite\\Zn any conflicting settings/dotfiles on the user account.\\n\\nGARBS will \\Zbnot\\Zn overwrite your user files, documents, videos, etc., so don't worry about that, but only click <CONTINUE> if you don't mind your settings being overwritten.\\n\\nNote also that GARBS will change $name's password to the one you just gave." 14 70
	}

adduserandpass() { \
	# Adds user `$name` with password $pass1.
	dialog --infobox "Adding user \"$name\"..." 4 50
	useradd -m -g wheel -s /bin/bash "$name" &>/dev/null ||
	usermod -a -G wheel "$name" && mkdir -p /home/"$name" && chown "$name":wheel /home/"$name"
	echo "$name:$pass1" | chpasswd
	unset pass1 pass2 ;}

gitmakeinstall() {
	dir=$(mktemp -d)
	dialog --title "GARBS Installation" --infobox "Installing \`$(basename $1)\` ($n of $total) via \`git\` and \`make\`. $(basename $1) $2." 5 70
	git clone --depth 1 "$1" "$dir" &>/dev/null
	cd "$dir" || exit
	make &>/dev/null
	make install &>/dev/null
	cd /tmp ;}

maininstall() { # Installs all needed programs from main repo.
	dialog --title "GARBS Installation" --infobox "Installing \`$1\` ($n of $total). $1 $2." 5 70
	pacman --noconfirm --needed -S "$1" &>/dev/null
	}

aurinstall() { \
	dialog --title "GARBS Installation" --infobox "Installing \`$1\` ($n of $total) from the AUR. $1 $2." 5 70
	grep "^$1$" <<< "$aurinstalled" && return
	sudo -u $name $aurhelper -S --noconfirm "$1" &>/dev/null
	}

installationloop() { \
	([ -f "$progsfile" ] && cp "$progsfile" /tmp/progs.csv) || curl -Ls "$progsfile" > /tmp/progs.csv
	total=$(wc -l < /tmp/progs.csv)
	aurinstalled=$(pacman -Qm | awk '{print $1}')
	while IFS=, read -r tag program comment; do
	n=$((n+1))
	case "$tag" in
	"") maininstall "$program" "$comment" ;;
	"A") aurinstall "$program" "$comment" ;;
	"G") gitmakeinstall "$program" "$comment" ;;
	esac
	done < /tmp/progs.csv ;}

serviceinit() { for service in "$@"; do
	dialog --infobox "Enabling \"$service\"..." 4 40
	systemctl enable "$service"
	systemctl start "$service"
	done ;}

newperms() { # Set special sudoers settings for install (or after).
	sed -i "/#GARBS/d" /etc/sudoers
	echo -e "$@ #GARBS" >> /etc/sudoers ;}

systembeepoff() { dialog --infobox "Getting rid of that retarded error beep sound..." 10 50
	rmmod pcspkr
	echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf ;}

putgitrepo() { # Downlods a gitrepo $1 and places the files in $2 only overwriting conflicts
	dialog --infobox "Downloading and installing config files..." 4 60
	dir=$(mktemp -d)
	chown -R "$name":wheel "$dir"
	sudo -u "$name" git clone --depth 1 "$1" "$dir"/gitrepo &>/dev/null &&
	sudo -u "$name" mkdir -p "$2" &&
	sudo -u "$name" cp -rT "$dir"/gitrepo "$2"
	}

resetpulse() { dialog --infobox "Reseting Pulseaudio..." 4 50
	killall pulseaudio
	sudo -n "$name" pulseaudio --start ;}

manualinstall() { # Installs $1 manually if not installed. Used only for AUR helper here.
	[[ -f /usr/bin/$1 ]] || (
	dialog --infobox "Installing \"$1\", an AUR helper..." 8 50
	cd /tmp
	rm -rf /tmp/"$1"*
	curl -sO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz &&
	sudo -u "$name" tar -xvf "$1".tar.gz &>/dev/null &&
	cd "$1" &&
	sudo -u $name makepkg --noconfirm -si &>/dev/null
	cd /tmp) ;}

finalize(){ \
	dialog --infobox "Preparing welcome message..." 4 50
	echo "exec_always --no-startup-id notify-send -i ~/.scripts/larbs.png '<b>Welcome to LARBS:</b> Press Super+F1 for the manual.' -t 10000"  >> /home/$name/.config/i3/config
	dialog --title "All done!" --msgbox "Congrats! Provided there were no hidden errors, the script completed successfully and all the programs and configuration files should be in place.\\n\\nTo run the new graphical environment, log out and log back in as your new user, then run the command \"startx\" to start the graphical environment.\\n\\n-Gauge" 12 80
	}

###
### THE ACTUAL SCRIPT ###
###
### This is how everything happens in an intuitive format and order.
###

# Check if user is root on Arch distro. Install dialog.
initialcheck

# Welcome user.
welcomemsg || { clear; exit; }

# Get and verify username and password.
getuserandpass

# Give warning if user already exists.
usercheck || { clear; exit; }

# Last chance for user to back out before install.
preinstallmsg || { clear; exit; }

### The rest of the script requires no user input.

adduserandpass

# Refresh Arch keyrings.
refreshkeys

# Allow user to run sudo without password. Since AUR programs must be installed
# in a fakeroot environment, this is required for all builds with AUR.
newperms "%wheel ALL=(ALL) NOPASSWD: ALL"

manualinstall $aurhelper

# The command that does all the installing. Reads the progs.csv file and
# installs each needed program the way required. Be sure to run this only after
# the user has been created and has priviledges to run sudo without a password
# and all build dependencies are installed.
installationloop

# Install the dotfiles in the user's home directory
putgitrepo "$dotfilesrepo" "/home/$name"

#Agnoster ZSH theme
curl https://gitlab.com/GaugeK/dots/raw/master/bin/agnoster.zsh-theme -o /usr/share/oh-my-zsh/themes/agnoster.zsh-theme &>/dev/null

#Sauce Code Pro font
rm /tmp/SauceCodePro.zip &>/dev/null
curl -Ls https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/SourceCodePro.zip > /tmp/SauceCodePro.zip &>/dev/null
unzip -o /tmp/SauceCodePro.zip -d /usr/share/fonts/TTF/ &>/dev/null

#Iosevka font
rm /tmp/02-iosevka-term-2.0.1.zip &>/dev/null
curl -Ls https://github.com/be5invis/Iosevka/releases/download/v2.0.1/02-iosevka-term-2.0.1.zip > /tmp/02-iosevka-term-2.0.1.zip &>/dev/null
unzip -o /tmp/02-iosevka-term-2.0.1.zip -d /usr/share/fonts/TTF/ &>/dev/null

fc-cache -f

#ls with icons and colours
if [ ! -f /usr/bin/ls_extended ]; then
curl -L "https://gitlab.com/GaugeK/dots/raw/master/bin/ls_extended?inline=false" -o "/usr/bin/ls_extended"
chmod a+x "/usr/bin/ls_extended"
fi

#Hibernate (for rofi)
if [ ! -f /usr/bin/hibernate ]; then
echo "#\!/usr/bin/bash

systemctl hibernate" >> /usr/bin/hibernate
fi

#Hibernate and lock
if [ ! -f /usr/bin/hib ]; then
echo "#\!/usr/bin/bash

systemctl hibernate && lock" >> /usr/bin/hib
fi

#Disable mouse acceleration
if [ ! -f /etc/X11/xorg.conf.d/50-mouse-acceleration.conf ]; then
echo 'Section "InputClass"
    Identifier "My Mouse"
    MatchIsPointer "yes"
    Option "AccelerationProfile" "-1"
    Option "AccelerationScheme" "none"
    Option "AccelSpeed" "-0.75"
EndSection' >> /etc/X11/xorg.conf.d/50-mouse-acceleration.conf
fi

#Touchpad stuff
if [ ! -f /etc/X11/xorg.conf.d/70-synaptics.conf ]; then
echo 'Section "InputClass"
    Identifier "touchpad"
    Driver "synaptics"
    MatchIsTouchpad "on"
        Option "TapButton1" "1"
        Option "TapButton2" "3"
        Option "TapButton3" "2"
        Option "VertEdgeScroll" "on"
        Option "VertTwoFingerScroll" "on"
        Option "HorizEdgeScroll" "on"
        Option "HorizTwoFingerScroll" "on"
        Option "CircularScrolling" "on"
        Option "CircScrollTrigger" "2"
        Option "EmulateTwoFingerMinZ" "40"
        Option "EmulateTwoFingerMinW" "8"
        Option "CoastingSpeed" "0"
        Option "FingerLow" "30"
        Option "FingerHigh" "50"
        Option "MaxTapTime" "125"
EndSection' >> /etc/X11/xorg.conf.d/70-synaptics.conf
fi


# Install the LARBS Firefox profile in ~/.mozilla/firefox/
#putgitrepo "https://github.com/LukeSmithxyz/mozillarbs.git" "/home/$name/.mozilla/firefox"

# Pulseaudio, if/when initially installed, often needs a restart to work immediately.
[[ -f /usr/bin/pulseaudio ]] && resetpulse

# Enable services here.
serviceinit NetworkManager cronie 
systemctl enable sddm

# Most important command! Get rid of the beep!
systembeepoff

# This line, overwriting the `newperms` command above will allow the user to run
# serveral important commands, `shutdown`, `reboot`, updating, etc. without a password.
newperms "%wheel ALL=(ALL) ALL\\n%wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/systemctl suspend,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/packer -Syu,/usr/bin/packer -Syyu,/usr/bin/systemctl restart NetworkManager,/usr/bin/rc-service NetworkManager restart,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/yay"

# Make pacman and yay colorful because why not.
sed -i "s/^#Color/Color/g" /etc/pacman.conf

#One line per pkg pacman
sed -i "s/^#VerbosePkgLists/VerbosePkgLists/g" /etc/pacman.conf

#Pacman-like loading bar in pacman
if grep -q ILoveCandy "/etc/pacman.conf"; then
	else
	sed -i '/# Misc options/a ILoveCandy' /etc/pacman.conf
fi

#Make sudo as normal user request the root user's password instead of that user's
if grep -q "Defaults rootpw" "/etc/sudoers"; then
	else
	sed -i '/## Defaults specification/a Defaults rootpw' /etc/pacman.conf
fi

#Screenshot folder
if [ ! -f /home/$name/Stuff/Screenshots/scrot/ ]; then
	mkdir /home/$name/Stuff
	mkdir /home/$name/Stuff/Screenshots/
	mkdir /home/$name/Stuff/Screenshots/scrot/
fi

#Make wifi faster on my card
sh -c 'echo "options iwlwifi bt_coex_active=0 swcrypto=1 11n_disable=8" > /etc/modprobe.d/iwlwifi.conf'

#Shorter timeout for systemd init
sed -i "s/^#DefaultTimeoutStartSec=90s/DefaultTimeoutStartSec=15s/g" /etc/systemd/system.conf
sed -i "s/^#DefaultTimeoutstopSec=90s/DefaultTimeoutstopSec=10s/g" /etc/systemd/system.conf

# Last message! Install complete!
finalize
clear

#Start the display manager
#systemctl start sddm
