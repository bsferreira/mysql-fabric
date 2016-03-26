#!/bin/bash

MYSQL=`which mysql`

#Fabric promote bug fix: https://bugs.mysql.com/bug.php?id=72281
Q0="SET sql_log_bin=0;"

# Server user: accesses the managed MySQL servers, and is created on each managed MySQL server.
Q1="CREATE USER 'fabric_server'@'%' IDENTIFIED BY 'secret';"
Q2="GRANT ALL PRIVILEGES ON *.* TO 'fabric_server'@'%' WITH GRANT OPTION;"
Q3="FLUSH PRIVILEGES;"

SQL="${Q0}${Q1}${Q2}${Q3}"
$MYSQL -uroot -e "$SQL"
