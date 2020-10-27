#!/bin/bash
# Script to setup cloud cluster fcgateways - sets up zabbix proxy, VPN -> hub, nginx webserver
#
# Prerequisites
#

# Update Firewall Rules
echo "Updating local firewall rules"
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --add-port 22/tcp --permanent #SSH
firewall-cmd --add-port 80/tcp --permanent #HTTP server for agentd files
firewall-cmd --add-port 10050/tcp --permanent #Zabbix Port - Incoming from Zabbix Server
firewall-cmd --add-port 10051/tcp --permanent #Zabbix Port - Incoming from other agents
firewall-cmd --reload
systemctl restart firewalld

# Packages
echo "Installing Prerequisites"
yum install -y -e0 vim git epel-release wget -q
yum install -y -e0 s3cmd awscli ipmitool -q 
yum install -y -e0 httpd yum-plugin-priorities yum-utils createrepo -q
yum install -y -e0 net-snmp net-snmp-utils -q #Install snmp utils for snmp disco

#
# Install Tools
#
echo "Installing Tools"
curl -s https://repo.openflighthpc.org/openflight/centos/7/openflight.repo > /etc/yum.repos.d/openflight.repo

yum clean all
yum install -y -e0 --nogpgcheck https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-release-4.4-1.el7.noarch.rpm -q
yum install -y -e0 --nogpgcheck mariadb-server -q
yum install -y -e0 --nogpgcheck zabbix-agent-4.4.5 zabbix-proxy-mysql-4.4.5 -q

#
# Configure Zabbix Proxy
#
systemctl enable mariadb
systemctl start mariadb
echo "create database zabbix_proxy character set utf8 collate utf8_bin;" | mysql -uroot
echo "grant all privileges on zabbix_proxy.* to zabbixuser@localhost identified by 'password';" | mysql -uroot
echo "flush privileges;" | mysql -uroot
zcat /usr/share/doc/zabbix-proxy-mysql-4.4.5/schema.sql.gz | mysql -u zabbixuser zabbix_proxy -ppassword

echo "Downloading scripts from flight-monitor github"
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/zabbix_proxy.conf -O /etc/zabbix/zabbix_proxy.conf --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/zabbix_agentd.monitor.conf -O /etc/zabbix/zabbix_agentd.conf --no-check-certificate -q 

EXT_IP=$(curl ifconfig.me)

echo -e "\033[0;32m==== FCM INITIAL SETUP COMPLETE ====\033[0m"
echo -e "\033[0;31m==== Remember to add $EXT_IP/32 port 1195 to AWS security group - inbound rules ====\033[0m"

echo "Installing openvpn"
yum install epel-release -y -q
yum install openvpn -y -q

cat << EOF > /etc/openvpn/fcmonitor.conf
client
dev tun0
proto tcp
remote 52.49.123.145 1195
resolv-retry infinite
nobind
persist-key
persist-tun
<ca>
-----BEGIN CERTIFICATE-----
MIIE3TCCA8WgAwIBAgIJALkwLvje8YdBMA0GCSqGSIb3DQEBCwUAMIGgMQswCQYD
VQQGEwJVSzEUMBIGA1UECAwLT3hmb3Jkc2hpcmUxDzANBgNVBAcMBk94Zm9yZDEZ
MBcGA1UECgwQQWxjZXMgRmxpZ2h0IEx0ZDEXMBUGA1UECwwOSW5mcmFzdHJ1Y3R1
cmUxETAPBgNVBAMMCENoYW5nZU1lMSMwIQYJKoZIhvcNAQkBFhRzc2xAYWxjZXMt
ZmxpZ2h0LmNvbTAeFw0yMDAyMDYxNjU1NTRaFw0zMDAyMDMxNjU1NTRaMIGgMQsw
CQYDVQQGEwJVSzEUMBIGA1UECAwLT3hmb3Jkc2hpcmUxDzANBgNVBAcMBk94Zm9y
ZDEZMBcGA1UECgwQQWxjZXMgRmxpZ2h0IEx0ZDEXMBUGA1UECwwOSW5mcmFzdHJ1
Y3R1cmUxETAPBgNVBAMMCENoYW5nZU1lMSMwIQYJKoZIhvcNAQkBFhRzc2xAYWxj
ZXMtZmxpZ2h0LmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMSm
kQhLgB2qWQ3sL1Q2GwLvdmylR0u8zaUc+vLE966c2Pyd6DcZw30v/KjvguF9otXj
Z835LShSnPTeOZiy3t2L/p0colJML2pECFkjneKl3Tk0Xyns897vnBQTwgU0+qI8
brgeoq4CTokBw6uskLXQ9WBA+eMk5hYe4uh+ga5x716N4HH13Bqp9qCj5IEcPV2C
Jfl3hTQxqKMYAlfrsGyxZ+KEG8QEkA7d9kXmqyrGBzM25ANY/b9LQG2U7geLnhSa
ZDysaOiodksoWaKgi8fqoWUmBcQUCHc6cDsOVx4cBEncmy4JOtYeWz6RkczItIkT
8PqkTT2pXUEOxF/UfI0CAwEAAaOCARYwggESMB0GA1UdDgQWBBStiZw19XmYwnFv
dR06Pe6sJiPqhDCB1QYDVR0jBIHNMIHKgBStiZw19XmYwnFvdR06Pe6sJiPqhKGB
pqSBozCBoDELMAkGA1UEBhMCVUsxFDASBgNVBAgMC094Zm9yZHNoaXJlMQ8wDQYD
VQQHDAZPeGZvcmQxGTAXBgNVBAoMEEFsY2VzIEZsaWdodCBMdGQxFzAVBgNVBAsM
DkluZnJhc3RydWN0dXJlMREwDwYDVQQDDAhDaGFuZ2VNZTEjMCEGCSqGSIb3DQEJ
ARYUc3NsQGFsY2VzLWZsaWdodC5jb22CCQC5MC743vGHQTAMBgNVHRMEBTADAQH/
MAsGA1UdDwQEAwIBBjANBgkqhkiG9w0BAQsFAAOCAQEAHuEL/hOZVN4Rkt/Tkxp2
/miWerlRbSBTKbFt0TA1MX+ecGerQ5Zpcdx5kYswJzvYfRDVSy/u2Wkw+euYNUpl
ojEu/iF1Vo3RR3fyj3BuVBrCfaNdTyBj9X3OXs6cOD/zpOos+yXVojnFr1lTtjn0
zQo7RpNVvKnatPKirh6nNI0sPEEX1dR6+P5Tb+mt9BL5pIA9y/qU5ibC4AGsJFVq
A++V1PiI35cxNI1VPasWcNR6WQnSxfwZXry7M2bosQe1PwPFb2c4JL2xjc5GryI/
5uGoC1ghA/g030xNc8LNWmeXM8FPyzPweiRseJ+Sdi9Vjx9NekN3QFBitO2Xf5cZ
bQ==
-----END CERTIFICATE-----
</ca>
auth-user-pass auth.fcmonitor
ns-cert-type server
comp-lzo
verb 3
EOF

echo -n "Enter your fcops VPN Username: "; read CLUSTERNAME
echo -n "Enter your fcops VPN Password: "; read PASSWORD
cat << EOF > /etc/openvpn/auth.fcmonitor
${CLUSTERNAME}
${PASSWORD}
EOF

chmod 600 /etc/openvpn/auth.fcmonitor

systemctl start openvpn@fcmonitor
systemctl enable openvpn@fcmonitor

sleep 15 #Gives openvpn a chance to start up before below test!

#Testing openvpn is setup
if  ping -c 1 10.178.0.1 ; then
        echo "openvpn setup tested with success"
	echo -e "\033[0;32m==== VPN SETUP COMPLETE ====\033[0m"
	echo "Now VPN is enabled, run script /tmp/fcm-webserver.sh to setup webserver"
else
	echo -e "\033[0;31m==== VPN SETUP INCOMPLETE ====\033[0m"
	echo "please re-run script and check credentials"
    exit 1
fi


mkdir -p /opt/zabbix/srv/resources/{maint_scripts,apps_scripts,zabbix}
chown fcops: /opt/zabbix/srv/resources/ -R
echo "Installing nginx"
yum -y -e0 install nginx -q

if=$(ip link | awk -F: '$0 !~ "lo|vir|tun|wl|^[^0-9]"{print $2;getline}' |head -1)
ipaddr=$(ifconfig $if | grep inet | awk '{ print $2 }' | head -1)

cat << EOF > /etc/nginx/conf.d/fcm-resources.conf
server {
  listen *:80;
  server_name $ipaddr;
  location /resources/ {
    autoindex on;
    }

  root /opt/zabbix/srv;
  autoindex on;
}
EOF

echo "Downloading ngnix config from flight-monitor github"
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/nginx.conf -O /etc/nginx/nginx.conf --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/client/install_agent.sh -O /opt/zabbix/srv/resources/install_agent.sh --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/zabbix_agentd.conf -O /opt/zabbix/srv/resources/zabbix_agentd.conf --no-check-certificate -q
wget https://www.zabbix.com/downloads/4.4.5/zabbix_agent-4.4.5-linux-3.0-amd64-static.tar.gz -O /opt/zabbix/srv/resources/zabbix_agent.tgz -q


echo "Downloading Custom Zabbix Conf"
wget https://github.com/alces-software/flight-monitor/blob/master/resources/zabbix_custom_checks.tar.gz?raw=true -O /opt/zabbix/srv/resources/zabbix_checks.tar.gz -q --no-check-certificate
tar -zxvf /opt/zabbix/srv/resources/zabbix_checks.tar.gz -C /opt/zabbix/srv/resources/


#Hostname change when people give u VMs that aren't called fcgateway...
sed -i s/fcgateway/$(hostname -s)/g /opt/zabbix/srv/resources/*

echo "Starting Nginx Services"
systemctl enable nginx
systemctl start nginx

echo "Starting Zabbix Services"
systemctl start zabbix-proxy.service
systemctl start zabbix-agent.service
systemctl enable zabbix-proxy.service
systemctl enable zabbix-agent.service

echo -e "\033[0;32m==== WEBSERVER SETUP COMPLETE ====\033[0m"
echo "Add this proxy server to Zabbix (via Frontend on ops-hub)"
