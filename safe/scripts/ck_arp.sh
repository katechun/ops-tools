#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
#source ~/.bash_profile

arp -a -n | awk '{++S[$4]} END {for(a in S) {if($2>1) print $2,a,S[a]}}'
