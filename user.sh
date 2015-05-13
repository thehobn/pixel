#!/bin/bash

echo "$(tput setaf 6 & tput smso)Installing yaourt . . .$(tput sgr0)"
mkdir ~/.builds
cd ~/.builds && wget https://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz && tar -xzf package-query.tar.gz
cd ~/.builds && wget https://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz && tar -xzf yaourt.tar.gz
cd ~/.builds/package-query && makepkg -si
cd ~/.builds/yaourt && makepkg -si

echo "$(tput setaf 6 & tput smso)Installing AUR packages . . .$(tput sgr0)"
yaourt -Syyu st-git-zsh tor-browser-en

echo "$(tput setaf 6 & tput smso)Installing DWM . . .$(tput sgr0)"
cd ~/.builds && sudo abs community/dwm
cp -r /var/abs/community/dwm ~/.builds/dwm
cd ~/.builds && makepkg -i
# config.h
# 
# makepkg -efi --skipinteg #for recompiling with config.h modifications

echo "$(tput setaf 6 & tput smso)Editing xinitrc . . .$(tput sgr0)"
printf 'xset s off &\nxset -dpms &\nxsetroot -name pixel &\nexec dwm' > ~/.xinitrc

echo "$(tput setaf 6 & tput smso)Setting up X autostart . . .$(tput sgr0)"
printf '[[ -z $DISPLAY && $XDG_VTNR -le 10 ]] && exec startx' > ~/.zprofile

# fonts (inconsolata)

# xkb the locks out

# pacman mirrors

# cleanup
rm user.sh
