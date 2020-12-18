#!/bin/bash
# Script to setup zabbix on newly adopted node
# This script should probably be called with whether or not it is a new node to zabbix or whether it is a node which just needs enabling?
# If node is already in zabbix then should enable - setup if statement and do with functions

ZABBIX_AUTH=$(cat /opt/zabbix/srv/resources/maint_scripts/adopt_config |grep zabbix_auth |awk '{print $2}')
NEW_NODE=$1

#Setup Json Request Logic
function json_request {
	zaburl=https://hub.fcops.alces-flight.com/api_jsonrpc.php
	zabrequest=$(cat $1)
	curl -s -X POST -H 'Content-Type: application/json' $zaburl -d "$zabrequest" |json_pp
}

#Decide whether node already exists in zabbix

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

#Try and find if the host is on zabbix currently
if json_request /tmp/hosts.txt |grep $NEW_NODE >/dev/null ;then
	echo "Node already in Zabbix - Enabling"
	enable_node $NEW_NODE
else
	echo "Node not present in Zabbix - Adopting"
	zabbix_addition $NEW_NODE
fi

cat << EOF > /tmp/enable_node.txt
{
    "jsonrpc": "2.0",
    "method": "host.update",
    "params": {
        "hostid": "replace_me",
        "status": 0
    },
    "auth": "$ZABBIX_AUTH",
    "id": 1
}
EOF

enable_node{

}

