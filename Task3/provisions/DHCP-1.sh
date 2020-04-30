#!/bin/bash


# Install DHCP server
if ! dpkg -l | grep isc-dhcp-server; then
	apt install -y isc-dhcp-server
fi

# Configuration
cp -f /vagrant/DHCP-1/dhcpd.conf /etc/dhcp

# Enable DHCP
systemctl enable isc-dhcp-server

# Stop DHCP
systemctl stop isc-dhcp-server

# Interfaces
cp -f /vagrant/DHCP-1/isc-dhcp-server /etc/default

# Start DHCP
systemctl start isc-dhcp-server

# Check status DHCP
systemctl status isc-dhcp-server
