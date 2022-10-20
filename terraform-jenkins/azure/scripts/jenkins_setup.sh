#!/bin/bash

set -ex

# Install Java
sudo apt install openjdk-11-jre-headless -y

# Create workspace directory
mkdir -p /tmp/workspace
cd /tmp/workspace

# Clone jenkins backup script
git clone https://github.com/vibakar/jenkins-backup-script.git
cd jenkins-backup-script
chmod +x jenkins-helper.sh

cd ..

# Download jenkins war file
sudo curl -L "https://get.jenkins.io/war-stable/2.361.1/jenkins.war" -o /usr/lib/jenkins.war

# Jenkins
sudo wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
echo deb https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
sudo apt update -y
sudo apt install jenkins -y

# Create service file for jenkins
echo -e "[Unit]\nDescription=Jenkins Continuous Integration Server\nRequires=network.target\nAfter=network.target\n\n[Service]\nType=notify\nNotifyAccess=main\nExecStart=/bin/bash -c '`which java` -jar /usr/lib/jenkins.war'\nRestart=on-failure\nSuccessExitStatus=143" | sudo tee -a /etc/systemd/system/jenkins.service

sudo systemctl start jenkins

sudo reboot