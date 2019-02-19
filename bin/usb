#!/bin/bash

dev="$(lsblk | awk '/sd[a-z]/ {print $1}' | tr -d '─├└` ')" 
siz="$(lsblk -o name,size | awk '/sd[a-z]/' | tr -d '─├└`')" 
lab="$(lsblk -o name,label)"
mp="$(lsblk -o name,mountpoint)"
usd="$(lsblk -o name,fsused)"

thing=""
line="
"

for num in $dev; do 
    [[ $(echo "$lab" | grep $num | awk '{print $2}' | wc -m) = 1 ]] && label="No label" || label="$(echo "$lab" | grep $num | awk '{$1=""; print}' | sed 's/^ //')"
    used="$(echo "$usd"  | grep $num | awk '{print $2}')"
    size="$(echo "$siz" | grep $num | awk '{print $2}')"
    [[ $(echo "$mp" | grep $num | awk '{print $2}' | wc -m) = 1 ]] && mounted="Not mounted" || mounted="$(echo "$mp" | grep $num | awk '{print $2}')"
    if [[ $(printf "$num" | wc -m) == 3 ]] && [[ $(printf "$num") != sda ]]; then
        thing="$thing  $line"
    elif [[ $num != sda ]]; then
        thing="$thing$(printf "%-12s" "$label") \
$(printf "%-10s" " - /dev/$num") \
$(printf "%-16s" " - $mounted") \
$([[ -n $used ]] && printf "%-14s" " - $used/$size" || printf "%-14s" " - $size")​$line​"
fi
done

thing="$(printf "$thing" | sed '$ d')"

#printf "$thing"
#notify-send "Disks" "$thing"

function notify-root() {
    #Detect the name of the display in use
    display=":$(/usr/bin/ls /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"

    #Detect the user using such display
    user=$(who | grep '('$display')' | awk '{print $1}' | sed -n -e 1p)

    #Detect the id of the user
    uid=$(id -u $user)

    sudo -u $user DISPLAY=$display DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus /usr/bin/notify-send "$@"
}

notify-root "USBs Connected" "$thing"
