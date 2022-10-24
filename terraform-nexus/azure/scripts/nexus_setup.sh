#!/bin/bash

# Update the installed packages and package cache on your instance.
sudo apt update -y
sudo apt upgrade -y

# Install the most recent Docker Engine package.
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install docker-ce -y

# On Amazon Linux 2, to ensure that the Docker daemon starts after each system reboot, run the following command:
sudo systemctl enable docker

sudo mkdir /nexus-data
sudo chown -R 200 /nexus-data

sudo docker run -d -p 8081:8081 --name nexus -v /nexus-data:/nexus-data sonatype/nexus3