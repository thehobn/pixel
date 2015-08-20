amixer -c0 set Master "100%" &
pulseaudio -D &
setxkbmap -option caps:none &
xbindkeys &
xbacklight -set 10 &
xset s off &
xset -dpms &
xrandr --newmode "1280x850" 88.75 1280 1352 1480 1680 850 853 863 883 -hsync -vsync &
xrandr --addmode eDP1 1280x850 &
exec dwm
