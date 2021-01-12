#!/bin/bash
# A wrapper script to install necessary things + create a cfcgateway
# This wrapper script assumes that you have setup necessary VPN stuff

#Curl + Run original cloud setup script
curl https://raw.githubusercontent.com/alces-software/flight-monitor/master/build/cloud/fcm-setup_cloud.sh | /bin/bash

#This initial setup should then pull other scripts to /tmp so we don't have to keep curling files

#Adds gw to ops hub cluster VPN - will prompt for user and pass atm
bash /tmp/fcm-vpnclient.sh

#Sets up fcops user - this should be run bofore webserver bc permissions
bash /tmp/fcm-fcops-user.sh

#Sets up Nginx + Zabbix Proxy/Agent
bash /tmp/fcm-webserver.sh

