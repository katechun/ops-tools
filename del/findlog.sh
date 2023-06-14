#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

logfiles=${dir}/../conf/del_log.list

WHICH=/usr/bin/which

FIND=` ${WHICH} find `


lfiles=` ${FIND} /  ! -path '/proc/*' -name *.log|grep -v ":"| xargs `
if [ "${lfiles}" != "" ];then
   logs=` file ${lfiles} |grep -i text|awk -F':' '{ print $1 }' `
fi


 echo "${logs}" > ${logfiles}

