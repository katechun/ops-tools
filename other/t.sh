#!/bin/bash
ipaddress=`ip a|grep "global"|awk '{print $2}' |awk -F/ '{print $1}'`
file_output=os_check_summary_$ipaddress.html
td_str=''
th_str=''
os_log=/var/log/messages
os_run_time=`uptime | awk '{print $3}'`
os_name=`hostname`
os_time=`date "+%Z %Y-%m-%d %Hh%Mm%Ss"`
os_edition=`cat /etc/redhat-release`
os_memmory=`grep MemTotal /proc/meminfo | awk '{printf "%0.2f",$2/1024/1024}'`
os_product_name=`dmidecode | grep 'Product Name' | head -1  |sed 's/:/\n/g'  | sed -n '2p'`
os_physical_cpu=`cat /proc/cpuinfo |grep "physical id"|sort |uniq|wc -l`
os_logical_cpu=`cat /proc/cpuinfo |grep "processor"|wc -l`
create_html_css(){
  echo -e "<html>
<head>
<style type="text/css">
    body        {font:12px Courier New,Helvetica,sansserif; color:black; background:White;}
    table,tr,td {font:12px Courier New,Helvetica,sansserif; color:Black; background:#FFFFCC; padding:0px 0px 0px 0px; margin:0px 0px 0px 0px;} 
    th          {font:bold 12px Courier New,Helvetica,sansserif; color:White; background:#0033FF; padding:0px 0px 0px 0px;} 
    h1          {font:bold 12pt Courier New,Helvetica,sansserif; color:Black; padding:0px 0px 0px 0px;} 
</style>
</head>
<body>"
}
create_html_head(){
echo -e "<h1>$1</h1>"
}
create_table_head1(){
  echo -e "<table width="68%" border="1" bordercolor="#000000" cellspacing="0px" style="border-collapse:collapse">"
}
create_table_head2(){
  echo -e "<table width="100%" border="1" bordercolor="#000000" cellspacing="0px" style="border-collapse:collapse">"
}
create_td(){
    td_str=`echo $1 | awk 'BEGIN{FS="|"}''{i=1; while(i<=NF) {print "<td>"$i"</td>";i++}}'`
}
create_th(){
    th_str=`echo $1|awk 'BEGIN{FS="|"}''{i=1; while(i<=NF) {print "<th>"$i"</th>";i++}}'`
}
create_tr1(){
  create_td "$1"
  echo -e "<tr>
    $td_str
  </tr>" >> $file_output
}
create_tr2(){
  create_th "$1"
  echo -e "<tr>
    $th_str
  </tr>" >> $file_output
}
create_tr3(){
  echo -e "<tr><td>
  <pre style=\"font-family:Courier New; word-wrap: break-word; white-space: pre-wrap; white-space: -moz-pre-wrap\" >
  `cat $1`
  </pre></td></tr>" >> $file_output
}
create_table_end(){
  echo -e "</table>"
}
create_html_end(){
  echo -e "</body></html>"
}
NAME_VAL_LEN=12
name_val () {
   printf "%+*s | %s\n" "${NAME_VAL_LEN}" "$1" "$2"
}
os_baseinfo(){
   echo "检查时间  | 主机名 | 运行天数 | IP地址   | 版本信息  | 内存(GB) | CPU个数 | 逻辑cpu数 | 服务器型号" >>/tmp/tmpbaseinfo_h1_`date +%y%m%d`.txt
   echo -e "$os_time | $os_name | $os_run_time | $ipaddress |$os_edition | $os_memmory | $os_physical_cpu | $os_logical_cpu | $os_product_name"  >>/tmp/tmpbaseinfo_t1_`date +%y%m%d`.txt
}
os_df_info(){
echo "磁盘路径  |  大小(GB)    |使用大小(GB)   |  可用大小(GB)   |  使用率(100%)  | 挂载点 " >>/tmp/tmpdf_h1_`date +%y%m%d`.txt
df -hP | sed '1d' | awk '{print $1,"|",$2,"|",$3,"|",$4,"|",$5,"|",$6}' >> /tmp/tmpdf_t1_`date +%y%m%d`.txt
}
os_dfi_info(){
echo "磁盘路径  |  Inode大小(GB)    |Inode使用(GB)   |  Inode可用(GB)   |  Inode使用率(100%)  | Inode挂载点 " >>/tmp/tmpdfi_h1_`date +%y%m%d`.txt
df -hiP | sed '1d' | awk '{print $1,"|",$2,"|",$3,"|",$4,"|",$5,"|",$6}' >> /tmp/tmpdfi_t1_`date +%y%m%d`.txt
}
os_netinfo(){
   echo "IP Info " >>/tmp/tmpnet_h1_`date +%y%m%d`.txt
   ifconfig -a  >>/tmp/tmpnet_t1_`date +%y%m%d`.txt
}
os_log_error(){
 echo "OS Log" >>/tmp/tmplog_h1_`date +%y%m%d`.txt
tail -400 $os_log >> /tmp/tmplog_t1_`date +%y%m%d`.txt
}
create_html(){
  rm -rf $file_output
  touch $file_output
  create_html_css >> $file_output
  echo "<center><font size=+3 color=darkgreen><b>Linux Inspection report</b></font></center><hr>" >> $file_output
  create_html_head "基础信息" >> $file_output
  create_table_head1 >> $file_output
  os_baseinfo
  while read line
  do
  create_tr2 "$line" 
  done < /tmp/tmpbaseinfo_h1_`date +%y%m%d`.txt
  while read line
  do
  create_tr1 "$line" 
  done < /tmp/tmpbaseinfo_t1_`date +%y%m%d`.txt
  create_table_end >> $file_output
  create_html_head "磁盘空间使用信息" >> $file_output
  create_table_head1 >> $file_output
  os_df_info
  while read line
  do
  create_tr2 "$line" 
  done < /tmp/tmpdf_h1_`date +%y%m%d`.txt
  while read line
  do
  create_tr1 "$line" 
  done < /tmp/tmpdf_t1_`date +%y%m%d`.txt
  create_table_end >> $file_output
 create_html_head "Inode空间使用信息" >> $file_output
  create_table_head1 >> $file_output
  os_dfi_info
  while read line
  do
  create_tr2 "$line" 
  done < /tmp/tmpdfi_h1_`date +%y%m%d`.txt
  while read line
  do
  create_tr1 "$line" 
  done < /tmp/tmpdfi_t1_`date +%y%m%d`.txt
  create_table_end >> $file_output
  create_html_head "网络信息" >> $file_output
  create_table_head1 >> $file_output
  os_netinfo
  while read line
  do
  create_tr2 "$line" 
  done < /tmp/tmpnet_h1_`date +%y%m%d`.txt
  while read line
  do
  create_tr1 "$line" 
  done < /tmp/tmpnet_t1_`date +%y%m%d`.txt
  create_table_end >> $file_output
  create_html_head "系统日志" >> $file_output
  create_table_head1 >> $file_output
  os_log_error
  while read line
   do
  create_tr2 "$line" 
  done < /tmp/tmplog_h1_`date +%y%m%d`.txt
  while read line
   do
  create_tr1 "$line" 
  done < /tmp/tmplog_t1_`date +%y%m%d`.txt
  create_table_end >> $file_output 
  create_html_end >> $file_output
  sed -i 's/BORDER=1/width="68%" border="1" bordercolor="#000000" cellspacing="0px" style="border-collapse:collapse"/g' $file_output
  rm -rf /tmp/tmp*_`date +%y%m%d`.txt
}
# This script must be executed as root
RUID=`id|awk -F\( '{print $1}'|awk -F\= '{print $2}'`
if [ ${RUID} != "0" ];then
    echo"This script must be executed as root"
    exit 1
fi
PLATFORM=`uname`
if [ ${PLATFORM} = "HP-UX" ] ; then
    echo "This script does not support HP-UX platform for the time being"
exit 1
elif [ ${PLATFORM} = "SunOS" ] ; then
    echo "This script does not support SunOS platform for the time being"
exit 1
elif [ ${PLATFORM} = "AIX" ] ; then
    echo "This script does not support AIX platform for the time being"
exit 1
elif [ ${PLATFORM} = "Linux" ] ; then
echo -e "
###########################################################################################
#Only support Linux and default directory is current run directory
#root user commond: sh os_check.sh
#The document output is in HTML format
###########################################################################################
"
  create_html
fi
