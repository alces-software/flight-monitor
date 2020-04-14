#!/bin/bash

adduser monitor
groupadd monitor

cat << FOE >> /etc/sudoers
## Allows people in group monitor to run all commands
%monitor	ALL=(ALL)	ALL
FOE

usermod –aG monitor monitor

echo "Please set the password for the monitor user with passwd monitor"
