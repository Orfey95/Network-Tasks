#!/bin/bash


# Netplan configuration
rm /etc/netplan/50-vagrant.yaml
cp /vagrant/Router13/50-vagrant.yaml /etc/netplan
netplan apply

# Enable ip forwarding
sysctl -w net.ipv4.ip_forward=1

# IpTables configuration
iptables -A FORWARD -i enp0s8 -j ACCEPT
iptables -A FORWARD -o enp0s8 -j ACCEPT
iptables -t nat -A POSTROUTING -o enp0s8 -j MASQUERADE
iptables -A FORWARD -i enp0s9 -j ACCEPT
iptables -A FORWARD -o enp0s9 -j ACCEPT
iptables -t nat -A POSTROUTING -o enp0s9 -j MASQUERADE

# Install iptables-persistent
apt update
DEBIAN_FRONTEND=noninteractive apt install -y iptables-persistent
iptables-save > /etc/iptables/rules.v4

# Install DHCP relay
DEBIAN_FRONTEND=noninteractive apt install -y isc-dhcp-relay
sed -i 's/SERVERS=""/SERVERS="172.16.2.2"/' /etc/default/isc-dhcp-relay
sed -i 's/INTERFACES=""/INTERFACES="enp0s9 enp0s8"/' /etc/default/isc-dhcp-relay
/etc/init.d/isc-dhcp-relay restart
# Check status DHCP relay
systemctl status isc-dhcp-relay
