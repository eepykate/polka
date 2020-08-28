#!/bin/sh

{
	printf '#!/usr/bin/env bash\n'
	printf 'export TERM=linux\n'
	printf 'for tty in /dev/tty[0-9]; do\n'
	printf '\t[ -w "$tty" ] || continue\n'
	. ~/etc/colours/current
	for i in 0$bg1 1$red 2$yellow 3$green 4$cyan 5$blue 6$purple 7$fg1; do
		printf '\tprintf "\\033]P%s%s" > "$tty"\n' "${i%??????}" "${i#?}"
		printf '\tprintf "\\033]P%X%s" > "$tty"\n' "$((${i%??????}+8))" "${i#?}"
	done
	printf 'done\n'
} > "$HOME/bin/ttycol.sh"

chmod a+x "$HOME/bin/ttycol.sh"
sudo mv "$HOME/bin/ttycol.sh" /usr/local/bin/
