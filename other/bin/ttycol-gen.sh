#!/usr/bin/env zsh

template="	echo -en \"\\e]P0xd\" > \"\$tty\" # black
	echo -en \"\\e]P1xd\" > \"\$tty\" # darkred
	echo -en \"\\e]P2xd\" > \"\$tty\" # darkgreen
	echo -en \"\\e]P3xd\" > \"\$tty\" # brown
	echo -en \"\\e]P4xd\" > \"\$tty\" # darkblue
	echo -en \"\\e]P5xd\" > \"\$tty\" # darkmagenta
	echo -en \"\\e]P6xd\" > \"\$tty\" # darkcyan
	echo -en \"\\e]P7xd\" > \"\$tty\" # lightgrey
	echo -en \"\\e]P8xd\" > \"\$tty\" # darkgrey
	echo -en \"\\e]P9xd\" > \"\$tty\" # red
	echo -en \"\\e]PAxd\" > \"\$tty\" # green
	echo -en \"\\e]PBxd\" > \"\$tty\" # yellow
	echo -en \"\\e]PCxd\" > \"\$tty\" # blue
	echo -en \"\\e]PDxd\" > \"\$tty\" # magenta
	echo -en \"\\e]PExd\" > \"\$tty\" # cyan
	echo -en \"\\e]PFxd\" > \"\$tty\" # white"

echo "Getting colours from xrdb"
colours=($(xrdb -query | \
grep "\*.*color" | \
sed -e 's/\*//' -e 's/color//' -e 's/\://' -e 's/#//' | \
sort -n | \
awk '{print $2}'))

echo "Writing to '$HOME/bin/ttycol.sh'"
{
	echo '#!/usr/bin/env bash'
	echo 'export TERM=linux'
	echo 'for tty in /dev/tty[0-9]; do'

	for i in {1..16}; do
		sed -e "${i}!d" -e "s/xd/${colours[${i}]}/" <<< $template
	done

	echo 'done'

} > "$HOME/bin/ttycol.sh"

echo "Marking ttycol.sh as executable"
chmod a+x "$HOME/bin/ttycol.sh"

echo "Moving ttycol.sh to /usr/local/bin/"
sudo mv "$HOME/bin/ttycol.sh" /usr/local/bin/
