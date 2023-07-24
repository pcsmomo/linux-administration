#!/bin/bash

iptables -F

iptables -A INPUT -p tcp --dport 22 -m time --timestart 10:00 --timestop 16:00 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -m time -j DROP

iptables -A FORWARD -p tcp --dport 442 -d www.ubuntu.com -m time --timestart 18:00 --timestop 8:00 -j ACCEPT
iptables -A FORWARD -p tcp --dport 442 -d www.ubuntu.com -j DROP