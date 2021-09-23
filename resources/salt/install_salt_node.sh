#!/bin/bash

display_usage() {
  echo -e "\nUsage: $0 [node]\n"
}

if [ $# -lt 1 ]
then
	display_usage
	exit 1
fi

NODE=$1

ssh root@controller "pdsh -w $NODE 'curl http://10.10.0.2/resources/salt/salt_minion.sh | bash'"
