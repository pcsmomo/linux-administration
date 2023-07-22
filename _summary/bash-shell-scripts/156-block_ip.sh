#!/bin/bash
read -p "Enter the IP address of domain to block: " ip
iptables -I INPUT -s $ip -j DROP
echo "The packets from $ip will be dropped."
