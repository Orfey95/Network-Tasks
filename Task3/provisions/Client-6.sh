#!/bin/bash


# Set DHCP_HOSTNAME
echo "      dhcp4-overrides:
        hostname: Client-6" | tee -a /etc/netplan/50-vagrant.yaml
# Reboot interface
netplan apply
if [ $(ip a show enp0s8 | egrep "inet ") -eq ""]; then
echo "You could not get the address via DHCP!"
echo "Therefore, you have been assigned a temporary static address!"
echo "      addresses: [ 172.16.2.73/24 ]" >> /etc/netplan/50-vagrant.yaml
netplan apply
fi