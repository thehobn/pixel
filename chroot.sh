#!/bin/bash
SSD=/dev/disk/by-id/ata-KINGSTON_RBU-SUS151S364GD_50026B7E51D74E12
KEY=/dev/disk/by-id/usb-Generic_Power_Saving_USB_000000000260-0:0

echo "$(tput setaf 6 & tput smso)Building kernel . . .$(tput sgr0)"
printf 'MODULES="btrfs nls_cp437 i915"\nHOOKS="base udev autodetect modconf block encrypt lvm2 filesystems keyboard fsck consolefont"' > /etc/mkinitcpio.conf
mkinitcpio -p linux

echo "$(tput setaf 6 & tput smso)Installing packages . . .$(tput sgr0)"
pacman -S dialog wpa_supplicant wireless_tools xorg-server xorg-server-utils xorg-xinit xorg-utils xorg-xkbcomp xf86-input-synaptics xf86-video-intel mesa alsa-utils acpi sudo base-devel wget git ntp rsync mlocate openssh unzip unrar p7zip gptfdisk util-linux parted coreutils zsh zsh-completions gvim vim slock surf mpd vlc libreoffice gimp abs dmenu syslinux --noconfirm

echo "$(tput setaf 6 & tput smso)Configuring bootloader . . .$(tput sgr0)"
mkdir /boot/syslinux
cp -r /usr/lib/syslinux/bios/*.c32 /boot/syslinux
extlinux --install /boot/syslinux
sgdisk $KEY --attributes=1:set:2
dd bs=440 conv=notrunc count=1 if=/usr/lib/syslinux/bios/gptmbr.bin of=$KEY
printf 'PROMPT 0\nTIMEOUT 0\nDEFAULT arch\n\nLABEL arch\n\tMENU LABEL Arch Linux\n\tLINUX ../vmlinuz.linux\n\tAPPEND cryptkey=$KEY:btrfs:/keyfile cryptdevice=$SSD:sys root=/dev/mapper/sys-root rw rootwait ignore_loglevel debug debug_locks_verbose=1 sched_debug initcall_debug mminit_loglevel=4 udev.log_priority=8 loglevel=8 earlyprintk=vga,keep log_buf_len=10M print_fatal_signals=1 apm.debug=Y i8042.debug=Y drm.debug=1 scsi_logging_level=1 usbserial.debug=Y option.debug=Y pl2303.debug=Y firewire_ohci.debug=1 hid.debug=1 pci_hotplug.debug=Y pci_hotplug.debug_acpi=Y shpchp.shpchp_debug=Y apic=debug show_lapic=all hpet=verbose lmb=debug pause_on_oops=5 panic=10 sysrq_always_enabled\n\tINITRD ../initramfs-linux.img' > /boot/syslinux/syslinux.cfg

echo "$(tput setaf 6 & tput smso)Configuring locale and time . . .$(tput sgr0)"
printf en_US.UTF-8 UTF-8 >> /etc/locale.gen
locale-gen
printf LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
ln -s /usr/share/zoneinfo/US/Pacific /etc/localtime
hwclock --systohc --utc

echo "$(tput setaf 6 & tput smso)Setting hostname and adding user . . .$(tput sgr0)"
printf pixel > /etc/hostname
useradd -m -g users -G wheel min

echo "$(tput setaf 6 & tput smso)Set autologin . . .$(tput sgr0)"
printf '[Service]\nExecStart=\nExecStart=-/sbin/agetty --autologin min --noclear %%I 38400 linux\nType=simple' > /etc/systemd/system/getty@tty1.service.d

echo "$(tput setaf 6 & tput smso)Changing shells . . .$(tput sgr0)"
chsh -s /bin/zsh root
chsh -s /bin/zsh min

echo "$(tput setaf 6 & tput smso)Configuring vim . . .$(tput sgr0)"
printf 'export EDITOR=vim' >> /etc/profile
printf 'set ttyscroll=0\nset guifont=inconsolata\nsyntax enable\nset nu' > /etc/vimrc

echo "$(tput setaf 6 & tput smso)Setting up sudo . . .$(tput sgr0)"
printf 'root ALL=(ALL) ALL\n%%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers

echo "$(tput setaf 6 & tput smso)Editing logind . . .$(tput sgr0)"
printf '[Login]\nNAutoVTs=10\nHandlePowerKey=suspend\nHandleSuspendKey=ignore\nHandleHibernateKey=ignore\nHandleLidSwitch=ignore\nHandleLidSwitchDocked=ignore' > /etc/systemd/logind.conf

echo "$(tput setaf 6 & tput smso)Editing synaptics . . .$(tput sgr0)"
printf 'Section "InputClass"\n\tIdentifier "touchpad"\n\tDriver "synaptics"\n\tMatchIsTouchpad "on"\n\t\tOption "TapButton1" "1"\n\t\tOption "TapButton2" "2"\n\t\tOption "TapButton3" "3"\n\t\tOption "VertTwoFingerScroll" "on"\n\t\tOption "HorizTwoFingerScroll" "on"\nEndSection' > /etc/X11/xorg.conf.d/50-synaptics.conf

echo "$(tput setaf 6 & tput smso)Starting next stage . . .$(tput sgr0)"
rm chroot.sh
su min -c ./user.sh
