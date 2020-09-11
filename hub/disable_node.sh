#!/bin/bash

if [ $# -eq 0 ] ; then
        echo "Please provide a hostname"
        echo "See -help for further info"
        exit 1
else
        if [ $1 == "-help" ] ; then
                echo "Usage: ./disable_node.sh hostname"
                echo "Please use FQDN, eg:"
                echo "Hostname format: cnode01.cloud.pri.cluster.alces.network"
                exit 0
        else
                echo "Disabling $1"
        fi
fi


request='bash /home/dan.shaw/json_req.sh'
host_list="/home/dan.shaw/hosts.txt"
hostname=$1

#Get hostID of node
host_id=$($request $host_list |grep $hostname -B 1 |grep hostid |awk '{print $3}' |sed 's/"//g' |sed 's/,//g')

#Should implement some way of determining if host is legit?

disable_json='/home/dan.shaw/disable_json.txt'

#Put hostID into the json request
sed -i s/replace_me/"$host_id"/g $disable_json

#Disable node
$request $disable_json

#Return json req back to template
sed -i s/"$host_id"/replace_me/g $disable_json
