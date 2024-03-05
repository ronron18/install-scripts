#!/bin/bash

# Install Graylog 5.2 on a FRESH Debian 11 system
# Installation script follows official installation guide with added steps for dependencies.
# This is part 1 of the install, which installs dependencies, mongodb, and preparation for opensearch installation.
# Please reboot between parts.

# opensearch hates easy default passwords, so this is the initial admin password. You should change it later
# for security reasons
OPENSEARCH_PASSWORD="V3rY5tr0nGP@ssW0rD!"   
echo "Enter the non-root user: "
read default_user

# Make sure that proxmox cpu type is set to host

# Add sbin paths
chmod 666 /root/.bashrc
echo "export PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin" >> /root/.bashrc
chmod 644 /root/.bashrc

# Install sudo and add specified user to group.
apt-get install sudo
usermod -a -G sudo $default_user

# MongoDB installation: Install mongodb 6.x on the system. 
# Disable THP

# Install cryptographic libraries
apt-get install gnupg
# Import keys
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | apt-key add -
# Add debian repo to apt list
echo "deb http://repo.mongodb.org/apt/debian bullseye/mongodb-org/6.0 main" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list
# update repo and install mongodb
apt-get update
apt-get install mongodb-org

systemctl daemon-reload
systemctl enable mongod.service
systemctl restart mongod.service
systemctl status mongod.service

# Here we use opensearch instead of elasticsearch as recommended by graylog
wget https://artifacts.opensearch.org/releases/bundle/opensearch/2.9.0/opensearch-2.9.0-linux-x64.deb

chmod 666 /etc/environment
echo -e "OPENSEARCH_INITIAL_ADMIN_PASSWORD=$OPENSEARCH_PASSWORD\nOPENSEARCH_JAVA_HOME=/usr/share/opensearch/jdk" >> /etc/environment
chmod 644 /etc/environment
echo "Please reboot your system"

# reboot then run part 2