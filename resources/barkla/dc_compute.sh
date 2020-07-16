#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

function check_ib {
if compute_ib=$(pdsh -f1 -g cn "ibstatus |grep 'state' "|grep -v 'ACTIVE\|LinkUp') && [ -z "$compute_ib" ]
then
        echo "Compute IB are OK"
else
        echo "Compute IB Check Failed"
        echo -e "$compute_ib"
fi
}

function check_disk_space {
if compute_root_space=$(pdsh -g cn "df -h / |awk '{print \$5}' |grep -v "Use%" |sed s/%//g |awk '\$1>80 { \$1 = \"Root filesystem usage is: \" \$1 \"%\" ; print}'") && [ -z "$compute_root_space" ]
then
        echo "Space on / on compute is ok - Less than 80%"
else
        echo "/ filesystem check on compute failed"
        echo -e "$compute_root_space"
fi

if compute_var_space=$(pdsh -g cn "df -h /var |awk '{print \$5}' |grep -v "Use%" |sed s/%//g |awk '\$1>80 { \$1 = \"Var filesystem usage is: \" \$1 \"%\" ; print}'") && [ -z "$compute_var_space" ]
then
        echo "Space on /var on compute is ok - Less than 80%"
else
        echo "/var filesystem check on compute failed"
        echo -e "$compute_var_space"
fi

if compute_tmp_space=$(pdsh -g cn "df -h /tmp |awk '{print \$5}' |grep -v "Use%" |sed s/%//g |awk '\$1>80 { \$1 = \"Tmp filesystem usage is: \" \$1 \"%\" ; print}'") && [ -z "$compute_tmp_space" ]
then
        echo "Space on /tmp on compute is ok - Less than 80%"
else
        echo "/tmp filesystem check on compute failed"
        echo -e "$compute_tmp_space"
fi

}

function compute_uptime {
if cn_uptime=$(pdsh -g cn "cat /proc/uptime |awk '{print int(\$1/3600)}' |awk '\$1<72 { \$1 = \"Uptime is: \" \$1 \" hours\" ; print}'") && [ -z "$cn_uptime" ]
then
        echo "Compute Uptimes are OK - above 72 hours"
else
        echo "Compute Uptime Check Failed"
        echo -e "$cn_uptime"
fi
}


function compute_zombies {
if cn_zombie=$(bash /root/check_zombie.sh) && [ -z "$cn_zombie" ]
then
        echo "Compute Zombie Check is OK"
else
        echo "Compute Zobmie Check Failed"
        echo -e "$cn_zombie"
fi
}

function check_ipmi {
if cn_ipmi=$(metal ipmi -g cn -k 'sel elist' |grep -v "Log area reset/cleared") && [ -z "$cn_ipmi" ]
then
        echo "Compute IPMI Check is OK"
else
        echo "Compute IPMI Check Failed"
        echo -e "$cn_ipmi"
fi
}

function run_check {
echo -e "${RED}Running checks${NC}"
check_ib
check_disk_space
compute_uptime
compute_zombies
check_ipmi
}

run_check