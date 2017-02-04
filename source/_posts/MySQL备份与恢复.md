---
title: MySQL备份与恢复
date: 2016-11-15 19:17:06
tags: MySQL
categories: 数据库学习
description: <center>MySQL备份与恢复方法实践与总结</center>
---
## 声明
>本文整理自好友分享文档。

>原作者：王绍晖
个人简介：腾云天下实习DBA


## binlog的解读

- 查看binlog：
    - mysqlbinlog -vv mysqlserver.00000[1-9]  	#可以带正则表达式
```
# at 3871734  	当前位置
#160828 10:08:13 server id 2  end_log_pos 3871891  CRC32 0x796512ad
时间点                服务器id           结束位置    校验码
Query	thread_id=21	exec_time=0	error_code=0
        线程ID                           =0代表执行成功
```
```
[root@localhost data]# mysqlbinlog --help
 --start-position=#		开始位置
 --stop-position=# 		停止位置
```

## binlog自动切换的条件：
- 达到阀值
- 数据库重启会出现切换的情况
- binlog强行切换：

`mysql> flush logs;`		

> 查看在使用的哪个日志，可以ls -t看时间
 
## 关于日志的截取：
- binlog的恢复：
```
[root@localhost data]# mysqlbinlog  --start-position=100  --stop-position= 8000 mysqlserver.00001[2-9]	>a.a
[root@localhost data]# cat a.a | mysql
```

## 逻辑备份和物理备份
- 逻辑备份：将数据备份成一个文本文件（抽取数据行）
1. 数据库必须是打开的状态
2. 登陆数据库，将数据抽出来，导到一个文件里

- 逻辑备份：mysqldump
```
Usage: mysqldump [OPTIONS] database [tables]		某些表
OR   mysqldump [OPTIONS] --databases [OPTIONS] DB1 [DB2 DB3...]	  某些库
OR   mysqldump [OPTIONS] --all-databases [OPTIONS]	备份所有的库
```
```
options：	
-u 
-p
-F：flush log  		#恢复的时候直接从下一个日志开始就可以了
-l：lock tables  	#数据的一致性，在备份的期间，myisam表是不能用的
--single-transaction 		#影响innodb表的，不锁表和行
-fields-terminated-by=name 		#列和列之间的分隔符
                      Fields in the output file are terminated by the given  string.
--fields-enclosed-by=name 
                      Fields in the output file are enclosed by the given character.
--fields-optionally-enclosed-by=name 
                      Fields in the output file are optionally enclosed by the given character.
--fields-escaped-by=name 
                      Fields in the output file are escaped by the given

-T, --tab=name      Create tab-separated textfile for each table to given	#指定tab键为分隔符
```
```
[root@localhost tmp]# mysqldump -uroot -p -l -F  --single-transaction -T /tmp -S /usr/local/mysql/data/mysql.sock test t1 >t1.txt	#文件名必须与表的名字一致，否则没有内容；-T指定那个文件夹，这条命令就要到哪个文件夹下面执行
[root@localhost tmp]# cat t1.txt 
1	a
2	b
3	c
4	e
```

- 备份一张表：
`mysqldump -uroot -p -l -F --single-transaction -S /usr/local/mysql/data/mysql.sock test t1 >aa.sql`

- 恢复一张表：
`cat aa.sql | mysql -uroot -p123123 -S /usr/local/mysql/data/mysql.sock test`

### 关注的点：
> 备份出来的数据对应的binlog的日志起点
> 备份时候要把表给锁住，对myisam来说，备份期间锁住的表是不能用的；对innodb来说，不锁表，在备份期间结合MVCC和undo把开始备份时刻和备份完成时刻之间的数据恢复



## 物理备份---xtrabackup
xtrabackup既可以备份myisam表也可以备份innodb表
物理备份：可以认为是cp，备份的是数据文件页和里面的数据页
- 冷备：数据库关闭，把数据库相关的文件cp出来
- 热备：数据库开启，使用相关的工具将数据备份出来

> 不管物理或逻辑，必须知道你备份的点，能跟binlog连起来的，备份恢复的时候，binlog 的起点必须是你备份的那个点

1. 建立一个备份目录，注意：属主属组一定要是mysql
2. 备份数据库：将相关的数据文件拷贝出来

```
[root@localhost ~]# innobackupex --user=root --password=123123  --socket=/usr/local/mysql/data/mysql.sock --port 3307 --no-timestamp  /backup/		#不建立一个时间戳的目录
这个命令默认会去找rpm安装的mysql，最好把rpm安装的mysql配置文件名字改一下
成功的话在最后会有一个complete
```

- backup里面相关文件：
```
[root@localhost ~]# ll /backup/
total 77860
-rw-r-----. 1 root root      387 Sep  8 17:22 backup-my.cnf
-rw-r-----. 1 root root 79691776 Sep  8 17:21 ibdata1
drwx------. 2 root root     4096 Sep  8 17:22 mysql
drwx------. 2 root root     4096 Sep  8 17:22 performance_schema
drwx------. 2 root root     4096 Sep  8 17:22 test
drwx------. 2 root root     4096 Sep  8 17:22 tpcc1000
-rw-r-----. 1 root root       23 Sep  8 17:22 xtrabackup_binlog_info
-rw-r-----. 1 root root      119 Sep  8 17:22 xtrabackup_checkpoints
-rw-r-----. 1 root root      538 Sep  8 17:22 xtrabackup_info
-rw-r-----. 1 root root     2560 Sep  8 17:22 xtrabackup_logfile
```

> xtrabackup_logfile：在备份期间产生的redo log，从log file里面取出来，放到这个文件里。
```
xtrabackup_info：
start_time = 2016-09-08 17:21:16
end_time = 2016-09-08 17:22:37
lock_time = 0
binlog_pos = filename 'mysqlserver.000023', position '120'	#binlog位置，从哪里开始备
innodb_from_lsn = 0	#每一个数据页都有一个lsn号，这两行表示全备（方便增备）
innodb_to_lsn = 3171620346
xtrabackup_binlog_info：mysqlserver.000023	120
xtrabackup_checkpoints：backup_type = full-backuped	#代表全备	
```
- 模拟环境：删除一张表

    - apply-log
```
[root@localhost backup]# innobackupex --apply-log /backup/		#apply-log带着一个隐藏的rollback，如果不想roll back加上--redo-only
！！！一定要看到一个complete
[root@localhost backup]# cat xtrabackup_checkpoints
backup_type = full-prepared		#不仅是全备而且apply log了
```

- 关闭数据库，删除数据库（注意：一定不要删除binlog）
将binlog从里面移出来，注意不要放到backup下面，否则一会恢复的时候binlog页都给恢复了，这个是不需要的。


- 恢复数据库：就是把backup下面的文件再拷贝回去
```
[root@localhost backup]# innobackupex --defaults-file=/etc/mysla.cnf  --copy-back /backup/	#注意：最好指定配置文件，有的会报如下错误
```

- 文件拷贝完成记得一定要修改datadir下面文件的属主和属组，重启数据库

- 跑binlog：
起始位置以及哪个binlog：xtrabackup_info 	记录在这个文件里
终点位置需要我们自己去找：mysqlbinlog -vv mysqlserver.000023 | grep -i "drop" -C 100			
```
[root@localhost binlog]# cat a.sql | mysql -uroot -p -S /usr/local/mysql/data/mysql.sock 
Enter password: 
```
- 跑binlog的时候去监控：show processlist---是实时变化的



## mysql启动流程分析：
1. cat /etc/my.cnf   	文件是否存在，文件内容是否正确，主要看datadir
2. 看datadir的权限
3. 进入datadir，看里面的内容是否齐全：ibdata1，ib_logfile，mysql，performation_scheme,information_scheme
4. 确认一下errorlog，pid文件，sock文件，
5. mysql_safe --defaults-file=/etc/my.cnf  &
6. ps -ef | grep mysqld
7. tail -100f 	errorlog
8. 登陆mysql -uroot -p -h127.0.0.1 或者mysql -uroot -p -S /.../...sock


## 备份方案：
1. 备份期间会产生大量的IO，qps和tps都会大幅度的下降，从某种意义来说，在备份期间，数据库基本没法用
2. 将备份的文件传走(传到从库)：对IO和网络带宽产生负载
3. 恢复的时间：恢复的时候，binlog跑得特别慢，生产做业务的时候是并发执行的，恢复的时候只有一个线程在跑

- 需要考虑的点：	
1. 备份对生产的影响,备份和数据传输
2. 备份的恢复时间

### 对于恢复的时间的计算
> 恢复时间=备份拷贝回来的时间（IO和网络带宽）+跑binlog的时间（不太容易计算，需要实际测试）
### 注意
- binlog的恢复时间非常不可控，binlog中有的sql语句特别慢，甚至跑的时候跑不动

## 增量备份
主要是对innodb而言的，对于myisam和其他的表还是一个全拷贝。
每个数据页都会有一个lsn号，每产生一次变化，lsn都会发生改变。
- 增量备份
    - 备份的是发生变化的页（这些数据页指的是LSN大于xtrabackup_checkpoints中给定的LSN），增备是基于全备的，第一次的增备的数据必须基于上一次的全备。
- 增量备份的过程：
    - 缺点：要把所有的页都扫描一遍才能知道哪些页发生变化，所以备份的时候对库的压力并没有变小，只是备份出来的数据量有可能变少了
    - 好处：恢复的时候是可控的，可以把增量apply到全备里面；备份完成之后就可以apply到全备里面去，不是非要等到恢复的时候再apply。
- 模拟完全+增量+prepare
1. 完全备份,备份完记得apply log
2. 建立一个增备的文件并修改权限

```
[root@localhost backup]# mkdir /back_inr
[root@localhost backup]# chown -R mysql:mysql /back_inr/
```
- 第一次增量备份（增量备份还是希望有时间戳的）
```
[root@localhost ~]# innobackupex --user=root --password=123123 --socket=/usr/local/mysql/data/mysql.sock --incremental /back_inr/ --incremental-basedir=/backup/
```

- 第二次增量备份（和第一次执行的命令大致相同，只有他的--incremental-basedir应该指向上一次的增量备份所在的目录）
```
[root@localhost back_inr]# innobackupex --user=root --password=123123 --socket=/usr/local/mysql/data/mysql.sock --incremental /back_inr/ --incremental-basedir=/back_inr/2016-09-09_08-50-13/
```

- 把增量prepare到全备里面去,只要有增量就要一直redo-only
```
[root@localhost ~]# innobackupex --socket=/usr/local/mysql/data/mysql.sock   --user=root --password=123123 --apply-log-only --redo-only  /backup/ --incremental-dir=/back_inr/2016-09-09_08-50-13/ 	
```

- 跑binlog
起点在xtrbackup_binlog_info里面找


### copy-back和move-back的区别：
如果备份和数据库所在的是一个文件系统，move-back的时候其实就是给了一个名字，速度非常的快



## innobackupex参数详解：
[--compress]和[--compress-threads=NUMBER-OF-THREADS]：备份的时候压缩非常消耗CPU，压的时候可以加大cpu的力度
[--encrypt=ENCRYPTION-ALGORITHM] ：备份有加密的需求
--no-timestamp：备份完之后不生成时间戳
--compact：优化，所有表上的二级索引不备份

--parallel=NUMBER-OF-FORKS：只支持全备，备份的时候可以用并发（并行）的方式去备份（在带宽足够的条件下，可以大量的减少备份的时间）
--throttle=#  阀值，
限流：限制流量，控制他的IO使用量，降低对主库使用的影响，不要对生产产生影响
--safe-slave-backup：停止对从库的更新，然后进行备份，这样备份非常快。
--log-copy-interval=# ：每隔多长时间记录一下日志
--kill-long-queries-timeout=#：如果系统里有一个长事务一直未提交，加锁加不上，那么备份的时候就会hang住，等多长时间事务不提交加不上锁的话就把他杀死
--ftwrl-wait-timeout=# 
--no-lock：在备份期间不加锁
使用这个参数要保证在备份期间：
没有DDL（会导致数据不一致）
没有对myisam表的更新
--redo-only  ：This is necessary if the backup  will have incremental changes applied to it later. 只要后面还有增量就一定要加上redo-only

- log scan up to：
在备份的过程中会有大量的log scan up to：不断的记日志，数据页不断的更新；说明我读到的这个数据页在不断的更新。

## ！！！注意
- 备份期间innodb表也会短时间的加锁，最好在从库上备份，并且暂停主库对从库的更新


 
## 表的导入导出
- 一般都是基于表的。
### 导出：两种方式
- 1.select ... into outfile  options
```
options：

mysql> select * from t3 into outfile "/data/1.txt" fields terminated by ',';	#注意权限的问题

mysql> select * from t3 into outfile "/data/1.txt" fields terminated by ',' lines terminated by '..........';

mysql> select * from t3 into outfile "/data/1.txt" fields terminated by ','  enclosed by '"';

mysql> select * from t3 into outfile "/data/1.txt" fields terminated by ','  optionally  enclosed by '"
```
```
mysql> insert into t4 values(1,'\tdasd');		#插入一行数据以tab分隔
mysql> select * from t4 into outfile "/data/1.txt" fields terminated by ','  escaped by '\\';';		#只在个别的字符类型上加引用符
```

- 2.mysqldump -T
```
mysqldump -u username- T  target_ dir dbname  tablename  [option] 
```
### 导入：load data
- load data
load比insert into速度要快好多，批量导入
mysql >LOAD DATA  [LOCAL]  INFILE  'filename'  INTO  TABLE tablename [option] 
- mysqlimport
Shell> mysqlimport -u root  -p***  [--LOCAL]  dbname order_tab.txt  [option] 















































