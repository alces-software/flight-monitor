#!/bin/bash

export REPOSOURCE=10.150.0.10
export REPODIR='repo/etc/scripts/'

#
# Prerequisites
#

# SElinux
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

# Firewall
systemctl stop firewalld
systemctl disable firewalld

# Packages
yum install -y vim git epel-release wget
yum install -y s3cmd awscli
yum install -y httpd yum-plugin-priorities yum-utils createrepo


#
# Install Tools
#
curl https://repo.openflighthpc.org/openflight/centos/7/openflight.repo > /etc/yum.repos.d/openflight.repo

yum clean all
#yum install -y flight-architect flight-cloud flight-manage flight-metal flight-inventory
yum install -y https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-release-4.4-1.el7.noarch.rpm
yum install -y mariadb-server
yum install -y zabbix-agent-4.4.5 zabbix-proxy-mysql-4.4.5

#
# Pretty Prompt
#
cat << "EOF" > /etc/profile.d/monitor-prompt.sh
if [ "$PS1" ]; then
  PS1="[\u@\h\[\e[1;34m\] [Flight Monitor]\[\e[0m\] \W]\\$ "
fi
EOF

#
# Configure Zabbix Proxy
#
systemctl enable mariadb
systemctl start mariadb
echo "create database zabbix_proxy character set utf8 collate utf8_bin;" | mysql -uroot
echo "grant all privileges on zabbix_proxy.* to zabbixuser@localhost identified by 'password';" | mysql -uroot
echo "flush privileges;" | mysql -uroot
zcat /usr/share/doc/zabbix-proxy-mysql-4.4.5/schema.sql.gz | mysql -u zabbixuser zabbix_proxy -ppassword

wget http://${REPOSOURCE}/${REPODIR}/resources/zabbix_proxy.conf -O /etc/zabbix/zabbix_proxy.conf
wget http://${REPOSOURCE}/${REPODIR}/resources/zabbix_agentd.monitor.conf -O /etc/zabbix/zabbix_agentd.conf
wget http://${REPOSOURCE}/${REPODIR}/fcm-vpnclient.sh -O /tmp/fcm-vpnclient.sh 

chmod +x /tmp/fcm-vpnclient.sh
/tmp/fcm-vpnclient.sh

systemctl enable zabbix-proxy
systemctl enable zabbix-agent
systemctl start zabbix-proxy
systemctl start zabbix-agent