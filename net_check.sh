#!/bin/bash


# On script logging
set -x

# Add to cron
script_name=$(realpath $0)
if ! grep -q "$script_name" /etc/crontab; then 
   echo "*/5 * * * * root $script_name > /dev/null 2>&1" >> /etc/crontab
fi


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
   if [ "$(yum list installed | grep wget)" = "" ]; then
      yum install -y wget > /dev/null
   fi
   connection_check_first_try
   connection_check_second_try 
fi



# Off script logging
set +x
