#!/bin/bash

# a script for the controller section of a daily check

d=$(date +%d)

RED='\033[0;31m'
NC='\033[0m' 

function check_uptime {
if cont_uptime=$(cat /proc/uptime |awk '{print int($1/3600)}' |awk '$1<72 { $1 = "Uptime is: " $1 " hours" ; print}') && [ -z "$cont_uptime" ]
then
        echo "Controller Uptime is OK - above 72 hours"
else
        echo "Controller Uptime Check Failed"
        echo -e "$cont_uptime"
fi
}

function check_mem {
if cont_mem=$(free -m |grep Mem: |awk '{print int($3/$2*100)}' |awk '$1>80 { $1 = "Mem used is: " $1 "%" ; print}') && [ -z "$cont_mem" ]
then
	echo "Memory Usage on controller is ok - Less than 80%"
else
	echo "Memory Usage on controller check failed"
	echo -e "$cont_mem"
fi

if cont_swap=$(free -m |grep Swap: |awk '{print int($3/$2*100)}' |awk '$1>80 { $1 = "Mem used is: " $1 "%" ; print}') && [ -z "$cont_swap" ]
then
	echo "Swap Usage on controller is ok - Less than 80%"
else
	echo "Swap Usage on controller check failed"
	echo -e "$cont_swap"
fi
}

function check_disk_space {
if root_space=$(df -h / |awk '{print $5}' |grep -v "Use%" |sed s/%//g |awk '$1>80 { $1 = "Root filesystem usage is: " $1 "%" ; print}') && [ -z "$root_space" ]
then
        echo "Space on / on controller is ok - Less than 80%"
else
        echo "/ filesystem check on controller failed"
        echo -e "$root_space"
fi

if boot_space=$(df -h /boot |awk '{print $5}' |grep -v "Use%" |sed s/%//g |awk '$1>80 { $1 = "Boot filesystem usage is: " $1 "%" ; print}') && [ -z "$boot_space" ]
then
        echo "Space on /boot on controller is ok - Less than 80%"
else
        echo "/boot filesystem check on controller failed"
        echo -e "$boot_space"
fi
}

function run_check {
echo -e "${RED}Running checks${NC}"
check_uptime
check_mem
check_disk_space
}

run_check
