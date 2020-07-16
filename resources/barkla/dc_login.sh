#!/bin/bash

d=$(date +%d)

RED='\033[0;31m'
NC='\033[0m'

function check_login_uptime {
if log_uptime=$(pdsh -g login "cat /proc/uptime |awk '{print int(\$1/3600)}' |awk '\$1<72 { \$1 = \"Uptime is: \" \$1 \" hours\" ; print}'") && [ -z "$log_uptime" ]
then
        echo "Login Uptimes are OK - above 72 hours"
else
        echo "Login Uptime Check Failed"
        echo -e "$log_uptime"
fi
}

function check_viz_uptime {
if viz_uptime=$(pdsh -g viz "cat /proc/uptime |awk '{print int(\$1/3600)}' |awk '\$1<72 { \$1 = \"Uptime is: \" \$1 \" hours\" ; print}'") && [ -z "$viz_uptime" ]
then
        echo "Viz Uptimes are OK - above 72 hours"
else
        echo "Viz Uptime Check Failed"
        echo -e "$viz_uptime"
fi
}

function check_users {
login_users=$(pdsh -g login "uptime | grep -i users |awk '{ \$6 = \"Number of users logged in is: \" \$6 ; print \$6 }'")
viz_users=$(pdsh -g viz "uptime | grep -i users |awk '{ \$6 = \"Number of users logged in is: \" \$6 ; print \$6 }'")
echo -e "$login_users"
echo -e "$viz_users"
}

function check_tmp {
if tmp_space=$(pdsh -g login "df -h /tmp |awk '{print \$5}' |grep -v "Use%" |sed s/%//g |awk '\$1>80 { \$1 = \"Tmp filesystem usage is: \" \$1 \"%\" ; print}'") && [ -z "$tmp_space" ]
then
        echo "Space on /tmp on logins is ok - Less than 80%"
else
        echo "/tmp filesystem check on logins failed"
        echo -e "$tmp_space"
fi

if viz_tmp_space=$(pdsh -g viz "df -h /tmp |awk '{print \$5}' |grep -v "Use%" |sed s/%//g |awk '\$1>80 { \$1 = \"Tmp filesystem usage is: \" \$1 \"%\" ; print}'") && [ -z "$viz_tmp_space" ]
then
        echo "Space on /tmp on viz is ok - Less than 80%"
else
        echo "/tmp filesystem check on viz failed"
        echo -e "$viz_tmp_space"
fi
}

function check_root {
if login_root_space=$(pdsh -g login "df -h / |awk '{print \$5}' |grep -v "Use%" |sed s/%//g |awk '\$1>80 { \$1 = \"Root filesystem usage is: \" \$1 \"%\" ; print}'") && [ -z "$login_root_space" ]
then
        echo "Space on / on logins is ok - Less than 80%"
else
        echo "/ filesystem check on logins failed"
        echo -e "$login_root_space"
fi

if viz_root_space=$(pdsh -g viz "df -h / |awk '{print \$5}' |grep -v "Use%" |sed s/%//g |awk '\$1>80 { \$1 = \"Root filesystem usage is: \" \$1 \"%\" ; print}'") && [ -z "$viz_root_space" ]
then
        echo "Space on / on viz is ok - Less than 80%"
else
        echo "/ filesystem check on viz failed"
        echo -e "$viz_root_space"
fi

}

function check_var {
if login_var_space=$(pdsh -g login "df -h /var |awk '{print \$5}' |grep -v "Use%" |sed s/%//g |awk '\$1>80 { \$1 = \"Var filesystem usage is: \" \$1 \"%\" ; print}'") && [ -z "$login_var_space" ]
then
        echo "Space on /var on logins is ok - Less than 80%"
else
        echo "/var filesystem check on logins failed"
        echo -e "$login_var_space"
fi

if viz_var_space=$(pdsh -g viz "df -h /var |awk '{print \$5}' |grep -v "Use%" |sed s/%//g |awk '\$1>80 { \$1 = \"Var filesystem usage is: \" \$1 \"%\" ; print}'") && [ -z "$viz_var_space" ]
then
        echo "Space on /var on viz is ok - Less than 80%"
else
        echo "/var filesystem check on viz failed"
        echo -e "$viz_var_space"
fi
}

function check_mem {
if login_mem=$(pdsh -g login "free -m |grep Mem: |awk '{print int(\$3/\$2*100)}' |awk '\$1>80 { \$1 = \"Mem used is: \" \$1 \"%\" ; print}'") && [ -z "$login_mem" ]
then
	echo "Memory Usage on logins is ok - Less than 80%"
else
	echo "Memory Usage on logins check failed"
	echo -e "$login_mem"
fi

if viz_mem=$(pdsh -g viz "free -m |grep Mem: |awk '{print int(\$3/\$2*100)}' |awk '\$1>80 { \$1 = \"Mem used is: \" \$1 \"%\" ; print}'") && [ -z "$viz_mem" ]
then
        echo "Memory Usage on viz is ok - Less than 80%"
else
        echo "Memory Usage on viz check failed"
        echo -e "$viz_mem"
fi
}

function check_swap {
if login_swap=$(pdsh -g login "free -m |grep Swap: |awk '{print int(\$3/\$2*100)}' |awk '\$1>80 { \$1 = \"Swap used is: \" \$1 \"%\" ; print}'") && [ -z "$login_swap" ]
then
        echo "Swap Usage on logins is ok - Less than 80%"
else
        echo "Swap Usage on logins check failed"
        echo -e "$login_swap"
fi

if viz_swap=$(pdsh -g viz "free -m |grep Mem: |awk '{print int(\$3/\$2*100)}' |awk '\$1>80 { \$1 = \"Swap used is: \" \$1 \"%\" ; print}'") && [ -z "$viz_swap" ]
then
        echo "Swap Usage on viz is ok - Less than 80%"
else
        echo "Swap Usage on viz check failed"
        echo -e "$viz_swap"
fi
}

function run_check {
echo -e "${RED}Running checks${NC}"
check_login_uptime
check_viz_uptime
check_users
check_tmp
check_root
check_var
check_var_viz
check_mem
check_swap
}

run_check