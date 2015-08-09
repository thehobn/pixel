[[ XDG_VTNR -eq 1 ]] && exec startx -- -keeptty -nolisten tcp vt$XDG_VTNR > /dev/null 2>&1
[[ XDG_VTNR -gt 1 ]] && vlock
