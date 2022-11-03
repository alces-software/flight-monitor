#!/bin/bash

#Install necessary packages to /tmp
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.4.0/node_exporter-1.4.0.linux-amd64.tar.gz
tar -xzvf /tmp/node_exporter-1.4.0.linux-amd64.tar.gz

#move bin to new folder
mv /tmp/node_exporter-1.4.0.linux-amd64 /opt/node-exporter

#Create service
cat << EOF > /usr/lib/systemd/system/node-exporter.service
[Unit]
Description=Node exporter service
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/node-exporter
ExecStart=/opt/node-exporter/node_exporter --log.level=error --collector.filesystem.ignored-mount-points='^/(run|dev|proc|sys|var/lib/docker/(containers|devicemapper)/.+)($|/)'
KillMode=control-group

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now node-exporter

#Clear leftover files in /tmp
rm -f /tmp/node_exporter-1.4.0.linux-amd64.tar.gz
