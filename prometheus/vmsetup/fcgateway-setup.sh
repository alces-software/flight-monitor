#!/bin/bash

mkdir -p /opt/zabbix/srv/resources/metrics
cd /opt/zabbix/srv/resources/metrics

# Grab binaries from hub
wget --no-verbose https://hub.fcops.alces-flight.com/resources/metrics/slurm_exporter --no-check-certificate
wget --no-verbose https://hub.fcops.alces-flight.com/resources/metrics/lustre_exporter --no-check-certificate
wget --no-verbose https://hub.fcops.alces-flight.com/resources/metrics/gpfs_exporter --no-check-certificate
wget --no-verbose https://hub.fcops.alces-flight.com/resources/metrics/nvidia_gpu_prometheus_exporter --no-check-certificate
wget --no-verbose https://hub.fcops.alces-flight.com/resources/metrics/snmp_exporter --no-check-certificate

# Grab exporter install scripts from git
wget --no-verbose https://raw.githubusercontent.com/alces-software/flight-monitor/master/prometheus/vmsetup/vmagentSetup.sh
wget --no-verbose https://raw.githubusercontent.com/alces-software/flight-monitor/master/prometheus/vmsetup/snmpExporterSetup.sh
wget --no-verbose https://raw.githubusercontent.com/alces-software/flight-monitor/master/prometheus/vmsetup/nodeExporterSetup.sh
wget --no-verbose https://raw.githubusercontent.com/alces-software/flight-monitor/master/prometheus/vmsetup/slurmExporterSetup.sh
wget --no-verbose https://raw.githubusercontent.com/alces-software/flight-monitor/master/prometheus/vmsetup/gpfsExporterSetup.sh
wget --no-verbose https://raw.githubusercontent.com/alces-software/flight-monitor/master/prometheus/vmsetup/ibExporterSetup.sh
wget --no-verbose https://raw.githubusercontent.com/alces-software/flight-monitor/master/prometheus/vmsetup/lustreExporterSetup.sh
wget --no-verbose https://raw.githubusercontent.com/alces-software/flight-monitor/master/prometheus/vmsetup/lustreExporterSetupMDS.sh

chown -R fcops:fcops /opt/zabbix/srv/resources/metrics

# Install vmagent
bash /opt/zabbix/srv/resources/metrics/vmagentSetup.sh

# Install node and snmp exporter
bash /opt/zabbix/srv/resources/metrics/nodeExporterSetup.sh
bash /opt/zabbix/srv/resources/metrics/snmpExporterSetup.sh
