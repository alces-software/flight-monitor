#!/bin/bash

#source "/tmp/slack.txt"

HOSTCLUSTER=$(hostname | cut -d . -f3)

msg="
Invtool running on $1 of $HOSTCLUSTER.
"

#cat << EOF | curl --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
#{
#  "text": "$msg",
#  "channel": "$HOSTCLUSTER",
#  "as_user": true
#}
#EOF

#sudo rm -r invtool.tar.gz

sudo tar -zcvf invtool.tar.gz invtool

pdsh -w $1 "curl 'http://fcgateway/resources/test_suite/invtool.tar.gz' > /tmp/invtool.tar.gz"

pdsh -w $1 "cd /tmp/ ; tar -xzvf /tmp/invtool.tar.gz"

pdsh -w	$1 "bash /tmp/invtool/invtool.sh"

pdsh -w $1 "rm -r /tmp/invtool /tmp/invtool.tar.gz"

msg="
invtool finished running on $1 of $HOSTCLUSTER.
"
#Send Message

#cat <<EOF | curl --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
#{
#  "text": "$msg",
#  "channel": "$HOSTCLUSTER",
#  "as_user": true
#}
#EOF
