#Grab bin from hub
curl "http://hub/resources/metrics/gpfs_exporter"

#Run setup on node(s) remotely
HOST=$1
pdsh -w -N $HOST "curl http://fcgateway/gpfs_exporter && curl http://fcgateway/resources/vmsetup/gpfsExporterSetup"
#(/opt/zabbix/srv/resources/)
