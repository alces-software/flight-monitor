#!/bin/bash

# The new script to check for infiniband errors

ibqueryerrors | grep -i linkdowned | grep -i portrcverrors | grep -i portrcvremotephysicalerrors | grep -i portrcvswitchrelayerrors | grep -i port[rcvlxmit]constrainterrors | grep -i rcvremotephyserrors | grep -i symbolerrors | grep -i vl15drop | grep -i xmtdiscards | wc -l   
