#!/bin/bash
# Script to add new FC gw client to 'fcops' VPN
# Root Check
if [ `whoami` != 'root' ]
	then 
		echo "Please run this script as the root user"
		exit
fi

# Add new user + set password
echo -n "Enter new client username: "; read CLIENTNAME
echo -n "Enter new client password: "; read PASSWORD
useradd $CLIENTNAME --shell=/sbin/nologin
echo ${PASSWORD} | passwd --stdin $CLIENTNAME

touch /etc/openvpn/ccd-cluster/$CLIENTNAME

echo "Available IP ranges for new client: "
tail /root/CLUSTER_IP.txt

# Push new IP
echo -n "Enter IP to push to new client [format - 10.178.0.XX 10.178.0.XY]: "; read IP
cat << EOF > /etc/openvpn/ccd-cluster/$CLIENTNAME
ifconfig-push ${IP}
EOF

# Restart VPN
systemctl restart openvpn@cluster

echo -e "\033[0;32m==== VPN CLIENT SETUP COMPLETE ====\033[0m"
echo "Please update /root/CLUSTER_IP.txt with new client IP address"
