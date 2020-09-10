#!/bin/sh

loc="/usr/lib/firefox-developer-edition"
[ -d "$loc" ] || loc="/usr/lib/firefox"

curl -Ls \
	https://raw.githubusercontent.com/alice0775/userChrome.js/master/72/userChrome.js \
	-o "$HOME/etc/.mozilla/firefox/*/chrome/userChrome.js"

sudo curl -Ls \
	https://raw.githubusercontent.com/alice0775/userChrome.js/master/72/install_folder/defaults/pref/config-prefs.js \
	-o "$loc/defaults/pref/config-prefs.js" 2>/dev/null

sudo curl -Ls \
	https://raw.githubusercontent.com/alice0775/userChrome.js/master/72/install_folder/config.js \
	-o "$loc/config.js" 2>/dev/null
