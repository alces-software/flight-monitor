#!/bin/bash

d=$(date +%d)

RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}check storage uptime/reboots:${NC}" ; pdsh -g storage uptime ;

ssh login1 "echo 'hostname is:' ; hostname ; 

echo -e '${RED}check parallel filesystem capacity:${NC}' ; lfs df -h | grep -i file ;

echo -e '${RED}check parallel filesystem inodes:${NC}' ; lfs df -hi | grep -i file ;

echo -e '${RED}check user filesystems:${NC}' ; df -h /users ; 

echo -e '${RED}check user filesystems gridware:${NC}' ; df -h /opt/gridware ; 

echo -e '${RED}check user filesystems service:${NC}' ; df -h /opt/service ; 

echo -e '${RED}check user filesystems apps:${NC}' ; df -h /opt/apps ; "

ssh controller "echo -e '${RED}check disk space available:${NC}' ; pdsh -g storage 'df -h / /tmp /var' ; " 

ssh login1 "echo -e '${RED}check volume data1:${NC}' ; df -h /mnt/data1 ;

echo -e '${RED}check volume data2:${NC}' ; df -h /mnt/data2 ; " 

ssh oss1 "echo -e '${RED}check var log messages:${NC}' ; cat /var/log/messages | grep -v systemd | grep -v journal | grep -v desktop | grep -v gnome | grep -v megaraid | grep -v tftpd | grep -v dhcpd | grep -v krb5 | grep -v rosalind-module | grep -v fm0_sm | grep "$d" | grep -vi named | grep -vi oxford | grep -vi 'notice' | grep -vi skipped ; "

ssh oss2 "echo -e '${RED}check var log messages:${NC}' ; cat /var/log/messages | grep -v systemd | grep -v journal | grep -v desktop | grep -v gnome | grep -v megaraid | grep -v tftpd | grep -v dhcpd | grep -v krb5 | grep -v rosalind-module | grep -v fm0_sm | grep "$d" | grep -vi named | grep -vi oxford | grep -vi 'notice' | grep -vi skipped ; "

ssh nfs1 "echo -e '${RED}check var log messages:${NC}' ; cat /var/log/messages | grep -v systemd | grep -v journal | grep -v desktop | grep -v gnome | grep -v megaraid | grep -v tftpd | grep -v dhcpd | grep -v krb5 | grep -v rosalind-module | grep -v fm0_sm | grep "$d" | grep -vi named | grep -vi oxford | grep -vi 'notice' | grep -vi skipped ; "

ssh nfs2 "echo -e '${RED}check var log messages:${NC}' ; cat /var/log/messages | grep -v systemd | grep -v journal | grep -v desktop | grep -v gnome | grep -v megaraid | grep -v tftpd | grep -v dhcpd | grep -v krb5 | grep -v rosalind-module | grep -v fm0_sm | grep "$d" | grep -vi named | grep -vi oxford | grep -vi 'notice' | grep -vi skipped ; "

ssh mds1 "echo -e '${RED}check var log messages:${NC}' ; cat /var/log/messages | grep -v systemd | grep -v journal | grep -v desktop | grep -v gnome | grep -v megaraid | grep -v tftpd | grep -v dhcpd | grep -v krb5 | grep -v rosalind-module | grep -v fm0_sm | grep "$d" | grep -vi named | grep -vi oxford | grep -vi 'notice' | grep -vi skipped ; " 

ssh controller "echo -e '${RED}check disk status in arrays:${NC}' ; pdsh -g storage '/opt/MegaRAID/MegaCli/MegaCli64 -ldinfo -lall -aall' | grep State ; " 

ssh storage1 "echo -e '${RED}check for users over quota:${NC}' ; repquota -s /export/users " 

ssh controller "echo -e '${RED}MANUALLY CHECK PROCESS SANITY ON oss1, oss2, nfs1, nfs2 AND mds1${NC}' ; "          
