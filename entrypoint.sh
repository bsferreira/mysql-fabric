#!/bin/bash

# Set server_id on my.cnf
echo "Setting server_id=$SERVER_ID."
sed -i 's/change_server_id/'"$SERVER_ID"'/' /etc/my.cnf
echo "Setting change_report_port=$SERVER_PORT."
sed -i 's/change_server_port/'"$SERVER_PORT"'/' /etc/my.cnf

echo "Starting mysqld service..."
service mysqld start

echo "Running node specific script..."
./$NODE_SCRIPT

tail -f /var/log/mysqld.log
