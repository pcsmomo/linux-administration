#!/bin/bash
echo "Dropping packets from $1"
iptables -I INPUT -s $1 -j DROP
echo "The packets from $1 will be dropped."
