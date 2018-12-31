#!/bin/bash

# Gauge's Auto Rice Boostrapping Script (GARBS)
# Original by Luke Smith (https://github.com/LukeSmithxyz/LARBS)

# Luke's Auto Rice Boostrapping Script (LARBS)
# by Luke Smith <luke@lukesmith.xyz>
# License: GNU GPLv3

# You can provide a custom repository with -r or a custom programs csv with -p.
# Otherwise, the script will use my defaults.

### DEPENDENCIES: git and make. Make sure these either are among the first in the progs.csv file or installed manually beforehand.

###
### OPTIONS AND VARIABLES ###
###

while getopts ":a:r:p:h" o; do case "${o}" in
	h) echo -e "Optional arguments for custom use:\\n  -r: Dotfiles repository (local file or url)\\n  -p: Dependencies and programs csv (local file or url)\\n  -a: AUR helper (must have pacman-like syntax)\\n  -h: Show this message" && exit ;;
	r) dotfilesrepo=${OPTARG} && git ls-remote "$dotfilesrepo" || exit ;;
	p) progsfile=${OPTARG} ;;
	a) aurhelper=${OPTARG} ;;
	*) echo "-$OPTARG is not a valid option." && exit ;;
esac done

# DEFAULTS:
[ -z ${dotfilesrepo+x} ] && dotfilesrepo="https://gitlab.com/gaugek/dots.git"
[ -z ${progsfile+x} ] && progsfile="https://gitlab.com/GaugeK/dots/raw/master/garbs/progs.csv"
[ -z ${aurhelper+x} ] && aurhelper="yay"

###
### FUNCTIONS ###
###

initialcheck() { pacman -Syyu --noconfirm --needed dialog || { echo "Are you sure you're running this as the root user? Are you sure you're using an Arch-based distro? ;-) Are you sure you have an internet connection?"; exit; } ;}

preinstallmsg() { \
	dialog --title "Let's get this party started!" --yes-label "Let's go!" --no-label "No, nevermind!" --yesno "The rest of the installation will now be totally automated, so you can sit back and relax.\\n\\nIt will take some time, but when done, you can relax even more with your complete system.\\n\\nNow just press <Let's go!> and the system will begin installation!" 13 60 || { clear; exit; }
	}

welcomemsg() { \
	dialog --title "Welcome!" --msgbox "Welcome to Gauge's Auto-Rice Bootstrapping Script!\\n\\nThis script will automatically install a fully-featured openbox Arch Linux desktop, which I use as my main machine.\\n\\n-Gauge" 10 60
	}

refreshkeys() { \
	dialog --infobox "Refreshing Arch Keyring..." 4 40
	pacman --noconfirm -Sy archlinux-keyring &>/dev/null
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
	dialog --colors --title "WARNING!" --yes-label "CONTINUE" --no-label "No wait..." --yesno "The user \`$name\` already exists on this system. garbs can install for a user already existing, but it will \\Zboverwrite\\Zn any conflicting settings/dotfiles on the user account.\\n\\nLARBS will \\Zbnot\\Zn overwrite your user files, documents, videos, etc., so don't worry about that, but only click <CONTINUE> if you don't mind your settings being overwritten.\\n\\nNote also that garbs will change $name's password to the one you just gave." 14 70
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
	dialog --title "garbs Installation" --infobox "Installing \`$(basename $1)\` ($n of $total) via \`git\` and \`make\`. $(basename $1) $2" 5 70
	git clone --depth 1 "$1" "$dir" &>/dev/null
	cd "$dir" || exit
	make &>/dev/null
	make install &>/dev/null
	cd /tmp ;}

maininstall() { # Installs all needed programs from main repo.
	dialog --title "garbs Installation" --infobox "Installing \`$1\` ($n of $total). $1 $2" 5 70
	pacman --noconfirm --needed -S "$1" &>/dev/null
	}

aurinstall() { \
	dialog --title "garbs Installation" --infobox "Installing \`$1\` ($n of $total) from the AUR. $1 $2" 5 70
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
	sed -i "/#garbs/d" /etc/sudoers
	echo -e "$@ #garbs" >> /etc/sudoers ;}

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
	dialog --infobox "Installing \"$1\", an AUR helper..." 4 50
	cd /tmp
	rm -rf /tmp/"$1"*
	curl -sO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz &&
	sudo -u "$name" tar -xvf "$1".tar.gz &>/dev/null &&
	cd "$1" &&
	sudo -u $name makepkg --noconfirm -si &>/dev/null
	cd /tmp) ;}

finalize(){ \
	dialog --infobox "Preparing welcome message..." 4 50
	echo "exec_always --no-startup-id notify-send -i ~/.scripts/pix/larbs.png '<b>Welcome to garbs:</b> Press Super+F1 for the manual.' -t 10000"  >> /home/$name/.config/i3/config
	dialog --title "All done!" --msgbox "Congrats! Provided there were no hidden errors, the script completed successfully and all the programs and configuration files should be in place.\\n\\nTo run the new graphical environment, log out and log back in as your new user, then run the command \"startx\" to start the graphical environment.\\n\\n-Gauge" 12 80
	}

mystuff(){ \
	dialog --infobox "Installing some of my configurations in the root directory" 4 50
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

dialog --title "garbs Installation" --infobox "Installing \`basedevel\` for build software." 5 70
pacman --noconfirm --needed -S base-devel &>/dev/null

manualinstall $aurhelper

# The command that does all the installing. Reads the progs.csv file and
# installs each needed program the way required. Be sure to run this only after
# the user has been created and has priviledges to run sudo without a password
# and all build dependencies are installed.
installationloop


## Give root sudoers permissions if not already given (Also mine but this needs to be at the start)
if [ -z grep "root ALL=(ALL) ALL" "/etc/sudoers" ]; then
	sed -i '/## User privilege specification/a root ALL=(ALL) ALL' /etc/sudoers
fi

# Install the dotfiles in the user's home directory
putgitrepo "$dotfilesrepo" "/home/$name"

# Install the LARBS Firefox profile in ~/.mozilla/firefox/
#putgitrepo "https://github.com/LukeSmithxyz/mozillarbs.git" "/home/$name/.mozilla/firefox"

# Installation of the post-install wizard
#putgitrepo "https://github.com/LukeSmithxyz/arch-postinstall-wizard" "/home/$name/larbs-wizard"
#ln -T /home/$name/.larbs-wizard/wizard.sh postinstall-wizard.sh

# Pulseaudio, if/when initially installed, often needs a restart to work immediately.
[[ -f /usr/bin/pulseaudio ]] && resetpulse

# Enable services here.
serviceinit NetworkManager cronie

# Most important command! Get rid of the beep!
systembeepoff

# This line, overwriting the `newperms` command above will allow the user to run
# serveral important commands, `shutdown`, `reboot`, updating, etc. without a password.
newperms "%wheel ALL=(ALL) ALL\\n%wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/systemctl suspend,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/packer -Syu,/usr/bin/packer -Syyu,/usr/bin/systemctl restart NetworkManager,/usr/bin/rc-service NetworkManager restart,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/yay,/usr/bin/pacman -Syyuw --noconfirm"

#--------------My stuff--------------

mystuff

#Agnoster ZSH theme
curl https://gitlab.com/GaugeK/dots/raw/master/bin/agnoster.zsh-theme -o /usr/share/oh-my-zsh/themes/agnoster.zsh-theme &>/dev/null

#Sauce Code Pro font
rm -f /tmp/SauceCodePro.zip &>/dev/null
curl -Ls https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/SourceCodePro.zip >> /tmp/SauceCodePro.zip 
unzip -o /tmp/SauceCodePro.zip -d /usr/share/fonts/TTF/ &>/dev/null

#Iosevka font
rm -f /tmp/02-iosevka-term-2.0.1.zip &>/dev/null
curl -Ls https://github.com/be5invis/Iosevka/releases/download/v2.0.1/02-iosevka-term-2.0.1.zip >> /tmp/02-iosevka-term-2.0.1.zip 
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
        Option "PalmDetect" "1"
        Option "PalmMinWidth" "8"
        Option "PalmMinZ" "100"
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
EndSection
' >> /etc/X11/xorg.conf.d/70-synaptics.conf
fi

#Make sudo as normal user request the root user's password instead of that user's
if [[ -z $(grep "Defaults rootpw" "/etc/sudoers") ]]; then
	sed -i '/## Defaults specification/a Defaults rootpw' /etc/sudoers
fi

#One line per pkg pacman
sed -i "s/^#VerbosePkgLists/VerbosePkgLists/g" /etc/pacman.conf

#Pacman-like loading bar in pacman
if [[ -z $(grep ILoveCandy "/etc/pacman.conf") ]]; then
	sed -i '/# Misc options/a ILoveCandy' /etc/pacman.conf
fi

# Make pacman and yay colorful because why not.
sed -i "s/^#Color/Color/g" /etc/pacman.conf

#Make wifi faster on my card
if [ -n /etc/modprobe.d/iwlwifi.conf ]; then
	sh -c 'echo "options iwlwifi bt_coex_active=0 swcrypto=1 11n_disable=8" > /etc/modprobe.d/iwlwifi.conf'
fi

#Shorter timeout for systemd init
sed -i "s/^#DefaultTimeoutStartSec=90s/DefaultTimeoutStartSec=15s/g" /etc/systemd/system.conf
sed -i "s/^#DefaultTimeoutstopSec=90s/DefaultTimeoutstopSec=10s/g" /etc/systemd/system.conf
systemctl daemon-reload

#Show details about boot while booting up
sed -i "s/quiet//" /etc/default/grub

#Enable hibernation (Probably won't work lmao)
if [[ -n $(grep swap /etc/fstab) ]]; then

	swap="$(lsblk | awk '/SWAP/ {print $1}' | tr -d '─├└')" 

	swap="$(echo /dev/$swap)"

	#uswap="$(blkid | grep ${swap} | tr -d '\"' | awk '{print $2}')" 

	#uswap="$(/usr/bin/ls -lha /dev/disk/by-uuid | grep ${swap} | awk '{print $9}')"

	#uswap="$(grep swap /etc/fstab | awk '{print $1}')"

fi

if [[ -n $(grep swap /etc/fstab) ]] && [[ -z $(grep "resume" "/etc/default/grub") ]]; then 

	sed -i "/GRUB_CMDLINE_LINUX_DEFAULT=/s/ $//" /etc/default/grub 
	sed -i "/GRUB_CMDLINE_LINUX_DEFAULT=/s/\"$//" /etc/default/grub 
	sed -i "/GRUB_CMDLINE_LINUX_DEFAULT=/s/$/ resume=${swap} \"/" /etc/default/grub 

	grub-mkconfig -o /boot/grub/grub.cfg &>/dev/null

fi

if [[ -n $(grep swap /etc/fstab) ]] && [[ -z $(grep "resume" "/etc/mkinitcpio.conf") ]]; then 

	sed -i '/HOOKS=/s/\<filesystems\>/resume &/' /etc/mkinitcpio.conf

	mkinitcpio -p linux &>/dev/null

fi

#Enable Multilib repo if not already enabled
if [[ -n $(grep "\#\[multilib\]" /etc/pacman.conf) ]]; then

	multiline="$(grep -n "\[multilib\]" /etc/pacman.conf |  tr -dc '0-9')"

	multiline2="$(( ${multiline} + 1 ))"

	sed -i "${multiline}s/\#\[multilib\]/\[multilib\]/" ~/pacman.conf

	sed -i "${multiline2}s/\#Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/" ~/pacman.conf

fi

#Install the nvidia drivers
if [[ -n $(lspci | grep NVIDIA) ]]; then
	pacman -S --noconfirm nvidia nvidia-utils lib32-nvidia-utils nvidia-settings
fi


#Generate the openbox menu
sudo -u $name obmenu-generator -s -i &>/dev/null

#Change default shell to zsh
if [[ -n $(grep $name /etc/passwd | grep bash) ]]; then
	sed -i "/$name/s/\/bin\/bash/\/usr\/bin\/zsh/" /etc/passwd
fi


#(re)install ST
git clone https://gitlab.com/gaugek/st.git /tmp/st &&
cd /tmp/st &&
make &&
make install;
cd /tmp;


#Send a notification when a USB is un/plugged, with the detected USBs and a bit of information
mkdir -p /usr/local/bin;
curl -L https://gitlab.com/GaugeK/dots/raw/master/bin/usb-remove -o /usr/local/bin/usb-remove;
curl -L https://gitlab.com/GaugeK/dots/raw/master/bin/usb-insert -o /usr/local/bin/usb-insert;
curl -L https://gitlab.com/GaugeK/dots/raw/master/bin/usb.rules -o /etc/udev/rules.d/usb.rules;

udevadm control --reload-rules && udevadm trigger;


#--------------End My stuff--------------

# Last message! Install complete!
finalize
clear
