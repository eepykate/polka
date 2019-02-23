#!/usr/bin/env bash

printf "♻ "
free -h | awk '/^Mem:/ {print $3 "/" $2}'
