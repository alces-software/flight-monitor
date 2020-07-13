#!/bin/bash

# a script for the controller section of a daily check

d=$(date +%d)

RED='\033[0;31m'
NC='\033[0m' 

echo -e "${RED}uptime is:${NC}" ; uptime ; 

echo -e "${RED}check var log messages:${NC}" ; cat /var/log/messages | grep -v systemd | grep -v journal | grep -v desktop | grep -v gnome | grep -v megaraid | grep -v tftpd | grep -v dhcpd | grep -v krb5 | grep -v rosalind-module | grep -v fm0_sm | grep "$d" | grep -vi named | grep -vi oxford ;

echo -e "${RED}check controller memory:${NC}" ; free -hm ; 

echo -e "${RED}check controller disk space:${NC}" ; df -h / /boot ;     
