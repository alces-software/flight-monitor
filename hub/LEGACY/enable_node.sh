#!/bin/bash

if [ $# -eq 0 ] ; then
	echo "Please provide a hostname"
	echo "See -help for further info"
	exit 1
else
	if [ $1 == "-help" ] ; then
		echo "Usage: ./enable_node.sh hostname"
        	echo "Please use FQDN, eg:"
        	echo "Hostname format: cnode01.cloud.pri.cluster.alces.network"
        	exit 0
	else
		echo "Enabling $1"
	fi
fi


request='bash /opt/scripts/json_req.sh'
host_list="/opt/scripts/hosts.txt"
hostname=$1

#Get hostID of node
host_id=$($request $host_list |grep $hostname -B 1 |grep hostid |awk '{print $3}' |sed 's/"//g' |sed 's/,//g')

#Should implement some way of determining if host is legit?

enable_json='/opt/scripts/enable_json.txt'

#Put hostID into the json request
sed -i s/replace_me/"$host_id"/g $enable_json

#Disable node
$request $enable_json

#Return json req back to template
sed -i s/"$host_id"/replace_me/g $enable_json
