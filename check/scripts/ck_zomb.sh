#!  /bin/bash
# author: xiaochun

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ps -ef | grep zombie|grep -v grep
