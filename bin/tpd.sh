#!/bin/bash

sleep 3

printf "" > /tmp/tpd
 
for mouse in /sys/class/input/mouse*; do
    type="$(udevadm info ${mouse} | awk '$1 ~ "E:"' | awk '/ID_TYPE/' | awk '{$1=""; print $2}')"
    echo "${type}" >> /tmp/tpd
done

type="$(cat /tmp/tpd)"

sleep 1

if [[ $(echo "$type" | grep -i hid | wc -m) -ge 5 ]]; then
    /usr/bin/synclient TouchpadOff=1
else
    /usr/bin/synclient TouchpadOff=0
fi
