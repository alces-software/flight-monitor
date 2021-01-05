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
chown fcops: /users/fcops/git
cat << EOF > /users/fcops/.gitconfig
[user]
	name = Dan Shaw
	email = dan.shaw@alces-flight.com
[credential]
	helper = store
EOF

#Ask the user for Dan's git credentials 
echo -n "Please provide your git username: " ; read GUSER
echo -n "Please provide your git password: " ; read GPASS

echo "https://$GUSER:$GPASS@github.com" > /users/fcops/.git-credentials

#Pull necessary git repos to /users/fcops/git dir
cd /users/fcops/git
git clone https://github.com/alces-software/flight-monitor.git
git clone https://github.com/alces-software/flight-monitor-resources.git
cd


#Setting fcops as sudo user on fcgateway
echo "fcops    ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/fcops

#Install / Configure pdsh/genders
yum install -y -e0 genders pdsh pdsh-mod-genders -q
touch /etc/genders
echo "StrictHostKeyChecking no" >> ~fcops/.ssh/config
chown fcops: ~fcops/.ssh/config
chmod 600 ~fcops/.ssh/config

echo "Add ~fcops/.ssh/id_rsa.pub key to auth keys on ops-hub"
