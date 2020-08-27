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

#Setting fcops as sudo user on fcgateway
cat << 'EOF' > /etc/sudoers.d/fcops
fcops    ALL=(ALL)       NOPASSWD: ALL
EOF 


echo "Add ~fcops/.ssh/id_rsa.pub key to auth keys on ops-hub"
