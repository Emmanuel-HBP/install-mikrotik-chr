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

## Notes

- Ensure your VM or server has a single main disk and at least one active network interface.  
- The script automatically configures your first Ethernet interface with the current IP and gateway.  
- The system will reboot automatically after the installation is complete.  

## FAQ

**Q1: Can I install this on a system with multiple disks?**  
A1: The script automatically detects the first disk. Installing on a system with multiple disks may overwrite the wrong disk. Use a single disk or modify the script to select the desired disk.

**Q2: Can I change the default network configuration?**  
A2: Yes, after installation you can manually configure interfaces and IP addresses via MikroTik CLI or Winbox.

**Q3: Do I need a password for the admin user?**  
A3: By default, the admin account has no password. You should set a password immediately after installation for security.

**Q4: Can I upgrade RouterOS later?**  
A4: Yes, you can upgrade MikroTik CHR using standard RouterOS upgrade procedures without rerunning this script.

## Troubleshooting

**Issue:** The script cannot detect the disk or network interface.  
- **Solution:** Make sure your VM has at least one disk and one active network interface. Check with `lsblk` and `ip addr`.

**Issue:** Download fails or URL is unreachable.  
- **Solution:** Verify your internet connection and that MikroTik servers are accessible. You can manually download the CHR image and place it in the script directory, then modify the script to use the local file.

**Issue:** Installation fails during `dd` or image write.  
- **Solution:** Ensure the disk is not in use and that you have root privileges. For VMs, check that the disk is attached properly and unmounted.

**Issue:** Cannot login after reboot.  
- **Solution:** Ensure you are using the correct credentials (`admin` / empty password). If necessary, access the VM console and reset the password using MikroTik CLI commands.
