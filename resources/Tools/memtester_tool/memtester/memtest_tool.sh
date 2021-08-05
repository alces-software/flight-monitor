#!/bin/bash

source /tmp/slack.txt

HOSTNAME = hostname
msg="
Memtester running on $HOSTNAME.
"
#Send Message

cat << EOF | curl --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
{
  "text": "$msg",
  "channel": "support-alerts-zabbix2",
  "as_user": true
}
EOF


bash ~/memtester/bequiet.sh sudo bash ~/memtester/run_memtester.sh & sleep $1

sudo killall -9 memtester
 
msg="
Memtester finished running on $HOSTNAME.
"
#Send Message

cat <<EOF | curl --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
{
  "text": "$msg",
  "channel": "support-alerts-zabbix2",
  "as_user": true
}
EOF


# command should look like: memtester <node> <time>
# "memtester" should be an alias of something like "bash memtester.sh &"
# run memtester on given node for given time, automatically halt afterwards (and ping you start & end)
# pdsh run memtester on <node>, then sleep for <time> before halting memtester (how to halt it?).
# should all run as background/new shell instance, only thing user should have to do is the command.


