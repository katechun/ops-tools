#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


remoteLogin=$(cat /etc/ssh/sshd_config | grep -v ^# |grep "PermitRootLogin no")
if [ $? -eq 1 ];then
  echo "Root user can remote ssh login, warning! "
fi

