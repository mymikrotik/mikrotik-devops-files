#!/bin/bash
wget https://download.mikrotik.com/routeros/6.44.6/chr-6.44.6.img.zip -O chr.img.zip  && \
gunzip -c chr.img.zip > chr.img  && \

# https://kvaps.medium.com/easy-way-for-install-mikrotiks-cloud-hosted-router-on-any-cloud-vm-fb1cf7302b85

mount -o loop,offset=512 chr.img /mnt && \
ADDRESS=`ip addr show ens3 | grep global | cut -d' ' -f 6 | head -n 1` && \
GATEWAY=`ip route list | grep default | cut -d' ' -f 3` && \
echo "/ip address add address=10.0.0.148/24 interface=[/interface ethernet find where name=ether1]
/ip route add gateway=10.0.0.1
/user set 0 name=admin password=Lnkfile_3
/ip dns set servers=1.1.1.1,1.0.0.1
 " > /mnt/rw/autorun.scr && \
umount /mnt && \
echo u > /proc/sysrq-trigger && \
dd if=chr.img bs=1024 of=/dev/sda && \
echo "sync disk" && \
echo s > /proc/sysrq-trigger && \
echo "Sleep 5 seconds" && \
sleep 5 && \
echo "Ok, reboot" && \
echo b > /proc/sysrq-trigger



dd if=chr.img of=/dev/sda bs=4M oflag=sync