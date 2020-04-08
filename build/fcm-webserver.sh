#!/bin/bash

mkdir -p /opt/zabbix/srv/resources
yum -y -e0 install nginx

if=$(ip link | awk -F: '$0 !~ "lo|vir|tun|wl|^[^0-9]"{print $2;getline}' |head -1)
ipaddr=$(ifconfig $if | grep inet | awk '{ print $2 }' | head -1)

cat << EOF > /etc/nginx/conf.d/fcm-resources.conf
server {
  listen *:80;
  server_name $ipaddr;
  location /resources/ {
    autoindex on;
    }

  root /opt/zabbix/srv;
  autoindex on;
}
EOF


wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/build/nginx.conf -O /etc/nginx/nginx.conf
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/agent/install_agent.sh -O /opt/zabbix/srv/resources/install_agent.sh
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/zabbix_agentd.conf -O /opt/zabbix/srv/resources/zabbix_agentd.conf
wget https://www.zabbix.com/downloads/4.4.5/zabbix_agent-4.4.5-linux-3.0-amd64-static.tar.gz -O /opt/zabbix/srv/resources/zabbix_agent.tgz

systemctl enable nginx
systemctl start nginx
