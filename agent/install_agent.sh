#!/bin/bash

mkdir -p /opt/zabbix
cd /opt/zabbix
mkdir -p /run/zabbix
chown zabbix /run/zabbix/


wget http://monitor1/resources/zabbix_agent.tgz -O zabbix_agent.tgz
tar -zxvf zabbix_agent.tgz

useradd zabbix

cat << 'EOF' > /usr/lib/systemd/system/zabbix-agent.service
[Unit]
Description=Zabbix Agent
After=syslog.target
After=network.target

[Service]
Environment="CONFFILE=/opt/zabbix/conf/zabbix_agentd.conf"
EnvironmentFile=-/etc/sysconfig/zabbix-agent
Type=forking
Restart=on-failure
PIDFile=/run/zabbix/zabbix_agentd.pid
KillMode=control-group
ExecStart=/opt/zabbix/sbin/zabbix_agentd -c $CONFFILE
ExecStop=/bin/kill -SIGTERM $MAINPID
RestartSec=10s
User=zabbix
Group=zabbix

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable zabbix-agent
systemctl start zabbix-agent