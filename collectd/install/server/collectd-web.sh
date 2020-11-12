#!/bin/bash
#Clone collectd-web from git repo
cd /usr/local/
git clone https://github.com/httpdss/collectd-web.git
cd collectd-web/
chmod +x cgi-bin/graphdefs.cgi

#Update /usr/local/collectd-web/runserver.py to allow access from any IP
sed -i s/127.0.0.1/0.0.0.0/g runserver.py 

#Install collectd from repos (Much easier than compiling from source)
yum install -e0 -y epel-release
yum install -e0 -y collectd
yum install -e0 -y collectd-rrdtool
systemctl start collectd

#Grab deps for rrd stuff
yum install -e0 -y rrdtool rrdtool-devel rrdtool-perl perl-HTML-Parser perl-JSON perl-CGIq

#Configure basic collectd config
cat <<'EOF' > /etc/collectd.conf
Hostname    "localhost"
FQDNLookup   true
BaseDir     "/var/lib/collectd"
PIDFile     "/var/run/collectd.pid"
PluginDir   "/usr/lib64/collectd"
TypesDB     "/usr/share/collectd/types.db"
AutoLoadPlugin false
CollectInternalStats true
Interval     10

LoadPlugin logfile

<Plugin logfile>
	LogLevel info
	File "/var/log/collectd.log"
	Timestamp true
	PrintSeverity false
</Plugin>

LoadPlugin cpu
LoadPlugin cpufreq
LoadPlugin disk
LoadPlugin interface
LoadPlugin load
LoadPlugin memory
LoadPlugin network
LoadPlugin nfs
LoadPlugin rrdtool

<Plugin rrdtool>
	DataDir "/var/lib/collectd/rrd"
	CreateFilesAsync false
	CacheTimeout 120
	CacheFlush   900
	WritesPerSecond 50
</Plugin>

Include "/etc/collectd.d"
EOF

#Tell collectd-web where to look for rrd data
touch /etc/collectd/collection.conf
echo 'datadir: "/var/lib/collectd/rrd"' > /etc/collectd/collection.conf

#Create basic startup script for collectd-web
cat <<'EOF' > /usr/local/bin/collectd-server
#!/bin/bash


PORT="8888"
  case $1 in
            start)
	cd /usr/local/collectd-web/
	python runserver.py 2> /tmp/collectd.log &
    sleep 1
    stat=`netstat -tlpn 2>/dev/null | grep $PORT | grep "python"| cut -d":" -f2 | cut -d" " -f1`
            if [[ $PORT -eq $stat ]]; then
    sock=`netstat -tlpn 2>/dev/null | grep $PORT | grep "python"`
    echo -e "Server is  still running:\n$sock"
            else
    echo -e "Server has stopped"
            fi
                    ;;
            stop)
    pid=`ps -x | grep "python runserver.py" | grep -v "color"`
            kill -9 $pid 2>/dev/null
    stat=`netstat -tlpn 2>/dev/null | grep $PORT | grep "python"| cut -d":" -f2 | cut -d" " -f1`
            if [[ $PORT -eq $stat ]]; then
    sock=`netstat -tlpn 2>/dev/null | grep $PORT | grep "python"`
    echo -e "Server is  still running:\n$sock"
            else
    echo -e "Server has stopped"
            fi
                    ;;
            status)
    stat=`netstat -tlpn 2>/dev/null |grep $PORT| grep "python" | cut -d":" -f2 | cut -d" " -f1`
            if [[ $PORT -eq $stat ]]; then
    sock=`netstat -tlpn 2>/dev/null | grep $PORT | grep "python"`
    echo -e "Server is running:\n$sock"
            else
    echo -e "Server is stopped"
            fi
                    ;;
            *)
    echo "Use $0 start|stop|status"
                    ;;
    esac
EOF

