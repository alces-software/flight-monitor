#!/bin/bash

#read intensity

$intensity=echo $(1^^)

if [ $intensity == "LONG" ] then

	echo "This functionality doesn't exist yet."

elif [ $intensity == "MED" ] then

	echo "This functionality doesn't exist yet."

elif [ $intensity == "SHORT" ] then

	bash run_invtool.sh $1
	bash run_memtool.sh $1 0.5
else
	echo "Please enter a valid intensity."
	echo "Valid intensities are as follows: "
	echo "LONG tests will take 24 hours to complete."
	echo "MED tests will take 8 hours to complete."
	echo "SHORT tests will take 1 hour to complete."
fi


