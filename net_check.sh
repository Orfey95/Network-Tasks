#!/bin/bash


# On script logging
set -x

# Check operation system
if echo $(hostnamectl | grep "Operating System: ") | grep -q "Ubuntu 18.04"; then
    os="Ubuntu"
elif echo $(hostnamectl | grep "Operating System: ") | grep -q "CentOS Linux 7"; then
    os="Centos"
fi

# If Ubuntu 18.04
if echo $os -eq "Ubuntu"; then
   # Check connection, first try
   wget -q --spider google.com
   # If connection true, first try
   if [ $? -eq 0 ]; then
      exit 0
   # If connection false, first try
   else
      # Network restart
      netplan apply
      sleep 1
      # Check connection, second try
      wget -q --spider google.com
      # If connection true, second try
      if [ $? -eq 0 ]; then
          exit 0
      # If connection false, second try
      else
          # Reboot
          echo "No Connection"
          reboot
      fi
   fi
fi

# If Centos 7
if echo $os -eq "Centos"; then
   # Check wget, first try
   if echo $(yum list installed | grep wget) -eq ""; then
     yum install -y wget > /dev/null;
   fi
   # Check wget, second try
   if echo $(yum list installed | grep wget) -eq ""; then
     ;
   fi
   # Check connection, first try
   wget -q --spider google.com
   # If connection true, first try
   if [ $? -eq 0 ]; then
      exit 0
   # If connection false, first try
   else
      # Network restart
      systemctl restart network
      sleep 1
      # Check connection, second try
      wget -q --spider google.com
      # If connection true, second try
      if [ $? -eq 0 ]; then
          exit 0
      # If connection false, second try
      else
          # Reboot
          echo "No Connection"
          reboot
      fi
   fi
fi

# Off script logging
set +x
