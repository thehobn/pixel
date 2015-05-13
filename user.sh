#!/bin/bash

mkdir ~/.builds
cd ~/.builds && wget https://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz && tar -xzf package-query
cd ~/.builds && wget https://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz && tar -xzf yaourt
cd ~/.builds/package-query && makepkg -si
cd ~/.builds/yaourt && makepkg -si

yaourt -Syyu st-git-zsh tor-browser-en

cd ~/.builds && sudo abs community/dwm
cp -r /var/abs/community/dwm ~/.builds/dwm
cd ~/.builds && makepkg -i
# config.h
# 
# makepkg -efi --skipinteg #for recompiling with config.h modifications

echo 'xset s off &\nxset -dpms &\nxsetroot -name pixel &\nexec dwm' > ~/.xinitrc


echo '[[ -z $DISPLAY && $XDG_VTNR -le 10 ]] && exec startx' > ~/.zprofile

echo '[Login]\nNAutoVTs=10\nHandlePowerKey=suspend\nHandleSuspendKey=ignore\nHandleHibernateKey=ignore\nHandleLidSwitch=ignore\nHandleLidSwitchDocked=ignore' > /etc/systemd/logind.conf

echo 'Section "InputClass"\n\tIdentifier "touchpad"\n\tDriver "synaptics"\n\tMatchIsTouchpad "on"\n\t\tOption "TapButton1" "1"\n\t\tOption "TapButton2" "2"\n\t\tOption "TapButton3" "3"\n\t\tOption "VertTwoFingerScroll" "on"\n\t\tOption "HorizTwoFingerScroll" "on"\nEndSection' > /etc/X11/xorg.conf.d/50-synaptics.conf


# fonts (inconsolata)

# xkb the locks out

# pacman mirrors
