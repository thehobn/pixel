#!/bin/bash

echo "$(tput setaf 6 & tput smso)Applying tsowell patch . . .$(tput sgr0)"
mkdir -v ~/.builds
cd ~/.builds && curl -LO https://github.com/tsowell/linux-samus/releases/download/v0.2.2/linux-samus-arch-0.2.2.tar
tar xvf linux-samus-arch-0.2.2.tar
cd ~/.builds/linux-samus-arch-0.2.2 && sudo pacman -U *.pkg.tar.xz --noconfirm

echo "$(tput setaf 6 & tput smso)Installing yaourt . . .$(tput sgr0)"
cd ~/.builds && wget https://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz && tar -xzf package-query.tar.gz
cd ~/.builds && wget https://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz && tar -xzf yaourt.tar.gz
cd ~/.builds/package-query && makepkg -si --noconfirm
cd ~/.builds/yaourt && makepkg -si --noconfirm

echo "$(tput setaf 6 & tput smso)Installing AUR packages . . .$(tput sgr0)"
yaourt -Syua st-git-zsh tor-browser-en --noconfirm

echo "$(tput setaf 6 & tput smso)Installing DWM . . .$(tput sgr0)"
cd ~/.builds && sudo abs community/dwm
cp -v -r /var/abs/community/dwm ~/.builds/dwm
cd ~/.builds/dwm && makepkg -si --noconfirm
# config.h
# 
# makepkg -efi --skipinteg --noconfirm #for recompiling with config.h modifications

echo "$(tput setaf 6 & tput smso)Editing xinitrc . . .$(tput sgr0)"
printf 'xset s off &\nxset -dpms &\nxsetroot -name pixel &\nexec dwm' > ~/.xinitrc

echo "$(tput setaf 6 & tput smso)Setting up X autostart . . .$(tput sgr0)"
printf '[[ -z $DISPLAY && $XDG_VTNR -le 10 ]] && exec startx' > ~/.zprofile

# fonts (inconsolata)

# xkb the locks out

# pacman mirrors

echo "$(tput setaf 6 & tput smso)Finishing up . .$(tput sgr0)"
printf 'cd /home/min/.builds/linux-samus-arch-0.2.2 && ALSA_CONFIG_UCM=ucm/ alsaucm -c bdw-rt5677 set _verb HiFi' > /home/min/finish.sh
sudo rm /user.sh
