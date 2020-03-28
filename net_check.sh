#!/bin/bash


# Turn on script logging
set -x

# Chech date time
date 4>>mail.txt

# Check operation system
if echo $(hostnamectl | grep "Operating System: ") | grep -q "Ubuntu 18.04"; then
   os="Ubuntu" 4>>mail.txt
elif echo $(hostnamectl | grep "Operating System: ") | grep -q "CentOS Linux 7"; then
   os="Centos" 4>>mail.txt
else
   emailing
   echo "Your operating system does not support this script."
   exit 0
fi

# Make the file executable
script_name=$(realpath net_check.sh) >> mail.txt
chmod +x $script_name

# Add to cron
if ! grep -q "$script_name" /etc/crontab; then
   echo "*/5 * * * * root $script_name > /dev/null 2>&1" >> /etc/crontab 4>>mail.txt
fi

emailing(){
	# Email report 
	# For Ubuntu 18.04
	if [ "$os" = "Ubuntu" ]; then
	   DEBIAN_FRONTEND=noninteractive apt install -y postfix > /dev/null
	   echo "Subject: Logging net_check.sh" | cat - mail.txt | sendmail -t sasha7692@gmail.com
	   rm mail.txt
	fi
	# For Centos 7
	if [ "$os" = "Centos" ]; then
	   echo "Subject: Logging net_check.sh" | cat - mail.txt | sendmail -t sasha7692@gmail.com
	   rm mail.txt
	fi
}

connection_check_first_try(){
   wget -q --spider google.com
   # If connection true, first try
   if [ $? -eq 0 ]; then
      emailing
      exit 0
   # If connection false, first try
   else
      # Network restart
          if [ "$os" = "Ubuntu" ]; then
             netplan apply 4>>mail.txt
          elif [ "$os" = "Centos" ]; then
             systemctl restart network 4>>mail.txt
      fi
      sleep 1
   fi
}

connection_check_second_try(){
   wget -q --spider google.com
   # If connection true, second try
   if [ $? -eq 0 ]; then
      emailing
	  exit 0
   # If connection false, second try
   else
      # Reboot
      echo "No Connection. Reboot." 4>>mail.txt
      emailing
	  reboot
   fi
}

# If Ubuntu 18.04
if [ "$os" = "Ubuntu" ]; then
   connection_check_first_try 4>>mail.txt
   connection_check_second_try 4>>mail.txt
# If Centos 7
elif [ "$os" = "Centos" ]; then
   # Check wget, first try
   if [ "$(yum list installed | grep wget)" = "" ]; then
      yum install -y wget > /dev/null 4>>mail.txt
   fi
   # Check wget, second try
   if [ "$(yum list installed | grep wget)" = "" ]; then
      systemctl restart network 4>>mail.txt
      sleep 1
      yum install -y wget > /dev/null 4>>mail.txt
   else
      emailing
	  exit 0
   fi
   # Check wget, third try
   if [ "$(yum list installed | grep wget)" = "" ]; then
      emailing
	  reboot
   fi
   connection_check_first_try 4>>mail.txt
   connection_check_second_try 4>>mail.txt
fi
