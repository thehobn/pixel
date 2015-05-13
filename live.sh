#!/bin/bash
SSD=/dev/disk/by-id/ata-KINGSTON_RBU-SUS151S364GD_50026B7E51D74E12
KEY=/dev/disk/by-id/usb-Generic_Power_Saving_USB_000000000260-0:0
BEG='tput setaf 6 & tput smso'
END='tput sgr0'

printf "${BEG}Creating new GPT tables . . .${END}"
parted -s $SSD mktable gpt
parted -s $KEY mktable gpt

printf "${BEG}Generating keyfile . . .${END}"
dd bs=1024 count=8 if=/dev/urandom of=keyfile iflag=fullblock

printf "${BEG}Encrypting SSD . . .${END}"
cryptsetup luksFormat $SSD keyfile
cryptsetup open --type luks $SSD sys --key-file=keyfile

printf "${BEG}Creating LVM . . .${END}"
vgcreate sys /dev/mapper/sys
lvcreate -l +100%FREE sys -n root

printf "${BEG}Making filesystems . . .${END}"
mkfs.btrfs /dev/mapper/sys-root
btrfs filesystem label /dev/mapper/sys-root sys
mkfs.btrfs -f $KEY
btrfs filesystem label $KEY key

printf "${BEG}Mounting filesystems . . .${END}"
mount /dev/mapper/sys-root /mnt
mkdir /mnt/boot
mount $KEY /mnt/boot

printf "${BEG}Inserting keyfile . . .${END}"
mv keyfile /mnt/boot

printf "${BEG}Generating fstab . . .${END}"
genfstab -U -p /mnt >> /mnt/etc/fstab

printf "${BEG}Running pacstrap . . .${END}"
pacstrap /mnt base

printf "${BEG}Building kernel . . .${END}"
echo 'MODULES="btrfs nls_cp437 i915"\nHOOKS="base udev autodetect modconf block encrypt lvm2 filesystems keyboard fsck consolefont"' > /etc/mkinitcpio.conf
mkinitcpio -p linux



printf "${BEG}Starting next stage . . .${END}"
mv chroot.sh /mnt
mv user.sh /mnt
arch-chroot /mnt ./chroot.sh
