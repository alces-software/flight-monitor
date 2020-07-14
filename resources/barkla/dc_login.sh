#!/bin/bash

d=$(date +%d)

RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}check users logged into user-facing nodes:${NC}" ; pdsh -g login w | grep -i users, ; pdsh -g viz w | grep -i users, ; 
 
# Converts uptime to hours and flags nodes with less than 72 hour uptime
echo -e "${RED}check for reboots${NC}" ; pdsh -g login "cat /proc/uptime |awk '{print int(\$1/3600)}'" |awk '$2<72' ; pdsh -g viz "cat /proc/uptime |awk '{print int(\$1/3600)}'" |awk '$2<72' ; 

echo -e "${RED}check tmp partition space available:${NC}" ; pdsh -g login df -h /tmp ; pdsh -g viz df -h /tmp ; 

echo -e "${RED}check disk space on logins${NC}" ; pdsh -g login df -h | grep -i root ; pdsh -g viz df -h | grep -i root ;  
 
echo -e "${RED}check login memory usage${NC}" ; pdsh -g login free -m |grep Swap: |awk '{print int($3/$2*100)}' |awk '$1>80 { $1 = "Swap used is: " $1 "%" ; print}' ; pdsh -g viz free -m |grep Swap: |awk '{print int($3/$2*100)}' |awk '$1>80 { $1 = "Swap used is: " $1 "%" ; print}' ;  

echo -e "${RED}check login swap usages${NC}" ; pdsh -g login free -m |grep Swap: |awk '{print int($3/$2*100)}' |awk '$1>80 { $1 = "Swap used is: " $1 "%" ; print}' ; pdsh -g viz free -m |grep Swap: |awk '{print int($3/$2*100)}' |awk '$1>80 { $1 = "Swap used is: " $1 "%" ; print}' ; 

echo -e "${RED}check var partition space:${NC}" ; pdsh -g login df -h /var ; pdsh -g viz df -h /var ; 

echo -e "${RED}MANUALLY CHECK PROCESS SANITY ON ALL LOGIN AND VIZ NODES${NC}" ; 
