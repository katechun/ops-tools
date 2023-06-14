#! /bin/bash
# author: xiaochun
#set -x
source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

dt=` date "+%Y%m%d%H%M%S" `

scripts_file_list=` ls -l ${dir}/scripts |grep ck_ | awk '{ print $NF }' `

for i in ${scripts_file_list}; do
   script_len=${#i}
   other_print_len=` echo "60 - ${script_len}"|bc `
   str=$(printf "%-${other_print_len}s" "=")
   res=` sh ${dir}/scripts/${i} `
   ifexist=` echo "${res}"|grep -v "========="|grep -v ^$|wc -l `
   if [ "${ifexist}" != 0 ];then
      echo "===============${i}${str// /=}"
      echo "${res}"
   fi
 
done


