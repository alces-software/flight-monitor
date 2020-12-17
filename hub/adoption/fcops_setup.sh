#!/bin/bash
#Script to setup the fcops user on a cluster
#This script will be launched from cfcgateway but run on chead1
#Requires SSH KEY + FCOPS PASSWORD variables
groupadd -g 64646 fcops
useradd -d /home/fcops -s /bin/bash -u 64646 -g 64646 fcops
echo $FCOPS_PASSWORD | passwd --stdin fcops
echo 'fcops    ALL=(ALL)       NOPASSWD: ALL' > /etc/sudoers.d/fcops
su - fcops -c 'mkdir -p /home/fcops/.ssh'
su - fcops -c 'chmod 700 /home/fcops/.ssh'
su - fcops -c 'touch /home/fcops/.ssh/authorized_keys'
su - fcops -c 'chmod 640 /home/fcops/.ssh/authorized_keys'
echo "$PUB_SSH_KEY"  >> /home/fcops/.ssh/authorized_keys
