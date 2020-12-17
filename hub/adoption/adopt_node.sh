#!/bin/bash
# A wrapper script for adopting new nodes [CLOUD]
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

NEW_NODE=$1

# Should run fcops setup first

# Runs from chead1 of cloud cluster - keys from fcops@cfcgateway -> root@chead1 should exist
ssh root@chead1 <<-'EOF'
curl http://cfcgateway/resources/maint_scripts/fcops_setup.sh "$NEW_NODE" |/bin/bash
exit
EOF

# Then Zabbix install / setup / config

bash /opt/zabbix/srv/resources/zabbix/zabbix_setup.sh "$NEW_NODE"

# Then ensure checks will run on this new node

bash /opt/zabbix/srv/resources/zabbix/check_setup.sh "$NEW_NODE"



