#!/bin/bash
SSD=/dev/disk/by-id/ata-KINGSTON_RBU-SUS151S364GD_50026B7E51D74E12
KEY=/dev/disk/by-id/usb-Generic_Power_Saving_USB_000000000260-0:0
BEG='tput setaf 6 & tput smso'
END='tput sgr0'

echo "${BEG}Creating new GPT tables . . .${END}"
parted -s $SSD mktable gpt
parted -s $KEY mktable gpt

echo "${BEG}Generating keyfile . . .${END}"
dd bs=1024 count=8 if=/dev/urandom of=keyfile iflag=fullblock

echo "${BEG}Encrypting SSD . . .${END}"
cryptsetup luksFormat $SSD keyfile
cryptsetup open --type luks $SSD sys --key-file=keyfile

echo "${BEG}Creating LVM . . .${END}"
vgcreate sys /dev/mapper/sys
lvcreate -l +100%FREE sys -n root

echo "${BEG}Making filesystems . . .${END}"
mkfs.btrfs /dev/mapper/sys-root
btrfs filesystem label /dev/mapper/sys-root sys
mkfs.btrfs -f $KEY
btrfs filesystem label $KEY key

echo "${BEG}Mounting filesystems . . .${END}"
mount /dev/mapper/sys-root /mnt
mkdir /mnt/boot
mount $KEY /mnt/boot

echo "${BEG}Inserting keyfile . . .${END}"
mv keyfile /mnt/boot

echo "${BEG}Generating fstab . . .${END}"
genfstab -U -p /mnt >> /mnt/etc/fstab

echo "${BEG}Running pacstrap . . .${END}"
pacstrap /mnt base

echo "${BEG}Building kernel . . .${END}"
echo 'MODULES="btrfs nls_cp437 i915"\nHOOKS="base udev autodetect modconf block encrypt lvm2 filesystems keyboard fsck consolefont"' > /etc/mkinitcpio.conf
mkinitcpio -p linux



echo "${BEG}Starting next stage . . .${END}"
mv chroot.sh /mnt
mv user.sh /mnt
arch-chroot /mnt ./chroot.sh
