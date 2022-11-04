#set up exporter in /opt
mkdir /opt/gridengine-exporter
cd /opt/gridengine-exporter
wget http://fcgateway/resources/metrics/gridengine_exporter 
chmod ug+x gridengine_exporter

cat << EOF > config.yaml
test: false
port: 9081
pidfile: "/var/run/gridengine_exporter.pid"
sge:
  arch: "lx-amd64"
  cell: "etc"
  execd_port: 6445
  qmaster_port: 6444
  root: "/opt/service/gridscheduler"
  cluster_name: "cluster"
EOF


#create service
cat << EOF > /usr/lib/systemd/system/gridengine-exporter.service
[Unit]
Description=GridEngine Exporter
After=network.target

[Service]
WorkingDirectory=/opt/gridengine-exporter
ExecStart=/opt/gridengine-exporter/gridengine_exporter --config /opt/gridengine-exporter/config.yaml --collector.mount.mounts="/mmfs1" --collector.mmhealth
KillMode=process
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now gridengine-exporter

