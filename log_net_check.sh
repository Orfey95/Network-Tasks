#!/bin/bash


# Turn on script logging
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

# Run net_check.sh
bash net_check.sh > mail.txt

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
