#!/bin/bash


# Netplan configuration
rm /etc/netplan/50-vagrant.yaml
cp /vagrant/Client11/50-vagrant.yaml /etc/netplan
netplan apply

#Install nginx
apt install nginx


