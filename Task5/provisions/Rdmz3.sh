#!/bin/bash


set -e

# Interfaces configuration
rm /etc/sysconfig/network-scripts/ifcfg-eth1
rm /etc/sysconfig/network-scripts/ifcfg-eth2
cp /vagrant/Rdmz3/ifcfg-eth1 /etc/sysconfig/network-scripts
cp /vagrant/Rdmz3/ifcfg-eth2 /etc/sysconfig/network-scripts
if ! grep -q "DEFROUTE=no" /etc/sysconfig/network-scripts/ifcfg-eth0; then 
	echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0; 
fi
echo "GATEWAYDEV=eth1" | tee /etc/sysconfig/network

# Enable ip forwarding
echo "net.ipv4.ip_forward = 1" | tee /usr/lib/sysctl.d/51-default.conf

# Restart interfaces
systemctl restart network

# Install dhcp
if ! rpm -qa | grep "dhcp-[0-9]"; then
	yum --quiet install -y dhcp
fi

# dhcprelay configuration
cp -f /lib/systemd/system/dhcrelay.service /etc/systemd/system/dhcrelay.service
sed -i 's!ExecStart=/usr/sbin/dhcrelay -d --no-pid!ExecStart=/usr/sbin/dhcrelay -d --no-pid 172.16.2.2!' /etc/systemd/system/dhcrelay.service; 

# Reload demons
systemctl --system daemon-reload

# Enable dhcrelay
systemctl enable dhcrelay

# Start dhcrelay
systemctl start dhcrelay

# Check dhcrelay status
systemctl status dhcrelay

# Install bind-utils for host, nslookup and etc.
if ! rpm -qa | grep bind-utils; then
	yum --quiet install -y bind-utils
fi

# Restart interfaces
systemctl restart network

# FireWall configuration
if ! rpm -qa | grep iptables-services; then
	yum --quiet install -y iptables-services
	systemctl enable iptables
	iptables -A FORWARD -o eth1 -d 172.16.2.64/27 -m conntrack --ctstate NEW -j REJECT
	iptables -A FORWARD -o eth1 -d 172.16.2.96/29 -m conntrack --ctstate NEW -j REJECT
	service iptables save
fi
