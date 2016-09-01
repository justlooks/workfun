FROM jeongho/centos6:latest
RUN wget http://dev.mysql.com/get/mysql57-community-release-el6-8.noarch.rpm
RUN yum install mysql57-community-release-el6-8.noarch.rpm -y
RUN yum install mysql-community-server -y
RUN mkdir /data
COPY ./my.cnf /etc/
COPY ./mysql-entrypoint.sh /tmp
RUN chmod u+x /tmp/mysql-entrypoint.sh
ENTRYPOINT ["/tmp/mysql-entrypoint.sh"]
MAINTAINER <alex>
