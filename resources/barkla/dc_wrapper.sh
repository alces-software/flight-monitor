#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m' 
NC='\033[0m'

echo -e "${GREEN}~~~ CONTROLLER SCRIPT ~~~${NC}" 

bash /root/dc_controller.sh ; 

echo -e "${GREEN}~~~ MASTER SCRIPT ~~~${NC}"

bash /root/dc_master.sh ; 

echo -e "${GREEN}~~~ STORAGE SCRIPT ~~~${NC}"

bash /root/dc_storage.sh ; 

echo -e "${GREEN}~~~ INFRA SCRIPT ~~~${NC}"

bash /root/dc_infra.sh ; 

echo -e "${GREEN}~~~ LOGIN SCRIPT ~~~${NC}"

bash /root/dc_login.sh ; 

echo -e "${GREEN}~~~ COMPUTE SCRIPT ~~~${NC}"

bash /root/dc_compute.sh ; 
