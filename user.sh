#!/bin/bash

echo "$(tput setaf 6 & tput smso)Applying tsowell patch . . .$(tput sgr0)"
mkdir -v ~/.builds
cd ~/.builds && curl -LO https://github.com/tsowell/linux-samus/releases/download/v0.2.2/linux-samus-arch-0.2.2.tar
tar xvf linux-samus-arch-0.2.2.tar
cd ~/.builds/linux-samus-arch-0.2.2 && sudo pacman -U *.pkg.tar.xz --noconfirm
sudo cp -v -r ~/.builds/linux-samus-arch-0.2.2/ucm/bdw-rt5677 /usr/share/alsa/ucm
sudo mv -v /handler.sh /etc/acpi/handler.sh

echo "$(tput setaf 6 & tput smso)Installing yaourt . . .$(tput sgr0)"
cd ~/.builds && wget https://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz && tar -xzf package-query.tar.gz
cd ~/.builds && wget https://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz && tar -xzf yaourt.tar.gz
cd ~/.builds/package-query && makepkg -si --noconfirm
cd ~/.builds/yaourt && makepkg -si --noconfirm

echo "$(tput setaf 6 & tput smso)Installing AUR packages . . .$(tput sgr0)"
yaourt -Syua st-git-zsh tor-browser-en ttf-inconsolata-g --noconfirm

echo "$(tput setaf 6 & tput smso)Installing DWM . . .$(tput sgr0)"
cd ~/.builds && sudo abs community/dwm
cp -v -r /var/abs/community/dwm ~/.builds/dwm
sudo chown min:users ~/config.h
mv ~/config.h ~/.builds/dwm/config.h
cd ~/.builds/dwm && makepkg -si --noconfirm

echo "$(tput setaf 6 & tput smso)Editing xinitrc . . .$(tput sgr0)"
printf 'xset s off &\nxset -dpms &\nxsetroot -name pixel &\nexec dwm' > ~/.xinitrc

echo "$(tput setaf 6 & tput smso)Setting up X autostart . . .$(tput sgr0)"
printf '[[ -z $DISPLAY && $XDG_VTNR -le 10 ]] && exec startx && setxkbmap -option caps:none' > ~/.zprofile

echo "$(tput setaf 6 & tput smso)Finishing up . .$(tput sgr0)"
printf 'cd /home/min/.builds/linux-samus-arch-0.2.2 && ALSA_CONFIG_UCM=ucm/ alsaucm -c bdw-rt5677 set _verb HiFi\nsudo xrandr --newmode "1280x850" 88.75 1280 1352 1480 1680 850 853 863 883 -hsync +vsync\nsudo xrandr --addmode eDP1 1280x850' > /home/min/finish.sh
sudo rm /user.sh
