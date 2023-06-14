#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
#source ~/.bash_profile

if [ -f /var/log/yum.log ];then
   more /var/log/yum* | awk -F: '{print $NF}' | awk -F '[-]' '{print $1}' | sort | uniq | grep -E "(^nc|sqlmap|nmap|beef|nikto|john|ettercap|backdoor|proxy|msfconsole|msf)"
fi
