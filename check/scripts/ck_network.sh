#! /bin/bash
# author: xiaochun
# Check Netwwork used
#set -x
# name receiv_in(bytes) receiv_pages receiv_err send_out(bytes) send_pages send_err

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

dt=` date "+%Y-%m-%d:%H:%M:%S" `
file_dt=${dt:0:10}

# Get script file name
file_name=` echo ${0} | awk -F'/' '{ print $NF }' `

network_speed=` grep network_speed ${dir}/../../config.cnf |awk -F'=' '{ print $2 }' `

net_file=/proc/net/dev

net_names=` /usr/sbin/ifconfig | grep -E -o "^[a-z0-9]+" | grep -v "lo" | uniq `
net_u=
flag=0

for i in ${net_names}; do
    nn1=` cat ${net_file} |grep ${i} |awk '{ print $2,$3,$4,$10,$11,$12 }' `
    receiv_in1=` echo ${nn1} |awk '{ print $1 }' `
    receiv_pages1=` echo ${nn1} |awk '{ print $2 }' `
    receiv_err1=` echo ${nn1} |awk '{ print $3 }' `
    send_out1=` echo ${nn1} |awk '{ print $4 }' `
    send_pages1=` echo ${nn1} |awk '{ print $5 }' `
    send_err1=` echo ${nn1} |awk '{ print $6 }' `

    sleep 1
    nn2=` cat ${net_file} |grep ${i} |awk '{ print $2,$3,$4,$10,$11,$12 }' `
    receiv_in2=` echo ${nn2} |awk '{ print $1 }' `
    receiv_pages2=` echo ${nn2} |awk '{ print $2 }' `
    receiv_err2=` echo ${nn2} |awk '{ print $3 }' `
    send_out2=` echo ${nn2} |awk '{ print $4 }' `
    send_pages2=` echo ${nn2} |awk '{ print $5 }' `
    send_err2=` echo ${nn2} |awk '{ print $6 }' `

    receiv_in=` echo "${receiv_in2} - ${receiv_in1}"|bc `
    receiv_pages=` echo "${receiv_pages2} - ${receiv_pages1}"|bc `
    receiv_err=` echo "${receiv_err2} - ${receiv_err1}"|bc `
    send_out=` echo "${send_out2} - ${send_out1}"|bc `
    send_pages=` echo "${send_pages2} - ${send_pages1}"|bc `
    send_err=` echo "${send_err2} - ${send_err1}"|bc `
    net_u="${receiv_in} \t  ${receiv_pages} \t   ${receiv_err} \t   ${send_out} \t\t   ${send_pages} \t   ${send_err}"
    if [ "${receiv_in}" -gt "${network_speed}" -o "${send_out}" -gt "${network_speed}" ]; then
       if [ ${flag} == 0 ]; then
          echo "name r_in(bytes) r_pages r_err s_out(bytes) s_pages s_err"
          echo -e ${i}"\t"${net_u}
       else
          echo -e ${i}"\t"${net_u}
       fi
    fi
    flag=1
done
