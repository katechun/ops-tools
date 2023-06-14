#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ -f /etc/inetd.d/telnet ];then
   telnetd=`cat /etc/inetd.d/telnet | grep disable | awk '{print $3}'`
   if [ "${telnetd}"x = "yes"x ]; then
      echo "telnet service enabled,Please close!"
   fi
fi
