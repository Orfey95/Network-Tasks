#!/bin/bash

set -e

# Set DHCP_HOSTNAME
if ! grep -q "DHCP_HOSTNAME=Client3" /etc/sysconfig/network-scripts/ifcfg-eth1; then
	echo "DHCP_HOSTNAME=Client3" >> /etc/sysconfig/network-scripts/ifcfg-eth1
fi

# Reboot interface
systemctl restart network

# Configure DHCP Client
new_date=$(date "+%Y/%m/%d %T" -d '2 hour')
echo "
timeout 10;

interface \"eth1\" {
    send host-name \"Client3\";
}

lease {
  interface \"eth1\";
  fixed-address 172.16.2.73;
  option subnet-mask 255.255.255.0;
  renew 2 $new_date;
  rebind 2 $new_date;
  expire 2 $new_date;
}" | tee /etc/dhcp/dhclient.conf

