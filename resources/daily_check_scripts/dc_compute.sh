#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}check ib link status${NC}" ; pdsh -f1 -g cn 'ibstatus' ; 

#echo -e "${RED}check compute local disk space${NC}" ; pdsh -g cn 'df -h / /tmp /var' ; 
# Prints filesystem and usage col, removes % and flags if above 80% usage
echo -e "${RED}check compute local disk space${NC}" ; pdsh -g cn "df -h / /tmp /var |awk '{print \$1,\$5}'" |sed s/%//g |awk '$3>80' |grep -v "Filesystem Use" ;

#echo -e "${RED}check for reboots${NC}" ; pdsh -g cn uptime ; 
# Converts uptime to hours and flags nodes with less than 72 hour uptime
echo -e "${RED}check for reboots${NC}" ; pdsh -g cn "cat /proc/uptime |awk '{print int(\$1/3600)}'" |awk '$2<72' ; 

echo -e "${RED}check for zombies${NC}" ; ./check_zombie.sh ; 

echo -e "${RED}check compute ipmi for any messages${NC}" ; metal ipmi -g cn -k 'sel elist' ; 
