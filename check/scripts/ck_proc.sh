#!  /bin/bash
# author: xiaochun

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


WHICH=/usr/bin/which
LSOF=/usr/sbin/lsof
TOP=` ${WHICH} top|head -n 1 `

proc_cpu_used1=` grep proc_cpu_used ${dir}/../../config.cnf |awk -F'=' '{ print $2 }' `
proc_mem_used1=` grep proc_mem_used ${dir}/../../config.cnf |awk -F'=' '{ print $2 }' `
top_proces=` grep top_proces ${dir}/../../config.cnf |awk -F'=' '{ print $2 }' `
proc_threads1=` grep proc_threads ${dir}/../../config.cnf |awk -F'=' '{ print $2 }' `
proc_open_file1=` grep proc_open_file ${dir}/../../config.cnf |awk -F'=' '{ print $2 }' `


top_proc=` ps -aux |grep -iv mysql| sort -k4nr | head -${top_proces} |awk '{ print $2 }' `
proc=
flag=0
for i in ${top_proc}; do
   proc_used=` ${TOP} -p ${i} -b -n 1|grep -w ${i} |awk '{ print $1,$NF,$(NF-3),$(NF-2) }' `
   proc_threads=` ${TOP} -b -H -n 1 -p ${i}|grep Threads|awk '{ print $2 }' `

   proc_pid=` echo ${proc_used}|awk '{ print $1 }' `
   proc_name=` echo ${proc_used}|awk '{ print $2 }' `
   proc_cpu_used=` echo ${proc_used}|awk '{ print $3 }'|awk -F'.' '{ print $1 }' `
   proc_mem_used=` echo ${proc_used}|awk '{ print $4 }'|awk -F'.' '{ print $1 }' `
   proc_open_files=` ${LSOF} -p ${i} |wc -l `

  if [ "${proc_mem_used}" -gt "${proc_mem_used1}" -o "${proc_cpu_used}" -gt "${proc_cpu_used1}" -o "${proc_threads}" -gt "${proc_threads1}" -o "${proc_open_files}" -gt "${proc_open_file1}"  ];then
      if [ ${flag} == 0 ];then
         echo -e "pid \t name \t cpu% \t mem% \t threads \t openfiles"
         proc="${proc_pid}\t ${proc_name}\t${proc_cpu_used}\t${proc_mem_used}%\t${proc_threads}\t \t${proc_open_files}"
         echo -e ${proc}
      else
         proc="${proc_pid}\t ${proc_name}\t${proc_cpu_used}%\t${proc_mem_used}%\t${proc_threads}\t \t${proc_open_files}"
         echo -e ${proc}

      fi
   fi
   flag=1
done

