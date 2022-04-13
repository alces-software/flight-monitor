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
baseurl=https://bacula.org/packages/60bdee807161f/rpms/11.0.5/el7/
enabled=1
protect=0
gpgcheck=1
EOF

#Install bacula client
yum install --disablerepo=* --enablerepo=Bacula-Community bacula-client -y -e0 --nogpgcheck

#Update bacula-fd config
cat << EOF > /opt/bacula/etc/bacula-fd.conf
Director {
  Name = master1-dir
  Password = "pOqU9LEXiRg7dTwIeJOtN8KHIkLeofxYviNGlXF0seBr"
}

FileDaemon {                          # this is me
  Name = <client>-fd
  FDport = 9102                  # where we listen for the director
  WorkingDirectory = /opt/bacula/working
  Pid Directory = /opt/bacula/working
  Maximum Concurrent Jobs = 20
  Plugin Directory = /opt/bacula/plugins
}

# Send all messages except skipped files back to Director
Messages {
  Name = Standard
  director = master1-dir = all, !skipped, !restored, !saved
}
EOF

systemctl restart bacula-fd

