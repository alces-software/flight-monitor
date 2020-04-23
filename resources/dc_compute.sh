#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}check ib link status${NC}" ; pdsh -f1 -g cn 'ibstatus' ; 

echo -e "${RED}check compute local disk space${NC}" ; pdsh -g cn 'df -h / /tmp /var' ; 

echo -e "${RED}check for reboots${NC}" ; pdsh -g cn uptime ; 

echo -e "${RED}check for zombies${NC}" ; ./check_zombie.sh ; 

echo -e "${RED}check compute ipmi for any messages${NC}" ; metal ipmi -g cn -k 'sel elist' ; 
