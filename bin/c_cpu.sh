#!/usr/bin/env bash

notify-send "Biggest CPU hogs" "$(ps axch -o cmd:15,%cpu --sort=-%cpu | head | awk '{print $0"%"}')"
