#!/bin/bash
#Script to install / configure cacti server

# Based off instructions on https://www.tecmint.com/install-cacti-network-monitoring-on-rhel-centos-fedora/


#Packages
yum install -y -e0 httpd httpd-devel -q
yum install -y -e0 mariadb-server -q
yum install -y -e0 php-mysql php-pear php-common php-gd php-devel php php-mbstring php-cli -q
yum install -y -e0 php-snmp -q 
yum install -y -e0 net-snmp-utils net-snmp-libs -q
yum install -y -e0 rrdtool -q

systemctl start httpd.service
systemctl start mariadb.service
systemctl start snmpd.service

systemctl enable httpd.service
systemctl enable mariadb.service
systemctl enable snmpd.service

yum install cacti

