#!/bin/bash
# Script to setup privileged fcops user

mkdir /users

#Add user
useradd -d /users/fcops -s /bin/bash fcops

echo -n "Enter new fcops user password: "; read PASSWORD
echo ${PASSWORD} | passwd --stdin fcops

#Setup Pub key for fcops
ssh-keygen -t rsa -b 4096

echo "Add ~fcops/.ssh/id_rsa.pub key to auth keys on ops-hub"
