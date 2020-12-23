#!/bin/bash
#Script to ensure node is setup sucessfully + in genders file on cfcgateway
#Alert to slack either way?

SLACK=$(grep slack_token /opt/zabbix/srv/resources/maint_scripts/adopt_config |awk '{print $2}')

msg="
"$NEW_NODE" has been adopted into the ops team processes sucessfully!
"

SLACK_TOKEN="$SLACK"
cat <<EOF | curl --silent --output /dev/null --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
{
  "text": "$msg",
  "channel": "support-alerts-zabbix2",
  "as_user": true
}
EOF
