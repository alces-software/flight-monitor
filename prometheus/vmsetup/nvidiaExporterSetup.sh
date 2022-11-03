#!/bin/bash

mkdir /opt/nvidia-exporter
cd /opt/nvidia-exporter
wget http://fcgateway/resources/metrics/nvidia_gpu_prometheus_exporter
chmod +x /opt/nvidia-exporter/nvidia_gpu_prometheus_exporter

cat << EOF > /usr/lib/systemd/system/nvidia-exporter.service
[Unit]
Description=NVIDIA Exporter
After=network.target

[Service]
WorkingDirectory=/opt/nvidia-exporter
ExecStart=/opt/nvidia-exporter/nvidia_gpu_prometheus_exporter
KillMode=process
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now nvidia-exporter
