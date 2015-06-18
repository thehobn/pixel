[[ -z $DISPLAY && $XDG_VTNR -le 10 ]] && exec startx >/dev/null 2>&1 & setxkbmap -option caps:none
