#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
#source ~/.bash_profile

rpm -qa  | awk -F- '{print $1}' | sort | uniq | grep -E "^(ncat|sqlmap|nmap|beef|nikto|john|ettercap|backdoor|proxy|msfconsole|msf)$"
