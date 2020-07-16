#!/bin/bash

# a script for the master section of a daily check

d=$(date +%d)

RED='\033[0;31m'
NC='\033[0m'

function ha_check {
pdsh -w master1 "crm_mon -1 | grep -i 'last'"
}

function root_check {
if storage_root_space=$(pdsh -g masters "df -h / |awk '{print \$5}' |grep -v "Use%" |sed s/%//g |awk '\$1>80 { \$1 = \"Root filesystem usage is: \" \$1 \"%\" ; print}'") && [ -z "$masters_root_space" ]
then
        echo "Space on / on masters is ok - Less than 80%"
else
        echo "/ filesystem check on masters failed"
        echo -e "$masters_root_space"
fi
}

function check_ipmi {
if master_ipmi=$(pdsh -g masters "ipmitool sel elist |grep -v 'Log area reset/cleared') && [ -z "$master_ipmi" ]
then
        echo "Masters IPMI Check is OK"
else
        echo "Masters IPMI Check Failed"
        echo -e "$master_ipmi"
fi
}

function check_uptime {
if master_uptime=$(pdsh -g masters "cat /proc/uptime |awk '{print int(\$1/3600)}' |awk '\$1<72 { \$1 = \"Uptime is: \" \$1 \" hours\" ; print}'") && [ -z "$master_uptime" ]
then
        echo "Master Uptimes are OK - above 72 hours"
else
        echo "Master Uptime Check Failed"
        echo -e "$master_uptime"
fi
}

function check_dirvish {
pdsh -g masters "bash /root/check_dirvish"
}
  

function check_mem {
if master_mem=$(pdsh -g masters "free -m |grep Mem: |awk '{print int(\$3/\$2*100)}' |awk '\$1>80 { \$1 = \"Mem used is: \" \$1 \"%\" ; print}'") && [ -z "$masters_mem" ]
then
	echo "Memory Usage on masters is ok - Less than 80%"
else
	echo "Memory Usage on masters check failed"
	echo -e "$masters_mem"
fi

if master_swap=$(pdsh -g masters "free -m |grep Swap: |awk '{print int(\$3/\$2*100)}' |awk '\$1>80 { \$1 = \"Swap used is: \" \$1 \"%\" ; print}'") && [ -z "$masters_swap" ]
then
        echo "Swap Usage on masters is ok - Less than 80%"
else
        echo "Swap Usage on masters check failed"
        echo -e "$login_swap"
fi
}

function run_check {
echo -e "${RED}Running checks${NC}"
ha_check
root_check
check_ipmi
check_uptime
check_dirvish
check_mem
}

run_check
