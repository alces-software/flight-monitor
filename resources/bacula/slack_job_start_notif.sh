#!/bin/bash
#Check for mount + ping slack to say ur starting a backup

#Check if mountpoint exists, if not create it

if [ -d "/mnt/backup" ] 
then
    echo "Directory /mnt/backup exists" 
else
    echo "Directory /mnt/backup does not exist - creating"
    mkdir /mnt/backup
fi

#Check can reach fcops-backup + attempt to mount share

if  ping -c 1 10.178.0.141 ; then
        echo "Can reach fcops-backup"
else
	echo "Unable to ping fcops-backup - please check connection"
	exit 1
fi

ssh -q -o BatchMode=yes fcops@10.178.0.141 exit

if [ $? != "0" ]; then
    echo "Connection failed - please check ssh keys in place"
    exit 1
fi

#Check sshfs is installed, if not install it

if rpm -q --quiet fuse-sshfs ; then 
  echo "sshfs installed - continuing"
else
 echo "sshfs not installed - installing" 
 sudo yum install fuse-sshfs -e0 -y -q --nogpgcheck
fi

#Allow other users in fuse.conf, so can mount as fcops user

sudo bash -c 'cat <<EOF > /etc/fuse.conf
# mount_max = 1000
user_allow_other
EOF'


sshfs -o allow_other,default_permissions fcops@10.178.0.141:/mnt/backup1/clusters/<cluster>/ /mnt/backup/

host=$1
zaburl="https://hub.fcops.alces-flight.com/api_jsonrpc.php"
SLACK_TOKEN=$(curl -k --silent http://fcgateway:/resources/maint_scripts/adopt_config |grep slack_token |awk '{print $2}')

msg="
:floppy_disk: Bacula has started backup of \`$host\`[<cluster>] \n
"

cat <<EOF | curl -k --silent --output /dev/null --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
{
  "text": "$msg",
  "channel": "support-alerts-zabbix2",
  "as_user": true
}
EOF
