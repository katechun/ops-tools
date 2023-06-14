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

backup_dir=${dir}/../logs
backupdir_size=` grep logs_dir_size ${dir}/../config.cnf |awk -F'=' '{ print $2 }' `

if [ "${backup_dir}" != "" -a "${backupdir_size}" != "" ]; then
   sh ${dir}/base_del_file.sh ${backup_dir} ${backupdir_size}
else 
   echo "Parameter get error, backup dir or backup size!"
fi


backup_dir=${dir}/../report
backupdir_size=` grep report_dir_size ${dir}/../config.cnf |awk -F'=' '{ print $2 }' `

if [ "${backup_dir}" != "" -a "${backupdir_size}" != "" ]; then
   sh ${dir}/base_del_file.sh ${backup_dir} ${backupdir_size}
else
   echo "Parameter get error, backup dir or backup size!"
fi

