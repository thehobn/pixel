(physlock -l && slock && physlock -L) &
setxkbmap -option caps:none &
xbindkeys &
(ALSA_CONFIG_UCM=/home/min/.builds/linux-4.1-samus/scripts/setup/ucm/ alsaucm -c bdw-rt5677 set _verb HiFi && amixer -c0 set Speaker off && sed -i '/ALSA*/d' ~/.xinitrc) &
pulseaudio -D &
xset s off &
xset -dpms &
export _JAVA_AWT_WM_NONREPARENTING=1 &
exec dwm
