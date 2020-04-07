#!/bin/bash

#
# Prerequisites
#

# Firewall
systemctl stop firewalld
systemctl disable firewalld

# Packages
echo "Installing Prerequisites"
yum install -y -e0 vim git epel-release wget -q
yum install -y -e0 s3cmd awscli -q 
yum install -y -e0 httpd yum-plugin-priorities yum-utils createrepo -q


#
# Install Tools
#
echo "Installing Tools"
curl https://repo.openflighthpc.org/openflight/centos/7/openflight.repo > /etc/yum.repos.d/openflight.repo

yum clean all
yum install -y -e0 --nogpgcheck https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-release-4.4-1.el7.noarch.rpm -q
yum install -y -e0 --nogpgcheck mariadb-server -q
yum install -y -e0 --nogpgcheck zabbix-agent-4.4.5 zabbix-proxy-mysql-4.4.5 -q


#
# Configure Zabbix Proxy
#
systemctl enable mariadb
systemctl start mariadb
echo "create database zabbix_proxy character set utf8 collate utf8_bin;" | mysql -uroot
echo "grant all privileges on zabbix_proxy.* to zabbixuser@localhost identified by 'password';" | mysql -uroot
echo "flush privileges;" | mysql -uroot
zcat /usr/share/doc/zabbix-proxy-mysql-4.4.5/schema.sql.gz | mysql -u zabbixuser zabbix_proxy -ppassword


wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/zabbix_proxy.conf -O /etc/zabbix/zabbix_proxy.conf
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/zabbix_agentd.monitor.conf -O /etc/zabbix/zabbix_agentd.conf
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/build/vpn-client.sh -O /tmp/fcm-vpnclient.sh 
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/build/fcm-webserver.sh -O /tmp/fcm-webserver.sh 

chmod +x /tmp/fcm-vpnclient.sh
chmod +x /tmp/fcm-webserver.sh

echo "==== FCM INITIAL SETUP COMPLETE ===="
echo "Now run script located at /tmp/fcm-vpnclient.sh"
echo "Once VPN is enabled, run script /tmp/fcm-webserver.sh to complete"
