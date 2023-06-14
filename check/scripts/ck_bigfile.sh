#! /bin/bash
# author: xiaochun

source /etc/profile
source ~/.bash_profile

WHICH=/usr/bin/which

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

WHICH=/usr/bin/which

FIND=` ${WHICH} find `

DU=` ${WHICH} du `

SIZE=` grep file_size ${dir}/../../config.cnf |awk -F'=' '{ print $2 }' `

#bigfiles=` ${FIND} / -type f -size +${SIZE} ! -path '/proc/*' |xargs file | awk  '{ 
#    if($1 !~ /\.svn/){
#        len = length($1);
#        ans = substr($0, len+1);
#        if(ans ~/text/){
#            print substr($1, 0, length($1)-1);
#        }
#    }
#}' `

lfiles=` ${FIND} / -size +${SIZE}  ! -path '/proc/*' 2>/dev/null|grep -v ":"| xargs `
if [ "${lfiles}" != "" ];then
   biglogs=` file ${lfiles} |grep -i text|awk -F':' '{ print $1 }' `
fi


if [ "${bigfiles}" != "" ];then
   echo -e "Size(M)\t filename"
   for i in ${bigfiles}; do
      ${DU} -m ${i}
   done
fi

