#!/bin/bash

display_usage() {
  echo -e "\nUsage: $0 [gender]\n"
}

if [ $# -lt 1 ]
then
	display_usage
	exit 1
fi

GENDER=$1

ssh root@controller "pdsh -g $GENDER 'curl http://10.10.0.2/resources/salt/salt_minion.sh | bash'"
