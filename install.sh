#! /bin/bash
# author: xiaochun
#set -x

. ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

dt=` date "+%Y%m%d%H%M%S" `

cd ${dir}

# copy config file ,from exmaple to conf.
config_file="${dir}/example/config.cnf"
baktab_file="${dir}/example/bak_tab.list"
port_file="${dir}/example/port.list"
if [ -f ${dir}/config.cnf ];then
   mv ${dir}/config.cnf ${dir}/config.cnf.${dt}
fi

if [ -f ${dir}/conf/bak_tab.list ]; then
   mv ${dir}/conf/bak_tab.list ${dir}/conf/bak_tab.list.${dt}
fi

if [ -f ${dir}/conf/port.list ]; then
   mv ${dir}/conf/port.list ${dir}/conf/port.list.${dt}
fi


if [ -f "${config_file}" ];then
   cp ${config_file} ${dir} 
   if [ $? == 0 ];then
      echo "Config file write success!"
   fi
else
   echo "Not found ./example/config.cnf file!"
fi


if [ -f "${baktab_file}" ];then
   cp ${baktab_file} ${dir}/conf/
   if [ $? == 0 ];then
      echo "Backup table list file write success!"
   fi
else
   echo "Not found ./example/bak_tab.list file!"
fi


if [ -f "${port_file}" ];then
   cp ${port_file} ${dir}/conf/
   if [ $? == 0 ];then
      echo "Port list file write success!"
   fi
else
   echo "Not found ./example/port.list file!"
fi



# Init log file list.
sh ./del/findlog.sh > ./conf/del_log.list

if [ $? == 0 ];then
   echo "del_log.list file write success!"
fi

crond_ifexist=` ps -ef|grep crond|grep -v grep|wc -l `
if [ "${crond_ifexist}" -eq 0 ];then
   echo "crond not enabled,Please enabled crond service!"
   exit
fi
cron_file=/var/spool/cron/root
if [ ! -f ${cron_file} ];then
   touch ${cron_file} 
fi

cron_attr_i=` lsattr ${cron_file}|grep "\-i"|wc -l `
cron_attr_a=` lsattr ${cron_file}|grep "a\-"|wc -l `
if [ ${cron_attr_i} -gt 0 ];then
   chattr -i ${cron_file}
fi

if [ ${cron_attr_a} -gt 0 ];then
   chattr -a  ${cron_file}
fi

ck_exis_title=` grep "AutoOps Tool Kit for  Expert Product" ${cron_file}|wc -l `
if [ "${ck_exis_title}" -lt 1 ];then
   echo "# AutoOps Tool Kit for  Expert Product"  >> ${cron_file}
fi
#Crontab setting
#check report
ck_exis=` grep -w ck.sh ${cron_file}|wc -l `
if [ "${ck_exis}" -lt 1 ];then
   echo "15 */6 * * * sh ${dir}/check/check.sh >> ${dir}/logs/ck.sh.log  2>&1 " >> /var/spool/cron/root
   echo "crontab config: check report config success!"
fi

#check safe report
safe_exis=` grep -w ck.sh ${cron_file}|wc -l `
if [ "${ck_exis}" -lt 1 ];then
   echo "15 */6 * * * sh ${dir}/safe/check.sh >> ${dir}/logs/safe.sh.log  2>&1 " >> /var/spool/cron/root
   echo "crontab config: check safe report config success!"
fi



#filesystem check setting, delete log or table
dlog1_exis=` grep -w del_log1.sh ${cron_file}|wc -l `
if [ "${dlog1_exis}" -lt 1 ];then
   echo "11 * * * * sh ${dir}/del/del_log1.sh >> ${dir}/logs/del_log1.sh.log 2>&1" >> /var/spool/cron/root
fi
dlog2_exis=` grep -w del_log2.sh ${cron_file}|wc -l `
if [ "${dlog2_exis}" -lt 1 ];then
   echo "29 * * * * sh ${dir}/del/del_log2.sh >> ${dir}/logs/del_log2.sh.log 2>&1" >> /var/spool/cron/root
fi
dbigtab_exis=` grep -w del_bigtab.sh ${cron_file}|wc -l `
if [ "${dbigtab_exis}" -lt 1 ];then
   echo "55 * * * * sh ${dir}/del/del_bigtab.sh >> ${dir}/logs/del_bigtab.sh.log 2>&1" >> /var/spool/cron/root
   echo "crontab config: filesystem delete log or table config success!"
fi

#delete config file backup
dbak_exis=` grep -w del_bak.sh ${cron_file}|wc -l `
if [ "${dbak_exis}" -lt 1 ];then
   echo "8 23 * * * sh ${dir}/del/del_bak.sh >> ${dir}/logs/del_bak.sh.log 2>&1" >> /var/spool/cron/root
   echo "crontab config: delete backup config file success!"
fi


#delete self logs file 
dbak_exis=` grep -w del_selflogs.sh ${cron_file}|wc -l `
if [ "${dbak_exis}" -lt 1 ];then
   echo "39 23 * * * sh ${dir}/del/del_selflogs.sh >> ${dir}/logs/del_selflogs.sh.log 2>&1" >> /var/spool/cron/root
   echo "crontab config: delete selflogs config file success!"
fi


#safe check, backlist 
secssh_exis=` grep -w secure_ssh.sh ${cron_file}|wc -l `
if [ "${secssh_exis}" -lt 1 ];then
   echo "*/20 * * * * sh ${dir}/safe/secure_ssh.sh >> ${dir}/logs/secure_ssh.sh.log 2>&1" >> /var/spool/cron/root
   echo "crontab config: safe check config success!"
fi

#backup config table
btab_exis=` grep -w bak_config_table.sh ${cron_file}|wc -l `
if [ "${btab_exis}" -lt 1 ];then
   echo "5 18 * * * sh ${dir}/backup/bak_config_table.sh >> ${dir}/logs/bak_config_table.sh.log 2>&1" >> /var/spool/cron/root
   echo "crontab config: backup config table success!"
fi

#send mail alram
sendmail_exis=` grep -w send_mail.sh ${cron_file}|wc -l `
if [ "${btab_exis}" -lt 1 ];then
   echo "15 10 * * 1 sh ${dir}/mail/send_mail.sh >> ${dir}/logs/send_mail.sh.log 2>&1" >> /var/spool/cron/root
   echo "crontab config: auto send mail config  success!"
fi

#send mail alram
sendmail_exis=` grep -w send_mail.sh ${cron_file}|wc -l `
if [ "${btab_exis}" -lt 1 ];then
   echo "*/15 * * * * sh ${dir}/mail/send_mail_real.sh >> ${dir}/logs/send_mail_real.sh.log 2>&1" >> /var/spool/cron/root
   echo "crontab config: auto send real mail config  success!"
fi



if [ ${cron_attr_i} -gt 0 ];then
   chattr +i ${cron_file}
fi

if [ ${cron_attr_a} -gt 0 ];then
   chattr +a  ${cron_file}
fi

### config alias in .bash_profile
home=${HOME}
if [ -f ${home}/.bash_profile ];then
   ck_ifexist=` grep 'alias ck=' ${home}/.bash_profile|wc -l `
   if [ "${ck_ifexist}" -eq 0 ];then
      echo "alias ck='sh ${dir}/check/ck.sh;sh ${dir}/safe/ck.sh'" >> ${home}/.bash_profile
      . ${home}/.bash_profile > /dev/null
   fi
fi

if [ -f ${home}/.bash_profile ];then
   ck_ifexist=` grep 'alias ckreal=' ${home}/.bash_profile|wc -l `
   if [ "${ck_ifexist}" -eq 0 ];then
      echo "alias ckreal='sh ${dir}/check/ck.sh'" >> ${home}/.bash_profile
      . ${home}/.bash_profile > /dev/null
   fi
fi


echo
echo -e "\033[31mPlease check ${dir}/config.cnf config file!\033[m"
echo -e "\033[31m ${dir}/config.cnf\033[m"
echo -e "\033[31m ${dir}/conf/bak_tab.list\033[m"
echo -e "\033[31m ${dir}/conf/del_log.list\033[m"
echo -e "\033[31m ${dir}/conf/.pw\033[m"
echo
echo -e "\033[31mExecute command: source ${home}/.bash_profile\033[m"
echo
