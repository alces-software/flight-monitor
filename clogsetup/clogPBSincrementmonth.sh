#var yyyymm for specifying logs of current month
date="$(date +'%Y%m')"

#PBS sched_logs
if [[ "$HOSTNAME" = infra02* ]]; then
        cat << EOF > '/etc/rsyslog.d/02-sched_logs.conf'
module(load="imfile")

template(name="sched_logs" type="string" string="%msg:::sp-if-no-1st-sp%%msg:::drop-last-lf%\n")

ruleset(name="sched_logs") {
        action(type="omfwd" Target="fcgateway" Port="514" Protocol="tcp" Template="sched_logs")
        stop
}

input(type="imfile" File="/var/spool/pbs/sched_logs/$date*" Tag="sched_logs" Ruleset="sched_logs")
EOF

#PBS comm_logs
cat << EOF > '/etc/rsyslog.d/03-comm_logs.conf'
module(load="imfile")

template(name="comm_logs" type="string" string="%msg:::sp-if-no-1st-sp%%msg:::drop-last-lf%\n")

ruleset(name="comm_logs") {
        action(type="omfwd" Target="fcgateway" Port="514" Protocol="tcp" Template="comm_logs")
        stop
}

input(type="imfile" File="/var/spool/pbs/comm_logs/$date" Tag="comm_logs" Ruleset="comm_logs")
EOF

#PBS server_logs
cat << EOF > '/etc/rsyslog.d/04-server_logs.conf'
module(load="imfile")

template(name="server_logs" type="string" string="%msg:::sp-if-no-1st-sp%%msg:::drop-last-lf%\n")

ruleset(name="server_logs") {
        action(type="omfwd" Target="fcgateway" Port="514" Protocol="tcp" Template="server_logs")
        stop
}

input(type="imfile" File="/var/spool/pbs/server_logs/$date*" Tag="server_logs" Ruleset="server_logs")
EOF

else

#PBS mom_logs
cat << EOF > '/etc/rsyslog.d/05-momlogs.conf'
module(load="imfile")

template(name="mom_logs" type="string" string="%msg:::sp-if-no-1st-sp%%msg:::drop-last-lf%\n")

ruleset(name="mom_logs") {
        action(type="omfwd" Target="fcgateway" Port="514" Protocol="tcp" Template="mom_logs")
        stop
}

input(type="imfile" File="/var/spool/pbs/mom_logs/$date*" Tag="mom_logs" Ruleset="mom_logs")
EOF

fi

#restart service
systemctl restart rsyslog
