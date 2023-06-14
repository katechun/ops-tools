#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

WHICH=/usr/bin/which

DF=` ${WHICH} df `

df_names=` ${DF} -i|grep dev|grep -v tmpfs|awk '{ print $NF }' `
disk_rat=` grep inode_rat ${dir}/../../config.cnf |awk -F'=' '{ print $2 }' `

function get_param() {
   if_not_num=` echo ${inode_rat} | sed 's#[0-9]##g' `
   if [ -n "${if_not_num}" ]; then
      echo "Config parameter err: ../config.cnf -> disk_rat ."
      exit
   fi
}

#获取当前文件系统使用率高的
function busy_dir() {
   dellog_dir= 
   
   for i in ${df_names}; do
      dir_rat=` df -i ${i}|grep /|awk '{ print $(NF-1) }'|awk -F'%' '{ print $1 }' `
      ifnum=` echo ${dir_rat}| awk '{print($0~/^[-]?([0-9])+[.]?([0-9])+$/)?"number":"string"}' `
      if [ "${ifnum}" == "number" ];then
         if [ "${dir_rat}" -gt "${disk_rat}" ]; then
            dellog_dir="${dellog_dir} ${i}"
         fi
      fi
   done
   echo ${dellog_dir}
}

#匹配上就对相应的文件进行处理
function print_info() {
   dir1=$1
   df -i ${dir1} 
}

function main() {
   # 检查参数阈值是否设置
   get_param  
   #找出忙的文件系统
   busy=` busy_dir `
   if [ "${busy}" != "" ];then
      #打印
      print_info "${busy}"
   fi
}

main
