#!/bin/bash

# Build image
# docker build -t bsferreira/mysql-fabric:1.0 .

# IPs
export HOST_IP="10.0.2.15"
export FABRIC_IP="10.0.2.15"
export NODE1_IP="10.0.2.15"
export NODE2_IP="10.0.2.15"
export NODE3_IP="10.0.2.15"

# Ports
export FABRIC_PORT="3306"
export NODE1_PORT="3307"
export NODE2_PORT="3308"
export NODE3_PORT="3309"

# build docker-compose.yml from the template
source env.sh; rm -rf docker-compose.yml; envsubst < "template.yml" > "docker-compose.yml";

# Start all
docker-compose up
