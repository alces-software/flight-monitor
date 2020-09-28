#!/bin/bash
#Install openflight asset tools
yum -y -e0 -q install https://repo.openflighthpc.org/pub/centos/7/openflighthpc-release-latest.noarch.rpm
yum -y -e0 -q install https://alces-flight.s3-eu-west-1.amazonaws.com/repos/pub/centos/7/alces-flight-release-latest.noarch.rpm
yum -q makecache
yum -y -e0 -q install flight-fact flight-gather flight-inventory flight-asset



