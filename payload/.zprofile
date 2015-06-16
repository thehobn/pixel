[[ -z $DISPLAY && $XDG_VTNR -le 10 ]] && exec startx && setxkbmap -option caps:none
