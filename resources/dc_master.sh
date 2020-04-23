#!/bin/bash

# a script for the master section of a daily check

d=$(date +%d)

RED='\033[0;31m'
NC='\033[0m'

ssh master1 "echo 'hostname is' ; hostname ;
 
echo -e '${RED}check master HA pair status:${NC}' ; crm_mon -1 | grep -i 'last' ; "

ssh controller "echo 'hostname is' ; hostname ; 

echo -e '${RED}check disk space (local):${NC}' ; pdsh -g masters df -h | grep -i root ; 

echo -e '${RED}check IPMI on masters:${NC}' ; pdsh -g masters ipmitool -c sel elist ;

echo -e '${RED}uptime is:${NC}' ; pdsh -g masters uptime ; 

echo -e '${RED}check var log messages:${NC}' ; pdsh -g masters cat /var/log/messages | grep -v systemd | grep -v journal | grep -v desktop | grep -v gnome | grep -v megaraid | grep -v tftpd | grep -v dhcpd | grep -v krb5 | grep -v rosalind-module | grep -v fm0_sm | grep "$d" | grep -vi named | grep -vi oxford | grep -vi 'notice:' ;  

echo -e '${RED}check backups complete:${NC}' ; pdsh -g masters /root/check_dirvish ; 

echo -e '${RED}check memory/swap usage:${NC}' ; pdsh -g masters free -hm ;

echo -e '${RED}REMEMBER TO MANUALLY CHECK PROCESS SANITY ON BOTH MASTER1 AND MASTER2${NC}' ; "      
