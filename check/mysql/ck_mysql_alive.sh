#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


host=` grep host ${dir}/../../conf/.pw|awk -F'=' '{ print $2 }' `
user=` grep username ${dir}/../../conf/.pw|awk -F'=' '{ print $2 }' `
passwd=` grep passwd ${dir}/../../conf/.pw|awk -F'=' '{ print $2 }' `
port=` grep port ${dir}/../../conf/.pw|awk -F'=' '{ print $2 }' `

mysql_alive=` mysqladmin -P${port} -u${user} -p${passwd} -h${host} ping 2>/dev/null`
if [ "${mysql_alive}" != "mysqld is alive" ];then
   echo "MySQL not alive!!!!"
fi
 
