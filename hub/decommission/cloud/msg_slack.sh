#!/bin/bash
#Alert to slack either way that node had been biffed

NODE=$1
SLACK_TOKEN=$(cat /opt/zabbix/srv/resources/maint_scripts/adopt_config |grep slack_token  |awk '{print $2}')


msg="
"$NODE" has been removed from the ops team processes
"

cat <<EOF | curl --silent --output /dev/null --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
{
  "text": "$msg",
  "channel": "nucleus",
  "as_user": true
}
EOF
