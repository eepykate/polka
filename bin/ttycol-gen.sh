#!/bin/sh

{
	printf '#!/usr/bin/env bash\n'
	printf 'export TERM=linux\n'
	printf 'for tty in /dev/tty[0-9]; do\n'
	printf '\t[ -w "$tty" ] || continue\n'
	xrdb -q | while read -r line; do
		case $line in
			*color[0-9]*)
				set -- c${line#*c}
				one="${1##*r}"
				[ "${one%:}" -gt 15 ] && continue
				hex="$(printf %x "${one%:}")"
				printf '\tprintf "\\033]P%s%s" > "$tty"\n' "$hex" "${2#?}"
			;;
		esac
	done
	printf 'done\n'
} > "$HOME/bin/ttycol.sh"

chmod a+x "$HOME/bin/ttycol.sh"
sudo mv "$HOME/bin/ttycol.sh" /usr/local/bin/
