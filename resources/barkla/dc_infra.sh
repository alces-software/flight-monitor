#!/bin/bash

d=$(date +%d)

RED='\033[0;31m'
NC='\033[0m'
 
 
function infra_uptime {
if infra_uptimes=$(pdsh -g infra "cat /proc/uptime |awk '{print int(\$1/3600)}' |awk '\$1<72 { \$1 = \"Uptime is: \" \$1 \" hours\" ; print}'") && [ -z "$infra_uptimes" ]
then
        echo "Infra Uptime are OK - above 72 hours"
else
        echo "Infra Uptime Check Failed"
        echo -e "$infra_uptimes"
fi
}

function check_mem {
if infra_mem=$(pdsh -g infra "free -m |grep Mem: |awk '{print int(\$3/\$2*100)}' |awk '\$1>80 { \$1 = \"Mem used is: \" \$1 \"%\" ; print}'") && [ -z "$infra_mem" ]
then
	echo "Memory Usage on infra is ok - Less than 80%"
else
	echo "Memory Usage on infra check failed"
	echo -e "$infra_mem"
fi
}

function check_swap {
if infra_swap=$(pdsh -g infra "free -m |grep Swap: |awk '{print int(\$3/\$2*100)}' |awk '\$1>80 { \$1 = \"Swap used is: \" \$1 \"%\" ; print}'") && [ -z "$infra_swap" ]
then
        echo "Swap Usage on infra is ok - Less than 80%"
else
        echo "Swap Usage on infra check failed"
        echo -e "$infra_swap"
fi
}

function run_check {
echo -e "${RED}Running checks${NC}"
infra_uptime
check_mem
check_swap
}

run_check