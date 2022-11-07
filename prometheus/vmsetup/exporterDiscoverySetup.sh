#!/bin/bash

network="10.10.0.0/16"

# Check vmagent is installed
if [ ! -d "/opt/vmagent" ] ; then
	echo "Error: Install vmagent first."
	exit 1
fi

cd /opt/vmagent/bin
wget --no-check-certificate http://hub/resources/metrics/prometheus-net-discovery -O /opt/vmagent/bin/prometheus-net-discovery
chmod +x /opt/vmagent/bin/prometheus-net-discovery

cat << EOF > /usr/lib/systemd/system/exporter-discovery.service
[Unit]
Description=Prometheus Export Discovery Service
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/vmagent
ExecStart=/opt/vmagent/bin/prometheus-net-discovery --networks $network --filesdpath /opt/vmagent/targets/ --interval 24h

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now exporter-discovery
