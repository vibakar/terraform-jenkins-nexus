#!/bin/bash

# Update the installed packages and package cache on your instance.
yum update -y

# Install the most recent Docker Engine package.
# Amazon Linux 2
amazon-linux-extras install docker -y

# Start the Docker service.
service docker start

# On Amazon Linux 2, to ensure that the Docker daemon starts after each system reboot, run the following command:
systemctl enable docker

mkdir /nexus-data
chown -R 200 /nexus-data

docker run -d -p 8081:8081 --name nexus -v /nexus-data:/nexus-data sonatype/nexus3