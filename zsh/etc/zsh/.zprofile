#     ~/.profile     #
export XDG_CONFIG_HOME="$HOME/etc"
export XDG_CACHE_HOME="$HOME/usr/cache"
export XDG_DATA_HOME="$HOME/usr"


# I am unsure if this is needed right now,
# # so I'll just comment it out in case it is
#export GTK2_RC_FILES="${XDG_CONFIG_HOME:-~/.config}/gtk-2.0/gtkrc-2.0"
export XAUTHORITY="/run/user/$UID/.Xauthority"
export LdESSHISTFILE="/dev/null"


# Custom ls colours
eval "$(dircolors ${XDG_CONFIG_HOME:-~/.config}/zsh/dircolors)"

# Places where binaries/scripts go so you dont have to type the whole path to run them
export PATH="$(find ~/bin/ -maxdepth 1 -type d | sed 's|/$||'| tr '\n' ':')$PATH"

# less/man colors
export LESS=-R
export LESS_TERMCAP_md=$'\033[1;34m'       # begin blink
export LESS_TERMCAP_{me,ue}=$'\033[0m'     # reset bold/blink and underline
export LESS_TERMCAP_us=$'\033[1;35m'       # begin underline

shortcuts

if [[ "$TERM" = "linux" ]]; then
	# subshell is to hide the info about the fork to the background
	( source tty-colours.sh & )
	( sudo /usr/bin/kbdrate -d 200 -r 60 &>/dev/null & )
	#clear #for background artifacting
	# because for some reason I need to manually start pulseaudio now. ok
	( pulseaudio --start & )
fi
