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

backup_dir=$1
backupdir_size=$2

#判断备份目录大小 如果目录太大 就压缩到指定目录保存 20480
bak_size=` ${DU} -sm ${backup_dir}|awk '{ print $1 }' `
if [ ${bak_size} -gt ${backupdir_size} ];then
   OLD_FILE=` ls -ltr ${backup_dir}|grep -vE 'total|总量' |head -n 20 |awk '{print $NF }' `
   for file in ${OLD_FILE} ;
   do
      echo "rm -rf  ${backup_dir}/${file}"
   done

fi
