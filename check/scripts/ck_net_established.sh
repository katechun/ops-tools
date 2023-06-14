#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

net_conns=` grep net_conns ${dir}/../../config.cnf |awk -F'=' '{ print $2 }' `

conns_cnt=` netstat -nat|grep ESTABLISHED|wc -l `

if [ "${conns_cnt}" -gt "${net_conns}" ];then
   netstat -nat|grep ESTABLISHED|awk '{ print $4}' |sort |uniq -c |sort -n|tail -n 10
fi
