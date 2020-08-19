#!/bin/bash
#Grab openflight repo
yum install -e0 -y https://repo.openflighthpc.org/pub/centos/7/openflighthpc-release-latest.noarch.rpm

# The following is required whilst the rpms are in the dev repo
yum install -e0 -y yum-utils
yum-config-manager --enable openflight-dev

yum install -y flight-action-api-power
yum install -y awscli
