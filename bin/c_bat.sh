#!/bin/sh
# Give a battery name (e.g. BAT0) as an argument.

#capacity=$(cat /sys/class/power_supply/"$1"/capacity) || exit
#status=$(cat /sys/class/power_supply/"$1"/status)
#notify-send "Battery percentage is at $(echo "$capacity" | sed -e 's/$/%/')"

acpi="$(acpi)"

notify-send "$(acpi)"
