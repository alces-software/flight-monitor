#!/bin/bash

# The new script to check for infiniband errors

ibqueryerrors | grep -i 'linkdowned\|portrcverrors\|portrcvremotephysicalerrors\|portrcvswitchrelayerrors\|constrainterrors\|rcvremotephyserrors\|symbolerrors\|vl15drop\|xmtdiscards' | wc -l    
