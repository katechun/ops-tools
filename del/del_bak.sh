#!/bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

dt=` date "+%Y-%m-%d:%H:%M:%S" `
file_dt=${dt:0:10}

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

WHICH=/usr/bin/which

DU=` ${WHICH} du|head -n 1 `

backup_dir=` grep backup_dir ${dir}/../config.cnf |awk -F'=' '{ print $2 }' `
backupdir_size=` grep backupdir_size ${dir}/../config.cnf |awk -F'=' '{ print $2 }' `

#判断备份目录大小 如果目录太大 就压缩到指定目录保存 m 
bak_size=` ${DU} -sm ${backup_dir}|awk '{ print $1 }' `
    echo "bak_size:${bak_size}  backupdir_size: ${backupdir_size}"
if [ "${bak_size}" -gt "${backupdir_size}" ];then
   bak_file_num=` ls -ltr ${backup_dir} |grep "\.sql\.gz" |wc -l `
   del_file_num=` echo "${bak_file_num} / 2"|bc `
   OLD_FILE=` ls -ltr ${backup_dir} |grep "\.sql\.gz"|head -n ${del_file_num} |awk '{print $NF }' `
   for file in ${OLD_FILE} ;
   do
      echo "rm -rf  ${backup_dir}/${file}"
      if [ -f ${backup_dir}/${file} ];then
         rm -rf ${backup_dir}/${file}
      fi
   done

fi
