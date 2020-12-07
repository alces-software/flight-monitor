#!/bin/bash

if [ $# -eq 0 ] ; then
	echo "Please provide a hostname"
	echo "See -help for further info"
	exit 1
else
	if [ $1 == "-help" ] ; then
		echo "Usage: ./snmp_node.sh hostname"
        	echo "Please use FQDN, eg:"
        	echo "Hostname format: cnode01.cloud.pri.cluster.alces.network"
        	exit 0
	else
		echo "Adding SNMP interface for: $1"
	fi
fi


request='bash /opt/scripts/json_req.sh'
host_list="/opt/scripts/hosts.txt"
hostname=$1
host_ip_json="/opt/scripts/host_IP.txt"
udpate_snmp="/opt/scripts/snmp_interface.txt"
#Get hostID of node
host_id=$($request $host_list |grep -w "$hostname" -B 1 |grep hostid |awk '{print $3}' |sed 's/"//g' |sed 's/,//g')

#Update json request with host id
sed -i s/replace_id/"$host_id"/g $host_ip_json

#Get existing host IP
host_ip=$($request $host_ip_json |grep '"ip"' |awk '{print $3}' |sed 's/"//g'  |sed 's/,//g')

#Update IP ready to put into snmp request
snmp_ip=$(echo $host_ip |sed "s/10.10/10.11/g")

#Put new hostid and snmp IP into snmp json request
sed -i s/replace_me/"$host_id"/g $udpate_snmp
sed -i s/replace_ip/"$snmp_ip"/g $udpate_snmp

#Add snmp_interface to node
$request $udpate_snmp

#Return json req back to template
sed -i s/"$host_id"/replace_me/g $udpate_snmp
sed -i s/"$snmp_ip"/replace_ip/g $udpate_snmp
sed -i s/"$host_id"/replace_id/g $host_ip_json
