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

logfiles=${dir}/../conf/del_log.list

del_nobusy_log=` grep del_nobusy_log ${dir}/../config.cnf |awk -F'=' '{ print $2 }' `

df_names=` ${DF}|grep dev|grep -v tmpfs|awk '{ print $NF }' `

#获取当前文件系统使用率高的
function busy_dir() {
   dellog_dir= 
   for i in ${df_names}; do
      dir_rat=` df -h ${i}|grep /|awk '{ print $(NF-1) }'|awk -F'%' '{ print $1 }' `
      if [ ${dir_rat} -gt ${del_nobusy_log} ]; then
         dellog_dir=${dellog_dir}" "${i}
      fi
   done
   echo ${dellog_dir}
}

#匹配上就对相应的文件进行处理
function dellog() {
 nn=$1
 s=` echo ${nn}|sed 's/ //g' `
 if [ "${nn}" != "" -a "${s}"  != "" ]; then
   
  if [ -f ${nn} ];then 
   dir1=` stat -c "%m" ${nn} `
   b=`  busy_dir ` 
   log_exis=` echo ${b} |grep -w ${dir1} |wc -l `
   if [ ${log_exis} -gt 0 ];  then
      busy_file=` ${LSOF} ${nn}|wc -l ` 
      if [ ${busy_file} -lt 1 ]; then
         #echo "rm -rf "${nn}
         echo "rm -rf ${nn}"
         if [ -f ${nn} ];then
            rm -rf ${nn}
         fi
      fi
   fi
  fi
 fi

}

function main() {
  for n in ` cat ${logfiles} `; do
      dellog ${n}
  done
}

main
