#!/bin/bash


# Netplan configuration
rm /etc/netplan/50-vagrant.yaml
cp /vagrant/Client21/50-vagrant.yaml /etc/netplan
netplan apply
