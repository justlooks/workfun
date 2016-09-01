#!/bin/bash

DATADIR="/data/mysql"

if [ ! -d "${DATADIR}" ]; then
        ssap=$(mysqld --initialize --user=mysql --datadir=/data/mysql 2>&1 | awk '/[Note].*password/{print $NF}')
        service mysqld start
        echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '"${MYSQL_ROOT_PASSWORD}"'" | mysql -uroot -p${ssap} -S/tmp/mysql.sock --connect-expired-password
        echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '"${MYSQL_ROOT_PASSWORD}"'" >> /tmp/mylog
        echo "CREATE USER '"${MYSQL_USER}"'@'%' IDENTIFIED BY '"${MYSQL_USER_PASSWORD}"';grant all on *.* to '"${MYSQL_USER}"'@'%'" | mysql -uroot -p${MYSQL_ROOT_PASSWORD} -S/tmp/mysql.sock --connect-expired-password
        echo "CREATE USER '"${MYSQL_USER}"'@'%' IDENTIFIED BY '"${MYSQL_USER_PASSWORD}"';grant all on *.* to '"${MYSQL_USER}"'@'%'" >> /tmp/mylog
        echo -e  'alias my3306=\047mysql -uroot -pPy1Pu7%WmThSbnBTL -S/tmp/mysql.sock --prompt="\u@\h:\d \\r:\m:\s>"\047' >> /root/.bashrc
        service mysqld stop
fi
mysqld --user=mysql
