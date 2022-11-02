mkdir /opt/lustre-exporter
mv lustre_exporter /opt/lustre-exporter/lustre-exporter


cat << EOF > /usr/lib/systemd/system/lustre-exporter.service
[Unit]
Description=Lustre exporter service
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/lustre-exporter
ExecStart=/opt/lustre-exporter/lustre_exporter --web.listen-address=:9169 --log.level=error --collector.health=disabled --collector.generic=disabled --collector.ost=disabled --collector.mdt=disabled --collector.mgs=disabled --collector.mds=disabled --collector.client=extended --collector.lnet=disabled

[Install]
WantedBy=multi-user.target
EOF

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now slurm-exporter
