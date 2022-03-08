#!/bin/bash

#Grab GPG Key for yum repo
cd /tmp
wget https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc --no-check-certificate
rpm --import Bacula-4096-Distribution-Verification-key.asc
rm -f Bacula-4096-Distribution-Verification-key.asc

#Create new yum repo
cat << EOF > /etc/yum.repos.d/Bacula.repo
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

#Install libs from correct repo before installing rest of bacula...
yum install --disablerepo=centos-7-base --enablerepo=Bacula-Community bacula-libs -y -e0 --nogpgcheck
yum install bacula-postgresql -y -e0 --nogpgcheck

#Start postgres
systemctl start postgresql.service

#Update db user to be fcops
sudo sed -i 's/db_user=${db_user:-bacula}/db_user=${db_user:-fcops}/g' /opt/bacula/scripts/grant_postgresql_privileges
sudo su - postgres -c "/opt/bacula/scripts/create_postgresql_database ; /opt/bacula/scripts/make_postgresql_tables ; /opt/bacula/scripts/grant_postgresql_privileges"

# Backup bacula default configs
mv /opt/bacula/etc/bacula-dir.conf /opt/bacula/etc/bacula-dirORIG.conf
mv /opt/bacula/etc/bacula-fd.conf /opt/bacula/etc/bacula-fdORIG.conf
mv /opt/bacula/etc/bacula-sd.conf /opt/bacula/etc/bacula-sdORIG.conf
mv /opt/bacula/etc/bconsole.conf /opt/bacula/etc/bconsoleORIG.conf

# Update bacula configs
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/bacula/bacula-dir.conf -O /opt/bacula/etc/bacula-dir.conf --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/bacula/bacula-fd.conf -O /opt/bacula/etc/bacula-fd.conf --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/bacula/bacula-sd.conf -O /opt/bacula/etc/bacula-sd.conf --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/bacula/bconsole.conf -O /opt/bacula/etc/bconsole.conf --no-check-certificate -q

#Pull down template before/after job scripts
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/bacula/slack_job_start_notif.sh -O /opt/bacula/scripts/slack_job_start_notif.sh --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/bacula/slack_job_end_notif.sh -O /opt/bacula/scripts/slack_job_end_notif.sh --no-check-certificate -q

#Pull down slack notif stuff
SLACK_TOKEN=$(cat /opt/zabbix/srv/resources/maint_scripts/adopt_config |grep -i slack |awk '{print $2}')
mkdir /opt/bacula/slack
chown fcops: /opt/bacula/slack -R
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/bacula/slack/notif.conf -O /opt/bacula/slack/notif.conf
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/bacula/slack/slack.sh -O /opt/bacula/slack/slack.sh

sed -i "s/<token>/$SLACK_TOKEN/g" /opt/bacula/slack/notif.conf

#Permissions - set to fcops user
chown fcops: /opt/bacula/etc/bacula*.conf
chmod +x /opt/bacula/scripts/slack_job_end_notif.sh
chmod +x /opt/bacula/scripts/slack_job_start_notif.sh
chmod +x /opt/bacula/slack/slack.sh

#Create unit files so services run as fcops
cat << EOF > /usr/lib/systemd/system/bacula-dir.service
[Unit]
Description=Bacula Director Daemon service
Requires=network.target
After=network.target multi-user.target
RequiresMountsFor=/opt/bacula/working /opt/bacula/etc /opt/bacula/bin

# From http://www.freedesktop.org/software/systemd/man/systemd.service.html
[Service]
Type=simple
User=fcops
Group=fcops
ExecStart=/opt/bacula/bin/bacula-dir -fP -c /opt/bacula/etc/bacula-dir.conf
ExecReload=/opt/bacula/bin/bacula-dir -t -c /opt/bacula/etc/bacula-dir.conf
ExecReload=/bin/kill -HUP $MAINPID
SuccessExitStatus=15

[Install]
WantedBy=multi-user.target
EOF

cat << EOF > /usr/lib/systemd/system/bacula-sd.service
[Unit]
Description=Bacula Storage Daemon service
Requires=network.target
After=network.target
RequiresMountsFor=/opt/bacula/working /opt/bacula/etc /opt/bacula/bin

# from http://www.freedesktop.org/software/systemd/man/systemd.service.html
[Service]
Type=simple
User=fcops
Group=fcops
ExecStart=/opt/bacula/bin/bacula-sd -fP -c /opt/bacula/etc/bacula-sd.conf
SuccessExitStatus=15
LimitMEMLOCK=infinity

[Install]
WantedBy=multi-user.target
EOF


#Create logs
mkdir /opt/bacula/log
touch /opt/bacula/log/bacula.log
chown fcops: /opt/bacula/ -R

#Create alias for bacula console command
cat << EOF > /etc/profile.d/bacula.sh
alias bacula-console='sudo -u fcops /opt/bacula/bin/bconsole'
EOF

#Grab cluster name to update files 'automatically' [Presumes running on a site gw]
CLUSTER_NAME=$(hostname |cut -f3 -d.)

sed -i "s/<cluster>/$CLUSTER_NAME/g" /opt/bacula/etc/bacula-dir.conf
sed -i "s/<cluster>/$CLUSTER_NAME/g" /opt/bacula/scripts/slack_job_start_notif.sh
sed -i "s/<cluster>/$CLUSTER_NAME/g" /opt/bacula/slack/slack.sh

#Allow connections to DB for slack notif
sudo sed -i 's/local   all             all                                     peer/local   all             all                                     trust/g' /var/lib/pgsql/data/pg_hba.conf
sudo systemctl restart postgresql

# Start bacula
systemctl daemon-reload

systemctl start bacula-fd.service
systemctl start bacula-sd.service
systemctl start bacula-dir.service

#Next Steps
echo "----------------------------"
echo "Install complete - please check the following"
echo " - Connection to Bacula console"
echo " - Connection to Bacula storage"
echo " - Test slack pings work as expected"
echo "----------------------------"
