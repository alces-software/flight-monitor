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
firewall-cmd --add-port 5901-5905/tcp --permanent #VNC ports :1 to :5
firewall-cmd --reload
systemctl restart firewalld

# Packages
echo "Installing Prerequisites"
yum install -y -e0 vim git epel-release wget -q

#Skip installing GNMOE Desktop for now
#yum groupinstall -y -e0 "GNOME Desktop" -q

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

# install salt master
curl -L https://hub.fcops.alces-flight.com/resources/salt/install_salt_master.sh | bash
mkdir /opt/salt/srv/root/fcops

# fcops salt states
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/top.sls -O /opt/salt/srv/root/top.sls --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/group.sls -O /opt/salt/srv/root/fcops/group.sls --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/user.sls -O /opt/salt/srv/root/fcops/user.sls --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/install.sls -O /opt/salt/srv/root/fcops/install.sls --no-check-certificate -q

# fcops salt files
cat /users/fcops/.ssh/id_fcops.pub > /opt/salt/srv/root/fcops/authorized_keys
echo "fcops    ALL=(ALL)       NOPASSWD: ALL" > /opt/salt/srv/root/fcops/fcops
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/install_agent.sh -O /opt/salt/srv/root/fcops/install_agent.sh --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/user_params.conf -O /opt/salt/srv/root/fcops/user_params.conf --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/zabbix_agentd.conf -O /opt/salt/srv/root/fcops/zabbix_agentd.conf --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/zabbix-agent.service -O /opt/salt/srv/root/fcops/zabbix-agent.service --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/zabbix_agent-4.4.5-linux-3.0-amd64-static.tar.gz -O /opt/salt/srv/root/fcops/zabbix_agent.tgz --no-check-certificate -q

# Salt minion install files
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/salt/salt_minion.sh -O /opt/zabbix/srv/resources/salt/salt_minion.sh --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/salt/salt_minion.tgz -O /opt/zabbix/srv/resources/salt/salt_minion.tgz --no-check-certificate -q

# Cloud salt minion install files
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/salt/cnode_salt_minion.sh -O /opt/zabbix/srv/resources/salt/cnode_salt_minion.sh --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/salt/cnode_salt_minion.tgz -O /opt/zabbix/srv/resources/salt/cnode_salt_minion.tgz --no-check-certificate -q

# Cloud zab + slack notif scripts
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/salt/frontend_zab.sh -O /opt/zabbix/srv/resources/salt/frontend_zab.sh --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/salt/slack_notif.sh -O /opt/zabbix/srv/resources/salt/slack_notif.sh --no-check-certificate -q

# Reactor sls files
mkdir /opt/salt/srv/reactor/
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/salt/sls/reactor/auth-pending.sls -O /opt/salt/srv/reactor/auth-pending.sls --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/salt/sls/reactor/cnode-start.sls -O /opt/salt/srv/reactor/cnode-start.sls --no-check-certificate -q

echo "Downloading scripts from flight-monitor github"
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/zabbix_proxy.conf -O /etc/zabbix/zabbix_proxy.conf --no-check-certificate
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/zabbix_agentd.monitor.conf -O /etc/zabbix/zabbix_agentd.conf --no-check-certificate
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/build/vpn-client.sh -O /tmp/fcm-vpnclient.sh --no-check-certificate
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/build/fcm-fcops_webserver.sh -O /tmp/fcm-fcops_webserver.sh --no-check-certificate

chmod +x /tmp/fcm-vpnclient.sh
chmod +x /tmp/fcm-fcops_webserver.sh

EXT_IP=$(curl ifconfig.me)

echo -e "\033[0;32m==== FCM INITIAL SETUP COMPLETE ====\033[0m"
echo "Remember to add new gw to fcops VPN before running next script"
echo "Add $EXT_IP/32 port 1195 to AWS security group - inbound rules"
echo "Now run script located at /tmp/fcm-vpnclient.sh"
echo "Once VPN is enabled, run script /tmp/fcm-webserver.sh to complete installation"
