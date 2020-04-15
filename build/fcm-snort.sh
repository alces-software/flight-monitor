#!/bin/bash

#Install Snort from REPO
yum install -e0 -q https://github.com/alces-software/flight-monitor/blob/master/resources/snort-2.9.16-1.centos7.x86_64.rpm?raw=true

#Sym link needed if `snort -v` not found/errors
#ln -s /usr/lib64/libdnet.so.1.0.1 /usr/lib64/libdnet.1


