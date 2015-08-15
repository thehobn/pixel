(ALSA_CONFIG_UCM=/home/min/.builds/linux-4.1-samus/scripts/setup/ucm/ alsaucm -c bdw-rt5677 set _verb HiFi && amixer -c0 set Speaker off && sed -i '/ALSA*/d' ~/.xinitrc) &
amixer -c0 set Master "100%" &
pulseaudio -D &
setxkbmap -option caps:none &
xbindkeys &
xbacklight -set 10 &
xset s off &
xset -dpms &
export _JAVA_AWT_WM_NONREPARENTING=1 &
exec dwm
