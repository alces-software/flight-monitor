#!/bin/bash

d=$(date +%d)

RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}check users logged into user-facing nodes:${NC}" ; pdsh -g login w | grep -i users, ; pdsh -g viz w | grep -i users, ; 

echo -e "${RED}uptime is:${NC}" ; pdsh -g login uptime ; pdsh -g viz uptime ; 

echo -e "${RED}check tmp partition space available:${NC}" ; pdsh -g login df -h /tmp ; pdsh -g viz df -h /tmp ; 

echo -e "${RED}check disk space on logins${NC}" ; pdsh -g login df -h | grep -i root ; pdsh -g viz df -h | grep -i root ;  

ssh login1 "echo -e '${RED}check var log messages login1:${NC}' ; cat /var/log/messages | grep -v systemd | grep -v journal | grep -v desktop | grep -v gnome | grep -v megaraid | grep -v tftpd | grep -v dhcpd | grep -v krb5 | grep -v rosalind-module | grep -v fm0_sm | grep "$d" | grep -vi named | grep -vi oxford ; " 

ssh login2 "echo -e '${RED}check var log messages login2:${NC}' ; cat /var/log/messages | grep -v systemd | grep -v journal | grep -v desktop | grep -v gnome | grep -v megaraid | grep -v tftpd | grep -v dhcpd | grep -v krb5 | grep -v rosalind-module | grep -v fm0_sm | grep "$d" | grep -vi named | grep -vi oxford ; " 

ssh viz01 "echo -e '${RED}check var log messages viz01:${NC}' ; cat /var/log/messages | grep -v systemd | grep -v journal | grep -v desktop | grep -v gnome | grep -v megaraid | grep -v tftpd | grep -v dhcpd | grep -v krb5 | grep -v rosalind-module | grep -v fm0_sm | grep "$d" | grep -vi named | grep -vi oxford ; "

ssh viz02 "echo -e '${RED}check var log messages viz02:${NC}' ; cat /var/log/messages | grep -v systemd | grep -v journal | grep -v desktop | grep -v gnome | grep -v megaraid | grep -v tftpd | grep -v dhcpd | grep -v krb5 | grep -v rosalind-module | grep -v fm0_sm | grep "$d" | grep -vi named | grep -vi oxford ; " 

echo -e "${RED}check login memory/swap usage${NC}" ; pdsh -g login free -hm ; pdsh -g viz free -hm ; 

echo -e "${RED}check var partition space:${NC}" ; pdsh -g login df -h /var ; pdsh -g viz df -h /var ; 

echo -e "${RED}MANUALLY CHECK PROCESS SANITY ON ALL LOGIN AND VIZ NODES${NC}" ; 
