[English](README.md) | [فارسی](README_FA.md)

# MikroTik CHR Installer Script

Interactive installer for **MikroTik CHR** on Ubuntu. This script provides a fully guided installation process for deploying RouterOS CHR on a fresh Ubuntu VM or server.
During the installation, you will be prompted to select one of the CHR versions listed above.

## Features
- Fully interactive menu to choose RouterOS CHR version:
  - **Stable:** 7.19.4  
  - **Long-term:** 6.49.13  
  - **Testing:** 7.20beta7  
- Automatically detects main disk and primary network interface  
- Configures IP address and Gateway automatically  
- After installation, displays login credentials before reboot  

## Quick Install

⚠️ **Warning:** This will overwrite your system disk. Use only on a **fresh VM or server**.

Download and execute the installer:

```bash
wget https://raw.githubusercontent.com/Emmanuel-HBP/install-mikrotik-chr/main/install_chr.sh
```
```bash
chmod +x install_chr.sh
```
```bash
sudo ./install_chr.sh
```

## Login Credentials

After installation, log in using the following credentials:

- **Username:** admin  
- **Password:** (empty / no password)  
