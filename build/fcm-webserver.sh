#!/bin/bash

#Copy and paste from fcops user generation

# Script to setup privileged fcops user

mkdir /users

#Add user
useradd -d /users/fcops -s /bin/bash fcops

echo -n "Enter new fcops user password: "; read PASSWORD
echo ${PASSWORD} | passwd --stdin fcops


#Setup Pub key for fcops
echo "Creating Key for passwordless SSH to cluster as fcops user"
su fcops -c "ssh-keygen -t rsa -f ~/.ssh/id_fcops -C 'Alces Flight Operations Team'"

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
chown fcops: -R /users/fcops/git
cd

#Copy adoption scripts to nginx resource location
rsync -auv /users/fcops/git/flight-monitor/hub/adoption/cloud/ /opt/zabbix/srv/resources/adoption/

#Setting fcops as sudo user on fcgateway
echo "fcops    ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/fcops

#Install / Configure pdsh/genders
yum install -y -e0 genders pdsh pdsh-mod-genders -q
touch /etc/genders
echo "StrictHostKeyChecking no" >> ~fcops/.ssh/config
chown fcops: ~fcops/.ssh/config
chmod 600 ~fcops/.ssh/config

echo "Add ~fcops/.ssh/id_rsa.pub key to auth keys on ops-hub"



#Webserver install start 

mkdir -p /opt/zabbix/srv/resources/{maint_scripts,apps_scripts,zabbix}
chown fcops: /opt/zabbix/srv/resources/ -R
echo "Installing nginx"
yum -y -e0 install nginx -q

if=$(ip link | awk -F: '$0 !~ "lo|vir|tun|wl|^[^0-9]"{print $2;getline}' |head -1)
ipaddr=$(ifconfig $if | grep inet | awk '{ print $2 }' | head -1)

cat << EOF > /etc/nginx/conf.d/fcm-resources.conf
server {
  listen *:80;
  server_name $ipaddr;
  location /resources/ {
    autoindex on;
    }

  root /opt/zabbix/srv;
  autoindex on;
}
EOF

echo "Downloading ngnix config from flight-monitor github"
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/nginx.conf -O /etc/nginx/nginx.conf --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/client/install_agent.sh -O /opt/zabbix/srv/resources/zabbix/install_agent.sh --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/zabbix_agentd.conf -O /opt/zabbix/srv/resources/zabbix/zabbix_agentd.conf --no-check-certificate -q
#wget https://www.zabbix.com/downloads/4.4.5/zabbix_agent-4.4.5-linux-3.0-amd64-static.tar.gz -O /opt/zabbix/srv/resources/zabbix/zabbix_agent.tgz -q
wget https://cdn.zabbix.com/zabbix/binaries/stable/4.4/4.4.5/zabbix_agent-4.4.5-linux-3.0-amd64-static.tar.gz -O /opt/zabbix/srv/resources/zabbix/zabbix_agent.tgz -q


echo "Downloading Custom Zabbix Conf"
wget https://github.com/alces-software/flight-monitor/blob/master/resources/zabbix_custom_checks.tar.gz?raw=true -O /opt/zabbix/srv/resources/zabbix/zabbix_checks.tar.gz -q --no-check-certificate
tar -zxvf /opt/zabbix/srv/resources/zabbix/zabbix_checks.tar.gz -C /opt/zabbix/srv/resources/zabbix/


#Hostname change when people give u VMs that aren't called fcgateway...
for file in $(ls /opt/zabbix/srv/resources/) ; do sed -i s/fcgateway/$(hostname -s)/g $file ; done

echo "Starting Nginx Services"
systemctl enable nginx
systemctl start nginx

echo "Starting Zabbix Services"
systemctl start zabbix-proxy.service
systemctl start zabbix-agent.service
systemctl enable zabbix-proxy.service
systemctl enable zabbix-agent.service

echo -e "\033[0;32m==== WEBSERVER SETUP COMPLETE ====\033[0m"
echo "Add this proxy server to Zabbix (via Frontend on ops-hub)"
echo "Create the fcops user for fcgateway with /tmp/fcm-fcops-user.sh"
