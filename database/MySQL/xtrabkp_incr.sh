#!/bin/bash
#
# mysql backup script , do full backup on monday,and inc-backup other day
# this script should be deployed on each mysql host
#
#####################################

BASEDIR="/opt/mysql_xtrbackup/$(hostname)"
WORKPREFIX="full_inc_"
DAY=$(($(date +%u)-1))
WORKDIR=${WORKPREFIX}$(date +%Y_%m_%d -d "${DAY} days ago")
SSAP="mypass"
USER="myuser"
HOST="hostip"
CMD="xtrabackup --backup --user=${USER} --password=${SSAP} --host=${HOST} "
OP=("full" "inc" "inc" "inc" "inc" "inc" "inc")

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
if [ "${DAY}" -ne 0 ];then    # not full backup day
    LASTDAY=$((${DAY}-1))
    LASTDIR=${OP[${LASTDAY}]}_${LASTDAY}
    CMD=${CMD}" --incremental-basedir=./${LASTDIR}"
fi
echo "[op] do ${OP[${DAY}]} backup"
CMD=${CMD}" --target-dir=./${OP[${DAY}]}_${DAY}"
${CMD}
echo "[op] ${CMD}"
echo "[info] gut gemacht"
