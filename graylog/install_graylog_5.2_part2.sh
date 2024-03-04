#!/bin/bash

# PLEASE FINISH SETTING UP PART 1 BEFORE STARTING THIS
# PLEASE FINISH SETTING UP PART 1 BEFORE STARTING THIS
# PLEASE FINISH SETTING UP PART 1 BEFORE STARTING THIS
# PLEASE FINISH SETTING UP PART 1 BEFORE STARTING THIS
# PLEASE FINISH SETTING UP PART 1 BEFORE STARTING THIS

# This is part 2 of the graylog installation script. this part will install opensearch and graylog server into the system.
# Please make sure part 1 is done already.

JVM_RAM=4
ip_address=""   # Make this an input

dpkg -i opensearch-2.12.0-linux-x64.deb

systemctl enable opensearch
systemctl start opensearch
systemctl status opensearch

echo -e "\ncluster.name: graylog\nnode.name: ${HOSTNAME}\ndiscovery.type: single-node\nnetwork.host: 0.0.0.0\naction.auto_create_index: false\nplugins.security.disabled: true\nindices.query.bool.max_clause_count: 32768"

# Set jvm RAM
sed -i "s/-Xms1g/-Xms${JVM_RAM}g" /etc/opensearch/jvm.options
sed -i "s/-Xmx1g/-Xmx${JVM_RAM}g" /etc/opensearch/jvm.options

sysctl -w vm.max_map_count=262144
echo 'vm.max_map_count=262144' >> /etc/sysctl.conf

systemctl daemon-reload
systemctl enable opensearch
systemctl start opensearch

# Install graylog
wget https://packages.graylog2.org/repo/packages/graylog-5.2-repository_latest.deb
dpkg -i graylog-5.2-repository_latest.deb
apt-get update && apt-get install graylog-server

# Generate secret and password
< /dev/urandom tr -dc A-Z-a-z-0-9 | head -c${1:-96} >> /tmp/password_secret.tmp
echo -n "Enter Password: " && head -1 </dev/stdin | tr -d '\n' | sha256sum | cut -d" " -f1 >> /tmp/root_password_sha2.tmp

# Configure graylog server configuration file
--
--
--
--
--


# Start graylog server
systemctl daemon-reload
systemctl enable graylog-server
systemctl start graylog-server