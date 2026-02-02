#!/bin/bash
# auto install mikrotik CHR on a VM
# check this script Must be run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


# install required packages
apt install -y wget unzip gzip mount dd
# download CHR image
wget https://download.mikrotik.com/routeros/7.6/chr-7.6.img.zip -O chr.img.zip
# unzip CHR image
gunzip -c chr.img.zip > chr.img
# mount CHR image
mount -o loop,offset=512 chr.img /mnt

# get mikrotik admin password from user
echo "Enter mikrotik admin password:"
read ROS_ADMIN_PASSWORD

# get IP address
ADDRESS=`ip addr show ens3 | grep global | cut -d' ' -f 6 | head -n 1`
# get gateway
GATEWAY=`ip route list | grep default | cut -d' ' -f 3`
# get disk name (sda, vda , hda, etc)
DISK_NAME=`lsblk -o NAME,TYPE | grep disk | cut -d' ' -f 1`

# create autorun script

# find first interface name in mikrotik
echo "/ip address add address=$ADDRESS interface=[/interface ethernet find where name=ether1]
/ip route add gateway=$GATEWAY
/ip service disable telnet
/user set 0 name=admin password=$ROS_ADMIN_PASSWORD
/ip dns set servers=1.1.1.1
  " > /mnt/rw/autorun.scr

# unmount CHR image
umount /mnt
# reboot to disk
echo u > /proc/sysrq-trigger
# write CHR image to disk
dd if=chr.img bs=1024 of=/dev/$DISK_NAME
echo s > /proc/sysrq-trigger
sleep 5
echo "Done, rebooting..."
echo b > /proc/sysrq-trigger


