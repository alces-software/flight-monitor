#!/bin/bash

d=$(date +%d)

RED='\033[0;31m'
NC='\033[0m'

ssh infra1 "echo -e '${RED}check var log messages infra1:${NC}' ; cat /var/log/messages | grep -v systemd | grep -v journal | grep -v desktop | grep -v gnome | grep -v megaraid | grep -v tftpd | grep -v dhcpd | grep -v krb5 | grep -v rosalind-module | grep -v fm0_sm | grep "$d" | grep -vi named | grep -vi oxford ; " 

ssh infra2 "echo -e '${RED}check var log messages infra2:${NC}' ; cat /var/log/messages | grep -v systemd | grep -v journal | grep -v desktop | grep -v gnome | grep -v megaraid | grep -v tftpd | grep -v dhcpd | grep -v krb5 | grep -v rosalind-module | grep -v fm0_sm | grep "$d" | grep -vi named | grep -vi oxford ; "

ssh infra3 "echo -e '${RED}check var log messages infra3:${NC}' ; cat /var/log/messages | grep -v systemd | grep -v journal | grep -v desktop | grep -v gnome | grep -v megaraid | grep -v tftpd | grep -v dhcpd | grep -v krb5 | grep -v rosalind-module | grep -v fm0_sm | grep "$d" | grep -vi named | grep -vi oxford ; "

ssh infra4 "echo -e '${RED}check var log messages infra4:${NC}' ; cat /var/log/messages | grep -v systemd | grep -v journal | grep -v desktop | grep -v gnome | grep -v megaraid | grep -v tftpd | grep -v dhcpd | grep -v krb5 | grep -v rosalind-module | grep -v fm0_sm | grep "$d" | grep -vi named | grep -vi oxford ; " 

ssh controller "echo -e '${RED}uptime is:${NC}' ; pdsh -g infra uptime ; 

echo -e '${RED}check headnode memory/swap usage:${NC}' ; pdsh -g infra free -hm ; 

echo -e '${RED}MANUALLY CHECK PROCESS SANITY ON ALL INFRA NODES${NC}' ; " 
