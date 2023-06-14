#! /bin/bash
# author: xiaochun
# delete log file 
#set -x

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

dt=` date "+%Y-%m-%d:%H:%M:%S" `
file_dt=${dt:0:10}

# Get script file name
file_name=` echo ${0} | awk -F'/' '{ print $NF }' `

WHICH=/usr/bin/which

DF=` ${WHICH} df `
LSOF=` ${WHICH} lsof `
STAT=` ${WHICH} stat `

logfiles=${dir}/../conf/del_log.list

del_busy_log=` grep del_busy_log ${dir}/../config.cnf |awk -F'=' '{ print $2 }' `

df_names=` ${DF}|grep dev|grep -v tmpfs|awk '{ print $NF }' `

#获取当前文件系统使用率高的
function busy_dir() {
   dellog_dir= 
   for i in ${df_names}; do
      dir_rat=` df -h ${i}|grep /|awk '{ print $(NF-1) }'|awk -F'%' '{ print $1 }' `
      if [ "${dir_rat}" -gt "${del_busy_log}" ]; then
         dellog_dir=${dellog_dir}" "${i}
      fi
   done
   echo ${dellog_dir}
}

#匹配上就对相应的文件进行处理
function dellog() {
   nn=$1
   dir1=` ${STAT} -c "%m" ${nn} `
   b=`  busy_dir ` 
   log_exis=` echo ${b} |grep -w ${dir1} |wc -l `
   if [ ${log_exis} -gt 0 ];  then
         #echo "rm -rf "${nn}
         echo "> ${nn}"
         if [ -f ${nn} ];then
            echo > ${nn}
         fi
   fi

}

function main() {
  for n in ` cat ${logfiles} `; do
      if [ -f ${n} ];then
         dellog ${n}
      fi
  done
}

main
