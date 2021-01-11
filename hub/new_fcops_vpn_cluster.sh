#!/bin/bash
#Script for adding a new client to my cluster VPN

#Create a user
echo -n "Enter your fcops VPN Username: "; read CLUSTERNAME
echo -n "Enter your fcops VPN Password: "; read PASSWORD

useradd $CLUSTERNAME --shell=/sbin/nologin
echo ${PASSWORD} | passwd --stdin $CLUSTERNAME

echo $CLUSTERNAME >> /etc/openvpn/cluster.users

touch /etc/openvpn/ccd-cluster/$CLUSTERNAME

LAST_IP=$(tail /etc/hosts -n 1 |awk '{print $1}' |cut -d . -f4)
NEW_IP=$(expr $LAST_IP + 4)
NEW_IP_2=$(expr $LAST_IP + 5)

echo "ifconfig-push 10.178.0."$NEW_IP" 10.178.0."$NEW_IP_2"" > /etc/openvpn/ccd-cluster/$CLUSTERNAME

systemctl restart openvpn@cluster

echo "10.178.0.$NEW_IP "$CLUSTERNAME".fcops.alces-flight.com "$CLUSTERNAME".fcops "$CLUSTERNAME"" >> /etc/hosts
