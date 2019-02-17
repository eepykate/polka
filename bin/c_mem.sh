#!/bin/bash

notify-send "Biggest memory hogs" "$(ps axch -o cmd:15,%mem --sort=-%mem | head | awk '{print $0 "%"}')"
