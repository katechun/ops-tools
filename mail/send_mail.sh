#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dt=` date "+%Y%m%d12" `

from=` grep from_user ${dir}/../config.cnf |awk -F'=' '{ print $2 }' `
tos=` grep to_user ${dir}/../config.cnf |awk -F'=' '{ print $2 }' `
email_title=` grep email_title ${dir}/../config.cnf |awk -F'=' '{ print $2 }' `

email_content=` sh ${dir}/../check/ck.sh; sh ${dir}/../safe/ck.sh `

if_content=` echo ${email_content}|grep -v ^$|wc -l `

if [ "${if_content}" != "" ];then
   echo "${email_content}"

   for j in ${tos} ; do
      to=` echo ${j}|grep -v ^$|sed 's/"//g'|sed 's/ //g' `
      ${dir}/sendmail send -a "${to}" -t "${email_title}" -i "${email_content}" 
   done

fi
