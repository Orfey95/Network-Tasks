#!/bin/bash


# Netplan configuration
rm /etc/netplan/50-vagrant.yaml
cp /vagrant/Router13/50-vagrant.yaml /etc/netplan
netplan apply

# Enable ip forwarding
sysctl -w net.ipv4.ip_forward=1

# Install DHCP relay
apt update
DEBIAN_FRONTEND=noninteractive apt install -y isc-dhcp-relay
sed -i 's/SERVERS=""/SERVERS="192.168.2.2"/' /etc/default/isc-dhcp-relay
sed -i 's/INTERFACES=""/INTERFACES="enp0s9 enp0s8"/' /etc/default/isc-dhcp-relay
/etc/init.d/isc-dhcp-relay restart
# Check status DHCP relay
systemctl status isc-dhcp-relay
