#!/bin/bash
# Script to setup privileged fcops user

mkdir /users

#Add user
useradd -d /users/fcops -s /bin/bash fcops

echo -n "Enter new fcops user password: "; read PASSWORD
echo ${PASSWORD} | passwd --stdin fcops


#Setup Pub key for fcops
echo "Creating Key for passwordless SSH to cluster as fcops user"
su fcops -c "ssh-keygen -t rsa"

#Bit of git config
mkdir /users/fcops/git
cat < EOF > /users/fcops/.gitconfig
[user]
	name = Dan Shaw
	email = dan.shaw@alces-flight.com
[credential]
	helper = store
EOF

echo "https://USER:PASS@github.com" > ~/.git-credentials

echo "Will need to update ~/.git-credentials appropriately"

#Setting fcops as sudo user on fcgateway
echo "fcops    ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/fcops

#Install / Configure pdsh/genders
yum install -y -e0 genders pdsh


echo "Add ~fcops/.ssh/id_rsa.pub key to auth keys on ops-hub"
