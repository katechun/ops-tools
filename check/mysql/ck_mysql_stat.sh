#! /bin/bash
# author: xiaochun
#set -x

source /etc/profile
source ~/.bash_profile

# Get script file path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


host=` grep host ${dir}/../../conf/.pw|awk -F'=' '{ print $2 }' `
user=` grep username ${dir}/../../conf/.pw|awk -F'=' '{ print $2 }' `
passwd=` grep passwd ${dir}/../../conf/.pw|awk -F'=' '{ print $2 }' `
port=` grep port ${dir}/../../conf/.pw|awk -F'=' '{ print $2 }' `

statinfo=` mysqladmin -P${port} -u${user} -p${passwd} -h${host} ext 2>/dev/null`
varinfo=` mysqladmin -P${port} -u${user} -p${passwd} -h${host} var 2>/dev/null`

up_time=` echo "${statinfo}"|grep -w Uptime |awk -F'|' '{ print $3 }'|sed 's/ //g' `

function get_stat_value(){
  key=$1
  value=` echo "${statinfo}"|grep -w ${key}|awk -F'|' '{ print $3 }'|sed 's/ //g' `
  echo "${value}"
}


function get_var_value(){
  key=$1
  value=` echo "${varinfo}"|grep -w ${key}|awk -F'|' '{ print $3 }'|sed 's/ //g' `
  echo "${value}"
}


function uptime_stat_bc(){
   key=$1
   value=` get_stat_value ${key} `
   echo "scale=1; ${value} / ${up_time}"|bc
}


function uptime_var_bc(){
   key=$1
   value=` get_var_value ${key} `
   echo "scale=1; ${value} / ${up_time}"|bc
}


# 每秒打开文件数  Opened_tables/Uptime  = xx/s
function open_files(){
   open_file_sec=` uptime_stat_bc Opened_tables  `
   echo "${open_file_sec}"
}

# 每秒打开表数  Opened_table_definitions/Uptime  = xx/s
function open_tabs(){
   open_tab_sec=` uptime_stat_bc Opened_table_definitions `
   echo ${open_tab_sec}
}

# 平均每秒请求读指定行数据的次数  Handler_read_rnd/Uptime  = xx/s
function req_sec(){
   read_rnd_sec=` uptime_stat_bc Handler_read_rnd `
   echo ${read_rnd_sec}
}

# 平均每秒join没有使用索引的次数  Select_full_join /Uptime = xx/s
function full_join(){
   full_join_sec=` uptime_stat_bc Select_full_join `
   echo ${full_join_sec}
}

# join没有使用索引的百分比 ( Select_full_join / Com_select ) * 100 = xx%
function join_used(){
   full_join=` get_stat_value Select_full_join `
   select=` get_stat_value Com_select `
   join_used_rat=` echo "scale=1; (${full_join} / ${select}) * 100"|bc `
   echo "${join_used_rat}"
}

#平均每秒的连接次数  Connections /uptime = xx/
function conns_sec(){
  conn_sec=` uptime_stat_bc Connections `
  echo "${conn_sec}"
}

# 线程创建连接的百分比  ( Threads_created / Connections ) *100 = xx%
function conn_thread_rat(){
   thread_created=` get_stat_value Threads_created `
   conns=` get_stat_value Connections `
   conn_rat=` echo "scale=1; (${thread_created} / ${conns}) * 100"|bc `
   echo "${conn_rat}"
}

# 线程使用率( Max_used_connections / max_connections ) *100 = xx%
function thread_used(){
   used_conns=` get_stat_value Max_used_connections `
   max_conns=` get_var_value max_connections `
   echo "used_conns:${used_conns}  max_conns:${max_conns}"
   thread_used_rat=` echo "scale=1; ${used_conns} / ${max_conns} * 100"|bc `
   echo ${thread_used_rat}
}

# 连接缓存命中率   (Connections - Threads_created)  /Connections * 100%
function conn_hit(){
   conns=` get_stat_value Connections `
   threads_created=` get_stat_value Threads_created `
   conn_hit_rat=` echo "scale=1; (${conns} - ${threads_created}) / ${conns} * 100"|bc `
   echo "${conn_hit_rat}"
}

# 计算读写比  Com_select / (Com_select+Com_insert+Com_update+Com_delete)* 100
function read_write_rat(){
   select=` get_stat_value Com_select `
   insert=` get_stat_value Com_insert `
   update=` get_stat_value Com_update `
   delete=` get_stat_value Com_delete `
   rw_rat=` echo "scale=1; ${select} / (${select} + ${insert} + ${update} + ${delete}) * 100"|bc `
   echo "${rw_rat}"
}

# 计算 innodb 缓存命中率： select concat((Innodb_buffer_pool_read_requests - Innodb_buffer_pool_read) / Innodb_buffer_pool_read_requests * 100,’%’);
function buff_hit(){
   buf_read_reqs=` get_stat_value Innodb_buffer_pool_read_requests `
   buf_read=` get_stat_value Innodb_buffer_pool_reads `
   buf_hit_rat=` echo "scale=1; (${buf_read_reqs} - ${buf_read}) / ${buf_read_reqs} * 100"|bc `
   echo "${buf_hit_rat}"
}


