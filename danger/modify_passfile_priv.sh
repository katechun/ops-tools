#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

chmod 600 /etc/passwd
chmod 400 /etc/shadow
chmod 600 /etc/group

chattr +i +a /etc/shadow
chattr +i +a /etc/passwd
chattr +i +a /etc/group
