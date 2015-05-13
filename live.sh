#!/bin/bash
SSD=/dev/disk/by-id/ata-KINGSTON_RBU-SUS151S364GD_50026B7E51D74E12
KEY=/dev/disk/by-id/usb-Generic_Power_Saving_USB_000000000260-0:0

echo "$(tput setaf 6 & tput smso)Creating new GPT tables . . .$(tput sgr0)"
parted -s $SSD mktable gpt
parted -s $KEY mktable gpt

echo "$(tput setaf 6 & tput smso)Generating keyfile . . .$(tput sgr0)"
dd bs=1024 count=8 if=/dev/urandom of=keyfile iflag=fullblock

echo "$(tput setaf 6 & tput smso)Encrypting SSD . . .$(tput sgr0)"
cryptsetup luksFormat $SSD keyfile --batch-mode
cryptsetup open --type luks $SSD sys --key-file=keyfile

echo "$(tput setaf 6 & tput smso)Creating LVM . . .$(tput sgr0)"
vgcreate sys /dev/mapper/sys
lvcreate -l +100%FREE sys -n root

echo "$(tput setaf 6 & tput smso)Making filesystems . . .$(tput sgr0)"
mkfs.btrfs /dev/mapper/sys-root
btrfs filesystem label /dev/mapper/sys-root sys
mkfs.btrfs -f $KEY
btrfs filesystem label $KEY key

echo "$(tput setaf 6 & tput smso)Mounting filesystems . . .$(tput sgr0)"
mount /dev/mapper/sys-root /mnt
mkdir /mnt/boot
mount $KEY /mnt/boot

echo "$(tput setaf 6 & tput smso)Inserting keyfile . . .$(tput sgr0)"
mv keyfile /mnt/boot

echo "$(tput setaf 6 & tput smso)Running pacstrap . . .$(tput sgr0)"
pacstrap /mnt base

echo "$(tput setaf 6 & tput smso)Generating fstab . . .$(tput sgr0)"
genfstab -U -p /mnt >> /mnt/etc/fstab

echo "$(tput setaf 6 & tput smso)Starting next stage . . .$(tput sgr0)"
mv chroot.sh /mnt
mv user.sh /mnt
arch-chroot /mnt ./chroot.sh
