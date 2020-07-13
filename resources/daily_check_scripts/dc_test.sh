#!/bin/bash
echo "uptime is:" ; uptime ;

echo "~
~
~
 disk space free is:" ; df -h | grep -vi tmp ;  

echo "~
~
~
 free space:" ; free -m ; 

echo "~
~ 
~ 
Please remember to manually check /var/log/messages,in this instance from [controller]  and have a good day :) "
