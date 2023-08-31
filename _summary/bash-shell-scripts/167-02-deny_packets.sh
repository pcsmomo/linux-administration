#!/bin/bash

for ip in $(cat 167-02-ips.txt)
do
  echo "Dropping packcets from $ip"
  iptables -I INPUT -s $ip -j DROP
done