#!/usr/bin/env bash

printf "<span font='FontAwesome 11'></span> "
free -h | awk '/^Mem:/ {print $3 "/" $2}'
