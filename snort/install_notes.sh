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



#Setup SNORT USER / DIRS

#Grab latest rules
