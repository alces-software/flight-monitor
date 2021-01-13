#!/bin/bash
# A wrapper script to install necessary things + create a cfcgateway
# This wrapper script assumes that you have setup necessary VPN stuff

#Get vars
echo -n "Enter new fcops user password: "; read PASSWORD
echo -n "Please provide your git username: " ; read GUSER
echo -n "Please provide your git password: " ; read GPASS

#Curl + Run original cloud setup script
curl https://raw.githubusercontent.com/alces-software/flight-monitor/master/build/cloud/fcm-setup_cloud.sh | /bin/bash

#This initial setup should then pull other scripts to /tmp so we don't have to keep curling files

#Adds gw to ops hub cluster VPN - will prompt for user and pass atm
bash /tmp/fcm-vpnclient.sh

#Sets up fcops user - this should be run bofore webserver bc permissions
bash /tmp/fcm-fcops-user.sh

#Sets up Nginx + Zabbix Proxy/Agent
bash /tmp/fcm-webserver.sh

#Setup /etc/hosts line + configure hostname
echo "Please add a localhost entry line similar to: 10.10.0.2 cfcgateway.cloud.pri.opsteam.alces.network cfcgateway to /etc/hosts"
echo "Please set the hostname of this gw correctly: hostnamectl set-hostname cfcgateway.cloud.pri.XXXXX.alces.network"
echo "Once above steps have been completed - please restart this gateway"
