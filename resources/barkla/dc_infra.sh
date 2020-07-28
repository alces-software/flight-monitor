#!/bin/bash

d=$(date +%d)

RED='\033[0;31m'
NC='\033[0m'
 
export uptime=$(pdsh -f1 -w infra1,infra2,infra3,infra4 uptime) ; 

echo -e "${RED}uptime is:${NC}" ; echo '```'$uptime'```' ; 

export memory=$(pdsh -f1 -w infra1,infra2,infra3,infra4 free -hm) ;  

echo -e "${RED}check headnode memory/swap usage:${NC}" ; echo '```'$memory'```' ;  
  
