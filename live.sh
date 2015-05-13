#!/bin/bash
SSD=/dev/disk/by-id/ata-KINGSTON_RBU-SUS151S364GD_50026B7E51D74E12
KEY=/dev/disk/by-id/usb-Generic_Power_Saving_USB_000000000260-0:0

parted $SSD mktable gpt
parted $KEY mktable gpt

dd bs=1024 count=8192 if=/dev/urandom of=keyfile iflag=fullblock #lol
cryptsetup luksFormat $SSD keyfile
cryptsetup open --type luks $SSD sys --key-file=keyfile

vgcreate sys /dev/mapper/sys
lvcreate -l +100%FREE sys -n root

mkfs.btrfs /dev/mapper/sys-root
btrfs filesystem label /dev/mapper/sys-root sys
mkfs.btrfs $KEY
btrfs filesystem label $KEY key

mount /dev/mapper/sys-root /mnt
pacstrap /mnt base

mount $KEY /mnt/boot
cp keyfile /mnt/boot

echo 'MODULES="btrfs nls_cp437 i915"\nHOOKS="base udev autodetect modconf block encrypt lvm2 filesystems keyboard fsck consolefont"' > /etc/mkinitcpio.conf
mkinitcpio -p linux
genfstab -U -p /mnt >> /mnt/etc/fstab



cp chroot.sh /mnt
cp user.sh /mnt
arch-chroot /mnt ./chroot.sh
