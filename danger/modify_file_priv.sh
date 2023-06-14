#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -f /etc/shadow ];then
   chmod 400 /etc/shadow
fi

if [ -f /etc/securetty ];then
   chmod 600 /etc/securetty
fi

if [ -f /etc/xinetd.conf ];then
   chmod 600 /etc/xinetd.conf
fi

if [ -f /etc/grub.conf ];then
   chmod 600 /etc/grub.conf
fi

if [ -f /etc/lilo.conf ];then
   chmod 600 /etc/lilo.conf
fi

if [ -f /etc/passwd ];then
   chmod 600 /etc/passwd
fi

if [ -f /etc/group ];then
   chmod 600 /etc/group
fi

if [ -f /etc/services ];then
   chmod 644 /etc/services
fi
