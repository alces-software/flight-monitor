#!/bin/bash

# Import configuration file
source /opt/bacula/slack/notif.conf

# Get Job ID from parameter
baculaJobId="$1"

#SQL command
#postgres
#sql="PGPASSWORD=$baculaDbPass /usr/bin/psql -h$baculaDbAddr -p$baculaDbPort -U$baculaDbUser -d$baculaDbName -c" ;;
#Mysql
sql="/usr/bin/mysql -NB -h$baculaDbAddr -P$baculaDbPort -u$baculaDbUser -p$baculaDbPass -D$baculaDbName -e" ;;

# Get Job type from database, then if it is a backup job, proceed, if not, exit
baculaJobType=$($sql "select Type from Job where JobId=$baculaJobId;" 2>/dev/null)
if [ "$baculaJobType" != "B" ] ; then exit 9 ; fi

# Get Job level from database and classify it as Full, Differential, or Incremental
baculaJobLevel=$($sql "select Level from Job where JobId=$baculaJobId;" 2>/dev/null)
case $baculaJobLevel in
  'F') level='full' ;;
  'D') level='diff' ;;
  'I') level='incr' ;;
  *)   exit 11 ;;
esac

# Get Job exit status from database and classify it as OK, OK with warnings, or Fail
baculaJobStatus=$($sql "select JobStatus from Job where JobId=$baculaJobId;" 2>/dev/null)
if [ -z $baculaJobStatus ] ; then exit 13 ; fi
case $baculaJobStatus in
  "T") status=0 ;;
  "W") status=1 ;;
  *)   status=2 ;;
esac

# Get client's name from database
baculaClientName=$($sql "select Client.Name from Client,Job where Job.ClientId=Client.ClientId and Job.JobId=$baculaJobId;" 2>/dev/null)
if [ -z $baculaClientName ] ; then exit 15 ; fi

# Initialize return as zero
return=0

#Create Slack message to send

Job Exit Status: $status

#Bytes Transferred
baculaJobBytes=$($sql "select JobBytes from Job where JobId=$baculaJobId;" 2>/dev/null)
Bytes transferred: $baculaJobBytes

#Files transferred
baculaJobFiles=$($sql "select JobFiles from Job where JobId=$baculaJobId;" 2>/dev/null)
Files transferred: $baculaJobFiles

#Time spent by job
baculaJobTime=$($sql "select timestampdiff(second,StartTime,EndTime) from Job where JobId=$baculaJobId;" 2>/dev/null)
Time spent: $baculaJobTime

#Job speed
baculaJobSpeed=$($sql "select round(JobBytes/timestampdiff(second,StartTime,EndTime)/1024,2) from Job where JobId=$baculaJobId;" 2>/dev/null)
Job Speed: $baculaJobSpeed

# Exit with return status
exit $return
