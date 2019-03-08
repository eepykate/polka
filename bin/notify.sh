#!/usr/bin/env bash

gdbus call -e -d "org.freedesktop.Notifications" \
    -o /org/freedesktop/Notifications \
    -m org.freedesktop.Notifications.Notify "" \
    $1 "" "$2" "$3" "[]" "{}" 5000
