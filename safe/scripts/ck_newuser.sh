#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

more /var/log/secure | grep "new user"  | awk -F '[=,]' '{print $1,$2}' | awk '{print $1,$2,$3,$9}'
