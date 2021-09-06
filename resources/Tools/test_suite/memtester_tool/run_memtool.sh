#!/bin/bash

source "/tmp/slack.txt"

HOSTCLUSTER=$(hostname | cut -d . -f3)

msg="
Memtester running on $1 of $HOSTCLUSTER.
"

sudo rm -r memtester.tar.gz

sudo tar -zcvf memtester.tar.gz memtester

pdsh -w $1 "sudo curl 'http://fcgateway/resources/test_suite/memtester_tool/memtester.tar.gz' > /tmp/memtester.tar.gz"

pdsh -w $1 "sudo tar -xzvf /tmp/memtester.tar.gz"

Send Message

cat << EOF | curl --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
{
  "text": "$msg",
  "channel": "$HOSTCLUSTER",
  "as_user": true
}
EOF

pdsh -w	$1 "bash /tmp/memtester/memtest_tool.sh $2"

pdsh -w $1 "sudo rm -r /tmp/memtester /tmp/memtester.tar.gz"

msg="
Memtester finished running on $1 of $HOSTCLUSTER.
"
#Send Message

cat <<EOF | curl --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
{
  "text": "$msg",
  "channel": "$HOSTCLUSTER",
  "as_user": true
}
EOF

