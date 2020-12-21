#!/bin/bash

#Dependancies
sudo yum install -y gcc flex bison zlib libpcap pcre libdnet tcpdump
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y libnghttp2

#Snort install
cd /tmp
wget https://www.snort.org/downloads/archive/snort/daq-2.0.6-1.f21.x86_64.rpm 
yum localinstall daq-2.0.6-1.f21.x86_64.rpm
wget https://www.snort.org/downloads/archive/snort/snort-2.9.9.0-1.centos7.x86_64.rpm
yum localinstall snort-2.9.9.0-1.centos7.x86_64.rpm
rm -rf daq-2.0.6-1.f21.x86_64.rpm snort-2.9.9.0-1.centos7.x86_64.rpm
cd

#Setup SNORT USER / DIRS
sudo groupadd snort
sudo useradd snort -r -s /sbin/nologin -c SNORT_IDS -g snort

sudo mkdir -p /etc/snort/rules
sudo mkdir /var/log/snort
sudo mkdir /usr/local/lib/snort_dynamicrules

sudo chmod -R 5775 /etc/snort
sudo chmod -R 5775 /var/log/snort
sudo chmod -R 5775 /usr/local/lib/snort_dynamicrules
sudo chown -R snort:snort /etc/snort
sudo chown -R snort:snort /var/log/snort
sudo chown -R snort:snort /usr/local/lib/snort_dynamicrules

#Grab latest rules
wget https://www.snort.org/rules/snortrules-snapshot-3031.tar.gz?oinkcode=f5dc50fba9177525894ded43ea05cd500d068d2f -O snortrules-snapshot-3031.tar.gz
wget https://www.snort.org/rules/snortrules-snapshot-3034.tar.gz?oinkcode=f5dc50fba9177525894ded43ea05cd500d068d2f -O snortrules-snapshot-3034.tar.gz
wget https://www.snort.org/rules/snortrules-snapshot-2983.tar.gz?oinkcode=f5dc50fba9177525894ded43ea05cd500d068d2f -O snortrules-snapshot-2983.tar.gz
wget https://www.snort.org/rules/snortrules-snapshot-3000.tar.gz?oinkcode=f5dc50fba9177525894ded43ea05cd500d068d2f -O snortrules-snapshot-3000.tar.gz
wget https://www.snort.org/rules/snortrules-snapshot-29111.tar.gz?oinkcode=f5dc50fba9177525894ded43ea05cd500d068d2f -O snortrules-snapshot-29111.tar.gz
wget https://www.snort.org/rules/snortrules-snapshot-29130.tar.gz?oinkcode=f5dc50fba9177525894ded43ea05cd500d068d2f -O snortrules-snapshot-29130.tar.gz
wget https://www.snort.org/rules/snortrules-snapshot-29141.tar.gz?oinkcode=f5dc50fba9177525894ded43ea05cd500d068d2f -O snortrules-snapshot-29141.tar.gz
wget https://www.snort.org/rules/snortrules-snapshot-29150.tar.gz?oinkcode=f5dc50fba9177525894ded43ea05cd500d068d2f -O snortrules-snapshot-29150.tar.gz
wget https://www.snort.org/rules/snortrules-snapshot-29151.tar.gz?oinkcode=f5dc50fba9177525894ded43ea05cd500d068d2f -O snortrules-snapshot-29151.tar.gz
wget https://www.snort.org/rules/snortrules-snapshot-29160.tar.gz?oinkcode=f5dc50fba9177525894ded43ea05cd500d068d2f -O snortrules-snapshot-29160.tar.gz
wget https://www.snort.org/rules/snortrules-snapshot-29161.tar.gz?oinkcode=f5dc50fba9177525894ded43ea05cd500d068d2f -O snortrules-snapshot-29161.tar.gz
wget https://www.snort.org/rules/snortrules-snapshot-29170.tar.gz?oinkcode=f5dc50fba9177525894ded43ea05cd500d068d2f -O snortrules-snapshot-29170.tar.gz

