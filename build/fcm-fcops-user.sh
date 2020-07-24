#!/bin/bash
# Script to setup privileged fcops user

mkdir /users

#Add user
useradd -d /users/fcops -s /bin/bash fcops

echo -n "Enter new fcops user password: "; read PASSWORD
echo ${PASSWORD} | passwd --stdin fcops


#Setup Pub key for fcops
echo "Creating Key for passwordless SSH to cluster as fcops user"
ssh-keygen -t rsa

#Setting 

sshpass -pReypdac1 ssh -o StrictHostKeyChecking=no fcops@10.10.0.28 hostname


echo "Add ~fcops/.ssh/id_rsa.pub key to auth keys on ops-hub"
