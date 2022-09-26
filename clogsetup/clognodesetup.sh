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
fi

#restart service
systemctl restart rsyslog
