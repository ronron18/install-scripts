#!/bin/bash

# This script assumes you have zabbix installed, check ../zabbix out if you haven't

## Configure Zabbix to receive traps
#  Configuration file is in /etc/zabbix/zabbix_server.conf
#  StartSNMPTrapper=1
#  SNMPTrapperFile=[TRAP_FILE (/var/log/snmptrap/snmptrap.log)]
#  Give SNMPTrapperFile write permissions
chmod 666 /etc/zabbix/zabbix_server.conf
echo "StartSNMPTrapper=1" >> /etc/zabbix/zabbix_server.conf
chmod 644 /etc/zabbix/zabbix_server.conf
mkdir /var/log/snmptrap/
chmod 666 -R /var/log/snmptrap/

## Configure SNMPTT
apt-get install snmptt
chmod 666 /etc/snmp/snmptt.ini
sed -i "s/net_snmp_perl_enable = 0/net_snmp_perl_enable = 1/" /etc/snmp/snmptt.ini
sed -i "s/log_file = \\/var\\/log\\/snmptt\\/snmptt.log/log_file = \\/var\\/log\\/snmptrap\\/snmptrap.log/" /etc/snmp/snmptt.ini
sed -i "s/#date_time_format =/date_time_format = %H:%M:%S %Y\\/%m\\/%d/" /etc/snmp/snmptt.ini
#echo "date_time_format = %H:%M:%S %Y/%m/%d" >> /etc/snmp/snmptt.ini
chmod 644 /etc/snmp/snmptt.ini

chmod 666 /etc/snmp/snmptt.conf
sed -i "s/FORMAT/FORMAT ZBXTRAP \$aA/" /etc/snmp/snmptt.conf
chmod 644 /etc/snmp/snmptt.conf

## Enable receiving SNMPv3 Traps
read engine_id
read name
read type
read password
chmod 644 /etc/snmp/snmptrapd.conf
echo -e "createUser -e $engine_id $name $type $password AES\nauthuser log, execute $name" >> /etc/snmp/snmptrapd.conf
chmod 666 /etc/snmp/snmptrapd.conf

## Install MIBs
apt install snmp-mibs-downloader
download-mibs
chmod 666 /etc/snmp/snmp.conf
sed -i "s/mibs :/#mibs :/" /etc/snmp/snmp.conf
chmod 644 /etc/snmp/snmp.conf

service zabbix-server restart