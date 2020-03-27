#!/bin/bash


# Turn on script logging
set -x

# Chech date time
date

# Check operation system
if echo $(hostnamectl | grep "Operating System: ") | grep -q "Ubuntu 18.04"; then
   os="Ubuntu"
elif echo $(hostnamectl | grep "Operating System: ") | grep -q "CentOS Linux 7"; then
   os="Centos"
else
   echo "Your operating system does not support this script."
   exit 0
fi


# Install wget for Ubuntu 18.04
if [ "$os" = "Ubuntu" ]; then
   if [ "$(dpkg -l | grep wget)" == "" ]; then
      apt install -y wget > /dev/null
   fi
fi

# Install wget for Centos 7
if [ "$os" = "Centos" ]; then
   if [ "$(yum list installed | grep wget)" = "" ]; then
      yum install -y wget > /dev/null
   fi
fi

# Download net_check.sh
wget https://raw.githubusercontent.com/Orfey95/Network-Tasks/master/net_check.sh

# Run net_check.sh
bash net_check.sh 2>&1 | tee mail.txt

# Email report 
#echo $(!!) > mail.txt
# For Ubuntu 18.04
if [ "$os" = "Ubuntu" ]; then
   DEBIAN_FRONTEND=noninteractive apt install -y postfix > /dev/null
   echo "Subject: Logging pre_net_check.sh" | cat - mail.txt | sendmail -t sasha7692@gmail.com
   #rm mail.txt
fi
if [ "$os" = "Centos" ]; then
   echo "Subject: Logging pre_net_check.sh" | cat - mail.txt | sendmail -t sasha7692@gmail.com
   #rm mail.txt
fi
