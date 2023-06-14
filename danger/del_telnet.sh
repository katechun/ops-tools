#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

telnet_num=` rpm -qa | grep telnet-server|wc -l `

if [ "${telnet_num}" -gt 0 ];then
   systemctl stop telnet.socket
   rpm -e telnet-server --nodeps
   echo "telnet-server delete success!"
fi
