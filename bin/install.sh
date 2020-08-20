#!/bin/sh

_() {
	printf '%s\n' "$*"
}

printf 'username: '
read -r user
printf '\npassword: '
read -r pass1
printf '\nconfirm: '
read -r pass2
echo

[ "${#user}" -gt 0 ] && [ "$pass1" = "$pass2" ] || exit 1
useradd -m -g wheel -s /bin/bash "$user" >/dev/null 2>&1 ||
	usermod -a -G wheel "$user" && mkdir -p /home/"$user" &&
	chown "$user":wheel /home/"$user"
echo "$user:$pass1" | chpasswd


_ giving root correct permissions
_ "root ALL=(ALL) ALL" >> /etc/sudoers
_ "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

_ updating
pacman --noconfirm --needed -Syyu base-devel archlinux-keyring git

_ installing yay
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
sudo -u "$user" makepkg -si --noconfirm
cd /tmp


_ Installing programs
pacman -S --noconfirm --needed alsa-tools alsa-utils arandr atool bspwm \
	chromium crda dash dunst exfat-utils feh ffmpeg firefox-developer-edition \
	fzf gcolor3 gimp gucharmap htop imagemagick inkscape inotify-tools mpv \
	mumble murmur neovim ntfs-3g nvidia-nvidia-settings patch pavucontrol \
	playerctl pulseaudio pulseaudio-alsa rsync shotgun sxhkd xclip xdo \
	xdotool xkbset xorg-xev xorg-xgamma xorg-xinit xorg-xinput xorg-xkill \
	xorg-xprop xorg-xrandr xorg-xsetroot zsh



_ installing dotfiles
sudo sh -u "$user" -c "mkdir -p \$HOME/opt; cd \$HOME/opt
git clone https://github.com/6gk/polka dots; cd dots; ./deploy y"

_ getting rid of the annoying beep
rmmod pcspkr
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

_ modifying permissions
cat << EOF >> /etc/sudoers
%wheel ALL=(ALL) ALL
%wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/systemctl suspend,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/packer -Syu,/usr/bin/packer -Syyu,/usr/bin/systemctl restart NetworkManager,/usr/bin/rc-service NetworkManager restart,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/yay,/usr/bin/pacman -Syyuw --noconfirm, /usr/bin/kbdrate
EOF

_ Installing some fonts
mkdir -p "/home/$user/usr/fonts"

_ " - Roboto Condensed"
curl -Ls https://fonts.google.com/download?family=Roboto%20Condensed \
	-o /tmp/Roboto-Condensed.zip
unzip -o /tmp/Roboto-Condensed.zip -d "/home/$user/usr/fonts/" >/dev/null 2>&1

_ Disabling mouse acceleration
mkdir -p /etc/X11/xorg.conf.d/
[ -f /etc/X11/xorg.conf.d/50-mouse-acceleration.conf ] ||
	cat << EOF > /etc/X11/xorg.conf.d/50-mouse-acceleration.conf
Section "InputClass"
	Identifier "My Mouse"
	MatchIsPointer "yes"
	Option "AccelerationProfile" "-1"
	Option "AccelerationScheme" "none"
	Option "AccelSpeed" "-0.75"
EndSection
EOF

_ Making some minor touchpad modifications
[ -f /etc/X11/xorg.conf.d/70-synaptics.conf ] ||
	cat << EOF > /etc/X11/xorg.conf.d/70-synaptics.conf
Section "InputClass"
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
EOF

_ pacman tweaks

_ ' - Verbose package lists'
sed -i 's/^#VerbosePkgLists/VerbosePkgLists/g' /etc/pacman.conf

_ ' - pacman loading bar'
grep -iq '^ilovecandy' /etc/pacman.conf || _ 'ILoveCandy' >> /etc/pacman.conf

_ ' - colour'
sed -i 's/^#.*Color/Color/g' /etc/pacman.conf

_ Shortening systemd timeout
# Shorter timeout for systemd init
sed -i 's/^#DefaultTimeoutStartSec=.*/DefaultTimeoutStartSec=15s/g' /etc/systemd/system.conf
sed -i 's/^#DefaultTimeoutstopSec=.*/DefaultTimeoutstopSec=4s/g' /etc/systemd/system.conf
systemctl daemon-reload

# Show details about boot while booting up
sed -i 's/quiet//' /etc/default/grub

_ Enabling hibernation

set -- $(grep -i swap /etc/fstab)
[ "$1" ] && {
	grep -iq resume /etc/default/grub || {
		v=GRUB_CMDLINE_LINUX_DEFAULT
		sed -i "/$v=/s/\" *$/ resume=$1 \"/" /etc/default/grub

		grub-mkconfig -o /boot/grub/grub.cfg >/dev/null 2>&1
	}
	grep -iq resume "/etc/mkinitcpio.conf" || {
		sed -i '/HOOKS=/s/\<filesystems\>/resume &/' /etc/mkinitcpio.conf
		mkinitcpio -p linux >/dev/null 2>&1
	}
}


_ enabling multilib repo
grep -iq '^\[multilib\]' /etc/pacman.conf || {
	_ '[multilib]' >> /etc/pacman.conf
	_ 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
}


# Install the nvidia drivers
lspci | grep -iq NVIDIA &&
	_ Installing nvidia drivers &&
	pacman -S --noconfirm nvidia nvidia-utils lib32-nvidia-utils nvidia-settings

_ changing shell to zsh
chsh -s /bin/zsh "$user"

mkdir -p "/home/$user/opt/git"
_ Manually installing some programs

_ " - scr"
git clone https://github.com/6gk/scr "/home/$user/opt/git/scr" &&
	ln -s "/home/$user/opt/git/scr/scr" "/home/$user/bin/scr"

_ " - st"
git clone https://github.com/6gk/st.git "/home/$user/opt/git/st" &&
	cd "/home/$user/opt/git/st" && make clean install 2>&1 |:

_ " - stmessage (to live-reload st)"
git clone https://github.com/6gk/thememenu "/home/$user/opt/git/thememenu"
	cd "/home/$user/opt/git/thememenu" && make && cp stmessage /usr/local/bin/ 2>&1 |:

_ " - tabbed"
git clone https://github.com/6gk/tabbed.git "/home/$user/opt/git/tabbed" &&
	cd "/home/$user/opt/git/tabbed" && make clean install 2>&1 |:

_ " - dmenu"
git clone https://gitlab.com/6gk/dmenu.git "/home/$user/opt/git/dmenu" &&
	cd "/home/$user/opt/git/dmenu" && make clean install 2>&1 |:

_ " - colorpicker"
git clone https://github.com/ym1234/colorpicker.git "/home/$user/opt/git/colorpicker" &&
	cd "/home/$user/opt/git/colorpicker" &&
	make clean install 2>&1 |:

_ " - wmutils"
git clone https://github.com/wmutils/core "/home/$user/opt/git/core";
	cd "/home/$user/opt/git/core" && make clean install 2>&1 |:

git clone https://github.com/wmutils/opt "/home/$user/opt/git/opt";
	cd "/home/$user/opt/git/opt" && make clean install 2>&1 |:

_ " - mmutils"
git clone https://github.com/pockata/mmutils "/home/$user/opt/git/mmutils"
	cd "/home/$user/opt/git/mmutils" && make clean install 2>&1 |:

_ " - boox"
git clone https://github.com/https://github.com/BanchouBoo "/home/$user/opt/git/boox"
	cd "/home/$user/opt/git/boox" && make && make install


_ Adding scripts to send a notification when a usb is removed/inserted
mkdir -p /usr/local/bin /usr/local/sounds;
o=https://raw.githubusercontent.com/6gk/polka/master/opt
curl -L $o/usb-remove     -o /usr/local/bin/usb-remove;
curl -L $o/usb-insert     -o /usr/local/bin/usb-insert;
curl -L $o/usb.rules      -o /etc/udev/rules.d/usb.rules;
curl -L $o/usb-insert.wav -o /usr/local/sounds/usb-insert.wav;
curl -L $o/usb-remove.wav -o /usr/local/sounds/usb-remove.wav;


_ Installing vim-plug
curl -fLo "/home/$user/usr/nvim/site/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


echo "Changing a few things in journald to possibly speed up boot time"
sed -i \
	-e 's/^#Storage=.*/Storage=auto/' \
	-e 's/^#SystemMaxFiles=.*/SystemMaxFiles=5/' \
	-e 's/^#SystemMaxFileSize=.*/SystemMaxFileSize=1G/' \
	/etc/systemd/journald.conf


_ 'ZDOTDIR=$HOME/etc/sh' > /etc/zsh/zshenv
sed -i 's/\(.*esound-protocol-unix\)/#\1/g' /etc/pulse/default.pa

_ Telling linux to use no more than 50M ram for caching writes
echo 50000000 > /proc/sys/vm/dirty_bytes


echo Making firefox dev edition support uc.js files
mkdir -p "/home/$user/etc/.mozilla/firefox/gauge.gauge/chrome/userChrome.js"
git clone https://github.com/alice0775/userChrome.js "/home/$user/opt/git/userChrome.js"
cd "/home/$user/opt/git/userChrome.js/72" &&
cp -r install_folder/* /lib/firefox-developer-edition &&
cp userChrome.js "/home/$user/etc/.mozilla/firefox/gauge.gauge/chrome/userChrome.js"

_ adding nodelay to pam_unix.so so sudo doesn\'t take a lifetime to fail
sed -i "s/pam_unix.so.*/pam_unix.so     try_first_pass nullok nodelay/" /etc/pam.d/system-auth

_ "fixing permissions in $user's home dir"
chown -R "${user}:wheel" "/home/$user"


_ finished
