#!/bin/bash
#Wrapper script for handling decomission node
# This script should run from the associated cfcgateway

if [ $# -eq 0 ] ; then
	echo "Please provide a hostname"
	echo "See -help for further info"
	exit 1
else
	if [ $1 == "-help" ] ; then
		echo "Usage: ./adopt_node.sh hostname"
        	echo "Please use FQDN, eg:"
        	echo "Hostname format: cnode01.cloud.pri.cluster.alces.network"
        	exit 0
	else
		echo "Removing $1 from OPS processes"
	fi
fi

NODE=$1
NODE_SHORT=$(echo $NODE |cut -d"." -f1)

# Biff node from zabbix
bash /opt/zabbix/srv/resources/decommission/remove_zabbix.sh "$NODE"

#Remove node from genders on fcgw - should remove checks run by ops
sudo sed -i '/$NODE_SHORT/d' /etc/genders
