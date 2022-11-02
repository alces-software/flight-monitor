#!/bin/bash

if [ $# -lt 1 ]
then
	echo "Usage: bash setup.sh [node(s)]
	exit 1
fi

HOST=$1

pdsh -w -N $HOST "curl http://fcgateway/resources/vmsetup/nodeExporterSetup"

bash slurmExporterCurl.sh $HOST

bash gpfsExporterCurl.sh $HOST

bash lustreExporterCurl.sh $HOST

pdsh -w -N $HOST "curl http://fcgateway/resources/vmsetup/vmagentSetup.sh"

echo -e "Setup complete\nEnsure that you run lustreExporterSetupOSS/MDS for any OSS and MDS nodes"
