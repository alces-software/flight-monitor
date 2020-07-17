#!/bin/bash

useradd zabbix
mkdir -p /opt/zabbix
cd /opt/zabbix
mkdir -p /opt/zabbix/run
chown zabbix /opt/zabbix/run
mkdir -p /var/log/zabbix
chown zabbix /var/log/zabbix
mkdir -p /opt/zabbix/{scripts,logs}
chown zabbix /opt/zabbix/{scripts,logs}

wget http://fcgateway/resources/zabbix_agent.tgz -O zabbix_agent.tgz
tar -zxvf zabbix_agent.tgz


#Add zabbix user to sudoers
touch /etc/sudoers.d/zabbix-monitor
cat << 'EOF' >> /etc/sudoers.d/zabbix-monitor
Cmnd_Alias ZABBIX = /opt/MegaRAID/MegaCli/MegaCli64 -ldinfo *, /usr/sbin/crm_mon -s, /usr/sbin/multipath -ll, /usr/bin/ipmitool sensor, /usr/bin/SMcli -d -v, /usr/bin/ipmitool sel elist, /usr/sbin/nvme, /usr/bin/grep *, /usr/sbin/repquota, /usr/bin/sinfo *, /usr/sbin/lnetctl route show -v
zabbix    ALL=(ALL)       NOPASSWD: ZABBIX
EOF


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
PIDFile=/opt/zabbix/run/zabbix_agentd.pid
KillMode=control-group
ExecStart=/opt/zabbix/sbin/zabbix_agentd -c $CONFFILE
ExecStop=/bin/kill -SIGTERM $MAINPID
RestartSec=10s
User=zabbix
Group=zabbix

[Install]
WantedBy=multi-user.target
EOF

wget http://fcgateway/resources/zabbix_agentd.conf -O /opt/zabbix/conf/zabbix_agentd.conf

systemctl daemon-reload
systemctl enable zabbix-agent
systemctl start zabbix-agent
