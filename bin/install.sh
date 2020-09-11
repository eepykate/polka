#!/bin/sh

_() {
	printf '%s\n' "$*"
}

echo '%sudo ALL=(ALL) NOPASSWD: /usr/sbin/kbdrate,/usr/bin/apt,/usr/bin/mount,/usr/bin/umount,/usr/local/bin/cpm,/usr/bin/systemctl' >> /etc/sudoers

user=$(grep ':1000:' /etc/passwd)
user=${user%%:*}

systemctl disable gdm3

# @TODO FIX
_ Installing programs

apt-get install -y \
	arandr atool bspwm chromium feh firefox lxappearance mumble mumble-server \
	ntfs-3g neovim mpv transmission-cli transmission-daemon tree rxvt-unicode \
	zsh sxhkd steam


cat << CMD | sudo -u "$user" sh
_() { printf '%s\n' "$*"; }

_ 'installing some fonts'
_ ' - roboto condensed'

curl -Ls https://fonts.google.com/download?family=Roboto%20Condensed \
	-o /tmp/Roboto-Condensed.zip
unzip -o /tmp/Roboto-Condensed.zip -d "\$HOME/usr/fonts"


_ 'installing dotfiles'
mkdir -p \$HOME/opt
git clone https://github.com/6gk/polka \$HOME/opt/dots
cd \$HOME/opt/dots
./deploy y


mkdir -p \$HOME/opt/git

printf 'manually installing some programs'

_ " - vim-plug"
curl -fLo "\$HOME/usr/nvim/site/autoload/plug.vim" --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

_ " - scr"
git clone https://github.com/6gk/scr "\$HOME/opt/git/scr" &&
	ln -s "\$HOME/opt/git/scr/scr" "\$HOME/bin/scr"

_ " - st"
git clone https://github.com/6gk/st "\$HOME/opt/git/st" &&
	cd "\$HOME/opt/git/st" &&
	make clean install 2>&1 |:

_ " - tabbed"
git clone https://github.com/6gk/tabbed "\$HOME/opt/git/tabbed" &&
	cd "\$HOME/opt/git/tabbed" &&
	make clean install 2>&1 |:

_ " - dmenu"
git clone https://gitlab.com/6gk/dmenu "\$HOME/opt/git/dmenu" &&
	cd "\$HOME/opt/git/dmenu" &&
	make clean install 2>&1 |:

_ " - colorpicker"
git clone https://github.com/ym1234/colorpicker "\$HOME/opt/git/colorpicker" &&
	cd "\$HOME/opt/git/colorpicker" &&
	make clean install 2>&1 |:

_ " - wmutils"
git clone https://github.com/wmutils/core "\$HOME/opt/git/core";
	cd "\$HOME/opt/git/core" &&
	make clean install 2>&1 |:

git clone https://github.com/wmutils/opt "\$HOME/opt/git/opt";
	cd "\$HOME/opt/git/opt" &&
	make clean install 2>&1 |:

_ " - mmutils"
git clone https://github.com/pockata/mmutils "\$HOME/opt/git/mmutils"
	cd "\$HOME/opt/git/mmutils" &&
	make clean install 2>&1 |:

_ " - boox"
git clone https://github.com/BanchouBoo/boox "\$HOME/opt/git/boox"
	cd "\$HOME/opt/git/boox" &&
	make &&
	make install
CMD

_ changing shell to zsh
chsh -s /bin/zsh "$user"

_ getting rid of the annoying beep
rmmod pcspkr
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

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

_ Shortening systemd timeout
sed -i \
	-e 's/^#DefaultTimeoutstopSec=.*/DefaultTimeoutstopSec=4s/g'   \
	-e 's/^#DefaultTimeoutStartSec=.*/DefaultTimeoutStartSec=15s/g' \
	/etc/systemd/system.conf

systemctl daemon-reload

_ Adding scripts to send a notification when a usb is removed/inserted
mkdir -p /usr/local/bin /usr/local/sounds;
o=https://raw.githubusercontent.com/6gk/polka/master/opt
curl -L $o/usb-remove     -o /usr/local/bin/usb-remove;
curl -L $o/usb-insert     -o /usr/local/bin/usb-insert;
curl -L $o/usb.rules      -o /etc/udev/rules.d/usb.rules;
curl -L $o/usb-insert.wav -o /usr/local/sounds/usb-insert.wav;
curl -L $o/usb-remove.wav -o /usr/local/sounds/usb-remove.wav;

echo "Changing a few things in journald to possibly speed up boot time"
sed -i \
	-e 's/^#Storage=.*/Storage=auto/' \
	-e 's/^#SystemMaxFiles=.*/SystemMaxFiles=5/' \
	-e 's/^#SystemMaxFileSize=.*/SystemMaxFileSize=1G/' \
	/etc/systemd/journald.conf


printf 'ZDOTDIR=$HOME/etc/sh' > /etc/zsh/zshenv

sed -i 's/\(.*esound-protocol-unix\)/#\1/g' /etc/pulse/default.pa

_ adding nodelay to pam so sudo doesn\'t take a lifetime to fail
sed -i "s/pam_unix.so.*/pam_unix.so nullok_secure nodelay/" /etc/pam.d/common-auth

_ finished
