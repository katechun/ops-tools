#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

umask1=`cat /etc/profile | grep umask | grep -v ^# | awk '{print $2}'`
umask2=`cat /etc/csh.cshrc | grep umask | grep -v ^# | awk '{print $2}'`
umask3=`cat /etc/bashrc | grep umask | grep -v ^# | awk 'NR!=1{print $2}'`
flags=0
for i in ${umask1}
do
  if [ ${i} != "027" ];then
    echo "/etc/profile umask setting unsafe! Modify 027"
    break
  fi
done

for i in ${umask2}
do
  if [ ${i} != "027" ];then
    echo "/etc/csh.cshrc umask setting unsafe! Modify 027"
    break
  fi
done

for i in ${umask3}
do
  if [ $i != "027" ];then
    echo "/etc/bashrc umask setting unsafe! Modify 027"
    break
  fi
done

