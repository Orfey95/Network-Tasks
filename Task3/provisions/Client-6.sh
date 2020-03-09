#!/bin/bash


# Set DHCP_HOSTNAME
echo "      dhcp4-overrides:
        hostname: Client-6" | tee -a /etc/netplan/50-vagrant.yaml
# Reboot interface
netplan apply
# Configure DHCP Client
echo "

timeout 10;

lease {
  interface \"enp0s8\";
  fixed-address 172.16.2.76;
  option subnet-mask 255.255.255.0;
  renew 2 2022/1/12 00:00:01;
  rebind 2 2022/1/12 00:00:01;
  expire 2 2022/1/12 00:00:01;
}" | tee /etc/dhcp/dhclient.conf
# If DHCP fails, static IP is added
if [ $(ip a show enp0s8 | egrep "inet ") -eq ""]; then
echo "You could not get the address via DHCP!"
echo "Therefore, you have been assigned a temporary static address!"
dhclient -v enp0s8
fi