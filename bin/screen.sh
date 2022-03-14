#!/bin/sh

var=right  #bottom/right

#xrandr --output DVI-D-0 --off
#xcalib -c
#xcalib -v -red 1 4.3 100 -green 1 4.3 97 -blue 1 4.5 96 -alter
##redshift -o -l 0:0 -m randr:crtc=1 -P -t 7000:7000 -g 1:1.1:1.1 -b 1
#

#--output HDMI-0  --mode 1920x1080 -r 60 --pos 0x100    --rotate normal --scale 1x1 --primary \
#--output DVI-D-0 --mode 1440x900  -r 60 --pos 1920x0   --rotate right  --scale 1x1 \
#--output HDMI-0  --off \

#--output HDMI-0  --off \

case $var in
r*)
	xrandr \
		--output DP-0    --mode 2560x1440 --panning 2560x1440+1920+0 -r 165 --pos 1920x0 --rotate normal --reflect normal --scale 1x1 --primary \
		--output HDMI-0  --mode 1920x1080 --panning 1920x1080+0+110  -r 75  --pos 0x110   --rotate normal --reflect normal --scale 1x1
;;
b*)
	xrandr \
	--output DP-0    --mode 2560x1440 -r 165 --pos 0x1080 --rotate normal --reflect normal --scale 1x1 --primary \
	--output HDMI-0  --mode 1920x1080 -r 75  --pos 320x0   --rotate normal --reflect normal --scale 1x1
;;
esac
	#--output HDMI-0  --mode 1920x1080 -r 75  --pos 2560x360  --rotate normal --scale 1x1
#--output DVI-D-0 --mode 1440x900  -r 60  --pos 0x540     --rotate normal --scale 1x1 \
	#--output DVI-D-0 --mode 1440x900  -r 60    --right-of HDMI-0 --rotate normal --scale 1x1
#xrandrr \
#	--output DVI-D-0 --mode 1440x900  -r 60 --pos 0x0 --rotate normal --scale 1x1 --primary \
#	--output HDMI-0  --mode 1920x1080 -r 60 --right-of DVI-D-0 --rotate normal --scale 1x1
	#--output HDMI-0  --mode 1920x1080 -r 60 --pos 1440x0 --rotate normal --scale 1x1
#xrandr --output DVI-D-0 --off --output HDMI-0 --primary --mode 1920x1080 -r 72 --pos 0x0 --rotate normal --output DP-0 --off --output DP-1 --off
{
#sleep 0.5
nvidia-settings -l --config=$HOME/opt/nvidia-settings-rc
#redshift -o -l 0:0 -m randr:crtc=1 -P -t 6500:6500 -g 0.85:0.94:1.0 -b 0.7
sleep 0.5
#redshift -o -l 0:0 -m randr:crtc=2 -P -t 7900:7900 -g 0.95:0.95:0.95 -b 1
#redshift -o -l 0:0 -m randr:crtc=1 -P -t 7600:7600 -g 0.97:1:1 -b 1
#redshift -o -l 0:0 -m randr:crtc=0 -P -t 7000:7000 -b 0.34 #-g 0.79:0.98:1.0 -b 1
#xrandr --output eDP-1 --primary
#redshift -o -l 0:0 -m randr:crtc=2 -P -b 0.94 -g 0.95:0.95:0.88
:
} &
pap
