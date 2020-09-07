#!/bin/bash
#Grab openflight repo
yum install -e0 -y https://repo.openflighthpc.org/pub/centos/7/openflighthpc-release-latest.noarch.rpm

# The following is required whilst the rpms are in the dev repo
yum install -e0 -y yum-utils
yum-config-manager --enable openflight-dev

yum install -y flight-action-api-power
yum install -y awscli

domain=$(hostname |sed s/fcgateway.//g)

su fcops -c "sudo /opt/flight/bin/flight www cert-gen --cert-type self-signed --domain "$domain""

su fcops -c "/opt/flight/bin/flight www enable-https"

token=$(date | md5sum | cut -c 1-16)

su fcops -c "sed -i s/38acabfe21af73892d8876e3c01fd107/$token/g /opt/flight/opt/action-api/config/application.yaml" 

/opt/flight/bin/flight service enable action-api
/opt/flight/bin/flight service enable www
/opt/flight/bin/flight service start action-api
/opt/flight/bin/flight service start www

#Change ports on www service with
sudo /opt/flight/bin/flight service configure www


echo "ipmitool -U admin -P XXXX -H ${name}.bmc -I lanplus chassis power status" >> /opt/flight/opt/action-api/libexec/power-status/ipmi.sh
echo "ipmitool -U admin -P XXXX -H ${name}.bmc -I lanplus chassis power cycle" >> /opt/flight/opt/action-api/libexec/power-cycle/ipmi.sh
echo "ipmitool -U admin -P XXXX -H ${name}.bmc -I lanplus chassis power off" >> /opt/flight/opt/action-api/libexec/power-off/ipmi.sh
echo "ipmitool -U admin -P XXXX -H ${name}.bmc -I lanplus chassis power on" >> /opt/flight/opt/action-api/libexec/power-on/ipmi.sh
mkdir /opt/flight/opt/action-api/libexec/power-sel
echo "ipmitool -U admin -P XXXX -H ${name}.bmc -I lanplus chassis power status" >> /opt/flight/opt/action-api/libexec/power-sel/ipmi.sh

for node in {001..170} ;do echo -e "node$node:\n    ranks: [ipmi]" ;done >> /opt/flight/opt/action-api/config/nodes.yaml


for node in {1..9} ;do echo "10.11.100.$node    node00$node.bmc" ;done >> /etc/hosts
for node in {10..99} ;do echo "10.11.100.$node    node0$node.bmc" ;done >> /etc/hosts
for node in {100..170} ;do echo "10.11.100.$node    node$node.bmc" ;done >> /etc/hosts

yum install -y flight-power
