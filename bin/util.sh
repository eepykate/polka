#!/bin/sh
#
#  collection of utils written in POSIX sh
#   some probably only work on linux
#
#  shellcheck disable=SC2254 disable=SC2086
#

prin() { printf '%s\n' "$*"; }

pg() {  # pgrep
	[ "$1" = '-x' ] && a="$2" || a="*$1*"
	for i in /proc/[0-9]*; do
		read -r c < "$i/comm"
		case $c in
			$a) prin "${i##*/}";;
		esac
	done
}

pk() {  # pkill
	for i; do
		case $i in
			-x) v=-x; shift;;
			-*) p="$i"; shift;;
		esac
	done
	[ "$1" ] || exit 1
	g=$(pg $v "$1")
	# WARNING: kill isn't always a builtin
	# USE WITH CAUTION
	[ "$g" ] && kill $p $g
}

ppid() {
	while read -r line; do
		case $line in
			PPid*) prin "${line##*:?}"; break;;
		esac
	done < /proc/"$1"/status
}

# very slow...
cpids() {
	for i in /proc/[0-9]*; do
		[ "$(ppid "${i##/proc/}")" = "$1" ] && prin "${i##*/}"
	done
}

pname() {
	for i; do
		read -r v < /proc/"$i"/comm
		prin "$v"
	done
}

gr() {  # grep
	pat="*$1*"; shift
	case $pat in
		'*^'*|*'$*') pat=${pat#\*^}; pat=${pat%\$*}
	esac
	[ "$#" = 0 ] && set -- /dev/stdin
	for i; do
		[ "$#" -gt 1 ] && var="$i: "
		while IFS='' read -r l; do
			case $l in
				$pat) prin "$var$l";;
			esac
		done < "$i"
	done
}

ca() {  # cat
	[ $# = 0 ] && set -- /dev/stdin
	for i; do
		while IFS='' read -r l; do
			prin "$l"
		done < "$i"
	done
}

ll() {  # ls -1
	set -- "${1:-.}"/*
	# it just needs to separate dirs and have colours...
	for i; do
		[ -d "$i" ] && printf '\033[35m%s\033[0m\n' "${i##*/}"
	done

	for i; do
		[ -d "$i" ] && continue
		c=
		[ -x "$i" ] && c='\033[33m'
		[ -L "$i" ] && c='\033[32m'
		printf '%b\033[0m\n' "$c${i##*/}"
	done
}

fn() {  # find
	file=$1
	[ "$dir" ] || dir=${2:-.}
	for i in "$dir"/*; do
		case $i in
			$file) printf '%s\n' "$i";;
		esac
		[ -d "$i" ] && [ ! -h "$i" ] && dir="$i" && fn "$1"
	done
	:
}

fe() {  # field
	v=$*
	while read -r l; do
		set -- $l
		for i in $v; do
			# yucky yucky eval
			eval j="\$$i"
			printf '%s ' "$j"
		done
		prin
	done
}

he() {  # head
	u="$1"; shift
	[ "$1" ] || set -- /dev/stdin
	for i; do
		n=0
		while IFS='' read -r l; do
			prin "$l"
			n=$((n+1))
			[ "$n" = "$u" ] && break
		done < "$i"
	done
}

li() {  # line
	u="$1"; shift
	[ "$1" ] || set -- /dev/stdin
	for i; do
		n=0
		while IFS='' read -r l; do
			n=$((n+1))
			[ "$n" = "$u" ] && prin "$l" && break
		done < "$i"
	done
}

to() {  # touch
	for i; do
		[ -e "$i" ] && continue
		:> "$i"
	done
}

_() {
	case $1 in
		pk|pg|ppid|cpids|pname|gr|ca|ll|fn|fe|he|li|to) "$@"; exit $?;;
	esac
}

case $1 in
	-h|-?|--help) cat << EOF

clones in posix sh

usage:
 - 'ca <files>'              cat
 - 'fe <fields>'             print fields from stdin
 - 'fn <pattern> <dir>'      find
 - 'gr <pattern> <files'     grep
 - 'he <lines> <files>'      head
 - 'li <line> <files>'       print line # from file
 - 'll <dir>'                ls
 - 'to <files>'              touch

 - 'cpids <pid>'             child PIDs
 - 'pg [-x] <pattern>'       pgrep
 - 'pk [-x] <pattern>'       pkill
 - 'pname <pids>'            process name
 - 'ppid <pid>'              parent PID

EOF
	exit
esac

_ "${0##*/}" "$@"
_ "$@"
