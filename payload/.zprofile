[[ -z $DISPLAY && $XDG_VTNR -le 10 ]] && exec xinit -- :1 -nolisten tcp vt$XDG_VTNR & setxkbmap -option caps:none
