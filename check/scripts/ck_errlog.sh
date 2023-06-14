#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

dt=` date "+%Y-%m-%d" `
cpu_rat=` grep cpu_rat ${dir}/../../config.cnf |awk -F'=' '{ print $2 }' `

errlog_file=` cat ${dir}/../../conf/del_log.list `
err_count=` grep ${dt} ${errlog_file} 2>/dev/null|grep -i error |wc -l `

if [ "${err_count}" != 0 ];then
   echo "Log error count:${err_count},  Please use the command check!"
   echo "[ grep ${dt} \` cat ${dir}/../../conf/del_log.list \`|grep -i error|more ]"
fi

