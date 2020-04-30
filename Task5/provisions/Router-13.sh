#!/bin/bash


set -e

# Netplan configuration
rm /etc/netplan/50-vagrant.yaml
cp /vagrant/Router13/50-vagrant.yaml /etc/netplan
netplan apply

# Install DHCP relay
if ! dpkg -l | grep isc-dhcp-relay; then
	apt update
	DEBIAN_FRONTEND=noninteractive apt install -y isc-dhcp-relay
	sed -i 's/SERVERS=""/SERVERS="172.16.2.2"/' /etc/default/isc-dhcp-relay
	sed -i 's/INTERFACES=""/INTERFACES="enp0s9 enp0s8"/' /etc/default/isc-dhcp-relay
	/etc/init.d/isc-dhcp-relay restart
fi
# Check status DHCP relay
systemctl status isc-dhcp-relay

# Enable ip forwarding
sed -i "s!#net.ipv4.ip_forward=1!net.ipv4.ip_forward=1!" /etc/sysctl.conf
sysctl -p /etc/sysctl.conf