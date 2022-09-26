#removes system log forwarding to fcgateway
rm -f '/etc/rsyslog.d/99-remote-messages.conf'

#removes infra01 specific routing
rm -f '/etc/rsyslog.d/01-krb5kdc.conf'

#restart service
systemctl restart rsyslog
