#source "/tmp/slack.txt"

HOSTCLUSTER=$(hostname | cut -d . -f3)

msg="
hpltool started running.
"

#cat << EOF | curl --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
#{
#  "text": "$msg",
#  "channel": "$HOSTCLUSTER",
#  "as_user": true
#}
#EOF

#if there is no third field
if [ -z $3 ] ; then
	#get memory in megabytes, convert that to the value of N in HPL.dat
        nodeMem=$(free -hm | grep Mem | awk '{print $2}' | sed "s/[^0-9]//g")
        nodeMem=$(($nodeMem*1024))
        NVal=$(bc <<< $nodeMem*0.8)

	sudo cp -r /home/fcops/hpl/1-node-scott /tmp

	
	#get the line number for Ns in HPL.dat and replace with new value of N
        lineNumber=$(cat /tmp/1-node-scott/HPL.dat | grep -n Ns -m 1 | cut -d: -f1)
        sudo sed -i "${lineNumber}s/.*/$NVal         Ns/" /tmp/1-node-scott/HPL.dat
	echo "nval = $NVal"

	#get the number of cores and set the value of P or Q
        coreCount=$(lscpu | grep CPU\(s\) -m 1 | awk '{print $2}')
	pqVal=$(bc <<< $coreCount/4)
        if [ $pqVal -gt 4 ] ; then
                p=$pqVal
                q=4
        else
                p=4
                q=$pqVal
        fi

	#replace P/Q value in HPL.dat
	lineNumber=$(cat /tmp/1-node-scott/HPL.dat | grep -n Ps -m 1 | cut -d: -f1)
	sudo sed -i "${lineNumber}s/.*/$p         Ps/" /tmp/1-node-scott/HPL.dat

	echo "linenumber1: $lineNumber"

	lineNumber=$(cat /tmp/1-node-scott/HPL.dat | grep -n Qs -m 1 | cut -d: -f1)
        sudo sed -i "${lineNumber}s/.*/$q         Qs/" /tmp/1-node-scott/HPL.dat
	
	echo "linenumber2: $lineNumber"

	#alter mpirun line with updated specs
        lineNumber=$(cat /tmp/1-node-scott/run_1node.sh | grep -n mpirun | cut -d: -f1)
	xhpl=$(flight start ;flight env activate spack; spack load hpl; which xhpl)

	
	echo "linenumber3: $lineNumber"

        sudo sed -i "${lineNumber}s|.*|'mpirun -np $coreCount -ppn $coreCount $xhpl'|g" /tmp/1-node-scott/run_1node.sh    
	
	cat /tmp/1-node-scott/run_1node.sh | grep mpirun -m 1
		
	#run the 1-node script
        sudo bash /tmp/1-node-scott/run_1node.sh & sleep $1h ;
	#sudo rm -r /tmp/1-node-scott
else
        sudo bash /tmp/2-nodes/2-nodes.sh & sleep $1h ;
fi

msg="
hpltool finished running.
"

#cat <<EOF | curl --data @- -X POST -H "Authorization: Bearer $SLACK_TOKEN" -H 'Content-Type: application/json' https://slack.com/api/chat.postMessage
#{
#  "text": "$msg",
#  "channel": "$HOSTCLUSTER",
#  "as_user": true
#}
#EOF
