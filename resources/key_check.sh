#/bin/bash
RED='\033[0;31m'
NC='\033[0m'
#Root User
echo -e "${RED}Checking controller logs:${NC}" 
grep "Accepted publickey" /var/log/secure |awk '{print $1,$2,$3,$9,$11}'
#Non-root User
echo -e "${RED}Checking controller logs - non root user:${NC}"
grep "Accepted publickey" /var/log/secure |awk '{print $1,$2,$3,$9,$11}' |grep -v "for root"
#Login Nodes
#Root User
echo -e "${RED}Checking login node logs:${NC}"
pdsh -g login "grep 'Accepted publickey' /var/log/secure |awk '{print \$1,\$2,\$3,\$9,\$11}'"
#Non-root User
echo -e "${RED}Checking login node logs - non root user:${NC}"
pdsh -g login "grep 'Accepted publickey' /var/log/secure |grep -v 'for root' |awk '{print \$1,\$2,\$3,\$9,\$11}'" 
