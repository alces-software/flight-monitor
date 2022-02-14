#!/bin/bash
#Ping slack to say ur starting a backup

host=$1
zaburl="https://hub.fcops.alces-flight.com/api_jsonrpc.php"
SLACK_TOKEN=$(curl -k --silent http://fcgateway:/resources/maint_scripts/adopt_config |grep slack_token |awk '{print $2}')

msg="
:floppy_disk: Bacula has started backup of \`$host\` \n
"

cat <<EOF | curl -k --silent --output /dev/null --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
{
  "text": "$msg",
  "channel": "<cluster>-alerts",
  "as_user": true
}
EOF
