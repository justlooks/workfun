#!/bin/bash
#
# mysql backup script , do full backup on monday,and inc-backup other day
# this script should be deployed on each mysql host
#
#####################################

BASEDIR="/usr/local/MySQL_DB_Backup/mysql_xtrbackup/$(hostname)"
WORKPREFIX="full_inc_"
DAY=$(($(date +%u)-1))
WORKDIR=${WORKPREFIX}$(date +%Y_%m_%d -d "${DAY} days ago")
SSAP="mypass"
USER="myuser"
HOST="myip"
CMD="xtrabackup --backup --compress --user=${USER} --password=${SSAP} --host=${HOST} "
OP=("full" "inc" "inc" "inc" "inc" "inc" "inc")
LOGFILE="/tmp/mysql_xtrbak.log"
exec &> >(tee -a "$LOGFILE")
echo "[info] $(date '+%Y-%m-%d %H:%M:%S') backup start..."
if [ ! -d ${BASEDIR} ];then
    mkdir -p ${BASEDIR}
    echo "[op] create basedir ${BASEDIR}"
fi
cd ${BASEDIR}
if [ ! -d ${WORKDIR} ];then
    mkdir ${WORKDIR}
    echo "[op] create workdir : ${WORKDIR}"
fi
cd ${WORKDIR}
if [ "${OP[${DAY}]}" != "full" ];then    # not full backup day
    LASTDAY=$((${DAY}-1))
    LASTDIR=${OP[${LASTDAY}]}_${LASTDAY}
    echo "[op] add incremental base dir ${LASTDIR}"
    CMD=${CMD}" --incremental-basedir=./${LASTDIR}"
fi
echo "[op] do ${OP[${DAY}]} backup"
CMD=${CMD}" --target-dir=./${OP[${DAY}]}_${DAY}"
${CMD}
echo "[op] ${CMD}"
echo "[info] $(date '+%Y-%m-%d %H:%M:%S') gut gemacht"


------------------------------------

脚本 ： /usr/local/MySQL_DB_Backup/backup_scripts/xtrabkp_incr.sh
备份策略 ：  周一做全备份，周二到周五基于上一天的备份基础上做增量备份
备份目录结构 (所有生成的备份数据存放在 /usr/local/MySQL_DB_Backup/mysql_xtrbackup 目录下，按备份机hostname分开存放）
# tree
.
└── dev_mysql1
        └── full_inc_2017_08_21            ＃保存 2017-08-21 开始一周内的备份信息
                ├── full_00                                   ＃ 保存周一的全备
                ├── inc_01                                   ＃  本日生成的增量备份
                ├── inc_02
                ├── inc_03
                ├── inc_04
                ├── inc_05
                └── inc_06

前置操作，创建备份用户，安装xtrabackup在备份机器
CREATE USER 'backup_xtr'@'127.0.0.1' identified by 'xxx';
GRANT RELOAD, PROCESS, LOCK TABLES, REPLICATION CLIENT ON *.* TO 'backup_xtr'@'127.0.0.1';
 
关于备份数据的合并处理和恢复 
恢复机器上安装qpress
wget http://www.quicklz.com/qpress-11-linux-x64.tar && tar xvf qpress-11-linux-x64.tar && mv qpress /usr/local/bin
解压全备份，以及需要前滚的增量数据
xtrabackup --decompress  --target-dir=./full_0/
xtrabackup --decompress  --target-dir=./inc_1/
recover全备数据
 xtrabackup --prepare --apply-log-only --target-dir=./full_0/
在全备上前滚到周二增备
xtrabackup --prepare --apply-log-only --target-dir=./full_0/  --incremental-dir=./inc_1/
滚到周三备份
xtrabackup --prepare --apply-log-only --target-dir=./full_0/  --incremental-dir=./inc_2/
 
恢复数据
xtrabackup --copy-back --target-dir=./full_0/
修改数据库权限和ibdata1权限
chown -R mysql:mysql schema
chown mysql:mysql ibdata1

如果需要调整全备份的日子则对应调整OP数组中full元素的位置
