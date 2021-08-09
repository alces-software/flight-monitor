#!/bin/bash

source /tmp/slack.txt


HOSTNODE=$(hostname | cut -d . -f1) 

HOSTCLUSTER=$(hostname | cut -d . -f3)

msg="
Memtester running on $HOSTNODE of $HOSTCLUSTER.
"


#Send Message

cat << EOF | curl --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
{
  "text": "$msg",
  "channel": "$HOSTCLUSTER",
  "as_user": true
}
EOF


bash ~/memtester/bequiet.sh sudo bash ~/memtester/run_memtester.sh & sleep $1h

sudo killall -9 memtester
 
msg="
Memtester finished running on $HOSTNODE of $HOSTCLUSTER.
"
#Send Message

cat <<EOF | curl --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
{
  "text": "$msg",
  "channel": "$HOSTCLUSTER",
  "as_user": true
}
EOF



