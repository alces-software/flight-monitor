#!/bin/bash

#nfs-utils should be on base img, but if not
yum -q -e0 install nfs-utils

#Setup dirs
mkdir -p /scripts/{tools,customisations}
chmod 775 -R /scripts/

#Services
systemctl enable rpcbind
systemctl enable nfs-server
systemctl enable nfs-lock
systemctl enable nfs-idmap
systemctl start rpcbind
systemctl start nfs-server
systemctl start nfs-lock
systemctl start nfs-idmap
systemctl restart nfs-server

#Do we need firewall rules for nfs services?

#Pull github content to relevant place in /scripts
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/scripts/fcsops.sh -O /scripts

#Setup nfs exports
cat << EOF > /etc/exports
/scripts	10.10.0.0/16(ro,no_subtree_check,no_root_squash)
EOF
