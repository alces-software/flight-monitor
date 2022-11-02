mkdir /opt/lustre-exporter
mv lustre_exporter /opt/lustre-exporter/lustre-exporter


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

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now slurm-exporter
