#!/bin/bash

d=$(date +%d)

RED='\033[0;31m'
NC='\033[0m'

export loggedin=$(pdsh -g login w | grep -i users, ; pdsh -g viz w | grep -i users,) ; 

echo -e "${RED}check users logged into user-facing nodes:${NC}" ; echo '```'$loggedin'```' ; 

export uptime=$(pdsh -g login uptime ; pdsh -g viz uptime) ; 

echo -e "${RED}uptime is:${NC}" ; echo '```'"$uptime"'```' ; 

export tmp=$(pdsh -w login1,login2 df -h /tmp) ; 

echo -e "${RED}check tmp partition space available on logins:${NC}" ; echo '```'$tmp'```' ; 

export tmpviz=$(pdsh -g viz df -h /tmp) ; 

echo -e "${RED}check tmp partition space available on vis nodes:${NC}" ; echo '```'$tmpviz'```' ; 

export disk=$(pdsh -g login df -h | grep -i root ; pdsh -g viz df -h | grep -i root) ; 

echo -e "${RED}check disk space on logins${NC}" ; echo '```'$disk'```' ;  

export memory=$(pdsh -g login free -hm ; pdsh -g viz free -hm) ; 

echo -e "${RED}check login memory/swap usage${NC}" ; echo '```'$memory'```' ; 

export var=$(pdsh -g login df -h /var ; pdsh -g viz df -h /var) ; 

echo -e "${RED}check var partition space:${NC}" ; echo '```'$var'```' ; 
 
