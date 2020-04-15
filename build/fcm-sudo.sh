#!/bin/bash

useradd -G monitor monitor

echo '## Allows people in group monitor to run all commands' | sudo EDITOR='tee -a' visudo
echo '%monitor	ALL=(ALL)	ALL' | sudo EDITOR='tee -a' visudo

echo "Please set the password for the monitor user with passwd monitor"
