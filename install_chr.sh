#!/bin/bash
set -e

# ===============================
#  MikroTik CHR Installer Script
# ===============================
# Author: Emmanuel-HBP
# Description: Fully interactive installer for MikroTik CHR on Ubuntu
# ===============================

# ---------- Select CHR version ----------
echo -e "\033[1;33mSelect CHR Version:\033[0m"
echo "1) Stable (7.19.4)"
echo "2) Long-term (6.49.13)"
echo "3) Testing (7.20beta7)"
read -p "Enter choice [1-3]: " choice

case $choice in
  1)
    VERSION="7.19.4"
    URL="https://download.mikrotik.com/routeros/7.19.4/chr-7.19.4.img.zip"
    ;;
  2)
    VERSION="6.49.13"
    URL="https://download.mikrotik.com/routeros/6.49.13/chr-6.49.13.img.zip"
    ;;
  3)
    VERSION="7.20beta7"
    URL="https://download.mikrotik.com/routeros/7.20beta7/chr-7.20beta7.img.zip"
    ;;
  *)
    echo -e "\033[1;31mInvalid choice!\033[0m"
    exit 1
    ;;
esac

echo -e "\033[1;32mSelected version: $VERSION\033[0m"

# ---------- Detect primary disk ----------
DISK=$(lsblk -ndo NAME,TYPE | grep disk | head -n1 | awk '{print $1}')
if [[ -z "$DISK" ]]; then
  echo -e "\033[1;31mNo valid disk found!\033[0m"
  exit 1
fi
DISK_PATH="/dev/$DISK"
echo -e "\033[1;32mDetected primary disk: $DISK_PATH\033[0m"

# ---------- Detect primary network interface ----------
NETIF=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo | head -n1)
if [[ -z "$NETIF" ]]; then
  echo -e "\033[1;31mNo network interface found!\033[0m"
  exit 1
fi
echo -e "\033[1;32mDetected network interface: $NETIF\033[0m"

# ---------- Get IP and Gateway ----------
ADDRESS=$(ip addr show "$NETIF" | grep "inet " | awk '{print $2}' | head -n1)
GATEWAY=$(ip route | grep default | awk '{print $3}')

if [[ -z "$ADDRESS" || -z "$GATEWAY" ]]; then
  echo -e "\033[1;31mFailed to detect IP or Gateway!\033[0m"
  exit 1
fi

echo -e "\033[1;32mDetected IP: $ADDRESS | Gateway: $GATEWAY\033[0m"

# ---------- Download and prepare CHR image ----------
echo -e "\033[1;33mDownloading CHR $VERSION ...\033[0m"
wget -q "$URL" -O chr.img.zip

echo -e "\033[1;33mExtracting image ...\033[0m"
unzip -p chr.img.zip > chr.img

# ---------- Inject initial config ----------
mount -o loop,offset=512 chr.img /mnt
cat <<EOF > /mnt/rw/autorun.scr
/ip address add address=$ADDRESS interface=[/interface ethernet find where name=ether1]
/ip route add gateway=$GATEWAY
/user set 0 name=root password=""
EOF
umount /mnt

# ---------- Install CHR to disk ----------
echo -e "\033[1;33mWriting CHR image to $DISK_PATH ...\033[0m"
dd if=chr.img of="$DISK_PATH" bs=1M status=progress conv=fsync

sync
echo -e "\033[1;32mCHR installation completed successfully.\033[0m"

# ---------- Inform login ----------
echo -e "\033[1;33mLogin credentials:\033[0m"
echo -e "\033[1;33mUsername: admin\033[0m"
echo -e "\033[1;33mPassword: (empty / no password)\033[0m"

# ---------- Reboot ----------
echo -e "\033[1;33mRebooting in 5 seconds ...\033[0m"
sleep 5
reboot
