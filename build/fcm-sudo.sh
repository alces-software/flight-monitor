#!/bin/bash

useradd -G monitor monitor

cat << EOF >> /etc/sudoers
## Allows people in group monitor to run all commands
%monitor	ALL=(ALL)	ALL
EOF

echo "Please set the password for the monitor user with passwd monitor"
