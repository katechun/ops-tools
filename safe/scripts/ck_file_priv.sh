#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

file1=`ls -l /etc/passwd | awk '{print $1}'`
file2=`ls -l /etc/shadow | awk '{print $1}'`
file3=`ls -l /etc/group | awk '{print $1}'`
file4=`ls -l /etc/securetty | awk '{print $1}'`
file5=`ls -l /etc/services | awk '{print $1}'`
if [ -f /etc/xinetd.conf ];then
   file6=`ls -l /etc/xinetd.conf | awk '{print $1}'`
fi
if [ -f /etc/grub.conf ];then
   file7=`ls -l /etc/grub.conf | awk '{print $1}'`
fi
if [ -f /etc/lilo.conf ];then
   file8=`ls -l /etc/lilo.conf | awk '{print $1}'`
fi
#检测文件权限为400的文件
if [ "${file2}" != "-r--------" ];then
  echo "/etc/shadow file unsafe, set -r-------- 400"
fi
#检测文件权限为600的文件
if [ "${file4}" != "-rw-------" ];then
  echo "/etc/security file unsafe, set -rw------- 600"
fi
if [ "${file6}" != "-rw-------" ];then
  echo "/etc/xinetd.conf file unsafe, set -rw------- 600"
fi
if [ "${file7}" != "-rw-------" ];then
  echo "/etc/grub.conf file unsafe, set -rw------- 600"
fi
if [ -f /etc/lilo.conf ];then
  if [ "${file8}" != "-rw-------" ];then
    echo "/etc/lilo.conf file unsafe, set -rw------- 600"
  fi
fi

#检测文件权限为644的文件
if [ "${file1}" != "-rw-------" ];then
  echo "/etc/passwd file unsafe, -rw------- 600"
fi
if [ "${file5}" != "-rw-r--r--" ];then
  echo "/etc/services file unsafe, -rw-r--r-- 644"
fi
if [ "${file3}" != "-rw-------" ];then
  echo "/etc/group file unsafe, -rw-r--r-- 600"
fi

