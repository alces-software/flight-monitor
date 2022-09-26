#update package and start/enable service
yum install -y rsyslog
systemctl enable rsyslog
systemctl start rsyslog

#Open port to allow log transfer
firewall-cmd --zone public --add-port 514/tcp 
firewall-cmd --zone public --add-port 514/tcp --permanent

#Add flight-logs to fcgateway hosts file
cat << EOF >> /etc/hosts

10.178.0.161  flight-logs.fcops.alces-flight.com flight-logs
EOF


#Configure fcgateway to forward all logs to central logging server
cat << EOF > /etc/rsyslog.d/99-central-logging.conf
# Enable remote
module(load="imptcp")
input(type="imptcp" port="514")

# Make sure to use FROMHOST (fqdn) to forward logs
template(name="remoteFormat" type="string" string="<%PRI%>1 %TIMESTAMP:::date-rfc3339% %FROMHOST% %APP-NAME% %PROCID% %MSGID% %STRUCTURED-DATA% %msg%\n")

:fromhost-ip, !isequal, "127.0.0.1" {
	# Forward to central logging server
	# Use a queue to store logs when remote is down
	action(type="omfwd" Target="flight-logs.fcops.alces-flight.com" Port="514" Protocol="tcp" Template="remoteFormat" queue.filename="forwarding" queue.size="1000000" queue.type="LinkedList" queue.maxFileSize="1G" action.resumeRetryCount="-1")
	stop
}

EOF


#Add config to collate secure logs
cat << EOF > /etc/rsyslog.d/01-secure.conf
:fromhost-ip, !isequal, "127.0.0.1" {

        # Write authpriv messages to a seperate secure log
        :syslogfacility-text, isequal, "authpriv" {
                action(type="omfile" file="/var/log/cluster/secure.log" fileCreateMode="0640" dirCreateMode="0755")
        }
}
EOF


#Add config to collate slurm logs
cat << EOF > /etc/rsyslog.d/02-slurm.conf
:fromhost-ip, !isequal, "127.0.0.1" {

        # Write slurm messages to a seperate slurm log
        :syslogtag, isequal, "slurmctld:" {
                action(type="omfile" file="/var/log/cluster/slurm.log" fileCreateMode="0640" dirCreateMode="0755")
        }
        :syslogtag, isequal, "slurm" {
                action(type="omfile" file="/var/log/cluster/slurm.log" fileCreateMode="0640" dirCreateMode="0755")
        }
}
EOF


#Add config to write one log per host
cat << EOF > /etc/rsyslog.d/03-host.conf
template(name="host_log" type="string" string="/var/log/cluster/%FROMHOST%/host.log")

:fromhost-ip, !isequal, "127.0.0.1" {

        # Log to a file for each host
        action(type="omfile" dynaFile="host_log" fileCreateMode="0640" dirCreateMode="0755")

}
EOF


#restart service
systemctl restart rsyslog


#Add logrotate config
cat << EOF > /etc/logrotate.d/rsyslog-cluster
# Keep 5 weeks of secure and slurm log
/var/log/cluster/secure.log
/var/log/cluster/slurm.log
{
  create
  missingok
  weekly
  rotate 5
  sharedscripts
  postrotate
    /bin/systemctl restart rsyslog >/dev/null 2>&1 || true
  endscript
}

# Keep 7 days per host
/var/log/cluster/*/host.log {
  create
  missingok
  daily
  rotate 7
  sharedscripts
  postrotate
    /bin/systemctl restart rsyslog >/dev/null 2>&1 || true
  endscript
}
EOF
