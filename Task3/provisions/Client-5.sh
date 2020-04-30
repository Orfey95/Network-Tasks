#!/bin/bash

set -e

# Set DHCP_HOSTNAME
echo "---
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s8:
      dhcp4: true
      dhcp4-overrides:
        hostname: Client5
" | tee /etc/netplan/50-hostname.yaml
		
# Reboot interface
netplan apply

# Configure DHCP Client
new_date=$(date "+%Y/%m/%d %T" -d '2 hour')
echo "
timeout 10;

interface \"enp0s8\" {
    send host-name \"Client5\";
}

lease {
  interface \"enp0s8\";
  fixed-address 172.16.2.75;
  option subnet-mask 255.255.255.0;
  renew 2 $new_date;
  rebind 2 $new_date;
  expire 2 $new_date;
}" | tee /etc/dhcp/dhclient.conf
