#!/bin/bash

source /tmp/invtool/config.sh


#Check if expected filesystems are mounted
IFS=,
for filesystem in $expected_filesystem_list ; do
        if [ $(df -h | grep -c $filesystem) -eq 0 ] ; then
                echo "$filesystem not found";
        fi
done;


#Check if memory is as expected
totalMem=$(free -hm | grep Mem | awk '{print $2}' | sed "s/[^0-9]//g")
if [ "$totalMem" -ne "$expectedMem" ] ; then
        echo "Unexpected amount of memory present." ;
fi

#Check if CPU count is as expected
CPUcount=$(grep -ci "xeon" /proc/cpuinfo)
if [ $CPUcount -ne $expectedCount ] ; then
        echo "Unexpected number of CPUs detected." ;
fi

#Check for hyperthreading
if  [ $(lscpu | grep Thread | tr -s ' ' | cut -d ' ' -f4) -gt 1 ] ; then
        echo "Hyperthreading present on node." ;
fi

#Check if IB is available
#ibStatus=$(sudo ibstatus | grep -c "ACTIVE")
#if [ $ibstatus -lt 1 ] ; then
#       echo "IB switches down." ;
#fi

