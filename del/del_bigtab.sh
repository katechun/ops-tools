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


host=` grep host ${dir}/../conf/.pw|awk -F'=' '{ print $2 }' `
user=` grep username ${dir}/../conf/.pw|awk -F'=' '{ print $2 }' `
passwd=` grep passwd ${dir}/../conf/.pw|awk -F'=' '{ print $2 }' `



WHICH=/usr/bin/which

DF=` ${WHICH} df `
LSOF=` ${WHICH} lsof `
MYSQL=` ${WHICH} mysql `

logfiles=logfile.list

del_daily_tab=` grep del_daily_tab ${dir}/../config.cnf |awk -F'=' '{ print $2 }' `

df_names=` ${DF}|grep dev|grep -v tmpfs|awk '{ print $NF }' `

#获取当前文件系统使用率高的
function busy_dir() {
   dellog_dir= 
   for i in ${df_names}; do
      dir_rat=` df -h ${i}|grep /|awk '{ print $(NF-1) }'|awk -F'%' '{ print $1 }' `
      if [ "${dir_rat}" -gt "${del_daily_tab}" ]; then
         dellog_dir=${dellog_dir}" "${i}
      fi
   done
   echo ${dellog_dir}
}

function mysql_data_dir() {
    mpid=` check_mysql_pid ` 
    if [ "${mpid}" != "" ];then
       mysql_dir=` lsof -p ${mpid}|grep -E '\.MYD|\.ibd'|awk '{ print $NF }'|awk -F'/' '{for(i=1;i<NF-2;i++) { printf("%s ",$i);} printf("\n") }'|sort -u|sed 's/ /\//g' `
    fi
    echo "${mysql_dir}"
}

function check_mysql_pid(){
   mysql_pid=` ps -ef|grep -w mysqld|grep -v grep |awk '{ print $2 }'|head -n 1 `
   echo "${mysql_pid}"
}

#匹配上就对相应的文件进行处理
function del_tab() {
 nn=$1
 s=` echo ${nn}|sed 's/ //g' `
 if [ "${nn}" != "" -a "${s}"  != "" ]; then
   
   dir1=` stat -c "%m" ${nn} `
   b=`  busy_dir ` 
   log_exis=` echo ${b} |grep -w ${dir1} |wc -l `
   if [ ${log_exis} -gt 0 ];  then
      busy_file=` ${LSOF} ${nn}|wc -l ` 
      if [ ${busy_file} -lt 1 ]; then
         echo "del table!"
         del_daily_tab
      fi
   fi
 fi

}

function del_daily_tab(){
  select_daily_tab="SELECT \
	CONCAT( \
		'truncate table ', \
		TABLE_SCHEMA, \
		'.', \
		table_name, \
		';' \
	) \
FROM \
	information_schema. TABLES \
WHERE \
	( \
		table_name LIKE 'ONLINE_REAL_DATA_DAILY_%' \
		OR table_name LIKE 'ONLINE_REAL_WAVE_DAILY_%' \
	) \
AND table_name NOT LIKE CONCAT( \
	'ONLINE_REAL_DATA_DAILY_%_', \
	date_format(curdate(), '%Y%m%d') \
) \
AND table_name NOT LIKE CONCAT( \
	'ONLINE_REAL_WAVE_DAILY_%_', \
	date_format(curdate(), '%Y%m%d') \
);" 
   echo "Select truncate table list."
   ${MYSQL} -u"${user}" -h"${host}" -N -p"${passwd}" -e "${select_daily_tab}" |grep -v "-"  > trunc_tab_list.sql
  
   echo "Execute truncate table list!" 
   ${MYSQL} -u"${user}" -h"${host}" -N -p"${passwd}" < trunc_tab_list.sql
}

function main() {
  my_data_dir=` mysql_data_dir `
  if [ "${my_data_dir}" != "" ];then
     for n in ${my_data_dir}; do
       del_tab ${n}
     done
  fi
}

main
