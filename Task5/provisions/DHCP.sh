#!/bin/bash


# Netplan configuration
rm /etc/netplan/50-vagrant.yaml
cp /vagrant/DHCP/50-vagrant.yaml /etc/netplan
netplan apply

# IpTables configuration
iptables -A FORWARD -i enp0s8 -j ACCEPT
iptables -A FORWARD -o enp0s8 -j ACCEPT
iptables -t nat -A POSTROUTING -o enp0s8 -j MASQUERADE

# Check and install iptables-persistent
iptables_persistent_status=$(dpkg -l | grep iptables-persistent)
if [[ $iptables_persistent_status == "" ]]
then
echo "iptables-persistent is not installed"
apt update
DEBIAN_FRONTEND=noninteractive apt install -y iptables-persistent
else echo "iptables-persistent is already installed"
fi
iptables-save > /etc/iptables/rules.v4

# Install DHCP server
apt install -y isc-dhcp-server

# Configuration
cp -f /vagrant/DHCP/dhcpd.conf /etc/dhcp

# Insert key in /etc/bind/named.conf.local
sed -i "s!secret ;!secret \"$(cat /vagrant/key/*.private | grep Key: | awk '{print $2}')\";!" /etc/dhcp/dhcpd.conf; 

# Enable DHCP
systemctl enable isc-dhcp-server

# Start DHCP
systemctl start isc-dhcp-server

# Interfaces
cp -f /vagrant/DHCP/isc-dhcp-server /etc/default

# Restart DHCP
service isc-dhcp-server restart

# Check status DHCP
systemctl status isc-dhcp-server

