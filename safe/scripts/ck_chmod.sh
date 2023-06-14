#! /bin/bash
# author: xiaochun

source /etc/profile
source ~/.bash_profile

WHICH=/usr/bin/which

FIND=` ${WHICH} find `

unsafe_file=` ${FIND} /home ! -path '/proc/*' -perm 777 2>/dev/null |wc -l `
echo -e "Unsafe files \033[31m${unsafe_file}\033[m, Please check! [ find /home -perm 777 2>/dev/null| xargs chmod 755 2>/dev/null ]"
