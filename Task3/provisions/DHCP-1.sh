#!/bin/bash


# Install DHCP server
apt install -y isc-dhcp-server
# Configuration
rm /etc/dhcp/dhcpd.conf
cp /vagrant/DHCP-1/dhcpd.conf /etc/dhcp
# Interfaces
rm /etc/default/isc-dhcp-server
cp /vagrant/DHCP-1/isc-dhcp-server /etc/default
# Restart DHCP
service isc-dhcp-server restart
# Check status DHCP
systemctl status isc-dhcp-server
