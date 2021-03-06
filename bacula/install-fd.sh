#!/bin/bash
#Grab GPG Key for yum repo
cd /tmp
wget https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc
rpm --import Bacula-4096-Distribution-Verification-key.asc
rm -f Bacula-4096-Distribution-Verification-key.asc
#Create new yum repo
cat << EOF >> /etc/yum.repos.d/Bacula.repo
[Bacula-Community]
name=CentOS - Bacula - Community
baseurl=https://www.bacula.org/packages/60bdee807161f/rpms/11.0.2/el7/x86_64/
enabled=1
protect=0
gpgcheck=1
EOF
#Install bacula client
yum install bacula-client -y -e0
