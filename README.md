# MikroTik CHR Installer Script

Interactive installer for MikroTik CHR on Ubuntu.

## Features
- Fully interactive menu to choose RouterOS CHR version (Stable, Long-term, Testing)
- Automatically detects main disk and primary network interface
- Configures IP and Gateway automatically
- Root user without password
- Telnet remains enabled if default
- After installation, displays login credentials before reboot

## Login Credentials

After installation:
Username: admin
Password: (empty / no password)

## Quick Install

⚠️ **Warning:** This will overwrite your system disk. Use only on a **fresh VM or server**.

Download and execute the installer:

```bash
wget https://raw.githubusercontent.com/Emmanuel-HBP/install-mikrotik-chr/main/install_chr.sh
```
chmod +x install_chr.sh

sudo ./install_chr.sh
