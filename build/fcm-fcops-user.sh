#!/bin/bash
# Script to setup privileged fcops user

#Add user
useradd -d /users/fcops -s /bin/bash fcops

#Setup Pub key for fcops
ssh-keygen -t rsa -b 4096

echo "Add ~fcops/.ssh/id_rsa.pub key to auth keys on ops-hub"
