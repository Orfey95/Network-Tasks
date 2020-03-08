#!/bin/bash


# Install DHCP server
yum --quiet install -y dhcp
# Configuration
rm /etc/dhcp/dhcpd.conf
cp /vagrant/DHCP-2/dhcpd.conf /etc/dhcp
# Enable DHCP
systemctl enable dhcpd
# Start DHCP
systemctl start dhcpd
# Interfaces
rm /etc/sysconfig/dhcpd
cp /vagrant/DHCP-2/dhcpd /etc/sysconfig
# Restart DHCP
systemctl restart dhcpd
# Check status DHCP
systemctl status dhcpd
# DHCP log 
touch /var/log/dhcpd.log
chown syslog:adm /var/log/dhcpd.log
echo '
local7.*        /var/log/dhcpd.log
' | tee -a /etc/rsyslog.conf
# DHCP restart
service rsyslog restart
service dhcpd restart