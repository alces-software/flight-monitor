#/bin/bash

#Copy and paste from fcops user generation

# Script to setup privileged fcops user

mkdir /users
mkdir -p /opt/zabbix/srv/resources/{maint_scripts,apps_scripts,zabbix} #Setup Zabbix directories

#Add user
useradd -d /users/fcops -s /bin/bash fcops

echo -n "Enter new fcops user password: "; read PASSWORD
echo ${PASSWORD} | passwd --stdin fcops

mkdir /users/fcops

#Setup Pub key for fcops
echo "Creating Key for passwordless SSH to cluster as fcops user"
su fcops -c "ssh-keygen -t rsa -f ~/.ssh/id_fcops -C 'Alces Flight Operations Team'"

#Configure git + use ssh auth
curl https://hub.fcops.alces-flight.com/resources/keys/gitkey_rsa -o ~fcops/.ssh/gitkey_rsa
curl https://hub.fcops.alces-flight.com/resources/keys/gitkey_rsa.pub -o ~fcops/.ssh/gitkey_rsa.pub

chown fcops: ~fcops/.ssh/ -R
chmod 600 ~fcops/.ssh/gitkey_rsa
chmod 664 ~fcops/.ssh/gitkey_rsa.pub

touch /users/fcops/.ssh/config

cat << EOF >> /users/fcops/.ssh/config
Host github.com
  User git
  Hostname github.com
  IdentityFile ~/.ssh/gitkey_rsa
Host *
  IdentityFile ~/.ssh/id_fcops
  StrictHostKeyChecking no
EOF

chmod 600 /users/fcops/.ssh/config

git config --global user.name "dshaw29" 
git config --global user.email dan.shaw@alces-software.com

#Test connection to git // authenticate 
sudo su fcops -c "ssh -o StrictHostKeyChecking=no -T git@github.com"

#Pull necessary git repos to /users/fcops/git dir
mkdir /users/fcops/git
chown fcops: -R /users/fcops/git
su fcops -c "cd /users/fcops/git ; git clone ssh://github.com/alces-software/flight-monitor.git"
su fcops -c "cd /users/fcops/git ; git clone ssh://github.com/alces-software/flight-monitor-resources.git"
chown fcops: -R /users/fcops/git
cd

#Copy adoption scripts to nginx resource location
rsync -auv /users/fcops/git/flight-monitor/hub/adoption/cloud/ /opt/zabbix/srv/resources/adoption/

#Setting fcops as sudo user on fcgateway
echo "fcops    ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/fcops

#Install / Configure pdsh/genders
yum install -y -e0 genders pdsh pdsh-mod-genders -q
touch /etc/genders
chown fcops: ~fcops/.ssh/config
chmod 600 ~fcops/.ssh/config

echo "Add ~fcops/.ssh/id_rsa.pub key to auth keys on ops-hub"

#Webserver install start 
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
#wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/client/install_agent.sh -O /srv/salt/install_agent.sh --no-check-certificate -q
wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/zabbix_agentd.conf -O /opt/zabbix/srv/resources/zabbix/zabbix_agentd.conf --no-check-certificate -q
#wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/zabbix_agentd.conf -O /srv/salt/zabbix_agentd.conf --no-check-certificate -q
#wget https://www.zabbix.com/downloads/4.4.5/zabbix_agent-4.4.5-linux-3.0-amd64-static.tar.gz -O /opt/zabbix/srv/resources/zabbix/zabbix_agent.tgz -q
wget https://cdn.zabbix.com/zabbix/binaries/stable/4.4/4.4.5/zabbix_agent-4.4.5-linux-3.0-amd64-static.tar.gz -O /opt/zabbix/srv/resources/zabbix/zabbix_agent.tgz -q
#wget https://cdn.zabbix.com/zabbix/binaries/stable/4.4/4.4.5/zabbix_agent-4.4.5-linux-3.0-amd64-static.tar.gz -O /srv/salt/zabbix_agent.tgz -q
#wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/zabbix-agent.service -O /srv/salt/zabbix-agent.service --no-check-certificate -q
#wget https://raw.githubusercontent.com/alces-software/flight-monitor/master/resources/user_params.conf -O /srv/salt/user_params.conf --no-check-certificate -q

echo "Downloading Custom Zabbix Conf"
wget https://github.com/alces-software/flight-monitor/blob/master/resources/zabbix_custom_checks.tar.gz?raw=true -O /opt/zabbix/srv/resources/zabbix/zabbix_checks.tar.gz -q --no-check-certificate
tar -zxvf /opt/zabbix/srv/resources/zabbix/zabbix_checks.tar.gz -C /opt/zabbix/srv/resources/zabbix/

echo "Starting Nginx Services"
systemctl enable nginx
systemctl start nginx

echo "Starting Zabbix Services"
systemctl start zabbix-proxy.service
systemctl start zabbix-agent.service
systemctl enable zabbix-proxy.service
systemctl enable zabbix-agent.service

#Add flight things to path
echo "PATH=$PATH:/opt/flight/bin" >> ~fcops/.bashrc

echo "Updating hostname and /etc/hosts"
DOMAIN=$(hostname |cut -d . -f2-)
CLUSTER_IP=$(ifconfig |grep 10.10 |awk '{print $2}')
VPN_IP=$(ifconfig |grep 10.178 |awk '{print $2}')
hostnamectl set-hostname fcgateway.$DOMAIN

echo "$CLUSTER_IP       fcgateway.$DOMAIN fcgateway" >> /etc/hosts

# Salt master installation
echo "Installing salt master"
curl -L https://hub.fcops.alces-flight.com/resources/salt/install_salt_master.sh | bash
mkdir /opt/salt/srv/root/fcops

# Fcops adopt config
mkdir /opt/fcops/
wget https://hub.fcops.alces-flight.com/resources/keys/adopt_config -O /opt/fcops/adopt_config
chown -R fcops:fcops /opt/fcops


echo -e "\033[0;32m==== WEBSERVER SETUP COMPLETE ====\033[0m"
echo "This gateways VPN IP is: "$VPN_IP
echo "Add this proxy server to Zabbix (via Frontend on ops-hub)"
