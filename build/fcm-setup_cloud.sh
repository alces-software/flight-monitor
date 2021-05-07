#!/bin/bash

#
# Prerequisites
#

# Update Firewall Rules
echo "Updating local firewall rules"
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --add-port 22/tcp --permanent #SSH
firewall-cmd --add-port 80/tcp --permanent #HTTP server for agentd files
firewall-cmd --add-port 10050/tcp --permanent #Zabbix Port - Incoming from Zabbix Server
firewall-cmd --add-port 10051/tcp --permanent #Zabbix Port - Incoming from other agents
firewall-cmd --add-port 5901-5905/tcp --permanent #Zabbix Port - Incoming from other agents
firewall-cmd --reload
systemctl restart firewalld

# Packages
echo "Installing Prerequisites"
yum install -y -e0 vim git epel-release wget -q
yum groupinstall -y -e0 "GNOME Desktop" -q 
yum install -y -e0 s3cmd awscli ipmitool -q 
yum install -y -e0 httpd yum-plugin-priorities yum-utils createrepo -q
yum install -y -e0 net-snmp net-snmp-utils -q #Install snmp utils for snmp disco
yum install -y -e0 perl-JSON-PP -q #Install libs for json_pp requests

#
# Install Tools
#
echo "Installing Tools"
curl -s https://repo.openflighthpc.org/openflight/centos/7/openflight.repo > /etc/yum.repos.d/openflight.repo

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


#
# Configure Salt Installation
#

curl -L https://bootstrap.saltstack.com -o /tmp/install_salt.sh
sudo sh /tmp/install_salt.sh -M

echo "Downloading scripts from flight-monitor github"
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/zabbix_proxy.conf -O /etc/zabbix/zabbix_proxy.conf --no-check-certificate
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/zabbix_agentd.monitor.conf -O /etc/zabbix/zabbix_agentd.conf --no-check-certificate
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/build/vpn-client.sh -O /tmp/fcm-vpnclient.sh --no-check-certificate
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/build/fcm-webserver.sh -O /tmp/fcm-webserver.sh --no-check-certificate
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/build/fcm-fcops-user.sh -O /tmp/fcm-fcops-user.sh --no-check-certificate

chmod +x /tmp/fcm-vpnclient.sh
chmod +x /tmp/fcm-webserver.sh
chmod +x /tmp/fcm-fcops-user.sh

EXT_IP=$(curl ifconfig.me)

echo -e "\033[0;32m==== FCM INITIAL SETUP COMPLETE ====\033[0m"
echo "Remember to add new gw to fcops VPN before running next script"
echo "Add $EXT_IP/32 port 1195 to AWS security group - inbound rules"
echo "Now run script located at /tmp/fcm-vpnclient.sh"
echo "Once VPN is enabled, run script /tmp/fcm-webserver.sh to complete installation"
