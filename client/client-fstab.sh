#!/bin/bash

# Update fstab entries to contain mounts from fcgateway

cat << 'EOF' >> /etc/fstab
fcgateway:/scripts    /opt/fcops/scripts    nfs    intr,rsize=32768,wsize=32768,vers=3,_netdev    0 0
EOF
