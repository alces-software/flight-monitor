#Grab bin from hub
curl "http://hub/resources/metrics/slurm-exporter"


#Run setup on node(s) remotely
HOST=$1
pdsh -w -N $HOST "curl http://fcgateway/slurm-exporter && curl http://fcgateway/resources/vmsetup/slurmExporterSetup"
#(/opt/zabbix/srv/resources/)
