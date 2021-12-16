#!/bin/sh

# Jonas Sauge
# Settings

rootdatafolder=/opt/nextcloud
username=nextcloud
http=80
https=443
dbusername=nextcloud
dbname=nextcloud
dbhostname=db
mysqlrootpwd=$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)
mysqlnextcloudpwd=$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)

## Starting Nextcloud Installation
# Creating environnment and variables

# Sleep to leave time for network
echo "- Sleeping 15"
sleep 15

echo "- Getting login screen script"
wget -O /usr/local/bin/issue.sh https://raw.githubusercontent.com/antipiot/apliance_nextcloud/master/issue.sh
chmod 755 /usr/local/bin/issue.sh
echo '#!/bin/sh -e \n/usr/local/bin/issue.sh \nexit 0' > /etc/rc.local
chmod 755 /etc/rc.local

echo "- Adding User"
useradd $username
gid=$(id -g $username)
uid=$(id -u $username)


mkdir $rootdatafolder
mkdir $rootdatafolder/database
chown -R $uid:$gid $rootdatafolder

# Starting mysql container
docker run -d --name $dbhostname --restart unless-stopped --user $uid:$gid -v $rootdatafolder/database:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=$mysqlrootpwd -e MYSQL_DATABASE=$dbname -e MYSQL_USER=$dbusername -e MYSQL_PASSWORD=$mysqlnextcloudpwd mariadb:10.5 --transaction-isolation=READ-COMMITTED --binlog-format=ROW
# Starting nextcloud container
docker run -d --name=nextcloud --restart unless-stopped -p $https:443 --link $dbhostname -e PUID=$uid -e PGID=$gid -e TZ=Europe/Geneva -v $rootdatafolder/config:/config -v $rootdatafolder/data:/data lscr.io/linuxserver/nextcloud
# Starting updater container
docker run -d --name watchtower --restart=unless-stopped -e WATCHTOWER_SCHEDULE="0 0 4 * * *" -e WATCHTOWER_CLEANUP="true" -e TZ="Europe/paris" -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
echo "Database user: $dbusername
Database password: $mysqlnextcloudpwd
Database name: $dbname
Database hostname: $dbhostname
Database root password: $mysqlrootpwd" > $rootdatafolder/credentials.txt

echo "- Waiting 3 minute for containers to start before rebooting"
sleep 180

rm -f $0

reboot now