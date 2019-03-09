#!/usr/bin/env bash

dar() {
    display=":$(/usr/bin/ls /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"
    user=$(who | grep pts | awk '{print $1}' | sed -n -e 1p)
    uid=$(id -u $user)

    sudo -u $user DISPLAY=$display DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus "$@"
}

re="\e[31m"
gr="\e[32m"
ye="\e[33m"
cy="\e[36m"
bl="\e[34m"
pu="\e[35m"
n="\e[0m"
b="\e[1m"
u="\e[4m"
i="\e[3m"

help="Basically notify-send but with less features and able to update notifications. (Using GDbus)
This script also works if ran as root.

${b}Syntax:${n}
  $ ${gr}notify.sh${n} ${ye}<options>${n} ${ye}<Title>${n} ${ye}<Body>${n}
 ${b}Examples:${n}
    This will just send a plain notification with the text \"Hello There!\" in the title, and \"This is a test notification\" in the body.
  $ ${gr}notify.sh${n} ${ye}\"Hello there\\!\"${n} ${ye}\"This is a test notification\"${n} 
    This will send a notification with the computer icon from your selected icon theme that will disappear after 10 seconds and will replace notifications with an ID of 420
  $ ${gr}notify.sh${n} ${ye}\"Test\"${n} ${ye}\"This is a test notification\"${n} ${cy}-i${n} computer ${cy}-t${n} 10 ${cy}-r${n} 420
    This is pretty much the last one, but with a 5 second timeout, laptop icon, and replaces 69
  $ ${gr}notify.sh${n} ${cy}-i${n} laptop ${cy}-t${n} 5 ${cy}-r${n} 69 ${ye}\"Test\"${n} ${ye}\"This is a test notification\"${n}
    This will send a notification whatever icon is found in /home/gauge/.startpage/favicon.png
  $ ${gr}notify.sh${n} ${ye}\"Hello again\\!\"${n} ${ye}\"This is another test notification\"${n} ${cy}-i${n} ${pu}${u}/home/gauge/.startpage/favicon.png${n}

Options can be anywhere in the command

${b} -h / --help ${n}          Display what you are reading now
${b} -r / --replace ${n}       Replace notifications with the ID supplied
${b} -t / --timeout ${n}       Time until the notification disappears (In seconds)"

opts=$(getopt -o i:t:r:h --long icon:,timeout:,replace:,help -- "$@")
eval set -- "$opts"

while true ; do
    case "$1" in
        -h|--help)    echo -e "$help"; exit;;
        -r|--replace) replace="$2"; shift 2;;
        -t|--timeout) timeout="$2"; shift 2;;
        -i|--icon)    icon="$2";    shift 2;;
		--) shift; break;;
    esac
done

[[ -z $replace ]] && replace="0"
[[ -z $timeout ]] && timeout="5000" || timeout="$(( $timeout * 1000 ))"
[[ -z $icon ]]    && icon=""

dar gdbus call -e -d "org.freedesktop.Notifications" \
        -o /org/freedesktop/Notifications \
        -m org.freedesktop.Notifications.Notify "" \
        $replace "$icon" "$1" "$2" "[]" "{}" "$timeout"
