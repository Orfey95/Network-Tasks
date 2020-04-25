#!/bin/bash


set -x

# Netplan configuration
rm /etc/netplan/50-vagrant.yaml
cp /vagrant/DHCP/50-vagrant.yaml /etc/netplan
netplan apply

# Install DHCP server
dpkg -l | grep isc-dhcp-server
if [ $? -eq 1 ]; then
	apt update
	apt install -y isc-dhcp-server
fi

# Stop DHCP
systemctl stop isc-dhcp-server

# Configuration
cp -f /vagrant/DHCP/dhcpd.conf /etc/dhcp

# Insert key in /etc/bind/named.conf.local
sed -i "s!secret ;!secret \"$(cat /vagrant/key/*.private | grep Key: | awk '{print $2}')\";!" /etc/dhcp/dhcpd.conf; 

# Interfaces
cp -f /vagrant/DHCP/isc-dhcp-server /etc/default

# Enable DHCP
systemctl enable isc-dhcp-server

# Start DHCP
systemctl start isc-dhcp-server

# Check status DHCP
systemctl status isc-dhcp-server

