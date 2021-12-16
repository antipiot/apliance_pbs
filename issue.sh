#!/bin/sh

# Sleep to leave time for network
sleep 15

ip=$(hostname -I | awk '{print $1}')
host=$(hostname)

echo "
---- Welcome to PBS Apliance ----
Host IP:  $ip
Hostname: $host" > /etc/issue
