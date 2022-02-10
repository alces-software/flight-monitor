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
baseurl=https://www.bacula.org/packages/60bdee807161f/rpms/11.0.5/el7/
enabled=1
protect=0
gpgcheck=1
EOF
#Install postgres DB (Bacula seems to prefer it over mysql)
yum install postgresql-server -e0 -y
postgresql-setup initdb
systemctl enable postgresql.service
#Install bacula packages
#Install libs from correct repo before installing rest of bacula...
yum install --disablerepo=centos-7-base --enablerepo=Bacula-Community bacula-libs -y -e0 --nogpgcheck
yum install bacula-postgresql -y -e0 --nogpgcheck
#Start postgres
systemctl start postgresql.service
#Setup DB + Services
sudo su - postgres -c "/opt/bacula/scripts/create_postgresql_database ; /opt/bacula/scripts/make_postgresql_tables ; /opt/bacula/scripts/grant_postgresql_privileges"
# Start bacula
systemctl start bacula-fd.service
systemctl start bacula-sd.service
systemctl start bacula-dir.service
mkdir /opt/bacula/log
touch /opt/bacula/log/bacula.log
#Create alias for bacula console command
cat << EOF >> /etc/profile.d/bacula.sh
echo"alias bacula-cons='sudo -u bacula /opt/bacula/bin/bconsole'
EOF
