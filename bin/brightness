#!/bin/bash

# base dir for backlight class
basedir="/sys/class/backlight/"

# get the backlight handler
handler=$basedir$(ls $basedir)"/"

# get current brightness
old_brightness=$(cat $handler"brightness")

# get max brightness
max_brightness=$(cat $handler"max_brightness")

# get current brightness %
old_brightness_p=$(( 100 * $old_brightness / $max_brightness ))

# calculate new brightness % 
new_brightness_p=$(($old_brightness_p $1))

# calculate new brightness value
new_brightness=$(( $max_brightness * $new_brightness_p / 100 ))

# set the new brightness value
sudo chmod 666 $handler"brightness"
echo $new_brightness > $handler"brightness"
