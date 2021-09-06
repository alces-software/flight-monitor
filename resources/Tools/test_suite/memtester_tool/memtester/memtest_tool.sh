#!/bin/bash

bash /tmp/memtester/bequiet.sh sudo bash /tmp/memtester/run_memtester.sh & sleep $1h

sudo killall -9 memtester

