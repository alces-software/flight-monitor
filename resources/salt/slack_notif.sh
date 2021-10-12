#!/bin/bash

display_usage() {
  echo -e "\nUsage: $0 [channel] [message]\n"
}

if [ $# -lt 2 ]
then
        display_usage
        exit 1
fi


zaburl=https://hub.fcops.alces-flight.com/api_jsonrpc.php
channel=$1
SLACK_TOKEN=$(cat /opt/zabbix/srv/resources/maint_scripts/adopt_config |grep slack_token |awk '{print $2}')


msg=$2

cat <<EOF | curl --silent --output /dev/null --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
{
  "text": "$msg",
  "channel": "$channel",
  "as_user": true
}
EOF

