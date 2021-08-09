#!/bin/bash

sudo rm -r memtester.tar.gz

sudo tar -zcvf memtester.tar.gz memtester

pdsh -w $1 "curl 'http://fcgateway/resources/memtester_tool/memtester.tar.gz' > memtester.tar.gz"

pdsh -w $1 "tar -xzvf memtester.tar.gz"

pdsh -w	$1 ./memtester/memtest_tool.sh $2

#pdsh -w $1 "rm -r memtester memtester.tar.gz"
