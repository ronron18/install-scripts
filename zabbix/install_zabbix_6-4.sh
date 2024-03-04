#!/bin/bash

# Variables
# default_user="test"     # To be inputted
# database_pass="test"
echo "Insert default user name"
read default_user
echo "Insert database password"
read -rs database_pass

# This script installs zabbix 6.4 into a clean Debian 12 install

# enable en_US locale
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen en_US.UTF-8
update-locale

# Add sbin paths
echo "export PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin" >> /root/.bashrc

# Install sudo and add specified user to group.
apt-get install sudo
usermod -a -G sudo $default_user

# Security configuration (Block access after certain amount of login failures, ensure no root access is allowed on ssh)

# Check if all packages requirements are met and install them if not met

# Install zabbix repo
wget https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/zabbix-release_6.4-1+debian12_all.deb
dpkg -i zabbix-release_6.4-1+debian12_all.deb
apt update

# Install zabbix server, frontend and agent
apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent

# Install mariadb
apt-get install mariadb-server

# Create initial DB and import initial schema and data. nb: Change 'password' to a more secure password
mysql -uroot -p -e "
create database zabbix character set utf8mb4 collate utf8mb4_bin;
create user zabbix@localhost identified by '$database_pass';
grant all privileges on zabbix.* to zabbix@localhost;
set global log_bin_trust_function_creators = 1;
"

zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix

mysql -uroot -p -e "set global log_bin_trust_function_creators = 0;"

echo "DBPassword=$database_pass" >> /etc/zabbix/zabbix_server.conf

# Start zabbix processes
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2


# Output next steps:
# 	- Modify config if needs more configuration
# 	- Change default Zabbix password
# 	- Start adding inputs

# Useful Resources
# Configure to use nxlog for remote logging instead of rsyslog because mariadb made syslog obsolete