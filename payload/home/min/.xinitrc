(ALSA_CONFIG_UCM=/home/min/.builds/linux-4.1-samus/scripts/setup/ucm/ alsaucm -c bdw-rt5677 set _verb HiFi && amixer -c0 set Speaker off && sed -i '/ALSA*/d' ~/.xinitrc) &
amixer -c0 set Master "100%" &
pulseaudio -D &
xbindkeys &
xbacklight -set 10 &
xset s off &
xset -dpms &
xrandr --newmode "1280x850" 88.75 1280 1352 1480 1680 850 853 863 883 -hsync -vsync &
xrandr --addmode eDP1 1280x850 &
setxkbmap -option caps:none &
exec dwm
