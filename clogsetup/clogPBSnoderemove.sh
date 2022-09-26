#removes system log forwarding to fcgateway
rm -rf '/etc/rsyslog.d/99-remote-messages.conf'

#removes ipa log forwarding
if [[ "$HOSTNAME" = infra01* ]]; then
rm -rf'/etc/rsyslog.d/01-krb5kdc.conf'
fi

#removes PBS sched_log forwarding
if [[ "$HOSTNAME" = infra02* ]]; then
rm -rf '/etc/rsyslog.d/02-sched_logs.conf'

#removes PBS comm_log forwarding
#rm -rf '/etc/rsyslog.d/03-comm_logs.conf'
#
#removes PBS server_log forwarding
#rm -rf '/etc/rsyslog.d/04-server_logs.conf'

fi

#removes PBS mom_log forwarding
rm -rf '/etc/rsyslog.d/05-momlogs.conf'

#restart service
systemctl restart rsyslog
