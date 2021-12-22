#!/bin/sh

# Sleep to leave time for network
sleep 15

ip=$(hostname -I | awk '{print $1}')
host=$(hostname)

# Enable leds for apu boards
if ls "/sys/class/leds/apu:green:1/trigger" > /dev/null ; then
echo 'cpu' > /sys/class/leds/apu:green:1/trigger
echo 'disk-activity' > /sys/class/leds/apu:green:2/trigger
fi

echo "
---- Welcome to PBS Apliance ----
Host IP:  $ip
Hostname: $host" > /etc/issue
