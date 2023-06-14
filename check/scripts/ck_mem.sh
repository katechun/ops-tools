#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mem_rat=` grep mem_rat ${dir}/../../config.cnf |awk -F'=' '{ print $2 }' `

function get_param() {
   if_not_num=` echo ${mem_rat} | sed 's#[0-9]##g' `
   if [ -n "${if_not_num}" ]; then
      echo "Config parameter err: ../config.cnf -> mem_rat ."
      exit
   fi
}

function busy_mem() {
   # memory file /proc/meminfo
   mem_info=` cat /proc/meminfo `

   mem_total=` echo "${mem_info}" |grep "MemTotal"|awk '{ print $2 }'|awk '{ print $1 }' `
   mem_free=` echo "${mem_info}" |grep "MemFree"|awk '{ print $2 }'|awk '{ print $1 }' `

   mem_buss=` echo "(${mem_total} - ${mem_free})*100 / ${mem_total} " |bc `

   if [ ${mem_buss} -gt ${mem_rat} ]; then
      echo -e "Memory used \033[31m${mem_buss}%\033[m, Pleas check memory!"
   fi
}

function main() {
   get_param
   busy_mem
}

main
