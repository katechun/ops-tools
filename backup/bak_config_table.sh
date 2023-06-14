#!/bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

dt=` date "+%Y-%m-%d:%H:%M:%S" `
file_dt=${dt:0:10}
ff=` date "+%Y-%m-%d-%H-%M-%S" `

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"



host=` grep host ${dir}/../conf/.pw|awk -F'=' '{ print $2 }' `
user=` grep username ${dir}/../conf/.pw|awk -F'=' '{ print $2 }' `
passwd=` grep passwd ${dir}/../conf/.pw|awk -F'=' '{ print $2 }' `


file_name=${dir}/../conf/bak_tab.list
WHICH=/usr/bin/which

TOP=` ${WHICH} top|head -n 1 `
MYSQL=` ${WHICH} mysql|head -n 1 `

backup_dir=` grep backup_dir ${dir}/../config.cnf |awk -F'=' '{ print $2 }' `
tname=` grep table_name ${dir}/../config.cnf |awk -F'=' '{ print $2 }' `

bak_tab2=` echo ${tname}|awk -F'.' '{ print $2 }' `
bak_schema=` echo ${tname}|awk -F'.' '{ print $1 }' `
bak_tab=` ${MYSQL} -u"${user}" -h"${host}" -N -p"${passwd}" -D etp -e "show tables like '${bak_tab2}'" 2>/dev/null|grep -v "-" `

if [ "${bak_tab}" != "${bak_tab2}" ]; then
  sql1="create table etp.backup_table_list select table_schema,table_name from information_schema.tables where table_name in ("
  get_tabs=` cat ${file_name}|grep -v \#|grep -v ^$|awk '{ print "\""$1"\"," }' `
  sql=${sql1}""${get_tabs%,}");"
  mysql -u"${user}" -h"${host}" -N -e "${sql}" -p"${passwd}" 2>/dev/null
fi

s1="select table_schema from ${tname} group by table_schema;"
bak_schema=` ${MYSQL} -u"${user}" -h"${host}" -N -p"${passwd}" -D "${bak_schema}" -e "${s1}" 2>/dev/null |grep -v "-" `

for i in ${bak_schema};do
  ss="select table_name from "${tname}" where table_schema = '${i}';"
  schema_tab=` ${MYSQL} -u"${user}" -h"${host}" -N -p"${passwd}"  -e "select table_name from ${tname} where table_schema='${i}'" 2>/dev/null |grep -v "-" |xargs`

  mysqldump -u"${user}" -h"${host}" -f -p"${passwd}" "${i}" ${schema_tab} > ${i}.sql 2>/dev/null

done

if [ ! -f "${backup_dir}" ];then
   mkdir -p ${backup_dir}
fi
tar czvf bak_config.${ff}.sql.gz  *.sql 1>/dev/null
mv bak_config.${ff}.sql.gz ${backup_dir}
rm -rf *.sql 2>/dev/null
