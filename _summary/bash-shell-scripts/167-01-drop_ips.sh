#!/bin/bash

DROPPED_IPS="8.8.8.8 1.1.1.1 10.10.10.1"
for ip in $DROPPED_IPS
do
  echo "Dropping packcets from $ip"
  iptables -I INPUT -s $ip -j DROP
done
