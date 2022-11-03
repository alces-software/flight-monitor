#!/bin/bash

cluster=$(hostname -f | cut -d"." -f3)
use_proxy=false
backup_channel="backups"
cluster_channel="${cluster}-alerts"

host=$(hostname -s)

# Import configuration file
source /opt/bacula/slack/notif.conf

# Get Job ID from parameter
baculaJobId="$1"

echo "ID is " $baculaJobId

#SQL command
sql=" /usr/bin/psql -qtAX ${baculaDbName} ${baculaDbUser} -p${baculaDbPort} -c"

# Get Job type from database, then if it is a backup job, proceed, if not, exit
baculaJobType=$($sql "select Type from Job where JobId=$baculaJobId;")

# Get Job level from database and classify it as Full, Differential, or Incremental
baculaJobLevel=$($sql "select Level from Job where JobId=$baculaJobId;")
case $baculaJobLevel in
  'F') level='Full' ;;
  'D') level='Differential' ;;
  'I') level='Incremental' ;;
  *)   level='Unknown' ;;
esac


# Get Job exit status from database and classify it as OK, OK with warnings, or Fail
baculaJobStatus=$($sql "select JobStatus from Job where JobId=$baculaJobId;")

# Get client's name from database
baculaClientName=$($sql "select Client.Name from Client,Job where Job.ClientId=Client.ClientId and Job.JobId=$baculaJobId;")

#Bytes Transferred
baculaJobBytes=$($sql "select JobBytes from Job where JobId=$baculaJobId;")
baculaJobBytes=$(echo $baculaJobBytes | numfmt --to=iec)

#Files transferred
baculaJobFiles=$($sql "select JobFiles from Job where JobId=$baculaJobId;")
#Time spent by job
#baculaJobTime=$($sql "select timestampdiff(second,StartTime,EndTime) from Job where JobId=$baculaJobId;")
#Job speed
#baculaJobSpeed=$($sql "select round(JobBytes/timestampdiff(second,StartTime,EndTime)/1024,2) from Job where JobId=$baculaJobId;")
#StartTime
baculaStartTime=$($sql "select StartTime from Job where JobId=$baculaJobId;")
#EndTime
baculaEndTime=$($sql "select EndTime from Job where JobId=$baculaJobId;")


baculaJobStatus=$($sql "select JobStatus from Job where JobId=$baculaJobId;")
if [ $baculaJobStatus = "T" ]; then
baculaJobStatusMsg="Job Completed Sucessfully :white_check_mark:"
channel=$backup_channel
else
baculaJobStatusMsg="Job did not complete normally :awooga:"
channel=$cluster_channel
fi

# Use proxy
if [ "$use_proxy" = true ] ; then
        export http_proxy=http://10.78.0.10:3128/; export https_proxy=$http_proxy
fi

#Create Slack message to send

bup_location=""

if [ "$host" = "fcgateway" ] ; then
	bup_location="Fcops Backups"
else
	bup_location="Site Backups"
fi

msg="
:floppy_disk: :vampire: Bacula Job Notification ($bup_location) for \`$cluster\` $baculaClientName (ID: $baculaJobId / Level: $level) \n
Job Exit Status: $baculaJobStatusMsg \n
Job ran from $baculaStartTime to $baculaEndTime ($baculaJobBytes / $baculaJobFiles files transferred)
"

#:stopwatch:  Time spent by job: $baculaJobTime \n
#:dash:  Job Speed: $baculaJobSpeed \n
#Send Message

cat << EOF | curl -k --silent --output /dev/null --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
{
  "text": "$msg",
  "channel": "$channel",
  "as_user": true
}
EOF

if [ "$use_proxy" = true ] ; then
        unset http_proxy
        unset https_proxy
fi
