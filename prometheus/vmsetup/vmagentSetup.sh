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
        - '/opt/vmagent/targets/node.json'
    # Remove port from hostname label
    relabel_configs:
      - source_labels: [__address__]
        target_label: instance
        regex: '([^:]+)(:[0-9]+)?'
        replacement: '${1}'
EOF

cat << 'EOF' > /opt/vmagent/configs/lustre.yml
# lustre_exporter
  - job_name: 'lustre'
    scrape_interval: 1m
    file_sd_configs:
      - files:
        - '/opt/vmagent/targets/lustre.json'
    # Remove port from hostname label
    relabel_configs:
      - source_labels: [__address__]
        target_label: instance
        regex: '([^:]+)(:[0-9]+)?'
        replacement: '${1}'
EOF

cat << 'EOF' > /opt/vmagent/configs/gpfs.yml
# gpfs-exporter
  - job_name: 'gpfs'
    file_sd_configs:
      - files:
        - '/opt/vmagent/targets/gpfs.json'
    # Remove port from hostname label
    relabel_configs:
      - source_labels: [__address__]
        target_label: instance
        regex: '([^:]+)(:[0-9]+)?'
        replacement: '${1}'
EOF

cat << 'EOF' > /opt/vmagent/configs/infiniband.yml
# infiniband-exporter
  - job_name: 'infiniband'
    file_sd_configs:
      - files:
        - '/opt/vmagent/targets/infiniband.json'
    # Remove port from hostname label
    relabel_configs:
      - source_labels: [__address__]
        target_label: instance
        regex: '([^:]+)(:[0-9]+)?'
        replacement: '${1}'
EOF

cat << 'EOF' > /opt/vmagent/configs/slurm.yml
# slurm_exporter
  - job_name: 'slurm'
    scrape_interval: 1m
    file_sd_configs:
      - files:
        - '/opt/vmagent/targets/slurm.json'
    # Remove port from hostname label
    relabel_configs:
      - source_labels: [__address__]
        target_label: instance
        regex: '([^:]+)(:[0-9]+)?'
        replacement: '${1}'
EOF

cat << 'EOF' > /opt/vmagent/configs/nvidia.yml
  - job_name: 'nvidia'
    file_sd_configs:
      - files:
        - '/opt/vmagent/targets/nvidia.json'
    # Remove port from hostname label
    relabel_configs:
      - source_labels: [__address__]
        target_label: instance
        regex: '([^:]+)(:[0-9]+)?'
        replacement: '${1}'
EOF

cat << 'EOF' > /opt/vmagent/configs/idrac.yml
# snmp_exporter
  - job_name: "idrac"
    scrape_interval: 1m
    file_sd_configs:
      - files:
        - '/opt/vmagent/targets/idrac.yml'
    metrics_path: /snmp
    params:
      module: [dell_idrac]
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
        regex: '([^.]+)(.bmc)?'
        replacement: '${1}'
      - target_label: __address__
        replacement: 127.0.0.1:9116
EOF

cat << 'EOF' > /opt/vmagent/configs/ilo.yml
# snmp_exporter
  - job_name: "ilo"
    scrape_interval: 1m
    file_sd_configs:
      - files:
        - '/opt/vmagent/targets/ilo.yml'
    metrics_path: /snmp
    params:
      module: [hpe_ilo]
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
        regex: '([^.]+)(.bmc)?'
        replacement: '${1}'
      - target_label: __address__
        replacement: 127.0.0.1:9116
EOF

#Add targets to relevant target files
touch /opt/vmagent/targets/node.json
touch /opt/vmagent/targets/lustre.json
touch /opt/vmagent/targets/gpfs.json
touch /opt/vmagent/targets/infiniband.json
touch /opt/vmagent/targets/slurm.json
touch /opt/vmagent/targets/nvidia.json

cat << EOF > /opt/vmagent/targets/idrac.yml
---
- targets:
EOF

cat << EOF > /opt/vmagent/targets/ilo.yml
---
- targets:
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
