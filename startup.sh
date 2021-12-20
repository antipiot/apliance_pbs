#!/bin/sh

# Jonas Sauge
# Settings

# Sleep to leave time for network
echo "- Sleeping 15"
sleep 15

# Installing PBS
echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
echo "postfix postfix/mailname string $hostname.local" | debconf-set-selections 


apt-get update -y
apt-get install -y samba dkms proxmox-backup-server 
apt-get install -y zfs-dkms
apt-get autoremove


echo "- Getting login screen script"
wget -O /usr/local/bin/issue.sh https://raw.githubusercontent.com/antipiot/apliance_pbs/master/issue.sh
chmod 755 /usr/local/bin/issue.sh
echo '#!/bin/sh -e \n/usr/local/bin/issue.sh \nexit 0' > /etc/rc.local
chmod 755 /etc/rc.local

rm -f $0

reboot now
