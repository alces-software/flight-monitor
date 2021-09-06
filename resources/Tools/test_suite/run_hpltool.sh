#source "/tmp/slack.txt"

HOSTCLUSTER=$(hostname | cut -d . -f3)

msg="
hpltool running on $1 of $HOSTCLUSTER.
"

#cat << EOF | curl --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
#{
#  "text": "$msg",
#  "channel": "$HOSTCLUSTER",
#  "as_user": true
#}
#EOF

pdsh -w $1 "curl 'http://fcgateway/resources/test_suite/hpltool.sh' > /tmp/hpltool.sh"

pdsh -w	$1 "bash /tmp/hpltool.sh $2"

pdsh -w $1 "rm -r /tmp/hpltool.sh"

msg="
hpltool finished running on $1 of $HOSTCLUSTER.
"
#Send Message

#cat <<EOF | curl --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
#{
#  "text": "$msg",
#  "channel": "$HOSTCLUSTER",
#  "as_user": true
#}
#EOF
