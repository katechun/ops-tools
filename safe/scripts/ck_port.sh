#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
#source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ftp 21
# sshd 22
# telnet 23
# smtp 25
# dns 53
# tftp 69
# pop3 110
# sftp 115
# mysql 3306
# oracle 1521
# tomcat 8080
# redis 6379
# mongodb 27017


function get_port() {
   service=$1
   port=$2
   ifexistport=` netstat -lnp |grep ${service} |grep -w LISTEN|head -n 1|awk '{ print $4 }'|awk -F':' '{ print $NF }' `
   if [ "${ifexistport}" == "${port}" ];then
      echo "${service} used default port:${port},Please modify!" 
   fi
}

function main(){
  get_port ftp 21
  get_port sshd 22
  get_port telnet 23
  get_port smtp 25
  get_port dns 53
  get_port tftp 69
  get_port pop3 110
  get_port sftp 115
  get_port mysql 3306
  get_port oracle 1521
  get_port tomcat 8080
  get_port redis 6379
  get_port mongodb 27017
}

main
