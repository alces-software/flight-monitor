#!/bin/bash
#Script to setup/configure flight asset on an fcgateway

# Install OpenFlight & Alces Flight repositories
sudo yum install https://repo.openflighthpc.org/pub/centos/7/openflighthpc-release-latest.noarch.rpm -y 
sudo yum install https://alces-flight.s3-eu-west-1.amazonaws.com/repos/pub/centos/7/alces-flight-release-latest.noarch.rpm -y

# Create yum cache
sudo yum makecache

# Install tools
sudo yum install flight-fact flight-gather flight-inventory flight-asset -y

#Configure tools
/opt/flight/bin/flight fact configure #Needs API Key 
/opt/flight/bin/flight asset configure #Needs component ID + API key

#Create default cluster groups
bash /opt/flight/bin/flight asset create-group 'Compute Nodes' 'Compute'
bash /opt/flight/bin/flight asset create-group 'Infrastructure Nodes' 'Service'
bash /opt/flight/bin/flight asset create-group 'Login Nodes' 'Access'
bash /opt/flight/bin/flight asset create-group 'Admin Nodes' 'Administrative'
#bash /opt/flight/bin/flight asset create-group 'GPU Nodes' 'Compute'
bash /opt/flight/bin/flight asset create-group 'Master Nodes' 'Service'
