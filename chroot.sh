#!/bin/bash
SSD=/dev/disk/by-id/ata-KINGSTON_RBU-SUS151S364GD_50026B7E51D74E12
KEY=/dev/disk/by-id/usb-Generic_Power_Saving_USB_000000000260-0:0
BOOT=/dev/disk/by-id/usb-Generic_Power_Saving_USB_000000000260-0:0-part1

echo "$(tput setaf 6 & tput smso)Building kernel . . .$(tput sgr0)"
mv -v /mkinitcpio.conf /etc/mkinitcpio.conf
chown root:root /etc/mkinitcpio.conf
mkinitcpio -p linux

echo "$(tput setaf 6 & tput smso)Installing packages . . .$(tput sgr0)"
pacman -S dialog wpa_supplicant wireless_tools xorg-server xorg-server-utils xorg-xinit xorg-utils xorg-xkbcomp xf86-input-synaptics xf86-video-intel mesa alsa-utils acpi sudo base-devel wget git ntp rsync mlocate openssh unzip unrar p7zip gptfdisk util-linux parted coreutils zsh grml-zsh-config zsh-completions gvim vim slock surf mpd vlc libreoffice gimp abs dmenu syslinux --noconfirm

echo "$(tput setaf 6 & tput smso)Configuring bootloader . . .$(tput sgr0)"
cp -v -r /usr/lib/syslinux/bios/*.c32 /boot/syslinux
extlinux --install /boot/syslinux
sgdisk $KEY --attributes=1:set:2
dd bs=440 conv=notrunc count=1 if=/usr/lib/syslinux/bios/gptmbr.bin of=$KEY
mv -v /syslinux.cfg /boot/syslinux/syslinux.cfg
chown root:root /boot/syslinux/syslinux.cfg

echo "$(tput setaf 6 & tput smso)Configuring locale and time . . .$(tput sgr0)"
echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
ln -v -s /usr/share/zoneinfo/US/Pacific /etc/localtime
hwclock --systohc --utc

echo "$(tput setaf 6 & tput smso)Setting hostname and adding user . . .$(tput sgr0)"
echo pixel > /etc/hostname
useradd -m -g users -G wheel min

echo "$(tput setaf 6 & tput smso)Enable dhcpcd . . .$(tput sgr0)"
systemctl enable dhcpcd.service

echo "$(tput setaf 6 & tput smso)Set autologin . . .$(tput sgr0)"
mv -v /getty@tty1.service /etc/systemd/system/getty.target.wants
systemctl daemon-reload

echo "$(tput setaf 6 & tput smso)Changing shells . . .$(tput sgr0)"
chsh -s /usr/bin/zsh root
chsh -s /usr/bin/zsh min

echo "$(tput setaf 6 & tput smso)Configuring vim . . .$(tput sgr0)"
echo'export EDITOR=vim' >> /etc/profile
mv -v /vimrc /etc/vimrc
chown root:root /etc/vimrc

echo "$(tput setaf 6 & tput smso)Setting up sudo and su . . .$(tput sgr0)"
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
mv -v /su /etc/pam.d/su
chown root:root /etc/pam.d/su

echo "$(tput setaf 6 & tput smso)Editing logind . . .$(tput sgr0)"
mv -v /logind.conf /etc/systemd/logind.conf
chown root:root /etc/systemd/logind.conf

echo "$(tput setaf 6 & tput smso)Editing synaptics . . .$(tput sgr0)"
mv -v /50-synaptics.conf /etc/X11/xorg.conf.d/50-synaptics.conf
chown root:root /etc/X11/xorg.conf.d/50-synaptics.conf

echo "$(tput setaf 6 & tput smso)Fixing Intel acceleration . . .$(tput sgr0)"
mv -v /20-intel.conf /etc/X11/xorg.conf.d/20-intel.conf
chown root:root /etc/X11/xorg.conf.d/20-intel.conf

echo "$(tput setaf 6 & tput smso)Fixing audio . . .$(tput sgr0)"
mv -v /alsa-base.conf /etc/modprobe.d/alsa-base.conf
chown root:root /etc/modprobe.d/alsa-base.conf
mv -v /asound.conf /etc/asound.conf
chown root:root /etc/asound.conf

echo "$(tput setaf 6 & tput smso)Setting up WiFi . . .$(tput sgr0)"
mv -v /wpa_supplicant-wlp1s0.conf /etc/wpa_supplicant/wpa_supplicant-wlp1s0.conf
chown root:root /etc/wpa_supplicant/wpa_supplicant-wlp1s0.conf
systemctl enable wpa_supplicant@wlp1s0.service

echo "$(tput setaf 6 & tput smso)Starting next stage . . .$(tput sgr0)"
mv config.h /home/min/
rm chroot.sh
su min -c ./user.sh
