#!/bin/bash

#Dependancies
sudo yum install -y gcc flex bison zlib libpcap pcre libdnet tcpdump
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y libnghttp2

#Snort install from source
sudo yum install -y zlib-devel libpcap-devel pcre-devel libdnet-devel openssl-devel libnghttp2-devel luajit-devel
mkdir ~/snort_src && cd ~/snort_src

#DAQ
wget https://www.snort.org/downloads/snort/daq-2.0.7.tar.gz
tar -xvzf daq-2.0.7.tar.gz
cd daq-2.0.7
./configure && make && sudo make install

#Snort
cd ~/snort_src
wget https://www.snort.org/downloads/snort/snort-2.9.17.tar.gz
tar -xvzf snort-2.9.17.tar.gz
cd snort-2.9.17
./configure --enable-sourcefire && make && sudo make install

#Configre Snort
sudo ldconfig
sudo ln -s /usr/local/bin/snort /usr/sbin/snort

#Setup SNORT USER / DIRS
sudo groupadd snort
sudo useradd snort -r -s /sbin/nologin -c SNORT_IDS -g snort
sudo mkdir -p /etc/snort/rules
sudo mkdir /var/log/snort
sudo mkdir /usr/local/lib/snort_dynamicrules

sudo touch /etc/snort/rules/white_list.rules
sudo touch /etc/snort/rules/black_list.rules
sudo touch /etc/snort/rules/local.rules

sudo cp ~/snort_src/snort-2.9.17/etc/*.conf* /etc/snort
sudo cp ~/snort_src/snort-2.9.17/etc/*.map /etc/snort

#Grab latest rules - registered user
#OINKCODE=$1
#wget https://www.snort.org/rules/snortrules-snapshot-29120.tar.gz?oinkcode=$OINKCODE -O ~/registered.tar.gz

#Change of plan - using 2.9 community rules
cd
wget https://www.snort.org/downloads/community/community-rules.tar.gz
tar xvzf community-rules.tar.gz
sudo cp ~/community-rules/* /etc/snort/rules
#By default, Snort on CentOS expects to find a number of different rule files which are not included in the community rules. Comment out the unnecessary lines using the next command.
sudo sed -i 's/include \$RULE\_PATH/#include \$RULE\_PATH/' /etc/snort/snort.conf


