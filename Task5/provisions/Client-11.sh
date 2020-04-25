#!/bin/bash


set -x

# Netplan configuration
rm /etc/netplan/50-vagrant.yaml
cp /vagrant/Client11/50-vagrant.yaml /etc/netplan
netplan apply

# Check and install nginx
dpkg -l | grep nginx
if [ $? -eq 1 ]; then
	echo "Nginx is not installed"
	apt update
	apt install -y nginx
else 
	echo "Nginx is already installed"
fi

# Upload my html page
rm /var/www/html/*
cp /vagrant/Client11/index.html /var/www/html