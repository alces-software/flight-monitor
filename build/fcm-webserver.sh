#!/bin/bash

mkdir -p /opt/zabbix/srv/resources
yum -y -e0 install nginx

if=$(ip link | awk -F: '$0 !~ "lo|vir|tun|wl|^[^0-9]"{print $2;getline}')
ipaddr=$(ifconfig $if | grep inet | awk '{ print $2 }' | head -1)

cat << 'EOF' > /etc/nginx/conf.d/fcm-resources.conf
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

#wget nginx.conf from github - link to be updated. 