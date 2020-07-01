#!/bin/bash

# a script for post-maintenance checks on poorly nodes

RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}date:${NC}" ; date ;

echo -e "${RED}id alces cluster available?${NC}" ; id alces-cluster ;

echo -e "${RED}expected filesystems mounted?${NC}" ; df -h ;

echo -e "${RED}memory as expected?${NC}" ; free -hm ;

echo -e "${RED}expected cpu count?${NC}" ; grep -ci "xeon" /proc/cpuinfo ;

echo -e "${RED}check ib status:${NC}" ; ibstatus ;

echo -e "${RED}ping node if idrac is up:${NC}" ; ping ;

echo -e "${RED}check ststus of GPUs:${NC}" ; nvidia-smi ;

echo -e "${RED}check nagios crontab entries:${NC}" ; crontab -u nagios -l ;

echo -e "${RED}show running system kernel version:${NC}" ; uname -r ;

echo -e "${RED}check ipmitool entires before clearing:${NC}" ; ipmitool sel list ;

echo -e "${RED}make sure to also; check top, moonipmi, dmidecode and make sure node is in the correct host group${NC}" ;
