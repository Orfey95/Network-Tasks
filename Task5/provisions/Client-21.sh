#!/bin/bash


set -e

# Netplan configuration
rm /etc/netplan/50-vagrant.yaml
cp /vagrant/Client21/50-vagrant.yaml /etc/netplan
netplan apply

# Check and install nginx
if ! dpkg -l | grep nginx; then
	echo "Nginx is not installed"
	apt update
	apt install -y nginx
else 
	echo "Nginx is already installed"
fi

# Upload my html page
rm /var/www/html/*
cp /vagrant/Client21/index.html /var/www/html
