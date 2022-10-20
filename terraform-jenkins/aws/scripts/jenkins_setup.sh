#!/bin/bash

set -ex

# Install Java:
sudo amazon-linux-extras install java-openjdk11 -y

# Download git
yum install git -y

# Create workspace directory
mkdir -p /root/workspace
cd /root/workspace

# Clone jenkins backup script
git clone https://github.com/vibakar/jenkins-backup-script.git
cd jenkins-backup-script
chmod +x jenkins-helper.sh

cd ..

# Download jenkins war file
curl -L "https://get.jenkins.io/war-stable/${jenkins_version}/jenkins.war" -o /usr/lib/jenkins.war

# Create service file for jenkins
cat > /etc/systemd/system/jenkins.service << EOF
[Unit]
Description=Jenkins Continuous Integration Server
Requires=network.target
After=network.target

[Service]
Type=notify
NotifyAccess=main
ExecStart=/bin/bash -c '`which java` -jar /usr/lib/jenkins.war'
Restart=on-failure
SuccessExitStatus=143
EOF

# Reload systemctl
systemctl daemon-reload

# Start Jenkins
systemctl restart jenkins