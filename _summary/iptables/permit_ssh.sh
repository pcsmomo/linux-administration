#!/bin/bash

iptables -F

# one of my machine
iptables -A INPIUT -p tcp --dport 22 -s 192.168.0.112 -j ACCEPT
iptables -A INPIUT -p tcp --dport 22 -j DROP
# iptables -A INPIUT -p tcp --dport 22 -s 0/0 -j DROP  # this is the same as above

iptables -A INPUT -p tcp -m multiport --dports 80,443 -j DROP