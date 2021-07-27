#!/bin/bash

echo "hello" > bashoutput.txt & sleep 10
echo "goodbye" > bashoutput.txt
curl -X POST -H 'Content-type: application/json' --data '{"text":"I have finished running"}' https://hooks.slack.com/services/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

# command should look like: memtester <node> <time>
# "memtester" should be an alias of something like "bash memtester.sh &"
# run memtester on given node for given time, automatically halt afterwards (and ping you start & end)
# pdsh run memtester on <node>, then sleep for <time> before halting memtester (how to halt it?).
# should all run as background/new shell instance, only thing user should have to do is the command.


