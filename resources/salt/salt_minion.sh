#!/bin/bash

if [ $(cat /etc/hosts | grep -c fcgateway) -le 0 ]; then
  echo "10.10.0.2    fcgateway    fcgw" >> /etc/hosts
fi

mkdir -p /opt/salt/{bin,cache,conf,run,log,pki,etc/salt}

wget http://fcgateway/resources/salt/salt_minion.tgz -O salt_minion.tgz
tar -zxvf salt_minion.tgz -C /opt/

mkdir -p /usr/lib/python2.7/site-packages/salt/ 
cp -R /opt/salt/reqs/site-packages/* /usr/lib/python2.7/site-packages/

yum -y install python-jinja2 python2-msgpack libyaml python-markupsafe python-requests python-backports_abc python-singledispatch zeromq python-zmq m2crypto PyYAML python2-crypto

cat << 'EOF' > /usr/lib/systemd/system/salt-minion.service
[Unit]
Description=The Salt Minion
After=syslog.target network.target

[Service]
Type=simple
ExecStart=/opt/salt/bin/salt-minion -c /opt/salt/conf

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable salt-minion
systemctl start salt-minion
