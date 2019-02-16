#!/bin/bash

#sleep 5;

dar() {
    #Detect the name of the display in use
    display=":$(/usr/bin/ls /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"

    #Detect the user using such display
    user=$(who | grep '('$display')' | awk '{print $1}' | sed -n -e 1p)

    #Detect the id of the user
    uid=$(id -u $user)

    sudo -u $user DISPLAY=$display DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus "$@"
}

mice=(/sys/class/input/mouse*)
mice=("${mice[@]//*mouse}")

dev=" "


for mouse in "${mice[@]}"; do
    export dev="$(udevadm info /sys/class/input/mouse${mouse} | awk '$1 ~ "E:"' | awk '/ID_TYPE/' | awk '{$1=""; print $2}')$dev"
done

if [[ -n $(echo "${dev}" | grep "hid") ]]; then
    dar /usr/bin/synclient TouchpadOff=1
else
    dar /usr/bin/synclient TouchpadOff=0
fi


