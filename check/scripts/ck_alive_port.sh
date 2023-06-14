#!  /bin/bash
# author: xiaochun

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

LSOF=/usr/sbin/lsof

while read i
do
    proc_name=` echo ${i}|awk '{ print $1 }' `
    port_num=` echo ${i}|awk '{ print $NF }' `

    port=` ${LSOF} -i:${port_num} | wc -l `

    if [ "${port}" -eq "0" ];then
       echo "${proc_name}:${port_num} disabled,Please check this process!"
    fi
done < ${dir}/../../conf/port.list

