#!/bin/bash


#Mount exports from fcm-exports.sh
####
#Setup /usr/local/sbin/fcmaintenancemode
cat << 'EOF' > /usr/local/sbin/fcmaintenancemode
#Check for arg
if [ $# -eq 0 ]
  then
    echo "No arguments supplied - please supply 'on' or 'off'"
    exit 1
fi
EOF

#Set PATH with tools/cmds
#DailyCheck
