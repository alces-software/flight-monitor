#!/bin/bash
################################################################################
# (c) Copyright 2007-2011 Alces Software Ltd                                   #
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

# Script to check the status of the dirvish backup system

# Set site variables (edit as necessary)
dirvishmaster=/etc/dirvish/master.conf

if [ "$1" == "-v" ] ; then
  echo "Setting verbose mode..."
  VERBOSE=1
else
  VERBOSE=0
fi

# Check dirvish master config file is present
[[ -f $dirvishmaster ]] || exit 3

bank=`grep -A 1 -i bank /etc/dirvish/master.conf | grep -vi bank: | awk '{print $1}'`

# Override automatic dirvish bank detection if required
#bank=/users/backup


# Step through all backups recorded and look for exit status
success=0
warning=0
error=0
failure=0

# Look for a running backup
running=`ps -ef | grep dirvish | grep -v grep | grep "/usr/bin/perl" | wc -l`

for backup in `find $bank -maxdepth 3 -name summary`
do
   case `tail -1 $backup | cut -d: -f 2 | awk '{print $1}'` in
      "success")
          success=`expr $success + 1`
          ;;
      "warning")
          if [ $VERBOSE -eq 1 ] ; then
             echo "warning - $backup"
          fi
          warning=`expr $warning + 1`
          ;;
      "error")
          if [ $VERBOSE  -eq 1 ] ; then
             echo "error - $backup"
          fi
          error=`expr $error + 1`
          ;;
      *)
          if [ $VERBOSE -eq 1 ] ; then
             echo "failure - $backup"
          fi
          failure=`expr $failure + 1`
          ;;
   esac
done

# If dirvish was running when we performed our check, one backup directory will be incorrected detected as failed
if [ $failure -gt 0 ] && [ $running -gt 0 ] ; then
   failure=`expr $failure - 1`
   if [ $VERBOSE -eq 1 ] ; then
      echo "Detected running backup - skipping one failure report"
   fi
fi


if [ $failure -gt 0 ] ; then
   echo "CRITICAL - Detected $failure failed dirvish backups ($error/$warning/$success backups with errors/warnings/successful)"
   exit 2
elif [ $error -gt 0 ] ; then
   echo "CRITICAL - Detected $error dirvish backup(s) with errors ($warning/$success backups with warnings/successful)"
   exit 2
elif [ $warning -gt 0 ] ; then
   echo "WARNING - Detected $warning dirvish backup(s) with warnings ($success backups successful)"
   exit 1
elif [ $success -gt 0 ] ; then
   echo "OK - Detected $success successful dirvish backup(s)"
   exit 0
else
   echo "OK - No dirvish backups recorded"
   exit 0
fi
