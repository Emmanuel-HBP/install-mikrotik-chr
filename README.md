# MikroTik CHR Installer Script

This repository contains a **bash script** to automatically install MikroTik CHR on Ubuntu.  

The script will:  
- Let you choose which RouterOS version to install (Stable, Long-term, Testing).  
- Detect the main disk (e.g. `vda`, `sda`, `nvme`).  
- Detect the network interface.  
- Configure CHR with current IP and gateway.  
- Enable SSH with `root` user (no password by default).  

---

## ⚡ Quick Install

Run this command directly on your fresh Ubuntu server:

```bash
curl -sL https://raw.githubusercontent.com/Emmanuel-HBP/install-mikrotik-chr/main/install_chr.sh | sudo bash
