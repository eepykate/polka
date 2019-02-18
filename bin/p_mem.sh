#!/bin/bash

printf "♻ "
free -h | awk '/^Mem:/ {print $3 "/" $2}'
