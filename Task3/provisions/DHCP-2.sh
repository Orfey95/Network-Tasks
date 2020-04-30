#!/bin/bash


# Install DHCP server
if ! rpm -qa | grep "dhcp-[0-9]"; then
	yum --quiet install -y dhcp
fi

# Configuration
cp -f /vagrant/DHCP-2/dhcpd.conf /etc/dhcp

# Enable DHCP
systemctl enable dhcpd

# Stop DHCP
systemctl stop dhcpd

touch /var/log/dhcpd.log

# Interfaces
cp -f /vagrant/DHCP-2/dhcpd /etc/sysconfig

# Restart DHCP
systemctl start dhcpd

# Check status DHCP
systemctl status dhcpd
