#!/bin/bash

mkdir -p /tmp/ramdisk
mount -t tmpfs -o size=512M tmpfs /tmp/ramdisk
cd /tmp/ramdisk

#wget https://download.mikrotik.com/routeros/7.16.2/chr-7.16.2.img.zip
wget https://raw.githubusercontent.com/mymikrotik/mikrotik-devops-files/refs/heads/main/files/chr-7.16.2.img.zip

if [ ! -f chr-7.16.2.img.zip ]; then
    echo "Download failed"
    exit 1
fi

unzip chr-7.16.2.img.zip

if [ ! -f chr-7.16.2.img ]; then
    echo "Extract failed"
    exit 1
fi

dd if=chr-7.16.2.img of=/dev/sda bs=4M conv=fsync status=progress

sync
sleep 2
sync
sleep 2
sync
sleep 2

cd /
umount /tmp/ramdisk

echo "Done! Rebooting..."
sleep 5

echo s > /proc/sysrq-trigger
sleep 3
echo b > /proc/sysrq-trigger
