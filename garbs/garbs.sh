#!/bin/bash

dots="https://gitlab.com/GaugeK/dots.git"

pacman -Syyu --noconfirm --needed dialog archlinux-keyring

getuserandpass() {
	# Prompts user for new username an password.
	# Checks if username is valid and confirms passwd.
	export name=$(dialog --inputbox "First, please enter a name for the user account." 10 60 3>&1 1>&2 2>&3 3>&1) || exit
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
	done
}

adduserandpass() {
	# Adds user `$name` with password $pass1.
	dialog --infobox "Adding user \"$name\"..." 4 50
	useradd -m -g wheel -s /bin/bash "$name" &>/dev/null ||
	usermod -a -G wheel "$name" && mkdir -p /home/"$name" && chown "$name":wheel /home/"$name"
	echo "$name:$pass1" | chpasswd
	unset pass1 pass2
}

putgitrepo() {
	# Downlods a gitrepo $1 and places the files in $2 only overwriting conflicts
	dir=$(mktemp -d)
	chown -R "$name":wheel "$dir"
	sudo -u "$name" git clone --depth 1 "$1" "$dir"/gitrepo &>/dev/null &&
	sudo -u "$name" mkdir -p "$2" &&
	sudo -u "$name" cp -rT "$dir"/gitrepo "$2"
}

###
### THE ACTUAL SCRIPT ###
###
### This is how everything happens in an intuitive format and order.
###

# Get and verify username and password.
getuserandpass

### The rest of the script requires no user input.

adduserandpass

# Allow user to run sudo without password. Since AUR programs must be installed
# in a fakeroot environment, this is required for all builds with AUR.
echo -e "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

pacman --noconfirm --needed -S base-devel &>/dev/null



echo "Installing yay, an AUR helper"

[[ -f /usr/bin/yay ]] || (
cd /tmp
rm -rf /tmp/"yay"*
curl -sO https://aur.archlinux.org/cgit/aur.git/snapshot/"yay".tar.gz &&
sudo -u "$name" tar -xvf "yay".tar.gz &>/dev/null &&
cd "yay" &&
 makepkg --noconfirm -si &>/dev/null
cd /tmp)


echo "Making sure the root user has sudoers permissions"

if ! grep "root ALL=(ALL) ALL" "/etc/sudoers" &>/dev/null; then
	echo "root ALL=(ALL) ALL" >> /etc/sudoers
fi

echo "Installing programs"
pacman -S --noconfirm --needed \
	git bspwm sxhkd xclip util-linux \
	transmission-qt transmission-cli \
	noto-fonts noto-fonts-cjk xfce4 xfce4-goodies \
	xorg-server xorg-xdpyinfo xorg-xwininfo \
	xorg-xinit xorg-xkill xorg-xset \
	xorg-xprop xorg-xrandr xorg-xgamma \
	curl wget code papirus-icon-theme \
	rofi zsh \
	arandr dosfstools exfat-utils \
	feh ffmpeg firefox firefox-developer-edition \
	gnome-keyring gnome-themes-extra ntfs-3g \
	pulseaudio pulseaudio-alsa \
	scrot maim unrar unzip p7zip \
	wget xdotool xssstate youtube-dl \
	source-highlight syntax-highlighting \
	vlc mpv gimp inkscape qt5ct \
	xf86-input-synaptics dunst \
	python xautolock playerctl gst-plugins-good \
	rsync ffmpegthumbnailer ffmpegthumbs \
	ark acpi imagemagick neovim cmus \
	zsh-completions compton mpd ncmpcpp \
	gcolor3 gnome-system-monitor


sudo -u $name yay -S --noconfirm --needed \
	i3lock-color-git qview gtk3-mushrooms \
	pulseaudio-ctl light-git bibata-cursor-theme \
	lemonbar-xft-git kvantum-qt4-git \
	transmission-remote-cli-git flashfocus-git \
	mpdris2

echo -e "installing dotfiles"

# Install the dotfiles in the user's home directory
putgitrepo "$dots" "/home/$name/git"

#Symlink / copy files from ~/git into ~/

mkdir -p \
	/home/$name/.mozilla/firefox/gauge.gauge/chrome \
	/home/$name/.config \
	/home/$name/.local/share \
	/home/$name/bin \
	/home/$name/.icons/default \
	/home/$name/.config/backup \
	/home/$name/.themes


find /home/$name/git/.config/ -maxdepth 1 > /tmp/config.txt
sed -e 's/git\///' -e '1d' < /tmp/config.txt > /tmp/config_1.txt
while read i; do mv $i /home/$name/.config/backup/; done < /tmp/config_1.txt
while read i; do ln -sf $i /home/$name/.config/; done < /tmp/config.txt

cp -rf /home/$name/git/.local/share/* /home/$name/.local/share/
cp -rf /home/$name/git/.themes/* /home/$name/.themes/

cp -f /home/$name/git/.icons/default/index.theme /home/$name/.icons/default/index.theme

find /home/$name/git/ -maxdepth 1 | grep -v "local\|config\|bin\|mozilla\|theme\|icon"> /tmp/home.txt
for i in $(cat /tmp/home.txt); do ln -sf $i /home/$name/; done

ln -sf /home/$name/git/.mozilla/firefox/gauge.gauge/chrome/* /home/$name/.mozilla/firefox/gauge.gauge/chrome/
cp /home/$name/git/.mozilla/firefox/profiles.ini /home/$name/.mozilla/firefox/profiles.ini

ln -sf /home/$name/git/bin/* /home/$name/bin/

chown $name:wheel /home/$name -R

# Most important command! Get rid of the beep!
rmmod pcspkr
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

# This line, overwriting the `newperms` command above will allow the user to run
# serveral important commands, `shutdown`, `reboot`, updating, etc. without a password.
echo -e "%wheel ALL=(ALL) ALL\\n%wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/systemctl suspend,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/packer -Syu,/usr/bin/packer -Syyu,/usr/bin/systemctl restart NetworkManager,/usr/bin/rc-service NetworkManager restart,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/yay,/usr/bin/pacman -Syyuw --noconfirm, /usr/bin/kbdrate -d 200 -r 30" >> /etc/sudoers


echo "Installing some fonts"

mkdir -p /usr/share/fonts/TTF
mkdir -p /usr/share/fonts/OTF

echo " - Source Code Pro"
# Sauce Code Pro font
rm -f /tmp/SauceCodePro.zip &>/dev/null
curl -Ls https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/SourceCodePro.zip >> /tmp/SauceCodePro.zip 
unzip -o /tmp/SauceCodePro.zip -d /usr/share/fonts/TTF/ &>/dev/null

echo " - Iosevka"
# Iosevka font
rm -f /tmp/02-iosevka-term-2.0.1.zip &>/dev/null
curl -Ls https://github.com/be5invis/Iosevka/releases/download/v2.0.1/02-iosevka-term-2.0.1.zip >> /tmp/02-iosevka-term-2.0.1.zip 
unzip -o /tmp/02-iosevka-term-2.0.1.zip -d /usr/share/fonts/TTF/ &>/dev/null

# Iosevka Nerd Font
rm /tmp/Iosevka-nerd-font.zip
curl -Ls https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Iosevka.zip -o /tmp/Iosevka-nerd-font.zip
unzip -o /tmp/Iosevka-nerd-font.zip -d /usr/share/fonts/TTF/ &>/dev/null

echo " - Roboto"
# Roboto fonts
curl -Ls https://fonts.google.com/download?family=Roboto -o /tmp/Roboto.zip
unzip -o /tmp/Roboto.zip -d /usr/share/fonts/TTF/ &>/dev/null

curl -Ls https://fonts.google.com/download?family=Roboto%20Condensed -o /tmp/Roboto-Condensed.zip
unzip -o /tmp/Roboto-Condensed.zip -d /usr/share/fonts/TTF/ &>/dev/null

echo " - Normal nerd font"
# Nerd font
rm /tmp/Regular.zip
curl -Ls https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Regular.zip -o /tmp/Regular.zip
unzip -o /tmp/Regular.zip -d /usr/share/fonts/TTF/ &>/dev/null

#Fira code font
#curl -Ls https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fura%20Code%20Regular%20Nerd%20Font%20Complete%20Mono.otf > "/usr/share/fonts/OTF/Fira Code Mono.otf"

fc-cache -f



echo "Disabling mouse acceleration"
# Disable mouse acceleration
if [ ! -f /etc/X11/xorg.conf.d/50-mouse-acceleration.conf ]; then
echo 'Section "InputClass"
    Identifier "My Mouse"
    MatchIsPointer "yes"
    Option "AccelerationProfile" "-1"
    Option "AccelerationScheme" "none"
    Option "AccelSpeed" "-0.75"
EndSection' >> /etc/X11/xorg.conf.d/50-mouse-acceleration.conf
fi

# Touchpad stuff
echo "Making some minor touchpad modifications"
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

# Make sudo as normal user request the root user's password instead of that user's
#if [[ -z $(grep "Defaults rootpw" "/etc/sudoers") ]]; then
#	sed -i '/## Defaults specification/a Defaults rootpw' /etc/sudoers
#fi

echo "Enabling verbose package lists in pacman"
# One line per pkg pacman
sed -i "s/^#VerbosePkgLists/VerbosePkgLists/g" /etc/pacman.conf

echo "Enabling pacman loading bar in pacman"
# Pacman-like loading bar in pacman
if [[ -z $(grep ILoveCandy "/etc/pacman.conf") ]]; then
	sed -i '/# Misc options/a ILoveCandy' /etc/pacman.conf
fi

echo "Making pacman/yay colourful"
# Make pacman and yay colorful because why not.
sed -i "s/^#Color/Color/g" /etc/pacman.conf

# Make wifi faster on my card
#if [ -n /etc/modprobe.d/iwlwifi.conf ]; then
#	sh -c 'echo "options iwlwifi bt_coex_active=0 swcrypto=1 11n_disable=8" > /etc/modprobe.d/iwlwifi.conf'
#fi

echo "Shortening systemd timeout"
# Shorter timeout for systemd init
sed -i "s/^#DefaultTimeoutStartSec=90s/DefaultTimeoutStartSec=15s/g" /etc/systemd/system.conf
sed -i "s/^#DefaultTimeoutstopSec=90s/DefaultTimeoutstopSec=10s/g" /etc/systemd/system.conf
systemctl daemon-reload

# Show details about boot while booting up
sed -i "s/quiet//" /etc/default/grub

echo "Enabling hibernation in grub/mkinitcpio"
# Enable hibernation (Probably won't work lmao)
if [[ -n $(grep swap /etc/fstab) ]]; then
	uswap="$(grep swap /etc/fstab | awk '{print $1}')"
fi

if [[ -n $(grep swap /etc/fstab) ]] && [[ -z $(grep "resume" "/etc/default/grub") ]]; then 
	sed -i "/GRUB_CMDLINE_LINUX_DEFAULT=/s/ $//" /etc/default/grub 
	sed -i "/GRUB_CMDLINE_LINUX_DEFAULT=/s/\"$//" /etc/default/grub 
	sed -i "/GRUB_CMDLINE_LINUX_DEFAULT=/s/$/ resume=${uswap} \"/" /etc/default/grub 

	grub-mkconfig -o /boot/grub/grub.cfg &>/dev/null
fi

if [[ -n $(grep swap /etc/fstab) ]] && [[ -z $(grep "resume" "/etc/mkinitcpio.conf") ]]; then 
	sed -i '/HOOKS=/s/\<filesystems\>/resume &/' /etc/mkinitcpio.conf
	mkinitcpio -p linux &>/dev/null
fi


# Enable Multilib repo if not already enabled
if [[ -n $(grep "\#\[multilib\]" /etc/pacman.conf) ]]; then
	echo "Enabling multilib repo"

	multiline="$(grep -n "\[multilib\]" /etc/pacman.conf |  tr -dc '0-9')"

	multiline2="$(( ${multiline} + 1 ))"

	sed -i "${multiline}s/\#\[multilib\]/\[multilib\]/" ~/pacman.conf

	sed -i "${multiline2}s/\#Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/" ~/pacman.conf

fi

# Install the nvidia drivers
if [[ -n $(lspci | grep -i NVIDIA) ]]; then
	echo "Installing nvidia drivers"
	pacman -S --noconfirm nvidia nvidia-utils lib32-nvidia-utils nvidia-settings
fi


echo "Downloading syntax highlighting plugin for zsh"
# Syntax highlighting in zsh 
git clone https://github.com/zdharma/fast-syntax-highlighting /usr/share/zsh/plugins/fast-syntax-highlighting

# Change default shell to zsh
if [[ -n $(grep $name /etc/passwd | grep bash) ]]; then
	echo "Changing default shell from bash to zsh"
	sed -i "/$name/s/\/bin\/bash/\/usr\/bin\/zsh/" /etc/passwd
fi


echo "Installing st"
# (re)install ST
git clone https://gitlab.com/gaugek/st.git /tmp/st &&
cd /tmp/st &&
make clean install &>/dev/null
cd /tmp;

echo "Installing tabbed"
# (re)install tabbed
git clone https://gitlab.com/gaugek/tabbed.git /tmp/tabbed &&
cd /tmp/tabbed &&
make clean install &>/dev/null
cd /tmp

echo "Installing dmenu"
# (re)install dmenu
git clone https://gitlab.com/gaugek/dmenu.git /tmp/dmenu &&
cd /tmp/dmenu &&
make clean install &>/dev/null
cd /tmp

echo "Installing wmutils"
# install wmutils
git clone https://github.com/wmutils/core /tmp/wmutils;
	cd /tmp/wmutils; make clean install &>/dev/null

mkdir -p /home/$name/Stuff/Screenshots/scrot/

echo "Adding mpris support to mpv"
# mpris support in mpv
mkdir -p /etc/mpv/scripts
cd /tmp
git clone https://github.com/hoyon/mpv-mpris
cd /tmp/mpv-mpris
make &>/dev/null
cp mpris.so /etc/mpv/scripts/

echo "Adding scripts to send a notification when a usb is removed/inserted"
# Send a notification when a USB is un/plugged, with the detected USBs and a bit of information
mkdir -p /usr/local/bin /usr/local/sounds;
curl -L https://gitlab.com/GaugeK/dots/raw/master/bin/usb-remove -o /usr/local/bin/usb-remove;
curl -L https://gitlab.com/GaugeK/dots/raw/master/bin/usb-insert -o /usr/local/bin/usb-insert;
curl -L https://gitlab.com/GaugeK/dots/raw/master/bin/usb.rules -o /etc/udev/rules.d/usb.rules;
curl -L https://gitlab.com/GaugeK/dots/raw/master/bin/usb-insert.wav -o /usr/local/sounds/usb-insert.wav;
curl -L https://gitlab.com/GaugeK/dots/raw/master/bin/usb-remove.wav -o /usr/local/sounds/usb-remove.wav;

udevadm control --reload-rules;



echo "Installing vim-plug for neovim"
# vim-plug for neovim
curl -fLo /home/$name/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


echo "Changing a few things in journald to possibly speed up boot time"
# Changes to systemd journald to speed up boot time
sed -i \
	-e 's/^#Storage=.*/Storage=auto/' \
	-e 's/^#SystemMaxFiles=.*/SystemMaxFiles=5/' \
	-e 's/^#SystemMaxFileSize=.*/SystemMaxFileSize=1G/' \
	/etc/systemd/journald.conf



echo "Telling linux to use no more than 10M ram for caching writes"
echo 10000000 > /proc/sys/vm/dirty_bytes
