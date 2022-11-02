#set up exporter in /opt
mkdir /opt/gpfs-exporter
wget http://fcgateway/resources/metrics/gpfs_exporter -O /opt/gpfs-exporter/gpfs_exporter
chmod ug+x /opt/gpfs-exporter/gpfs_exporter

#create service
cat << EOF > /usr/lib/systemd/system/gpfs-exporter.service
[Unit]
Description=GPFS Exporter
After=network.target

[Service]
WorkingDirectory=/opt/gpfs-exporter
ExecStart=/opt/gpfs-exporter/gpfs_exporter --collector.mount.mounts="/mmfs1" --collector.mmhealth
KillMode=process
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now gpfs-exporter

