#!/bin/bash
# Script to remove zabbix from an adopted node

ZABBIX_AUTH=$(cat /opt/zabbix/srv/resources/maint_scripts/adopt_config |grep zabbix_auth |awk '{print $2}')
NODE=$1
CLUSTER_NAME=$(echo $NODE |cut -d"." -f4) 

#Setup Json Request Logic
function json_request {
	zaburl=https://hub.fcops.alces-flight.com/api_jsonrpc.php
	zabrequest=$(cat $1)
	curl -s -X POST -H 'Content-Type: application/json' $zaburl -d "$zabrequest" |json_pp
}

# Setup json host request file
cat << EOF > /tmp/hosts.txt
{
    "jsonrpc": "2.0",
    "method": "host.get",
    "params": {
        "output": [
            "hostid",
            "host"
        ]
    },
    "id": 2,
    "auth": "$ZABBIX_AUTH"
}
EOF


function zabbix_remove {

host_id=$(json_request /tmp/hosts.txt |grep "$NODE" -B 1 |grep hostid |awk '{print $3}' |sed 's/"//g' |sed 's/,//g')

cat << EOF > /tmp/zabbix_remove.txt
{
    "jsonrpc": "2.0",
    "method": "host.delete",
    "params": [
        "$host_id"
    ],
    "auth": "$ZABBIX_AUTH",
    "id": 1
}
EOF

json_request /tmp/zabbix_remove.txt

}

echo "Removing node from Zabbix"
zabbix_remove
