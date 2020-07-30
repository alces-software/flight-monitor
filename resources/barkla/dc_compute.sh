#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

export iblink=$(pdsh -f1 -g cn ibstatus |grep -i state ) ; 

echo -e "${RED}### check ib link status${NC}" ; echo '```'"$iblink"'```' ; 

export disk=$(pdsh -g cn df -h / /tmp /var | grep -v "Filesystem Use") ; 

echo -e "${RED}### check compute local disk space${NC}" ; echo '```'"$disk"'```' ; 

export reboots=$(pdsh -g cn uptime) ; 

echo -e "${RED}### check for reboots${NC}" ; echo '```'"$reboots"'```' ; 

export ipmi=$(metal ipmi -g cn -k 'sel elist') ; 

echo -e "${RED}### check compute ipmi for any messages${NC}" ; echo '```'"$ipmi"'```' ;  
