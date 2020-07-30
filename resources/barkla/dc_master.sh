#!/bin/bash

# a script for the master section of a daily check

d=$(date +%d)

RED='\033[0;31m'
NC='\033[0m'

export ha=$(pdsh -w master1 crm_mon -1 | grep -i last) ; 

echo -e "${RED}### check master HA pair status:${NC}" ; echo '```'"$ha"'```' ;  

export disk=$(pdsh -g masters df -h | grep -i root) ; 
 
echo -e "${RED}### check disk space (local):${NC}" ; echo '```'"$disk"'```' ; 

export ipmi=$(pdsh -g masters ipmitool -c sel elist) ;

echo -e "${RED}### check IPMI on masters:${NC}" ; echo '```'"$ipmi"'```' ; 

export uptime=$(pdsh -g masters uptime) ;

echo -e "${RED}### uptime is:${NC}" ; echo '```'"$uptime"'```' ;  

export backups=$(pdsh -g masters /root/check_dirvish) ;
 
echo -e "${RED}### check backups complete:${NC}" ; echo '```'"$backups"'```' ;

export memory=$(pdsh -g masters free -hm) ; 

echo -e "${RED}### check memory/swap usage:${NC}" ; echo '```'"$memory"'```' ; 
      
