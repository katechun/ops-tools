#! /bin/bash
# author: xiaochun
#set -x
# datetime used%  system%  idle%  wait%  hardi%  softi%

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

WHICH=/usr/bin/which

TOP=` ${WHICH} top|head -n 1 `

cpu_rat=` grep cpu_rat ${dir}/../../config.cnf |awk -F'=' '{ print $2 }' `

function get_param() {
   if_not_num=` echo ${cpu_rat} | sed 's#[0-9]##g' `
   if [ -n "${if_not_num}" ]; then
      echo "Config parameter err: ../config.cnf -> cpu_rat ."
      exit
   fi
}

function busy_cpu() {
   cpu_info=` ${TOP} -b -n 1|grep Cpu `
   cpu_idle=` ${TOP} -b -n 1|grep Cpu|awk -F':|,' '{ print $5 }'|awk '{ print $1 }'|awk -F'.' '{ print $1 }' `
   cpu_1=` echo "100 - ${cpu_idle}"|bc `

   if [ ${cpu_1} -gt ${cpu_rat} ]; then
      echo -e "CPU used \033[31m${cpu_1}%\033[m, Pleas check cpu!" 
   fi
}


function main() {
   get_param
   busy_cpu
}

main
