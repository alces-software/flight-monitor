#!/bin/bash

# a script to check for infiniband errors

ibqueryerrors | grep -vi PortXmitWait | grep -vi PortRcvSwitchRelayErrors | grep -vi for | wc -l 
