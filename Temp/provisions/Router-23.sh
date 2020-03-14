#!/bin/bash


# Interfaces configuration
rm /etc/sysconfig/network-scripts/ifcfg-eth1
rm /etc/sysconfig/network-scripts/ifcfg-eth2
cp /vagrant/Router23/ifcfg-eth1 /etc/sysconfig/network-scripts
cp /vagrant/Router23/ifcfg-eth2 /etc/sysconfig/network-scripts
if ! grep -q "DEFROUTE=no" /etc/sysconfig/network-scripts/ifcfg-eth0; 
then echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0; 
fi

# Restart interfaces
systemctl restart network

# Enable ip forwarding
sysctl -w net.ipv4.ip_forward=1

# Install dhcp
yum --quiet install -y dhcp

# dhcprelay configuration
cp /lib/systemd/system/dhcrelay.service /etc/systemd/system/dhcrelay.service
if ! grep -q "ExecStart=/usr/sbin/dhcrelay -d --no-pid 172.16.2.2" /etc/systemd/system/dhcrelay.service; 
then sed -i 's!ExecStart=/usr/sbin/dhcrelay -d --no-pid!ExecStart=/usr/sbin/dhcrelay -d --no-pid 172.16.2.2!' /etc/systemd/system/dhcrelay.service; 
fi

# Rester demons
systemctl --system daemon-reload

# Start dhcrelay
systemctl start dhcrelay

# Check dhcrelay status
systemctl status dhcrelay

# Install bind-utils for host, nslookup and etc.
yum --quiet install -y bind-utils