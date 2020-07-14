#!/bin/bash

d=$(date +%d)

RED='\033[0;31m'
NC='\033[0m'
 

# converts uptime to hours and flags nodes with less than 72 hours uptime
"echo -e '${RED}check for reboots${NC}' ; pdsh -g infra "cat /proc/uptime |awk '{print int(\$1/3600)}'" |awk '$2<72' ;

echo -e '${RED}check headnode memory usage:${NC}' ; pdsh -g infra free -m |grep Mem: |awk '{print int($3/$2*100)}' |awk '$1>80 { $1 = "Mem used is: " $1 "%" ; print}' ;

echo -e '${RED}check headnode swap usage:${NC}' ; pdsh -g infra free -m |grep Swap: |awk '{print int($3/$2*100)}' |awk '$1>80 { $1 = "Swap used is: " $1 "%" ; print}' ;  
 
