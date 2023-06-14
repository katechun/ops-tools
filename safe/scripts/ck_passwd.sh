#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

max_passwd_days=` grep max_passwd_days ${dir}/../../config.cnf |awk -F'=' '{ print $2 }' `
min_passwd_days=` grep min_passwd_days ${dir}/../../config.cnf |awk -F'=' '{ print $2 }' `
len_passwd=` grep len_passwd ${dir}/../../config.cnf |awk -F'=' '{ print $2 }' `
age_passwd=` grep age_passwd ${dir}/../../config.cnf |awk -F'=' '{ print $2 }' `



passmax=`cat /etc/login.defs | grep PASS_MAX_DAYS | grep -v ^# | awk '{print $2}'`
passmin=`cat /etc/login.defs | grep PASS_MIN_DAYS | grep -v ^# | awk '{print $2}'`
passlen=`cat /etc/login.defs | grep PASS_MIN_LEN | grep -v ^# | awk '{print $2}'`
passage=`cat /etc/login.defs | grep PASS_WARN_AGE | grep -v ^# | awk '{print $2}'`


if [ "${passmax}" -gt "${max_passwd_days}" ];then
   echo "PASS_MAX_DAYS=${passmax} to long , Please modify password setting!"
fi

if [ "${passmin}" -gt "${min_passwd_days}" ];then
   echo "PASS_MIN_DAYS=${passmin} to short,Please modify password setting!"
fi

if [ "${passlen}" -lt "${len_passwd}" ];then
   echo "PASS_MIN_LEN=${passlen} to short,Please modify password setting!"
fi

if [ "${passage}" -gt "${age_passwd}" ];then
   echo "PASS_WARN_AGE=${passage} to short,Please modify password setting!"
fi
