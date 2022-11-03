#!/bin/bash

mkdir /opt/lustre-exporter
cd /opt/lustre-exporter
wget http://fcgateway/resources/metrics/lustre_exporter
chmod +x /opt/lustre-exporter/lustre_exporter

cat << EOF > /usr/lib/systemd/system/lustre-exporter.service
[Unit]
Description=Lustre exporter service
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/lustre-exporter
ExecStart=/opt/lustre-exporter/lustre_exporter --web.listen-address=:9169 --log.level=error --collector.health=extended --collector.generic=extended --collector.ost=disabled --collector.mdt=extended --collector.mgs=disabled --collector.mds=disabled --collector.client=disabled --collector.lnet=disabled

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now lustre-exporter
