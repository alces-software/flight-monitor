#!/bin/bash
/opt/flight/opt/slurm/bin/sinfo |grep idle > /dev/null 2>&1

#Original idle node count - still needed?
if [ $? = 0 ] ;
then
	#if can see nodes, count them as normal
	/opt/flight/opt/slurm/bin/sinfo |grep idle |awk '{print $4}' > /opt/zabbix/logs/slurm_idle.txt
else
	#echo a value of 0 nodes for logfile
	echo "0" > /opt/zabbix/logs/slurm_idle.txt
fi

#Script Variables
NODES=$(/opt/flight/opt/slurm/bin/sinfo -Nl |grep node |awk '{print $1}' |sed 's/*//g')
#MAXAGE=$(bc <<< '24*60*60') #24hr in seconds
MAXAGE=$(bc <<< '60*2') #120 seconds
SLACK_TOKEN="STU CAN'T HAVE THIS"

####

echo "Time of test: " `date` >> /opt/zabbix/logs/slurm_idle_details.txt

#Generic API -> Slack Msg
function zabbix_bot_idle_notif {
       cat <<EOF | curl --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
	{
  		"text": "$msg",
  		"channel": "nucleus",
  		"as_user": true
	}
EOF
}

for node in $NODES;
do
	msg="<@UNXAUTFQT> "$node" has been idle longer than "$MAXAGE" seconds - Please check that this node is expected to be powered on :awooga:\n"
	NODE_STATE=$(/opt/flight/opt/slurm/bin/sinfo -Nl |grep $node |awk '{print $4}' |sed 's/*//g')
	if [ $NODE_STATE = "idle" ] ; then
		echo $NODE_STATE
		#If idle and no file to track, create it
		if [ ! -f /opt/zabbix/logs/"$node"_idle.txt ] ; then
			touch /opt/zabbix/logs/"$node"_idle.txt
		else
			#Set fileage var and see how old file is
		        FILEAGE=$(($(date +%s) - $(date -r /opt/zabbix/logs/"$node"_idle.txt +%s)))
		        if [[ $FILEAGE -lt $MAXAGE ]] ; then
        		        echo "$node has been $NODE_STATE for less than "$MAXAGE" seconds" >> /opt/zabbix/logs/slurm_idle_details.txt
		        else
                		echo "$node has been $NODE_STATE for more than "$MAXAGE" seconds" >> /opt/zabbix/logs/slurm_idle_details.txt
				#As node has been idle for > threshold - we should alert "if we haven't before"
				if [ ! -f /opt/zabbix/logs/"$node"_zab_idle.txt ] ; then
					zabbix_bot_idle_notif  > /dev/null 2>&1
					#Create tmp file to mark that this has been alerted
					touch /opt/zabbix/logs/"$node"_zab_idle.txt
				else
					#Remove file saying that you've alerted before
					rm -rf /opt/zabbix/logs/"$node"_zab_idle.txt  > /dev/null 2>&1
				fi
        		fi
		fi
	else
		echo $node "is" $NODE_STATE >> /opt/zabbix/logs/slurm_idle_details.txt
		#Remove 'idle' file
		rm -rf /opt/zabbix/logs/"$node"_idle.txt > /dev/null 2>&1
	fi
done
