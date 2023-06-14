#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile


find / -xdev -mount -name .rhosts -exec rm -rf {} \;

find / -xdev -mount -name .netrc -exec rm -rf {} \;
