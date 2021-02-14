#!/bin/bash
# Script to check RPMs which have previously been installed to the new nodes gender group + installs packages where necessary
#Notes from node072 install
cd /users/fcops/git/flight-monitor-resources/kelvin2/apps_scripts/compute
for script in $(ls) ; do pdsh -w node072 "curl http://fcgateway/resources/apps_scripts/$script |/bin/bash" ; done
