#Adoption notes
* These scripts are expected to be used in relation to adopting new cloud nodes:
* check_setup.sh - Ensures OPS checks run on new node + runs sanity checks that other scripts have run ok
* fcops_setup.sh - Setup fcops user for ops usage
* zabbix_setup.sh - Setup + Configure Zabbix for new node
* adopt_node.sh - Wrapper script to run all scripts + fully adopt new node
* rpm_setup.sh - Ensures any necessary RPMs have been installed
