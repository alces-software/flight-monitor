#!/bin/bash
# Script to setup zabbix on newly adopted node
# This script should probably be called with whether or not it is a new node to zabbix or whether it is a node which just needs enabling?
# If node is already in zabbix then should enable - setup if statement and do with functions

CONFIG_FILE=/opt/zabbix/API/.config
ZABBIX_AUTH=$(cat $CONFIG_FILE |grep zabbix_auth |awk '{print $2}')
NEW_NODE=$1
CLUSTER_NAME=$(echo $NEW_NODE |cut -d"." -f4) #This may need to change to 3 when testing with stu clusters :) 

#Setup Json Request Logic
function json_request {
	zaburl=https://hub.fcops.alces-flight.com/api_jsonrpc.php
	zabrequest=$(cat $1)
	curl -s -X POST -H 'Content-Type: application/json' $zaburl -d "$zabrequest" |json_pp
}

if [ $# -eq 0 ] ; then
	echo "Please provide a hostname"
	echo "See -help for further info"
	exit 1
else
	if [ $1 == "-help" ] ; then
		echo "Usage: ./adopt_node.sh hostname"
        	echo "Please use FQDN, eg:"
        	echo "Hostname format: cnode01.cloud.pri.cluster.alces.network"
        	exit 0
	else
		echo "Enabling $1"
	fi
fi

CONFIG_FILE=/opt/zabbix/API/.config

function setup_config {
echo -n "Config file not found - Let's set one up:"
echo -n "Enter your slack bot auth token: "; read SLACK_TOKEN
echo -n "Enter your zabbix user auth token: "; read ZABBIX_AUTH
cat << EOF > $CONFIG_FILE
slack_token: ${SLACK_TOKEN}
zabbix_auth: ${ZABBIX_AUTH}
EOF
}

if [ ! -f "$CONFIG_FILE" ]; then
    setup_config
else
    echo "Config file found - Continuing"
fi

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

function slack_notif {
SLACK_TOKEN=$(cat $CONFIG_FILE |grep slack_token  |awk '{print $2}')
#Take a gamble on cluster name being the slack channel name?

msg="
"$NEW_NODE" has been adopted into the ops team processes sucessfully!
"

cat <<EOF | curl --silent --output /dev/null --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
{
  "text": "$msg",
  "channel": "$CLUSTER_NAME",
  "as_user": true
}
EOF
}

#Actually enable node in zabbix if you can find it
if json_request /tmp/hosts.txt |grep $NEW_NODE >/dev/null ;then
        echo "Node in Zabbix as expected - Enabling"
        enable_node
else
        echo "Node not present in Zabbix - Please adopt this node into fcops processes first"
        exit 1
fi

#Now that zabbix stuff has been setup on frontend - pull latest config
#sudo zabbix_proxy -c /etc/zabbix/zabbix_proxy.conf -R config_cache_reload


