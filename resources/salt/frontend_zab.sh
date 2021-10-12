#!/bin/bash
#DS 23/9/21 - Quick script to add node to frontend / group / template + then ping slack
ZABBIX_AUTH=$(cat /opt/zabbix/srv/resources/maint_scripts/adopt_config |grep zabbix_auth |awk '{print $2}')
NEW_NODE=$1
CLUSTER_NAME=$(echo $NEW_NODE |cut -d"." -f4) # change to 3 for site
NEW_NODE_SHORT=$(echo $NEW_NODE | cut -d"." -f1) # short hostname needed on cloud
CLUSTER_NAME="c$CLUSTER_NAME" # Seperate cloud cluster cfcgateway

#Setup Json Request Logic
function json_request {
	zaburl=https://hub.fcops.alces-flight.com/api_jsonrpc.php
	zabrequest=$(cat $1)
	curl -s -X POST -H 'Content-Type: application/json' $zaburl -d "$zabrequest" |json_pp
}


#If node only needs enabling - this will work + is needed to enable but piping to /dev/null bc output fails when new node and is scary
host_id=$(json_request /tmp/hosts.txt |grep "$NEW_NODE" -B 1 |grep hostid |awk '{print $3}' |sed 's/"//g' |sed 's/,//g') >> /dev/null

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

function enable_node {
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

# For Zabbix additions (ie. new nodes) - Once the node has been installed and setup on zabbix - will need to ensure the correct proxy is monitoring it

#Create proxy_get json
cat << EOF > /tmp/proxy_get.txt
{
    "jsonrpc": "2.0",
    "method": "proxy.get",
    "params": {
        "output": "extend"
    },
    "auth": "$ZABBIX_AUTH",
    "id": 1
}
EOF

#Get new node hostid

#NEW_NODE_ID=$(json_request /tmp/hosts.txt |grep -w "$NEW_NODE" -B 1 |grep hostid |awk '{print $3}' |sed 's/"//g' |sed 's/,//g')

#Also echo NEW_NODE_ID to a file for use in checks
#echo $NEW_NODE_ID > /tmp/new_node_host_id.txt

#Get id of proxy for this cluster
#Doing this based on it running on the gw which should be configured as a proxy

PROXY_NAME=$(hostname)

PROXY_ID=$(json_request /tmp/proxy_get.txt |egrep "host|proxyid" |grep "$PROXY_NAME" -B 1 |grep proxyid |awk '{print $3}' |sed 's/"//g' |sed 's/,//g')


function zabbix_addition {

#New host vars
NEW_NODE_IP=$(ping $NEW_NODE_SHORT -c 1 |grep -m1 $NEW_NODE_SHORT |awk '{print $3}' |sed 's/(//g' |sed 's/)//g')
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
       "proxy_hostid" : "$PROXY_ID"
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
