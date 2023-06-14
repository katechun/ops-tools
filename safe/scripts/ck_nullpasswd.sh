#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

awk -F: 'length($2)==0 {print $1" user is null password!"}' /etc/shadow
