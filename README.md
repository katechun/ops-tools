*************************************************************************************
*  Author        : XiaoChun 
*  Email         : 875381900@qq.com 
*  Last modified : 2021-12-09 16:34 
*  Description   : The is AutoOps Tool Kit for Ops
**************************************************************************************

注：此工具目前只在centos7上进行测试验证！在使用中出了问题，请与我联系(把问题发我邮箱)，我进行改进！

# 安装方法:  
tar -zxvf tool.tar.gz  
cd tool  
./install.sh  

# 使用说明：
1.安装完成后会自动在crontab里添加执行计划，会定期执行检查或删除操作，会在report目录下生成报告，在logs目录下生成日志。  
2.安装完成后要检查config.cnf配置文件和conf目录下的配置文件,修改成自己需要的配置，如果不懂的可以使用默认的配置。  
3.尽量使用root用户执行，本工具需要的权限比较大。  
4.会在当前用户的.bash_profile生成ck别名，在命令行执行ck命令，会进行系统的检查。  
5.工具集里的每个脚本都可以手动执行。
6.如有没有涉及到的功能，可以在相应目录下编写自己的脚本。  


配置文件修改(必须修改内容，其配置项可以使用默认)：  

全局配置文件config.cnf需要修改的内容：  
backup_dir=/root/backup   配置mysql配置表备份的文件存放的目录  
to_user=875381900@qq.com  配置告警接收的邮箱地址  
email_title="[某某项目]告警邮件"    配置接收邮件标题，如果是局域网，接收不了邮件，可以把crontab定时任务里的邮件发送任务去掉。  

局部配置文件需要修改内容：  
conf/.pw  存放数据库用户名密码，备份需要使用  
chattr –I –a conf/.pw  
chmod 755 conf/.pw  
vi conf/.pw  
conf/port.list 配置要监控的端口程序  
conf/bak_tab.list   配置要备份的表，目前需要在执行install.sh之前进行配置才能生效  
conf/del_log.list   配置日志删除功能，如果文件系统空间满了，需要删除哪些日志，首次install.sh,会find / -name “*.log”找出所有的结尾带.log的文件写道此文件里，检查有不想删除的文件，可以从列表里删除。  

# 定时任务说明:
#生成检查报告  
15 */6 * * * sh /root/autoops/tool/check/check.sh >> /root/autoops/tool/logs/ck.sh.log  2>&1  
#生成安全报告  
15 */6 * * * sh /root/autoops/tool/safe/check.sh >> /root/autoops/tool/logs/safe.sh.log  2>&1  
#文件系统使用率达到阈值 删除没有使用的del_log.list里配置的日志
11 * * * * sh /root/autoops/tool/del/del_log1.sh >> /root/autoops/tool/logs/del_log1.sh.log 2>&1  
#文件系统使用率达到阈值  情况正在使用的del_log.list里配置的日志
29 * * * * sh /root/autoops/tool/del/del_log2.sh >> /root/autoops/tool/logs/del_log2.sh.log 2>&1  
#如果数据库所在文件系统使用率超过阈值 truncate数据库里的日表（不包括当天的日表）
55 * * * * sh /root/autoops/tool/del/del_bigtab.sh >> /root/autoops/tool/logs/del_bigtab.sh.log 2>&1  
#达到阈值删除备份配置表的老的备份文件
8 23 * * * sh /root/autoops/tool/del/del_bak.sh >> /root/autoops/tool/logs/del_bak.sh.log 2>&1  
#删除自动化运维工具集自己的日志
39 23 * * * sh /root/autoops/tool/del/del_selflogs.sh >> /root/autoops/tool/logs/del_selflogs.sh.log 2>&1  
#发现有疑似暴力破解ip 加入黑名单
*/20 * * * * sh /root/autoops/tool/safe/secure_ssh.sh >> /root/autoops/tool/logs/secure_ssh.sh.log 2>&1  
#备份数据库里的配置表
5 18 * * * sh /root/autoops/tool/backup/bak_config_table.sh >> /root/autoops/tool/logs/bak_config_table.sh.log 2>&1  
#整体检查发邮件告警  不通外网需要删除
15 10 * * 1 sh /root/autoops/tool/mail/send_mail.sh >> /root/autoops/tool/logs/send_mail.sh.log 2>&1  
#实时检查发邮件告警  不通外网需要删除
*/15 * * * * sh /root/autoops/tool/mail/send_mail_real.sh >> /root/autoops/tool/logs/send_mail_real.sh.log 2>&1  



# 目录结构:  
tool
├── backup                     #备份脚本目录  
│   └── bak_config_table.sh    #备份配置文件脚本  
├── check                      #检查脚本目录  
│   ├── check.sh               #调用ck.sh  会输出报告  
│   ├── ck.sh                  #检查脚本汇总脚本  
│   └── scripts                #检查脚本目录  
│       ├── ck_alive.sh        #检查端口是否存在，要在tool/conf/port.list配置要检查的端口  
│       ├── ck_bigfile.sh      #检查大文件 config.cnf:file_size参数配置阈值大小 bytes  
│       ├── ck_biglog.sh       #检查大日志文 config.cnf:log_size参数配置阈值大小 byes  
│       ├── ck_chmod.sh        #检查文件权限是777的文件  
│       ├── ck_cpu.sh          #检查cpu使用率 config.cnf:cpu_rat参数配置阈值大小 %  
│       ├── ck_disk.sh         #检查文件系统使用率 config.cnf:disk_rat参数配置阈值大小 %  
│       ├── ck_inode.sh        #检查文件系统i节点使用 config.cnf:inode_rat参数配置阈值大小 %  
│       ├── ck_load.sh         #检查cpu负载(1m 5m 15m)使用率 config.cnf:cpu_load_xm参数配置阈值大小 %  
│       ├── ck_mem.sh          #检查内存使用率 config.cnf:mem_rat参数配置阈值大小 %  
│       ├── ck_network.sh      #检查网卡读写速度 config.cnf:network_speed参数配置阈值大小 bytes  
│       ├── ck_proc.sh         #检查进程资源使用情况 config.cnf:proc_cpu_used,proc_mem_used参数配置阈值大小 bytes  
│       └── ck_zomb.sh         #检查是否存在僵尸进程  
├── conf                       #配置文件目录  
│   ├── bak_tab.list           #备份数据配置表列表  
│   ├── del_log.list           #磁盘空间不足时，会找此文件下配置的日志文件列表，进行删除，安装时会find / -name *.log找出所有带.log后缀的文件写道此配置文件里，如有不行删除的文件，要自己从此配置文件里删除。  
│   └── port.list              #检查端口存活性，把要监控的端口写里面，会定期检查存活性  
├── config.cnf                 #总体的配置参数文件，大部分参数都在此文件里配置  
├── del                        #一些删除操作脚本的目录  
│   ├── base_del_file.sh       #删除文件的基础脚本会被其他脚本调用，传递参数进行指定删除  
│   ├── del_bak.sh             #删除备份数据库配置表脚本 config.cnf:backup_dir,backupdir_size,table_name  
│   ├── del_bigtab.sh          #如果文件系统超过阈值，删除数据库里的大表 config.cnf:del_daily_tab  
│   ├── del_log1.sh            #如果文件系统超过阈值，删除没有在使用的日志文件 config.cnf:del_nobusy_log  
│   ├── del_log2.sh            #如果文件系统超过阈值，清空正在使用的日志文件  config.cnf:del_busy_log  
│   ├── del_selflogs.sh        #如果tool工具集产生的日志达到多少，会进行删除  config.cnf:logs_dir_size,report_dir_size  
│   └── findlog.sh             #查询大日志文件 config.cnf:file_size  
├── example                    #配置文件例子 初次安装会使用这里面的配置文件  
│   ├── bak_tab.list  
│   ├── config.cnf  
│   └── install.sh  
├── install.sh                   #安装脚本  
├── logs                         #日志文件目录  
│   ├── bak_config_table.sh.log     
│   ├── ck.sh.log  
│   ├── del_bak.sh.log  
│   ├── del_bigtab.sh.log  
│   ├── del_log1.sh.log  
│   ├── del_log2.sh.log  
│   ├── del_selflogs.sh.log  
│   ├── safe.sh.log  
│   └── secure_ssh.sh.log  
├── other                         #杂的脚本  
├── README.md                     #说明文件  
├── report  
│   ├── ck_report.20211213181501  #tool/check/check.sh这个脚本生成的报告  
│   ├── ck_report.20211214001501  
│   ├── ck_report.20211214061501  
│   ├── ck_report.20211214121501  
│   ├── safe_report.20211213181501  #tool/safe/check.sh这个脚本生成的报告  
│   ├── safe_report.20211214001501  
│   ├── safe_report.20211214061501  
│   └── safe_report.20211214121501  
├── safe                            #安全检查脚本目录  
│    ├── check.sh                    #调用ck.sh,会生成报告，在report目录下  
│    ├── ck.sh                       #汇总脚本  
│    ├── scripts                     #脚本目录  
│    │   ├── ck_arp.sh               #检查是否存在arp攻击  
│    │   ├── ck_cron.sh              #检查crontab里是不是有些常出现攻击的命名  
│    │   ├── ck_file_priv.sh         #检查一些重要文件的权限是不是太大  
│    │   ├── ck_login.sh             #检查登录服务器的用户是不是在暴力破解密码  
│    │   ├── ck_newuser.sh           #检查是不是有新用户创建  
│    │   ├── ck_nginx_err.sh         #检查nginx日志收集400 499 攻击行为进行按ip统计次数  
│    │   ├── ck_nullpasswd.sh        #检查是不是有空密码用户  
│    │   ├── ck_passfile.sh          #检查是否有不安全的密码文件  
│    │   ├── ck_passwd.sh            #查密码设置是否安全   
│    │   ├── ck_port.sh              #检查服务器是否在使用默认的服务端口  
│    │   ├── ck_rootssh.sh           #检查是否开启了root ssh远程登陆  
│    │   ├── ck_soft.sh              #检查安装的软件有没有恶意程序  
│    │   ├── ck_telnet.sh            #检查telnet服务是否开启  
│    │   ├── ck_umask.sh             #检查umask参数是否设置的权限过大  
│    │   └── ck_yum.sh               #检查yum的日志是否有安装过恶意程序  
│    └── secure_ssh.sh               #发现暴力破解密码的ip，加入黑名单  
└── mail                             #发送邮件目录  
     ├── sendmail                    #发送邮件程序，二进制  ./sendmail send -a address -t title  -i content  
     ├── send_mail.sh                #会执行./check/ck.sh和./safe/ck.sh把内容邮件发送出去，进行告警  
     └── send_mail_real.sh           #会执行./check/ck.sh,准实时监控并发送告警邮件  
