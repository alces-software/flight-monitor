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
		echo "Adopting $1"
	fi
fi

NODE=$1
NODE_SHORT=$(echo $NODE |cut -d"." -f1)

# Biff node from zabbix
bash /opt/zabbix/srv/resources/decommission/remove_zabbix.sh "$NODE"

# Assume adoption script is used for compute nodes then:
sudo chown fcops: /etc/genders
echo ""$NEW_NODE_SHORT"   compute,cn,all" >> /etc/genders

# Then biff checks will on this new node

bash /opt/zabbix/srv/resources/decommission/check_setup.sh "$NODE"

