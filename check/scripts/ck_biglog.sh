#! /bin/bash
# author: xiaochun

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

WHICH=/usr/bin/which

FIND=` ${WHICH} find `

DU=` ${WHICH} du `

SIZE=` grep log_size ${dir}/../../config.cnf |awk -F'=' '{ print $2 }' `

lfiles=` ${FIND} / -size +${SIZE}  ! -path '/proc/*' -name *.log 2>/dev/null|grep -v ":"| xargs `
if [ "${lfiles}" != "" ];then
   biglogs=` file ${lfiles} |grep -i text|awk -F':' '{ print $1 }' `
fi


if [ "${biglogs}" != "" ];then
   echo -e "Size(M)\t filename"
   for i in ${biglogs}; do
      ${DU} -m ${i}
   done
fi

