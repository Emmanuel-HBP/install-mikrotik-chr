#!/bin/bash

# \033[1;33m Select CHR version menu \033[0m
echo -e "\033[1;33mSelect CHR Version:\033[0m"
echo "1) Stable (7.19.4)"
echo "2) Long-term (6.49.13)"
echo "3) Testing (7.20beta7)"
read -p "Enter choice [1-3]: " choice

case $choice in
  1) VERSION_URL="https://download.mikrotik.com/routeros/7.19.4/chr-7.19.4.img.zip" ;;
  2) VERSION_URL="https://download.mikrotik.com/routeros/6.49.13/chr-6.49.13.img.zip" ;;
  3) VERSION_URL="https://download.mikrotik.com/routeros/7.20beta7/chr-7.20beta7.img.zip" ;;
  *) echo -e "\033[1;33mInvalid choice!\033[0m"; exit 1 ;;
esac

# \033[1;33m Detect main disk (vda, sda, nvme) \033[0m
DISK=$(lsblk -ndo NAME,TYPE | grep disk | awk '{print $1}' | head -n 1)
echo -e "\033[1;33mDetected disk: /dev/$DISK\033[0m"

# \033[1;33m Detect network interface (exclude loopback) \033[0m
NET_IFACE=$(ip -o link show | awk -F': ' '{print $2}' | grep -v "lo" | head -n 1)
echo -e "\033[1;33mDetected network interface: $NET_IFACE\033[0m"

# \033[1;33m Download selected CHR version \033[0m
wget "$VERSION_URL" -O chr.img.zip || { echo "Download failed!"; exit 1; }

# \033[1;33m Unzip image file \033[0m
gunzip -c chr.img.zip > chr.img

# \033[1;33m Mount CHR image to /mnt \033[0m
mount -o loop,offset=512 chr.img /mnt

# \033[1;33m Get current IP and gateway \033[0m
ADDRESS=$(ip addr show "$NET_IFACE" | grep global | awk '{print $2}' | head -n 1)
GATEWAY=$(ip route list | grep default | awk '{print $3}')

# \033[1;33m Apply MikroTik initial configuration (root without password, SSH enabled) \033[0m
mkdir -p /mnt/rw/config
cat <<EOF > /mnt/rw/config/auto.rsc
/ip address add address=$ADDRESS interface=[/interface ethernet find where name=ether1]
/ip route add gateway=$GATEWAY
/ip service enable ssh
/user set 0 name=root password=""
EOF

# \033[1;33m Unmount before writing to disk \033[0m
umount /mnt
echo u > /proc/sysrq-trigger

# \033[1;33m Write CHR image to detected disk \033[0m
dd if=chr.img bs=1024 of="/dev/$DISK" status=progress

echo -e "\033[1;33mSyncing disk...\033[0m"
echo s > /proc/sysrq-trigger
sleep 5

echo -e "\033[1;33mRebooting system...\033[0m"
echo b > /proc/sysrq-trigger
