#!/bin/bash

#Add flight-graphs to hosts
cat << EOF >> /etc/hosts
10.178.0.169  flight-graphs.fcops.alces-flight.com flight-graphs
EOF

#Install vmagent
mkdir /tmp/vmetrics
cd /tmp/vmetrics/
wget https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v1.82.0/vmutils-linux-amd64-v1.82.0.tar.gz
tar -xzvf vmutils-linux-amd64-v1.82.0.tar.gz

mkdir -p /opt/vmagent/{bin,configs,targets}
cp /tmp/vmetrics/vmagent-prod /opt/vmagent/bin/vmagent
rm -rf /tmp/vmetrics/

#Create Prometheus config
cat << EOF > /opt/vmagent/prometheus.yml
global:
  scrape_interval: 15s # scrape every 15s by default

scrape_config_files:
- configs/*.yml
EOF


#Create configs for exporters
cat << 'EOF' > /opt/vmagent/configs/vmagent.yml
# vmagent
  - job_name: 'vmagent'
    static_configs:
      - targets:
          - fcgateway:8429
    # Remove port from hostname label
    relabel_configs:
      - source_labels: [__address__]
        target_label: instance
        regex: '([^:]+)(:[0-9]+)?'
        replacement: '${1}'
EOF

cat << 'EOF' > /opt/vmagent/configs/node-exporter.yml
# node-exporter
  - job_name: 'node'
    file_sd_configs:
      - files:
        - '/opt/vmagent/targets/node-exporter.yml'
    # Remove port from hostname label
    relabel_configs:
      - source_labels: [__address__]
        target_label: instance
        regex: '([^:]+)(:[0-9]+)?'
        replacement: '${1}'
EOF

#Add targets to relevant target files
cat << EOF > /opt/vmagent/targets/node-exporter.yml
---
- targets:
  - fcgateway:9100
EOF

#Create and start service
export CLUSTER=$(hostname -f | cut -d. -f3)

cat << EOF > /usr/lib/systemd/system/vmagent.service
[Unit]
Description=Victoria Metrics agent service
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/vmagent
ExecStart=/opt/vmagent/bin/vmagent --promscrape.config=/opt/vmagent/prometheus.yml --remoteWrite.url=http://flight-graphs:8429/insert/0/prometheus/api/v1/write --remoteWrite.label=cluster=$CLUSTER --loggerLevel=ERROR --remoteWrite.maxDiskUsagePerURL=5GB
KillMode=control-group

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now vmagent
