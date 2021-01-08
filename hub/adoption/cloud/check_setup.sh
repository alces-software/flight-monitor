#!/bin/bash
#Script to ensure node is setup sucessfully + in genders file on cfcgateway
#Alert to slack either way?

NEW_NODE=$1
SLACK_TOKEN=$(cat /opt/zabbix/srv/resources/maint_scripts/adopt_config |grep slack_token  |awk '{print $2}')

#Add some checks -- zabbix checks? 
#Is node there, enabled, with templates etc?
#Is node pdsh'able? (Would check genders + fcops conf)






msg="
"$NEW_NODE" has been adopted into the ops team processes sucessfully!
"

cat <<EOF | curl --silent --output /dev/null --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
{
  "text": "$msg",
  "channel": "support-alerts-zabbix2",
  "as_user": true
}
EOF
