#!/bin/bash

useradd zabbix
mkdir -p /opt/zabbix
cd /opt/zabbix
mkdir -p /opt/zabbix/run
chown zabbix /opt/zabbix/run
mkdir -p /var/log/zabbix
chown zabbix /var/log/zabbix
mkdir -p /opt/zabbix/{scripts,logs,conf/custom_checks}
chown zabbix /opt/zabbix/{scripts,logs,conf/custom_checks}

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

cat << 'EOF' > /opt/zabbix/custom_checks/user_params.conf
UserParameter=corosync,bash /opt/zabbix/scripts/check_corosync
UserParameter=haops,bash /opt/zabbix/scripts/check_ha_ops.sh
UserParameter=multipath,bash /opt/zabbix/scripts/check_multipath
UserParameter=psu,cat /opt/zabbix/logs/psu.out
UserParameter=mdarray,bash /opt/zabbix/scripts/check_dellMDarray
UserParameter=dirvish,bash /opt/zabbix/scripts/check_dirvish /mnt/backup
UserParameter=vncrunning,bash /opt/zabbix/scripts/check_vnc_running.sh 36 72
UserParameter=userquota,bash /opt/zabbix/scripts/check_quota_and_mount.sh /export/users 1
UserParameter=sysdisk,bash /opt/zabbix/scripts/check_PERC_H7X0 0 0
UserParameter=backupdisk,bash /opt/zabbix/scripts/check_PERC_H7X0 1 0
UserParameter=backupmount,findmnt -nr -o source -T /backup -O rw > /dev/null && echo 0 || echo 1
UserParameter=tmpmount,findmnt -nr -o source -T /tmp -O rw > /dev/null && echo 0 || echo 1
UserParameter=usermount,findmnt -nr -o source -T /users -O rw > /dev/null && echo 0 || echo 1
UserParameter=varmount,findmnt -nr -o source -T /var -O rw > /dev/null && echo 0 || echo 1
UserParameter=bootmount,findmnt -nr -o source -T /boot -O rw > /dev/null && echo 0 || echo 1
UserParameter=lustremount,findmnt -nr -o source -T /mnt/lustre -O rw > /dev/null && echo 0 || echo 1
UserParameter=zombieproc,bash /opt/zabbix/scripts/check_zombie.sh
UserParameter=ost1,bash /opt/zabbix/scripts/check_PERC_H7X0 0 1
UserParameter=ost2,bash /opt/zabbix/scripts/check_PERC_H7X0 1 1
UserParameter=ost3,bash /opt/zabbix/scripts/check_PERC_H7X0 2 1
UserParameter=ost4,bash /opt/zabbix/scripts/check_PERC_H7X0 3 1
UserParameter=ost5,bash /opt/zabbix/scripts/check_PERC_H7X0 4 1
UserParameter=ost6,bash /opt/zabbix/scripts/check_PERC_H7X0 5 1
UserParameter=xserver,bash /opt/zabbix/scripts/check_procs -c 1 --command X
UserParameter=ecc,bash /opt/zabbix/scripts/check_ECC-IPMI
UserParameter=temps,bash bash /opt/zabbix/scripts/check_inlettemps.sh
EOF

#Download custom scripts from fcgateway
cd /opt/zabbix/scripts ; wget -r -nH --cut-dirs=3 --no-parent --reject="index.html*" http://fcgateway/resources/custom_zabbix_checks/
cd

wget http://fcgateway/resources/zabbix_agentd.conf -O /opt/zabbix/conf/zabbix_agentd.conf

systemctl daemon-reload
systemctl enable zabbix-agent
systemctl start zabbix-agent
