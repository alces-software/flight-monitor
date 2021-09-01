source "/tmp/slack.txt"

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
        NVal=$(($nodeMem*0.8))

	#get the line number for Ns in HPL.dat and replace with new value of N
        lineNumber=$(bash bequiet.sh pdsh -w $2 "cat /users/alces-cluster/hpl/1-node/HPL.dat | grep -n Ns -m 1 | cut -d: -f1")
        bash bequiet.sh pdsh -w $2 "sed -i '$lineNumber\s/.*/$NVal         Ns/' users/alces-cluster/hpl/1-node/HPL.dat"

	#get the number of cores and set the value of P or Q
        coreCount=$(bash bequiet.sh pdsh -w $2 "lscpu | grep CPU\(s\) -m 1")
        if [ $coreCount/4 -gt 4 ] ; then
                p=$(($coreCount/4))
                q=4
        ; else
                p=4
                q=$(($coreCount/4))
        ; fi

	#replace P/Q value in HPL.dat
	lineNumber=$(bash bequiet.sh pdsh -w $2 "cat /users/alces-cluster/hpl/1-node/HPL.dat | grep -n Ps -m 1 | cut -d: -f1")
	bash bequiet.sh pdsh -w $2 "sed -i '$lineNumber\s/.*/$p         Ps/' users/alces-cluster/hpl/1-node/HPL.dat"

	lineNumber=$(bash bequiet.sh pdsh -w $2 "cat /users/alces-cluster/hpl/1-node/HPL.dat | grep -n Qs -m 1 | cut -d: -f1")
        bash bequiet.sh pdsh -w $2 "sed -i '$lineNumber\s/.*/$q         Qs/' users/alces-cluster/hpl/1-node/HPL.dat"
	
	#alter mpirun line with updated specs
        lineNumber=$(bash bequiet.sh pdsh-w $2 "cat /users/alces-cluster/hpl/1-node/1-node.sh | grep -n mpirun | cut -d. -f1")
        bash bequiet.sh pdsh -w $2 "sed -i $lineNumber\s/.*/'mpirun -np $coreCount -ppn $coreCount /users/alces-cluster/hpl/1-node/xhpl_broadwell' /users/alces-cluster/hpl/1-node/1-node.sh"    
	
	#run the 1-node script
        bash bequiet.sh pdsh -w $2 "bash /users/alces-cluster/hpl/1-node/1-node.sh" & sleep $1h ;
else
        bash bequiet.sh pdsh -w $2 "bash /users/alces-cluster/hpl/2-nodes/2-nodes.sh" & sleep $1h ;
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
