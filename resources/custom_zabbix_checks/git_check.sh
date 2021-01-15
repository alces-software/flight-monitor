#!/bin/bash

cd /users/fcops/git/flight-monitor-resources
if git status |grep "nothing to commit" >/dev/null
then
	echo "OK - Git is reporting nothing to commit"
else
	echo "WARNING - git needs looking at"
fi
cd
