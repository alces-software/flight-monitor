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
# Push new IP
echo -n "Enter IP to push to new client [format - 10.178.0.XX 10.178.0.XY]: "; read IP
cat << EOF > /etc/openvpn/ccd-cluster/$CLIENTNAME
ifconfig-push ${IP}
EOF

# Restart VPN
systemctl restart openvpn@cluster
