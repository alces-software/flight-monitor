#Grab bin from hub
curl "http://hub/resources/metrics/lustre_exporter"


#Run setup on node(s) remotely
HOST=$1
pdsh -w -N $HOST "curl http://fcgateway/lustre_exporter && curl http://fcgateway/resources/vmsetup/lustreExporterSetup"
#(/opt/zabbix/srv/resources/)
