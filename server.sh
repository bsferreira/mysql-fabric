#!/bin/bash

MYSQL=`which mysql`

#Fabric promote bug fix: https://bugs.mysql.com/bug.php?id=72281
Q0="SET sql_log_bin=0;"

# Backing store user: stores Fabric specific information, and is only created on the Fabric backing store MySQL server. For additional information, see Section 8.6, “Backing Store”
Q1="CREATE USER 'fabric_store'@'localhost' IDENTIFIED BY 'secret';"
Q2="GRANT ALTER, CREATE, CREATE VIEW, DELETE, DROP, EVENT, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON mysql_fabric.* TO 'fabric_store'@'localhost';"

# Server user: accesses the managed MySQL servers, and is created on each managed MySQL server.
Q3="CREATE USER 'fabric_server'@'localhost' IDENTIFIED BY 'secret';"
Q4="GRANT DELETE, PROCESS, RELOAD, REPLICATION CLIENT, REPLICATION SLAVE, SELECT, SUPER, TRIGGER ON *.* TO 'fabric_server'@'localhost';"
Q5="GRANT ALTER, CREATE, DELETE, DROP, INSERT, SELECT, UPDATE ON mysql_fabric.* TO 'fabric_server'@'localhost';"

# Backup user: executes backup operations, such as mysqldump, and is created on each managed MySQL server.
Q6="CREATE USER 'fabric_backup'@'localhost' IDENTIFIED BY 'secret';"
Q7="GRANT EVENT, EXECUTE, REFERENCES, SELECT, SHOW VIEW, TRIGGER ON *.* TO 'fabric_backup'@'localhost';"

# Restore user: executes restore operations that typically use the mysql client, and is created on each managed MySQL server.
Q8="CREATE USER 'fabric_restore'@'localhost' IDENTIFIED BY 'secret';"
Q9="GRANT ALTER, ALTER ROUTINE, CREATE, CREATE ROUTINE, CREATE TABLESPACE, CREATE VIEW, DROP, EVENT, INSERT, LOCK TABLES, REFERENCES, SELECT, SUPER, TRIGGER ON *.* TO 'fabric_restore'@'localhost';"

Q10="FLUSH PRIVILEGES;"

SQL="${Q1}${Q2}${Q3}${Q4}${Q5}${Q6}${Q7}${Q8}${Q9}${Q10}"
$MYSQL -uroot -e "$SQL"

# Fabric Server setup
mysqlfabric manage setup
nohup mysqlfabric manage start &
# Wait a few moments for fabric to start
sleep 5

mysqlfabric group create my_group
mysqlfabric group add my_group ${node1}
mysqlfabric group add my_group ${node2}
mysqlfabric group add my_group ${node3}
mysqlfabric group lookup_servers my_group #log check
mysqlfabric group promote my_group
mysqlfabric group activate my_group
mysqlfabric group health my_group #log check
