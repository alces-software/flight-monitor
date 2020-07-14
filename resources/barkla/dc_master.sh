#!/bin/bash

# a script for the master section of a daily check

d=$(date +%d)

RED='\033[0;31m'
NC='\033[0m'

ssh master1 "echo 'hostname is' ; hostname ;
 
echo -e '${RED}check master HA pair status:${NC}' ; crm_mon -1 | grep -i 'last' ; "

ssh controller "echo 'hostname is' ; hostname ; 

echo -e '${RED}check disk space (local):${NC}' ; pdsh -g masters df -h | grep -i root ; 

echo -e '${RED}check IPMI on masters:${NC}' ; pdsh -g masters ipmitool -c sel elist ; "



# Converts uptime to hours and flags nodes with less than 72 hour uptime
echo -e "${RED}check for reboots${NC}" ; pdsh -g cn "cat /proc/uptime |awk '{print int(\$1/3600)}'" |awk '$2<72' ; 


ssh controller "echo -e '${RED}check backups complete:${NC}' ; pdsh -g masters /root/check_dirvish ; "

echo -e "${RED}check memory usage:${NC}" ; pdsh -g masters free -m |grep Mem: |awk '{print int($3/$2*100)}' |awk '$1>80 { $1 = "Mem used is: " $1 "%" ; print}' ; 

echo -e "${RED}check swap usage:${NC}" ; pdsh -g masters free -m |grep Swap: |awk '{print int($3/$2*100)}' |awk '$1>80 { $1 = "Swap used is: " $1 "%" ; print}' ;        
