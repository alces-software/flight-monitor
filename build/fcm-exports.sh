#!/bin/bash

mkdir /scripts
chmod 775 -R /scripts

wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/scripts/fcsops.sh -O /scripts

cat << EOF > /etc/exports
/scripts	10.10.0.0/16(ro,no_subtree_check,no_root_squash)
EOF
