#!/bin/bash
#Grab GPG Key for yum repo
cd /tmp
wget https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc --no-check-certificate
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
# Backup bacula default configs
mv /opt/bacula/etc/bacula-dir.conf /opt/bacula/etc/bacula-dirORIG.conf
mv /opt/bacula/etc/bacula-fd.conf /opt/bacula/etc/bacula-fdORIG.conf
mv /opt/bacula/etc/bacula-sd.conf /opt/bacula/etc/bacula-sdORIG.conf
# Update bacula configs
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/bacula/bacula-dir.conf -O /opt/bacula/etc/bacula-dir.conf --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/bacula/bacula-fd.conf -O /opt/bacula/etc/bacula-fd.conf --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/bacula/bacula-sd.conf -O /opt/bacula/etc/bacula-sd.conf --no-check-certificate -q
#Pull down template before/after job scripts
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/bacula/slack_job_start_notif.sh -O /opt/bacula/scripts/slack_job_start_notif.sh --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/bacula/slack_job_end_notif.sh -O /opt/bacula/scripts/slack_job_end_notif.sh --no-check-certificate -q
chown bacula: /opt/bacula/etc/bacula*.conf
chmod +x /opt/bacula/scripts/slack_job_end_notif.sh
chmod +x /opt/bacula/scripts/slack_job_start_notif.sh
#Create logs
mkdir /opt/bacula/log
touch /opt/bacula/log/bacula.log
chown bacula: /opt/bacula/log -R
# Start bacula
systemctl start bacula-fd.service
systemctl start bacula-sd.service
systemctl start bacula-dir.service
#Create alias for bacula console command
cat << EOF >> /etc/profile.d/bacula.sh
alias bacula-console='sudo -u bacula /opt/bacula/bin/bconsole'
EOF
#Next Steps
echo "Replace <cluster> with your cluster name in /opt/bacula/etc/*"
echo "----------------------------"
echo "Adjust clients appropriately in /opt/bacula/etc/bacula-dir.conf"
echo "----------------------------"
echo "Update <cluster> in /opt/bacula/scripts/slack_*"
echo "----------------------------"
echo "Update password in /opt/bacula/etc/bconsole.conf to match the one in bacula-dir.conf"


