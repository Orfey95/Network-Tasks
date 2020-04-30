#!/bin/bash


set -e

# Netplan configuration
rm /etc/netplan/50-vagrant.yaml
cp /vagrant/DNS/50-vagrant.yaml /etc/netplan
netplan apply

# Install bind9
if ! dpkg -l | grep "bind9 "; then
	apt install -y bind9
fi

# Stop bind9
systemctl stop bind9

# Create key for dynamic DNS
cd /vagrant/key
rm *
dnssec-keygen -a HMAC-MD5 -b 128 -r /dev/urandom -n USER DHCP_UPDATER
cd

# named.conf.options configuration
cp -f /vagrant/DNS/named.conf.options /etc/bind

# forward.bind configuration
cp -f /vagrant/DNS/forward.bind /var/lib/bind

# reverse.bind configuration
cp -f /vagrant/DNS/reverse.bind /var/lib/bind

# named.conf.local configuration
cp -f /vagrant/DNS/named.conf.local /etc/bind

# Insert key in /etc/bind/named.conf.local
sed -i "s!secret ;!secret \"$(cat /vagrant/key/*.private | grep Key: | awk '{print $2}')\";!" /etc/bind/named.conf.local; 

# Chown bind
chown bind:bind /var/lib/bind

# Enable bind9
systemctl enable bind9

# Start bind9
systemctl start bind9

# Check status bind9
systemctl status bind9

# resolved.conf configuration
sed -i 's/#DNS=/DNS=172.16.2.3/' /etc/systemd/resolved.conf
systemctl daemon-reload
systemctl restart systemd-networkd
systemctl restart systemd-resolved

# Disable vagrant interface chaging
echo "network: {config: disabled}" | tee /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
netplan apply
