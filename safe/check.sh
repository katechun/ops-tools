#! /bin/bash
# author: xiaochun
#set -x
source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

dt=` date "+%Y%m%d%H%M%S" `
dt1=` date "+%Y-%m-%d %H:%M:%S" `

 
echo ${dt1} > ${dir}/../report/safe_report.${dt}
sh ${dir}/ck.sh >> ${dir}/../report/safe_report.${dt}
