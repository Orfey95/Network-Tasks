#!/bin/bash


# On script logging
set -x

# Check operation system
if echo $(hostnamectl | grep "Operating System: ") | grep -q "Ubuntu 18.04"; then
   os="Ubuntu"
elif echo $(hostnamectl | grep "Operating System: ") | grep -q "CentOS Linux 7"; then
   os="Centos"
else
   echo "Your operating system does not support this script."
   exit 0
fi

connection_check_first_try(){
   wget -q --spider google.com
   # If connection true, first try
   if [ $? -eq 0 ]; then
      exit 0
   # If connection false, first try
   else
      # Network restart
	  if [ "$os" = "Ubuntu" ]; then
         netplan apply
	  elif [ "$os" = "Centos" ]; then
	     systemctl restart network	  
      fi
      sleep 1
   fi
}

connection_check_second_try(){
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
}

# If Ubuntu 18.04
if [ "$os" = "Ubuntu" ]; then
   connection_check_first_try
   connection_check_second_try
# If Centos 7
elif [ "$os" = "Centos" ]; then
   # Check wget
   if echo $(yum list installed | grep wget) -eq ""; then
      yum install -y wget > /dev/null
   fi
   connection_check_first_try
   connection_check_second_try 
fi

# Off script logging
set +x
