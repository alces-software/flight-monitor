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

#Check for config file which needs to exist on cfcgateway
#Config file should contain ssh keys, slack tokens, zabbix auth keys etc (For that cluster obvs)

CONFIG_FILE=/opt/zabbix/srv/resources/maint_scripts/adopt_config

function setup_config {
echo -n "Config file not found - Let's set one up:"
echo -n "Enter your fcops user public ssh key: "; read SSH_KEY
echo -n "Enter your slack bot auth token: "; read SLACK_TOKEN
echo -n "Enter your zabbix user auth token: "; read ZABBIX_AUTH
echo -n "Enter your fcops user password for this cluster: "; read FCOPS_PASS
cat << EOF > /opt/zabbix/srv/resources/maint_scripts/adopt_config
ssh_key: ${SSH_KEY}
slack_token: ${SLACK_TOKEN}
zabbix_auth: ${ZABBIX_AUTH}
fcops_pass: ${FCOPS_PASS}
EOF
}
 
# Could we get script to add/remove from FC with API bits too ?

if [ ! -f "$CONFIG_FILE" ]; then
    setup_config
else
    echo "Config found - Continuing with adoption"
fi

NEW_NODE=$1
NEW_NODE_SHORT=$(echo $NEW_NODE |cut -d"." -f1)

# Should run fcops setup first

# Runs from chead1 of cloud cluster - keys from fcops@cfcgateway -> root@chead1 should exist
ssh root@chead1 "curl http://cfcgateway/resources/adoption/fcops_setup.sh |bash -s "$NEW_NODE""

# Then Zabbix install / setup / config

bash /opt/zabbix/srv/resources/adoption/zabbix_setup.sh "$NEW_NODE"

# Assume adoption script is used for compute nodes then:
sudo chown fcops: /etc/genders
echo ""$NEW_NODE_SHORT"   compute,cn,all" >> /etc/genders

# Then ensure checks will run on this new node

bash /opt/zabbix/srv/resources/adoption/check_setup.sh "$NEW_NODE"

# Also ensure any necessary RPMs have been installed

bash /opt/zabbix/srv/resources/adoption/rpm_setup.sh "$NEW_NODE"
