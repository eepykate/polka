#!/bin/sh
#  output windows

case $1 in
	focused) bspc query -N -n .local.\!hidden.focused.\!fullscreen;;
	normal)  bspc query -N -n .local.\!hidden.\!focused.\!fullscreen
esac
