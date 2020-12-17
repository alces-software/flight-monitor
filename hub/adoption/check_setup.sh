#!/bin/bash
#Script to ensure node is setup sucessfully + in genders file on cfcgateway
#Alert to slack either way?



msg="
"$NEW_NODE" has been adopted into the ops team processes sucessfully!
"

SLACK_TOKEN="<REDACTED>"
cat <<EOF | curl --silent --output /dev/null --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
{
  "text": "$msg",
  "channel": "support-alerts-zabbix2",
  "as_user": true
}
EOF
