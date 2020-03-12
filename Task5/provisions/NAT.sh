#!/bin/bash


# Route configuration
sed -i 's/      dhcp4: true/      dhcp4: true\n      dhcp4-overrides:\n        route-metric: 99/' /etc/netplan/50-vagrant.yaml
netplan apply

# IpTables configuration
iptables -A FORWARD -i enp0s8 -j ACCEPT
iptables -A FORWARD -o enp0s8 -j ACCEPT
iptables -t nat -A POSTROUTING -o enp0s8 -j MASQUERADE

# Save IpTables configuration after reboot
mkdir /etc/iptables/
touch /etc/iptables/rules.v4
iptables-save > /etc/iptables/rules.v4

echo "@reboot root iptables-restore < /etc/iptables/rules.v4" >> /etc/crontab
# Enable ip forwarding
sysctl -w net.ipv4.ip_forward=1
