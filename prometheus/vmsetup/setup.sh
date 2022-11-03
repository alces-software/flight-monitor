#!/bin/bash

if [ $# -lt 1 ]
then
	echo "Usage: bash setup.sh [node(s)]"
	exit 1
fi

HOST=$1
arr vHost=""
echo $(pdsh -w $HOST (hostname) | append port? )>> $vHost



bash nodeExporterSetup.sh #add gw to targets
pdsh -w -N $HOST "curl http://fcgateway/resources/vmsetup/nodeExporterSetup.sh" 
if [$? == 0]
then
	loop(vHost)
	format " - [i]:9100"
	cat << EOF >> /opt/vmagent/targets/node_exporter.yaml
	$vHost
EOF
fi

pdsh -w -N $HOST "curl http://fcgateway/gpfs_exporter && curl http://fcgateway/resources/vmsetup/gpfsExporterSetup.sh"
if [$? == 0]
then
        loop(vHost)
        format " - [i]:9100"
	cat << EOF >> /opt/vmagent/targets/gpfs_exporter.yaml
        $vHost #change port
EOF
fi

pdsh -w -N node01,node001,node0001 "curl http://fcgateway/resources/vmsetup/ibExporterSetup.sh"
if [$? == 0]
then         
	loop(vHost)
	format " - [i]:9100"
	cat << EOF >> /opt/vmagent/targets/ib_exporter.yaml
        $vHost #change port
EOF
fi

#reconsider
pdsh -w -N $HOST "curl http://fcgateway/lustre_exporter && curl http://fcgateway/resources/vmsetup/lustreExporterSetup.sh"
if [$? == 0]
then
        loop(vHost)
        format " - [i]:9169"
	cat << EOF >> /opt/vmagent/targets/lustre_exporter.yaml
        $vHost
EOF
fi

pdsh -w -N infra02 "curl http://fcgateway/slurm_exporter && curl http://fcgateway/resources/vmsetup/slurmExporterSetup.sh"
if [$? == 0]
then
        loop(vHost)
        format " - [i]:9101"
        echo $(pdsh -w infra02 "hostname" >> $vHost
        cat << EOF >> /opt/vmagent/targets/slurm_exporter.yaml
        $vHost
EOF
fi

bash vmagentSetup.sh

echo -e "Setup complete\nEnsure that you run lustreExporterSetupOSS/MDS for any OSS and MDS nodes"
