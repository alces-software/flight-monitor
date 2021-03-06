#!/bin/bash

mkdir -p /opt/zabbix/srv/resources/{maint_scripts,apps_scripts,zabbix}
chown fcops: /opt/zabbix/srv/resources/ -R
echo "Installing nginx"
yum -y -e0 install nginx -q

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

echo "Downloading ngnix config from flight-monitor github"
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/nginx.conf -O /etc/nginx/nginx.conf --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/client/install_agent.sh -O /opt/zabbix/srv/resources/zabbix/install_agent.sh --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/zabbix_agentd.conf -O /opt/zabbix/srv/resources/zabbix/zabbix_agentd.conf --no-check-certificate -q
#wget https://www.zabbix.com/downloads/4.4.5/zabbix_agent-4.4.5-linux-3.0-amd64-static.tar.gz -O /opt/zabbix/srv/resources/zabbix/zabbix_agent.tgz -q
wget https://cdn.zabbix.com/zabbix/binaries/stable/4.4/4.4.5/zabbix_agent-4.4.5-linux-3.0-amd64-static.tar.gz -O /opt/zabbix/srv/resources/zabbix/zabbix_agent.tgz -q


echo "Downloading Custom Zabbix Conf"
wget https://github.com/alces-software/flight-monitor/blob/master/resources/zabbix_custom_checks.tar.gz?raw=true -O /opt/zabbix/srv/resources/zabbix/zabbix_checks.tar.gz -q --no-check-certificate
tar -zxvf /opt/zabbix/srv/resources/zabbix/zabbix_checks.tar.gz -C /opt/zabbix/srv/resources/zabbix/


#Hostname change when people give u VMs that aren't called fcgateway...
sed -i s/fcgateway/$(hostname -s)/g /opt/zabbix/srv/resources/*

echo "Starting Nginx Services"
systemctl enable nginx
systemctl start nginx

echo "Starting Zabbix Services"
systemctl start zabbix-proxy.service
systemctl start zabbix-agent.service
systemctl enable zabbix-proxy.service
systemctl enable zabbix-agent.service

echo -e "\033[0;32m==== WEBSERVER SETUP COMPLETE ====\033[0m"
#echo "Add this proxy server to Zabbix (via Frontend on ops-hub)"
