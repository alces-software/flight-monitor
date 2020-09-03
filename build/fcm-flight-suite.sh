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

flight service enable action-api
flight service enable www
flight service start action-api
flight service start www

#Change ports on www service with
 sudo /opt/flight/bin/flight service configure www


yum install -y flight-power
