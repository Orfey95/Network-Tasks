#!/bin/bash


# Netplan configuration
rm /etc/netplan/50-vagrant.yaml
cp /vagrant/DNS/50-vagrant.yaml /etc/netplan
netplan apply

# Install bind9
apt install -y bind9

# Create key for dynamic DNS
cd /vagrant/key
rm *
dnssec-keygen -a HMAC-MD5 -b 128 -r /dev/urandom -n USER DHCP_UPDATER
#private_key=$(cat /vagrant/key/*.private | grep Key: | awk '{print $2}')
#echo "private_key=$(cat /vagrant/key/*.private | grep Key: | awk '{print $2}')" > /home/vagrant/.bash_profile

# Check status bind9
systemctl status bind9

# named.conf.options configuration
cp -f /vagrant/DNS/named.conf.options /etc/bind

# forward.bind configuration
cp -f /vagrant/DNS/forward.bind /var/lib/bind

# reverse.bind configuration
cp -f /vagrant/DNS/reverse.bind /var/lib/bind

# named.conf.local configuration
cp -f /vagrant/DNS/named.conf.local /etc/bind

# Insert key in /etc/bind/named.conf.local
sed -i "s/secret ;/secret \"$(cat /vagrant/key/*.private | grep Key: | awk '{print $2}')\";/" /etc/bind/named.conf.local; 

# Chown bind
chown bind:bind /var/lib/bind

# Restart bind9
service bind9 restart

# Install resolvconf
apt update
apt install resolvconf
echo "nameserver 172.16.2.3" | tee /etc/resolvconf/resolv.conf.d/tail
systemctl restart resolvconf

# Save vagrant NAT configuration
if ! grep -q "use-dns: no" /etc/netplan/50-cloud-init.yaml; 
then sed -i 's/            dhcp4: true/            dhcp4: true\n            dhcp4-overrides:\n              use-dns: no/' /etc/netplan/50-cloud-init.yaml; 
fi
touch /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
echo "network: {config: disabled}" | tee /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
netplan apply

# resolved.conf configuration
sed -i 's/#DNS=/DNS=172.16.2.3/' /etc/systemd/resolved.conf