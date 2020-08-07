#!/usr/bin/env bash

{
	printf '#!/usr/bin/env bash
export TERM=linux
for tty in /dev/tty[0-9]; do
[ -w "$tty" ] || continue\n'
	xrdb -q | while read -r line; do
		case $line in
			*color[0-9]*)
				set -- c${line#*c}
				one="${1##*r}"
				[ "${one%:}" -gt 15 ] && continue
				hex="$(printf %x "${one%:}")"
				printf 'echo -en "\\e]P%s%s" > "$tty"\n' "$hex" "${2#?}"
			;;
		esac
	done
	printf 'done\n'
} > "$HOME/bin/ttycol.sh"

chmod a+x "$HOME/bin/ttycol.sh"
sudo mv "$HOME/bin/ttycol.sh" /usr/local/bin/
