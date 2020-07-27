#!/bin/bash

touch /etc/sudoers.d/zabbix
cat << EOF > /etc/sudoers.d/zabbix
Cmnd_Alias ZABBIX = /opt/MegaRAID/MegaCli/MegaCli64 -ldinfo *, /usr/sbin/crm_mon -s, /usr/sbin/multipath -ll, /usr/bin/ipmitool sensor, /usr/bin/SMcli -d -v, /usr/bin/ipmitool sel elist, /usr/sbin/nvme, /usr/bin/grep *, /usr/sbin/repquota, /usr/bin/sinfo *, /usr/sbin/lnetctl route show -v
zabbix    ALL=(ALL)       NOPASSWD: ZABBIX
EOF
