#!/bin/bash

################################################################################
# (c) Copyright 2018 Stephen F Norledge & Alces Software Ltd.                  #
#                                                                              #
# HPC Cluster Toolkit                                                          #
#                                                                              #
# This file/package is part of the HPC Cluster Toolkit                         #
#                                                                              #
# This is free software: you can redistribute it and/or modify it under        #
# the terms of the GNU Affero General Public License as published by the Free  #
# Software Foundation, either version 3 of the License, or (at your option)    #
# any later version.                                                           #
#                                                                              #
# This file is distributed in the hope that it will be useful, but WITHOUT     #
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or        #
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License #
# for more details.                                                            #
#                                                                              #
# You should have received a copy of the GNU Affero General Public License     #
# along with this product.  If not, see <http://www.gnu.org/licenses/>.        #
#                                                                              #
# For more information on Alces Software, please visit:                        #
# http://www.alces-software.org/                                               #
#                                                                              #
################################################################################

machines=$1
passphrase=$2

if [ -z ${machines} ]; then
    echo ""
    echo "Error! Usage: $0 <machines> (specify in the same format as pdsh -w )"
    echo ""
    echo "e.g. $0 node0[1-4]"
    echo ""
    exit 1
fi
:

cluster=`hostname -f | sed 's|.*\.\(.*\)\.alces.network$|\1|g'`

echo
echo "Running tripwire --check on ${cluster} for the nodes specified by:  ${machines}"
echo 

pdsh -w ${machines} "/etc/tripwire/alces-tripwire-check.sh ${passphrase}" > /dev/null 2>&1

#
# Now let's take a look at the results.
#
detected_changes=`pdsh -w ${machines} 'cat /var/lib/tripwire/report/.twstatus.txt' | grep "1$" | wc -l`

echo ""
echo "Tripwire has detected changes across: ${detected_changes} nodes."
echo ""

#nodes_changed=`pdsh -w ${machines} 'cat /var/lib/tripwire/report/.twstatus.txt' | egrep -v "0$" | egrep -o "^[[:alnum:]]*"`

#echo -e "Nodes changed are:\n${nodes_changed}"

exit 0
