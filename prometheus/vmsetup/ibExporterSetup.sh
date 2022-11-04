#!/bin/bash

cd /tmp
wget http://github.com/treydock/infiniband_exporter/releases/download/v0.3.1/infiniband_exporter-0.3.1.linux-amd64.tar.gz
tar -xzvf infiniband_exporter-0.3.1.linux-amd64.tar.gz

mkdir /opt/infiniband_exporter
mv /tmp/infiniband_exporter-0.3.1.linux-amd64/infiniband_exporter /opt/infiniband_exporter
chmod +x /opt/infiniband_exporter/infiniband_exporter
rm -f tmp/infiniband_exporter-0.3.1.linux-amd64.tar.gz

cat << EOF > /usr/lib/systemd/system/infiniband_exporter.service
[Unit]
Description=Infiniband exporter service
Wants=basic.target
After=basic.target network.target

[Service]
Type=simple
WorkingDirectory=/opt/infiniband_exporter
ExecStart=/opt/infiniband_exporter --web.listen-address=:9315 --collector.hca --collector.switch
KillMode=process
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now infiniband_exporter
