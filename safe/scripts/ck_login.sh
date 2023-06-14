#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

more /var/log/secure|awk '/Failed/{print $(NF-3)}'|sort|uniq -c|awk '{print $2"="$1;}'|grep -v session > /tmp/black.list
for i in `cat  /tmp/black.list|grep -v session`
do
  IP=`echo $i |awk -F= '{print $1}'`
  NUM=`echo $i|awk -F= '{print $2}'`
  if [ ${#NUM} -gt 1 ]; then
     echo "${NUM} ${IP}"
  fi
done

