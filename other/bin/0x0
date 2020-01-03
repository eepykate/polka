#!/bin/sh
[ -f "${1}" ] && op=cat
${op:-echo} "${1:-`cat -`}" | curl -F file='@-' 'http://0x0.st'
