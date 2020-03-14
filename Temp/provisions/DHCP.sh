#!/bin/bash


# Netplan configuration
rm /etc/netplan/50-vagrant.yaml
cp /vagrant/DHCP/50-vagrant.yaml /etc/netplan
netplan apply

# Install DHCP server
apt install -y isc-dhcp-server

# Configuration
rm /etc/dhcp/dhcpd.conf
cp /vagrant/DHCP/dhcpd.conf /etc/dhcp

# Enable DHCP
systemctl enable isc-dhcp-server

# Start DHCP
systemctl start isc-dhcp-server

# Interfaces
rm /etc/default/isc-dhcp-server
cp /vagrant/DHCP/isc-dhcp-server /etc/default

# Restart DHCP
service isc-dhcp-server restart

# Check status DHCP
systemctl status isc-dhcp-server

# DHCP log 
touch /var/log/dhcpd.log
chown syslog:adm /var/log/dhcpd.log
if ! grep -q "local7.*        /var/log/dhcpd.log" /etc/rsyslog.conf; then echo "local7.*        /var/log/dhcpd.log" | tee -a /etc/rsyslog.conf; fi

# DHCP restart
service rsyslog restart
service isc-dhcp-server restart
