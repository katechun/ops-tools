#! /bin/bash
# author: xiaochun
# Check Cpu used
# datetime  load_1m  load_5m  load_15m

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

WHICH=/usr/bin/which
cpuinfo_file=/proc/cpuinfo

TOP=` ${WHICH} top `


cpu_load_1m=` grep cpu_load_1m ${dir}/../../config.cnf |awk -F'=' '{ print $2 }' `
cpu_load_5m=` grep cpu_load_5m ${dir}/../../config.cnf |awk -F'=' '{ print $2 }' `
cpu_load_15m=` grep cpu_load_15m ${dir}/../../config.cnf |awk -F'=' '{ print $2 }' `

load_info=` ${TOP} -b -n 1 |grep "load average"|awk -F 'load average' '{ print $2 }'|awk -F':|,' '{ print $2,$3,$4 }' `
l1=` echo ${load_info} |awk '{print $1}'|awk -F'.' '{ print $1}'  `
l5=` echo ${load_info} |awk '{print $2}'|awk -F'.' '{ print $1}' `
l15=` echo ${load_info} |awk '{print $3}'|awk -F'.' '{ print $1}' `

cores=` grep "physical id"  ${cpuinfo_file}| wc -l `
cpu_load_1m_1=` echo "${cores} * ${cpu_load_1m} / 100"|bc `
cpu_load_5m_1=` echo "${cores} * ${cpu_load_5m} / 100"|bc `
cpu_load_15m_1=` echo "${cores} * ${cpu_load_15m} / 100"|bc `

if [ "${l1}" -gt "${cpu_load_1m_1}" -o "${l5}" -gt "${cpu_load_5m_1}" -o "${l15}" -gt "${cpu_load_15m_1}" ]; then
   echo ${load_info}
fi 
