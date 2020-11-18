#!/bin/bash

#Install collectd and deps
yum install -e0 -y epel-release
yum install -e0 -y collectd
yum install -e0 -y rrdtool rrdtool-devel rrdtool-perl perl-HTML-Parser perl-JSON collectd-rrdtool

#Grab FQDN for conf
hostvar=$(hostname)

#Setup config
cat << 'EOF' > /etc/collectd.conf

Hostname    "$hostvar"
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

<Plugin network>
	<Server "10.178.0.65" "25826">
	</Server>
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
        Exec "flight" "/usr/local/bin/lustre-stats-wrapper-collectd.sh"
</Plugin>
Include "/etc/collectd.d"
EOF
