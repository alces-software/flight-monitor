#!/bin/bash
zaburl=https://hub.fcops.alces-flight.com/api_jsonrpc.php
zabreq=$(cat $1)
curl -s -X POST -H 'Content-Type: application/json' $zaburl -d "$zabreq" |json_pp
