#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

m=` date -R|awk '{ print $3 }' `
dt=` date "+%d/${m}/%Y" `

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

err_ip_nums=` grep err_ip_nums ${dir}/../../config.cnf |awk -F'=' '{ print $2 }' `

nginx_pid=` ps -ef|grep nginx|grep master|awk '{ print $2 }' `
if [ "${nginx_pid}" == "" ];then
   exit
fi

err_log=` lsof -p ${nginx_pid} |grep access|grep .log|awk '{ print $NF }'|sort -u|head -n 1 `

black_ips=` grep "${dt}" ${err_log}|grep -E 'python|jndi| 400| 499'|grep -v '200 499'|awk '{ print $1 }' |sort |uniq -c |grep -vw 1|sort -n|tail -n 5|awk '{ print $1":"$2 }' `

flag=0
   for i in ${black_ips} ; do
      ip_nums=` echo ${i}|awk -F':' '{ print $1 }' `
      ip=` echo ${i}|awk -F':' '{ print $2 }' `
      if [ "${ip_nums}" -gt "${err_ip_nums}" ];then
         echo "${i}"
      fi
   done

   for j in ${black_ips} ; do
      ip_nums1=` echo ${j}|awk -F':' '{ print $1 }' `
      ip1=` echo ${j}|awk -F':' '{ print $2 }' `
      if [ "${ip_nums1}" -gt "${err_ip_nums}" ];then
         if [ "${flag}" == 0 ];then
            echo
            echo "Please use the command check log:"
            echo "[ grep "${dt}" ${err_log}|grep -E 'python|jndi| 400| 499'|grep -v '200 499'|grep -w ${ip1}|more ]"
            flag=1
         else
            echo "[ grep "${dt}" ${err_log}|grep -E 'python|jndi| 400| 499'|grep -v '200 499'|grep -w ${ip1}|more ]"
         fi
      fi
   done

