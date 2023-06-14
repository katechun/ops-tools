#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

fileNetrc=`find / -xdev -mount -name .netrc > /dev/null`
if [ ! -z "${fileNetrc}" ];then
  echo "File .netrc exist,Please delete file!"
fi
fileRhosts=`find / -xdev -mount -name .rhosts > /dev/null`
if [ ! -z "$fileRhosts" ];then
  echo "File .rhosts exist,Please delete file!"
fi

