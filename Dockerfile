FROM centos:6

MAINTAINER ferreira.sousa.bruno@gmail.com

WORKDIR ~/

RUN rpm -i http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
RUN yum -y update
RUN yum -y install mysql mysql-server mysql-utilities
RUN yum install telnet telnet-server -y

COPY my.cnf /etc/my.cnf
COPY fabric.cfg /etc/mysql/fabric.cfg
COPY entrypoint.sh .
COPY server.sh .
COPY node.sh .
RUN chmod +x *.sh

ENTRYPOINT ["./entrypoint.sh"]
