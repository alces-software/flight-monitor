#!/bin/bash
# Script to setup privileged fcops user

#Create group
groupadd -g 64646 fcops

#Add user
useradd -d /home/fcops -s /bin/bash -u 64646 -g 64646 fcops

echo -n "Enter new fcops user password: "; read PASSWORD
echo ${PASSWORD} | passwd --stdin fcops

#Setup Sudo Rules for fcops user

echo 'fcops ALL=(ALL:ALL) ALL' | sudo EDITOR='tee -a' visudo

su - fcops -c 'mkdir -p /home/fcops/.ssh'
su - fcops -c 'chmod 700 /home/fcops/.ssh'
su - fcops -c 'touch /home/fcops/.ssh/authorized_keys'
su - fcops -c 'chmod 640 /home/fcops/.ssh/authorized_keys'
echo -n "Enter fcops public key from key: "; read KEY
echo $KEY >> /home/fcops/.ssh/authorized_keys

