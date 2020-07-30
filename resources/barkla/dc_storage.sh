#!/bin/bash

d=$(date +%d)

RED='\033[0;31m'
NC='\033[0m'

export uptime=$(pdsh -g storage uptime) ; 

echo -e "${RED}### check storage uptime/reboots:${NC}" ; echo '```'"$uptime"'```' ;

export pfcapacity=$(pdsh -w login1 lfs df -h | grep -i file) ; 

echo -e "${RED}### check parallel filesystem capacity:${NC}" ; echo '```'"$pfcapacity"'```' ;

export inodes=$(pdsh -w login1 lfs df -hi | grep -i file) ; 

echo -e "${RED}### check parallel filesystem inodes:${NC}" ; echo '```'"$inodes"'```' ;

export users=$(pdsh -w login1 df -h /users) ; 

echo -e "${RED}### check user filesystems:${NC}" ; echo '```'"$users"'```' ; 

export gridware=$(pdsh -w login1 df -h /opt/gridware) ; 

echo -e "${RED}### check user filesystems gridware:${NC}" ; echo '```'"$gridware"'```' ; 

export service=$(pdsh -w login1 df -h /opt/service) ; 

echo -e "${RED}### check user filesystems service:${NC}" ; echo '```'"$service"'```' ; 

export apps=$(pdsh -w login1 df -h /opt/apps) ; 

echo -e "${RED}### check user filesystems apps:${NC}" ; echo '```'"$apps"'```' ; 

export disk=$(pdsh -g storage 'df -h / /tmp /var') ; 

echo -e "${RED}### check disk space available:${NC}" ; echo '```'"$disk"'```' ;  

export data1=$(pdsh -w login1 df -h /mnt/data1) ; 

echo -e "${RED}### check volume data1:${NC}" ; echo '```'"$data1"'```' ;

export data2=$(pdsh -w login1 df -h /mnt/data2) ; 

echo -e "${RED}### check volume data2:${NC}" ; echo '```'"$data2"'```' ;  

export data3=$(pdsh -w login1 df -h /mnt/data3) ; 

echo -e "${RED}### check volume data3:${NC}" ; echo '```'"$data3"'```' ;  

export arrays=$(pdsh -g storage '/opt/MegaRAID/MegaCli/MegaCli64 -ldinfo -lall -aall' | grep State) ; 

echo -e "${RED}### check disk status in arrays:${NC}" ; echo '```'"$arrays"'```' ;  

export quota=$(pdsh -w storage1 repquota -s /export/users | grep +) ; 

echo -e "${RED}### check for users over quota:${NC}" ; echo '```'"$quota"'```' ; 

        
