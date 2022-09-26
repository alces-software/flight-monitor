#removes system log forwarding to fcgateway
rm -rf '/etc/rsyslog.d/99-remote-messages.conf'

#removes ipa log routing
if [[ "$HOSTNAME" = infra01* ]]; then
rm -rf '/etc/rsyslog.d/01-krb5kdc.conf'

#removes GE qmaster log forwarding
elif [[ "$HOSTNAME" = infra02* ]]; then
rm -rf '/etc/rsyslog.d/02-qmaster.conf'
fi

#removes GE log forwarding
rm -rf '/etc/rsyslog.d/03-GElogs.conf'

#restart service
systemctl restart rsyslog
