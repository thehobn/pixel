#!/bin/bash
SSD=/dev/disk/by-id/ata-KINGSTON_RBU-SUS151S364GD_50026B7E51D74E12
KEY=/dev/disk/by-id/usb-Generic_Power_Saving_USB_000000000260-0:0

pacman -S dialog wpa_supplicant wireless_tools xorg-server xorg-server-utils xorg-xinit xorg-utils xorg-xkbcomp xf86-input-synaptics xf86-video-intel mesa alsa-utils acpi sudo base-devel wget git ntp rsync mlocate openssh unzip unrar p7zip gptfdisk util-linux parted coreutils zsh zsh-completions gvim vim slock surf mpd vlc libreoffice gimp abs dmenu syslinux

mkdir /boot/syslinux
cp -r /usr/lib/syslinux/bios/*.c32 /boot/syslinux
extlinux --install /boot/syslinux
sgdisk $KEY --attributes=1:set:2
dd bs=440 conv=notrunc count=1 if=/usr/lib/syslinux/bios/gptmbr.bin of=$KEY

echo 'PROMPT 0\nTIMEOUT 0\nDEFAULT arch\n\nLABEL arch\n\tMENU LABEL Arch Linux\n\tLINUX ../vmlinuz.linux\n\tAPPEND cryptkey=$KEY:btrfs:/keyfile cryptdevice=$SSD:sys root=/dev/mapper/sys-root rw\n\tINITRD ../initramfs-linux.img' > /boot/syslinux/syslinux.cfg

echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
ln -s /usr/share/zoneinfo/US/Pacific /etc/localtime
hwclock --systohc --utc
echo pixel > /etc/hostname
useradd -m -g users -G wheel min

echo '[Service]\nExecStart=\nExecStart=-/sbin/agetty --autologin min --noclear %I 38400 linux\nType=simple' > /etc/systemd/system/getty@tty1.service.d

chsh -s /bin/zsh root
chsh -s /bin/zsh min

# set vim as default
echo 'set ttyscroll=0\nset guifont=inconsolata\nsyntax enable\nset nu' > /etc/vimrc

EDITOR=vim visudo



mv /user.sh /home/min
su min -c ./user.sh
