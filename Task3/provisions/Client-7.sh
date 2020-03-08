#!/bin/bash


# If DHCP fails, static IP is added
if [ $(ip a show eth1 | egrep "inet ") -eq ""]; then
echo "You could not get the address via DHCP!"
echo "Therefore, you have been assigned a temporary static address!"
mv /etc/sysconfig/network-scripts/ifcfg-eth1 /etc/sysconfig/network-scripts/ifcfg-eth1:0
touch /etc/sysconfig/network-scripts/ifcfg-eth1:1
echo "DEVICE="eth1:0"" >> /etc/sysconfig/network-scripts/ifcfg-eth1:1
echo "IPADDR=172.16.2.74" >> /etc/sysconfig/network-scripts/ifcfg-eth1:1
echo "NETMASK=255.255.255.0" >> /etc/sysconfig/network-scripts/ifcfg-eth1:1
systemctl restart network
fi