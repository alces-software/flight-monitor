#!/bin/bash

#Install collectd and deps
yum install -e0 -y epel-release -q
yum install -e0 -y collectd -q 
yum install -e0 -y rrdtool rrdtool-devel rrdtool-perl perl-HTML-Parser perl-JSON collectd-rrdtool -q


#Setup config
cat << 'EOF' > /etc/collectd.conf

Hostname    "insert_hostname"
FQDNLookup   true
BaseDir     "/var/lib/collectd"
PIDFile     "/var/run/collectd.pid"
PluginDir   "/usr/lib64/collectd"
TypesDB     "/usr/share/collectd/types.db"

Interval     10

LoadPlugin logfile

<Plugin logfile>
	LogLevel info
	File "/var/log/collectd.log"
	Timestamp true
	PrintSeverity false
</Plugin>

LoadPlugin contextswitch
LoadPlugin cpu
LoadPlugin cpufreq
LoadPlugin df
LoadPlugin disk
LoadPlugin interface
LoadPlugin load
LoadPlugin memory
LoadPlugin network
LoadPlugin nfs
LoadPlugin rrdtool
LoadPlugin uptime
LoadPlugin users

#<Plugin network>
#	<Server "10.178.0.65" "25826">
#	</Server>
#</Plugin>

<Plugin "network">
  Server "10.10.0.2"
</Plugin>

<Plugin rrdtool>
	DataDir "/opt/collectd/rrd/"
	CreateFilesAsync false
	CacheTimeout 120
	CacheFlush   900
	WritesPerSecond 50
</Plugin>

LoadPlugin exec
<Plugin exec>
        Exec "fcops" "/usr/local/bin/lustre-stats-wrapper-collectd.sh"
</Plugin>
Include "/etc/collectd.d"
EOF

sed -i s/insert_hostname/$(hostname)/g /etc/collectd.conf

systemctl enable collectd
systemctl start collectd
