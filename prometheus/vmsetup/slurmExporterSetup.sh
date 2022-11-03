#!/bin/bash

mkdir /opt/slurm-exporter
cd /opt/slurm-exporter
wget http://fcgateway/resources/metrics/slurm-exporter
chmod +x /opt/slurm-exporter/slurm-exporter

cat << EOF > /usr/lib/systemd/system/slurm-exporter.service
[Unit]
Description=Prometheus SLURM Exporter

[Service]
ExecStart=/opt/slurm-exporter/slurm-exporter -p 9101 -jN
Restart=always
RestartSec=15

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now slurm-exporter
