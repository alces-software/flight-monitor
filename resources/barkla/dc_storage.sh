#!/bin/bash

d=$(date +%d)

RED='\033[0;31m'
NC='\033[0m'

# Converts uptime to hours and flags nodes with less than 72 hour uptime
echo -e "${RED}check for reboots${NC}" ; pdsh -g storage "cat /proc/uptime |awk '{print int(\$1/3600)}'" |awk '$2<72' ; 



function check_lustre_capacity {
if lustre_capacity=$(pdsh -w login1 "lfs df -h |grep -i file |awk '{print \$5}' |grep -v "Use%" |sed s/%//g |awk '\$1>80 { \$1 = \"Lustre filesystem usage is: \" \$1 \"%\" ; print}'") && [ -z "$lustre_capacity" ]
then
        echo "lustre capacity is ok - Less than 80%"
else
        echo "lustre capacity check failed"
        echo -e "$lustre_capacity"
fi

if lustre_capacity_inodes=$(pdsh -w login1 "lfs df -hi |grep -i file |awk '{print \$5}' |grep -v "Use%" |sed s/%//g |awk '\$1>80 { \$1 = \"Lustre filesystem usage is: \" \$1 \"%\" ; print}'") && [ -z "$lustre_capacity" ]
then
        echo "lustre capacity (inodes) is ok - Less than 80%"
else
        echo "lustre capacity (inodes) check failed"
        echo -e "$lustre_capacity_inodes"
fi
}

function check_nfs_capacity {
if user_capacity=$(pdsh -w login1 "df -h /users |awk '{print \$5}' |grep -v "Use%" |sed s/%//g |awk '\$1>1 { \$1 = \"User filesystem usage is: \" \$1 \"%\" ; print}'") && [ -z "$user_capacity" ]
then
        echo "/users capacity is ok - Less than 80%"
else
        echo "/users capacity check failed"
        echo -e "$user_capacity"
fi

if gridware_capacity=$(pdsh -w login1 "df -h /opt/gridware |awk '{print \$5}' |grep -v "Use%" |sed s/%//g |awk '\$1>1 { \$1 = \"/opt/gridware filesystem usage is: \" \$1 \"%\" ; print}'") && [ -z "$gridware_capacity" ]
then
        echo "/opt/gridware capacity is ok - Less than 80%"
else
        echo "/opt/gridware capacity check failed"
        echo -e "$gridware_capacity"
fi

if service_capacity=$(pdsh -w login1 "df -h /opt/service |awk '{print \$5}' |grep -v "Use%" |sed s/%//g |awk '\$1>1 { \$1 = \"/opt/service filesystem usage is: \" \$1 \"%\" ; print}'") && [ -z "$service_capacity" ]
then
        echo "/opt/service capacity is ok - Less than 80%"
else
        echo "/opt/service capacity check failed"
        echo -e "$service_capacity"
fi

if apps_capacity=$(pdsh -w login1 "df -h /opt/apps |awk '{print \$5}' |grep -v "Use%" |sed s/%//g |awk '\$1>1 { \$1 = \"/opt/apps filesystem usage is: \" \$1 \"%\" ; print}'") && [ -z "$apps_capacity" ]
then
        echo "/opt/apps capacity is ok - Less than 80%"
else
        echo "/opt/apps capacity check failed"
        echo -e "$apps_capacity"
fi
}

function check_storage_disk {
if storage_root_space=$(pdsh -g storage "df -h / |awk '{print \$5}' |grep -v "Use%" |sed s/%//g |awk '\$1>80 { \$1 = \"Root filesystem usage is: \" \$1 \"%\" ; print}'") && [ -z "$storage_root_space" ]
then
        echo "Space on / on storage is ok - Less than 80%"
else
        echo "/ filesystem check on storage failed"
        echo -e "$storage_root_space"
fi

if storage_tmp_space=$(pdsh -g storage "df -h /tmp |awk '{print \$5}' |grep -v "Use%" |sed s/%//g |awk '\$1>80 { \$1 = \"tmp filesystem usage is: \" \$1 \"%\" ; print}'") && [ -z "$storage_tmp_space" ]
then
        echo "Space on /tmp on storage is ok - Less than 80%"
else
        echo "/tmp filesystem check on storage failed"
        echo -e "$storage_tmp_space"
fi

if storage_var_space=$(pdsh -g storage "df -h /var |awk '{print \$5}' |grep -v "Use%" |sed s/%//g |awk '\$1>80 { \$1 = \"Var filesystem usage is: \" \$1 \"%\" ; print}'") && [ -z "$storage_var_space" ]
then
        echo "Space on /var on storage is ok - Less than 80%"
else
        echo "/var filesystem check on storage failed"
        echo -e "$storage_var_space"
fi
}

function check_data {
if data1_space=$(pdsh -w login1 "df -h /mnt/data1 |awk '{print \$5}' |grep -v "Use%" |sed s/%//g |awk '\$1>80 { \$1 = \"data1 filesystem usage is: \" \$1 \"%\" ; print}'") && [ -z "$data1_space" ]
then
        echo "Space on /mnt/data1 is ok - Less than 80%"
else
        echo "/mnt/data1 filesystem check failed"
        echo -e "$data1_space"
fi

if data2_space=$(pdsh -w login1 "df -h /mnt/data2 |awk '{print \$5}' |grep -v "Use%" |sed s/%//g |awk '\$1>80 { \$1 = \"data2 filesystem usage is: \" \$1 \"%\" ; print}'") && [ -z "$data2_space" ]
then
        echo "Space on /mnt/data2 is ok - Less than 80%"
else
        echo "/mnt/data2 filesystem check failed"
        echo -e "$data2_space"
fi
}

function check_logicaldrives {
if ldinfo=$(pdsh -g storage '/opt/MegaRAID/MegaCli/MegaCli64 -ldinfo -lall -aall' | grep State |grep -v 'Optimal') && [ -z "$ldinfo" ]
then
        echo "Logical Drives are reporting as healthy"
else
        echo "Logical Drive check failed"
        echo -e "$ldinfo"
fi
} 

function user_quotas {
if user_qt=$(pdsh -w storage1 "repquota -s /export/users | awk '\$2!=\"--\"'") && [ -z "$user_qt"]
then
        echo "No users are currently over quota"
else
        echo "User quota check failed"
        echo -e "$user_qt"
fi
}

function run_check {
echo -e "${RED}Running checks${NC}"
check_lustre_capacity
check_nfs_capacity
check_storage_disk
check_data
check_logicaldrives
user_quotas
}

run_check