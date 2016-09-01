FROM jeongho/centos6:latest

ENV TOMCAT_MAJOR 7
ENV TOMCAT_VERSION 7.0.70
ENV JAVA_HOME /opt/jdk1.7.0_55
ENV CLASSPATH .:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV PATH=$PATH:$JAVA_HOME/bin
ENV CATALINA_HOME /opt/apache-tomcat
# ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

COPY ./jdk.tar.gz /opt/
RUN tar xvf /opt/jdk.tar.gz -C /opt
COPY ./apache-tomcat-$TOMCAT_VERSION.tar.gz /opt
# RUN wget $TOMCAT_TGZ_URL
RUN tar xvf /opt/apache-tomcat-$TOMCAT_VERSION.tar.gz -C /opt
RUN mv /opt/apache-tomcat-$TOMCAT_VERSION /opt/apache-tomcat
EXPOSE 8080

CMD ["/opt/apache-tomcat/bin/catalina.sh", "run"]
MAINTAINER <alex>
