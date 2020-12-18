#!/bin/bash
# Script to setup zabbix on newly adopted node
# This script should probably be called with whether or not it is a new node to zabbix or whether it is a node which just needs enabling?
# If node is already in zabbix then should enable - setup if statement and do with functions

ZABBIX_AUTH=$(cat /opt/zabbix/srv/resources/maint_scripts/adopt_config |grep zabbix_auth |awk '{print $2}')
NEW_NODE=$1
CLUSTER_NAME=$(echo $NEW_NODE |cut -d"." -f4)

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

#Setup json group get request file
cat << EOF > /tmp/get_group.txt
{
    "jsonrpc": "2.0",
    "method": "hostgroup.get",
    "params": {
        "output": "extend",
        "filter": {
            "name": [
                "$CLUSTER_NAME"
            ]
        }
    },
    "auth": "$ZABBIX_AUTH",
    "id": 1
}
EOF

function enable_node{
host_id=$(json_request /tmp/hosts.txt |grep $NEW_NODE -B 1 |grep hostid |awk '{print $3}' |sed 's/"//g' |sed 's/,//g')

cat << EOF > /tmp/enable_node.txt
{
    "jsonrpc": "2.0",
    "method": "host.update",
    "params": {
        "hostid": "$host_id",
        "status": 0
    },
    "auth": "$ZABBIX_AUTH",
    "id": 1
}
EOF

json_request /tmp/enable_node.txt

}


function zabbix_addition{

#New host vars
NEW_NODE_IP=$(ping $NEW_NODE -c 1 |grep -m1 $NEW_NODE |awk '{print $3}' |sed 's/(//g' |sed 's/)//g')
GROUP_ID=$(json_request /tmp/get_group.txt |grep groupid |cut -d'"' -f4)
#Hardcoded Template IDs at the moment for our generic cloud node templates: Linux NFS v3 Client, Template OS Linux by Zabbix agent
TEMPLATE_ID_1=12523 #Linux NFS v3 Client
TEMPLATE_ID_2=10001 #Template OS Linux by Zabbix agent

cat << EOF > /tmp/zabbix_addition.txt
{
    "jsonrpc": "2.0",
    "method": "host.create",
    "params": {
        "host": "$NEW_NODE",
        "interfaces": [
            {
                "type": 1,
                "main": 1,
                "useip": 1,
                "ip": "$NEW_NODE_IP",
                "dns": "",
                "port": "10050"
            }
        ],
        "groups": [
            {
                "groupid": "$GROUP_ID"
            }
        ],
        "templates": [
            {
                "templateid": "$TEMPLATE_ID_1",
                "templateid": "$TEMPLATE_ID_2"
            }
        ],
    },
    "auth": "$ZABBIX_AUTH",
    "id": 1
}
EOF

json_request /tmp/zabbix_addition.txt

}

#Try and find if the host is on zabbix currently
if json_request /tmp/hosts.txt |grep $NEW_NODE >/dev/null ;then
        echo "Node already in Zabbix - Enabling"
        enable_node
else
        echo "Node not present in Zabbix - Adopting"
        zabbix_addition
fi

# That's the zabbix frontend stuff done (thru API) now for the actuall zabbix install on node - in theory if we run the install script on a node with it already installed then it just restarts the agent :eyes:

# Need to run install as root user - connect to chead1 again 

ssh root@chead1 <<-'EOF'
pdsh -w $NEW_NODE "curl http://cfcgateway/resources/zabbix/install_agent.sh"
exit
EOF













