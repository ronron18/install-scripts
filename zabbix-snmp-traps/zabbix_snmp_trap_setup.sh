#!/bin/bash

# This script assumes you have zabbix installed, check ../zabbix out if you haven't

## Configure Zabbix to receive traps
#  Configuration file is in /etc/zabbix/zabbix_server.conf
#  StartSNMPTrapper=1
#  SNMPTrapperFile=[TRAP_FILE (/var/log/snmptrap/snmptrap.log)]
#  Give SNMPTrapperFile write permissions
echo "---===---   Configuring Zabbix to receive SNMP traps   ---===---"
chmod 666 /etc/zabbix/zabbix_server.conf
echo "StartSNMPTrapper=1" >> /etc/zabbix/zabbix_server.conf
chmod 644 /etc/zabbix/zabbix_server.conf
mkdir /var/log/snmptrap/
echo "" > /var/log/snmptrap/snmptrap.log
chmod 666 -R /var/log/snmptrap/

## Open port 162

## Install zabbix trap receiver perl script
# wget https://git.zabbix.com/projects/ZBX/repos/zabbix/raw/misc/snmptrap/zabbix_trap_receiver.pl -O /usr/bin/zabbix_trap_receiver.pl
echo "---===---   Installing perl trap receiver   ---===---"
cp zabbix_trap_receiver.pl /usr/bin/zabbix_trap_receiver.pl
chmod a+wx /usr/bin/zabbix_trap_receiver.pl
sed "a/\\$SNMPTrapperFile =/\\$SNMPTrapperFile = '\\/var\\/log\\/snmptrap\\/snmptrap.log' #/" /usr/bin/zabbix_trap_receiver.pl
apt install snmp snmptrapd

## Enable receiving SNMPv3 Traps
echo "---===---   Configurations   ---===---"
echo "Please enter Engine ID (Leave blank if unspecified): "
read engine_id
echo -e "\nPlease enter SNMPv3 Name: "
read name
echo -e "\nPlease enter password hash type: "
read type
echo -e "\nPlease enter password: "
read -rs password
chmod 644 /etc/snmp/snmptrapd.conf

if [ "$engine_id" != "" ]; then
    engine_id=" -e ${engine_id}"
fi
echo -e "createUser$engine_id $name $type $password AES\nauthuser log, execute $name" >> /etc/snmp/snmptrapd.conf

echo "perl do \"/usr/bin/zabbix_trap_receiver.pl\";" >> /etc/snmp/snmptrapd.conf
chmod 666 /etc/snmp/snmptrapd.conf

apt-get install libsnmp-perl

echo "---===---   Restarting services   ---===---"
service zabbix-server restart
service snmptrapd restart
zabbix_server -R config_cache_reload

clear
echo "---===---   Installation Completed   ---===---"