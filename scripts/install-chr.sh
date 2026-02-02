#!/bin/bash
# MikroTik CHR Installer

CHR_URL="https://github.com/mymikrotik/mikrotik-devops-files/raw/refs/heads/main/files/chr-7.16.2.img.zip"

[[ $EUID -ne 0 ]] && echo "Run as root!" && exit 1

DISK=$(lsblk -dno NAME,TYPE | awk '$2=="disk"{print "/dev/"$1; exit}')

mkdir -p /tmp/chr
mount -t tmpfs -o size=512M tmpfs /tmp/chr
cd /tmp/chr

wget -q --show-progress "$CHR_URL" -O chr.zip
gunzip -c chr.zip > chr.img 2>/dev/null || unzip -p chr.zip > chr.img

echo "Writing to $DISK..."
dd if=chr.img of="$DISK" bs=4M conv=fsync status=progress
sync

echo "Done! Rebooting..."
sleep 2
echo b > /proc/sysrq-trigger
