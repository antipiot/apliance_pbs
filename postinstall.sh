#!/bin/sh

# Jonas Sauge

# Permit Root login:
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# Add PBS official GPG key:
wget https://enterprise.proxmox.com/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
echo "deb https://enterprise.proxmox.com/debian/pbs bullseye pbs-enterprise" > /etc/apt/sources.list.d/pbs-enterprise.list

# Installing docker
apt update -y
apt install -y samba proxmox-backup-server

# Download reboot script and add run from rc.local
wget -O /root/startup.sh https://raw.githubusercontent.com/antipiot/apliance_pbs/master/startup.sh
chmod +x /root/startup.sh
# Add script to be started on boot then remove it once ran
echo "#!/bin/sh -e \n/root/startup.sh \nrm -f /etc/rc.local \nexit 0" > /etc/rc.local
chmod 755 /etc/rc.local


