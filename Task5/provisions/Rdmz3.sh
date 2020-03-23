#!/bin/bash


# Interfaces configuration
rm /etc/sysconfig/network-scripts/ifcfg-eth1
rm /etc/sysconfig/network-scripts/ifcfg-eth2
cp /vagrant/Rdmz3/ifcfg-eth1 /etc/sysconfig/network-scripts
cp /vagrant/Rdmz3/ifcfg-eth2 /etc/sysconfig/network-scripts
if ! grep -q "DEFROUTE=no" /etc/sysconfig/network-scripts/ifcfg-eth0; 
then echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0; 
fi
echo "GATEWAYDEV=eth1" | tee /etc/sysconfig/network

# Restart interfaces
systemctl restart network

# Enable ip forwarding
if ! grep -q "net.ipv4.ip_forward = 1" /usr/lib/sysctl.d/50-default.conf; 
then echo "net.ipv4.ip_forward = 1" | tee -a /usr/lib/sysctl.d/50-default.conf; 
fi

# Restart interfaces
systemctl restart network

# Install dhcp
yum --quiet install -y dhcp

# dhcprelay configuration
cp /lib/systemd/system/dhcrelay.service /etc/systemd/system/dhcrelay.service
if ! grep -q "ExecStart=/usr/sbin/dhcrelay -d --no-pid 172.16.2.2" /etc/systemd/system/dhcrelay.service; 
then sed -i 's!ExecStart=/usr/sbin/dhcrelay -d --no-pid!ExecStart=/usr/sbin/dhcrelay -d --no-pid 172.16.2.2!' /etc/systemd/system/dhcrelay.service; 
fi

# Reload demons
systemctl --system daemon-reload

# Enable dhcrelay
systemctl enable dhcrelay

# Start dhcrelay
systemctl start dhcrelay

# Check dhcrelay status
systemctl status dhcrelay

# Install bind-utils for host, nslookup and etc.
yum --quiet install -y bind-utils

# FireWall configuration
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --set-default-zone=external
firewall-cmd --zone=external --change-interface=eth0
firewall-cmd --zone=external --change-interface=eth1
firewall-cmd --zone=internal --change-interface=eth2
firewall-cmd --zone=internal --permanent --remove-service=samba-client
firewall-cmd --reload
