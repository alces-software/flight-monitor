#update package and start/enable service
yum install rsyslog
systemctl enable rsyslog
systemctl start rsyslog

#forwards system logs to fcgateway
cat << EOF > '/etc/rsyslog.d/99-remote-messages.conf'
action(type="omfwd" Target="fcgateway" Port="514" Protocol="tcp")
EOF

#if node is infra01, add config to foward ipa logs
if [[ "$HOSTNAME" = infra01* ]]; then
        cat << EOF > '/etc/rsyslog.d/01-krb5kdc.conf'
module(load="imfile")

template(name="krb5kdc" type="string" string="%msg:::sp-if-no-1st-sp%%msg:::drop-last-lf%\n")

ruleset(name="krb5kdc") {
        action(type="omfwd" Target="fcgateway" Port="514" Protocol="tcp" Template="krb5kdc")
        stop
}

input(type="imfile" File="/var/log/krb5kdc.log" Tag="krb5kdc" Ruleset="krb5kdc")
EOF

#GE qmaster logs
elif [[ "$HOSTNAME" = infra02* ]]; then
        cat << EOF > '/etc/rsyslog.d/02-qmaster.conf'
module(load="imfile")

template(name="qmaster" type="string" string="%msg:::sp-if-no-1st-sp%%msg:::drop-last-lf%\n")

ruleset(name="qmaster") {
        action(type="omfwd" Target="fcgateway" Port="514" Protocol="tcp" Template="qmaster")
        stop
}

input(type="imfile" File="/var/spool/gridscheduler/qmaster/messages" Tag="qmaster" Ruleset="qmaster")
EOF
fi

#GE logs
host="$( cut -d '.' -f 1 <<< "$HOSTNAME" )"

cat << EOF > '/etc/rsyslog.d/03-GElogs.conf'
module(load="imfile")

template(name="GElogs" type="string" string="%msg:::sp-if-no-1st-sp%%msg:::drop-last-lf%\n")

ruleset(name="GElogs") {
        action(type="omfwd" Target="fcgateway" Port="514" Protocol="tcp" Template="GElogs")
        stop
}

input(type="imfile" File="/var/spool/gridscheduler/execd/$host/messages" Tag="GElogs" Ruleset="GElogs")
EOF


#restart service
systemctl restart rsyslog
