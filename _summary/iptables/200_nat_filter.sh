#!/bin/bash

iptables -F FORWARD

PERMITTED_MACS="08:00:27:55:6f:20 08:00:27:55:6f:21 08:00:27:55:6f:22 08:00:27:55:6f:23"

for MAC in $PERMITTED_MACS
do
  iptables -A FORWARD -m mac --mac-source $MAC -j ACCEPT
  echo "$MAC permitted"
done

iptables -P FORWARD DROP