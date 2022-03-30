#!/bin/bash

host=$(hostname -f)
zaburl="https://hub.fcops.alces-flight.com/api_jsonrpc.php"
SLACK_TOKEN=$(cat /opt/fcops/adopt_config |grep slack_token |awk '{print $2}')
msg="
:eject: Unmounted \`/mnt/backup\` on \`$host\`\n
"

# Exit if /mnt/backup is already unmounted
grep -qs '/mnt/backup ' /proc/mounts

if [ $? -ne 0 ] ; then
        exit
fi

# Check for waiting / running backups
jobc=$(/usr/bin/psql -qtAX bacula fcops -p5432 -c "select COUNT(JobID) FROM Job WHERE StartTime>= (current_date - interval '1 week') AND JobStatus IN ('R', 'C')")

# Check if /mnt/backup has open file handles
mountc=$(sudo lsof 2>&1 | grep -c /mnt/backup)

if [[ $jobc == 0 ]] && [[ $mountc == 0 ]] ; then
    # Try unmounting
    sudo umount /mnt/backup

    # Successful?
    if [ $? -eq 0 ] ; then
        # Ping slack
        cat <<EOF | curl -k --silent --output /dev/null --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
{
  "text": "$msg",
  "channel": "support-alerts-zabbix2",
  "as_user": true
}
EOF
    fi
else
    exit
fi
