```sh
ssh root@170.64.181.165
```

## Section 22: [EXTRA] Security: Information Gathering and Sniffing Traffic

### 179. Scanning Networks with Nmap

NMAP is a network discovery and security auditing tool

- TCP Scans:
  - SYN Scan: -sS (root only)
  - Connect Scan: -sT
- UDT Scan: -sU
- ICMP Scan: -sn or -sP

#### Options

- `-sV`: including version
- `-p-`: all ports (it will take some time)

Example: `nmap -sS -p 22,100 -sV 192.168.0.1`

GUI interface from official NMAP: [Zenmap GUI](https://nmap.org/zenmap/)

```sh
# from linux 2
apt insetall nmap

nmap 192.168.0.20
nmap -sS 192.168.0.20 # can't do this without root permission
nmap -sS 170.64.181.165
# Starting Nmap 7.80 ( https://nmap.org ) at 2023-07-01 09:42 AEST
# Nmap scan report for 170.64.181.165
# Host is up (0.0067s latency).
# Not shown: 996 filtered ports
# PORT    STATE SERVICE
# 22/tcp  open  ssh
# 53/tcp  open  domain
# 80/tcp  open  http
# 443/tcp open  https

# Nmap done: 1 IP address (1 host up) scanned in 5.79 seconds

nmap -sT 170.64.181.165
# Starting Nmap 7.80 ( https://nmap.org ) at 2023-07-01 09:42 AEST
# Nmap scan report for 170.64.181.165
# Host is up (0.013s latency).
# Not shown: 996 filtered ports
# PORT    STATE SERVICE
# 22/tcp  open  ssh
# 53/tcp  open  domain
# 80/tcp  open  http
# 443/tcp open  https

# Nmap done: 1 IP address (1 host up) scanned in 4.77 seconds
```

```sh
# on destication
vim /etc/ssh/sshd_config
# change the port 50005 from 22
system
systemctl resstart ssh
netstat -tupan | grep ssh
netstat -tupan | grep ssh
# tcp        0      0 0.0.0.0:50005              0.0.0.0:*               LISTEN      890/sshd: /usr/sbin
# tcp6       0      0 :::50005                   :::*                    LISTEN      890/sshd: /usr/sbin
```

```sh
# on linux 2

# port 22 is gone and can't see port 50005 either
nmap 170.64.181.165
# PORT    STATE SERVICE
# 53/tcp  open  domain
# 80/tcp  open  http
# 443/tcp open  https

nmap -p 20,22,80,50005 170.64.181.165
# PORT      STATE   SERVICE
# 20/tcp    closed  ftp-data
# 22/tcp    closed  ssh
# 80/tcp    open    http
# 50005/tcp open    unknown

nmap -p 80,50005 -sV 170.64.181.165
# Starting Nmap 7.80 ( https://nmap.org ) at 2023-07-01 09:57 AEST
# Nmap scan report for 170.64.181.165
# Host is up (0.0050s latency).

# PORT      STATE SERVICE VERSION
# 80/tcp    open  http    Apache httpd 2.4.54
# 50005/tcp open  ssh     OpenSSH 9.0p1 Ubuntu 1ubuntu7 (Ubuntu Linux; protocol 2.0)
# Service Info: Host: ticketing-prod.site; OS: Linux; CPE: cpe:/o:linux:linux_kernel

# Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done: 1 IP address (1 host up) scanned in 8.53 seconds

# Scanning all ports (when enter it will show the progress)
nmap -p- 170.64.181.165
# Starting Nmap 7.80 ( https://nmap.org ) at 2023-07-01 09:59 AEST

# Stats: 0:00:05 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
# SYN Stealth Scan Timing: About 1.58% done; ETC: 10:04 (0:05:12 remaining)

# Stats: 0:00:14 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
# SYN Stealth Scan Timing: About 7.34% done; ETC: 10:02 (0:02:57 remaining)

# UDP scan
nmap -sU localhost
# Starting Nmap 7.80 ( https://nmap.org ) at 2023-07-01 09:59 AEST
# Nmap scan report for localhost (127.0.0.1)
# Host is up (0.0000030s latency).
# Not shown: 998 closed ports

# PORT     STATE         SERVICE
# 631/udp  open|filtered ipp
# 5353/udp open|filtered zeroconf

# Nmap done: 1 IP address (1 host up) scanned in 1.30 seconds

# ICMP Scan, it will display all networks
nmap -sn 192.168.0.0/24
Starting Nmap 7.80 ( https://nmap.org ) at 2023-07-01 10:00 AEST
```

### 180. ARP Scanning (arp-scan and netdiscover)

```sh
arp -an
apt install arp-scan
arp-scan --help
# --localnet or -l option is the most useful

ifconfig
arp-scan -I eth0 -l
```

```sh
apt update && apt install netdiscover
netdiscover
#  Currently scanning: 192.168.28.0/16   |   Screen View: Unique Hosts

#  0 Captured ARP Req/Rep packets, from 0 hosts.   Total size: 0
#  _____________________________________________________________________________
#    IP            At MAC Address     Count     Len  MAC Vendor / Hostname
#  -----------------------------------------------------------------------------

netdiscover -i eth0

# whole network
netdiscover -i eth0 -r 192.168.0.0/24
```

### 181. Hacking Google Searches (Google Dorks)

[Google dorks](https://www.exploit-db.com/google-hacking-database)

- "web scraping with python"
- Tools: past year
- "web scraping with python" filetype:pdf
- 2022 apple sales filetype:xlsx
- 2022 apple sales -iphone filetype:xlsx
  - exclude iphone keyword
- site:wikipedia.org intitle:security
- (bitcoin | ethereum) hash algorithm

Or navigate https://google.com/advanced_search

### 182. Using Wireshark for Packet Sniffing and Analyzing

[Wire Shark](https://www.wireshark.org/)

```sh
apt install wireshark
```

### 183. Capture Traffic Using tcpdump

[TCPDUMP](https://www.tcpdump.org/)

```sh
tcpdump -i eth0
tcpdump -i eth0 host 8.8.8.8
tcpdump -i eth0 dst medium.com -n
tcpdump -i eth0 net 192.168.0.0/24
tcpdump -i eth0 port 443 -vv -n
tcpdump -i eth0 dst port 53 -vv -n
tcpdump -i eth0 port 80 -A -n
```

```sh
# write and read
tcpdump -i eth0 port 80 -w cern.ch.pcap
tcpdump -r cern.ch.pcap
```

```sh
tcpdump -r cern.ch.pcap -n -vv -X
tcpdump -i eth0 icmp and host 8.8.8.8
tcpdump -i eth0 port 80 or port 443
```

## Section 23: [EXTRA] IPFS - The Interplanetary File System

### 184. What is IPFS and How It Works

- InterPlanetary File System (IPFS) is a protocol designed to create a permanent and decentralized method of storing ad sharing files;
- IPFS aims to replace HTTP and build a better web

IPTF Properties:

- IPFS is a peer-to-peer, decentralized, and destributed file system;
- IPFS is a CDN
- IPFS is also fault-tolerant with zero downtime
- IPFS is consorship-resistant
- IPFS uses content address (not location address like HTTP)

#### Content Addressing vs Location Addressing

- ## Location Addressing

```sh
echo "This is just an example for IPFS." > ipfs.txt

snap install ipfs
# ipfs 0.17.0 from Leo Arias (elopio) installed
sudo ipfs add ipfs.txt
# added {HASH} ipfs.txt

# Navigate, www.ipfs.io/ipfs/{HASH}

# download it via scp
scp -P 2299 ipfs.txt root@170.64.181.165:/var/www/html
```

### 185. Installing IPFS on Linux

- [Install IPFS Desktop][https://github.com/ipfs/ipfs-desktop#mac]
- [Download IPFS Distirubitions](https://dist.ipfs.tech/)

```sh
# (for mac)
brew install --cask ipfs

sudo ipfs init
sudo ipfs id

sudo ipfs swarm peers
sudo ipfs cat /ipfs/QOASDIOVXC1VJQOZLKXDCKXZCVLA > ~/Desktop/spaceship.jpg
```

### 186. Running an IPFS Node on Linux

```sh
sudo ipfs daemon
```

```sh
mkdir Project
cp /etc/passwd Project/

# add a screenshot to the Project folder

# -r: recursive
ipfs add -r Project/
sudo ipfs ls [HASH]
```

### 187. Pinning Objects

Pinning prevents to be removed by garbage collector

```sh
ip addr > ip.txt
sudo ipfs add ip.txt
sudo ipfs pin ls --type=all
sudo ipfs pin rm [HASH]
sudo ipfs cat [HASH]  # it is still there!

# to remove the pinned file, manually run the garbage collector
sudo ipfs repo gc
```

#### Some examples of pinning services

- [Pinata Cloud](https://www.pinata.cloud/)
- [Infura](https://www.infura.io/)
- [Eternum IO](https://www.eternum.io/)

## Section 24: [EXTRA] Security: Netfilter and Iptables Firewall

### 188. Introduction to Netfilter and Iptables

- `Netfilter` is **software firewall, a packet filtering framework inside the Linux Kernel**
- It enables **packet filtering, NAT, PAT, Port Forwarding and packet mangling**
- Netfilter framework is controlled by the `iptables` command
- Iptables is a tool that belongs to the **user-space** used to configure netfilter
- Netfilter and iptables are often combined into a single expression netfilter/iptables
- Every Linux distribution uses netfilter/iptables, there is nothing extra that should be installed
- Only root user can use or configure the netfilter framework

### 189. Chain Traversal in a Nutshell

- `Incoming traffic` is filtered on the `INPUT CHAIN` of the `filter table`
- `Outcoming traffic` is filtered on the `OUTPUT CHAIN` of the filter table
- `Routed traffic` is filtered on the `FORWARD CHAIN` of the filter table
- `SNAT/MASQUERADE` is performed on the `POSTROUTING CHAIN` of the `nat table`
- `DNAT/Port Forwarding` is performed on the `PREROUTING CHAIN` of the `nat table`
- To modify values from the packet's headers add rules to the `mangle table`
- To skip the connection tracking add rules with `NOTRACK target` to the `raw table`

### 190. Iptables Basic Usage

`iptables [-t table_name] -COMMAND CHANGE_NAME matches -j TARGET`

| Table            | Command      | CHAIN        | matches          | Target/Jump |
| ---------------- | ------------ | ------------ | ---------------- | ----------- |
| filter (default) | -A (append)  | INPUT        | -s source_ip     | ACCEPT      |
| nat              | -i (insert)  | OUTPUT       | -d dest_ip       | DROP        |
| mangle           | -D (delete)  | FORWARD      | -p protocol      | REJECT      |
| raw              | -R (replace) | PREROUTING   | --sport source_p | LOG         |
|                  | -F (flush)   | POSTROUTING  | --dport dest_p   | SNAT        |
|                  | -Z (zero)    | USER_DEFINED | -i incoming_int  | DNAT        |
|                  | -L (list)    |              | -o outgoing_int  | MASQUERADE  |
|                  | -S (show)    |              | -m mac           | LIMIT       |
|                  | -N           |              | -m time          | RETURN      |
|                  | -X           |              | -m quota         | TEE         |
|                  |              |              | -m limit         | TOS         |
|                  |              |              | -m recent        | TTL         |

```sh
sudo iptables -L
# Chain INPUT (policy ACCEPT)
# target     prot opt source               destination

# Chain FORWARD (policy ACCEPT)
# target     prot opt source               destination

# Chain OUTPUT (policy ACCEPT)
# target     prot opt source               destination

iptables -t nat -L
# Chain PREROUTING (policy ACCEPT)
# target     prot opt source               destination

# Chain INPUT (policy ACCEPT)
# target     prot opt source               destination

# Chain OUTPUT (policy ACCEPT)
# target     prot opt source               destination

# Chain POSTROUTING (policy ACCEPT)
# target     prot opt source               destination
```

- Open another terminal and ping to the server
- on the main linux, drop it during ping

```sh
ping 170.64.181.165
# PING 170.64.181.165 (170.64.181.165): 56 data bytes
# 64 bytes from 170.64.181.165: icmp_seq=0 ttl=53 time=38.018 ms
# 64 bytes from 170.64.181.165: icmp_seq=1 ttl=53 time=37.246 ms
# 64 bytes from 170.64.181.165: icmp_seq=2 ttl=53 time=33.443 ms
# Request timeout for icmp_seq 3
# 64 bytes from 170.64.181.165: icmp_seq=4 ttl=53 time=371.452 ms
# 64 bytes from 170.64.181.165: icmp_seq=5 ttl=53 time=1374.732 ms
# 64 bytes from 170.64.181.165: icmp_seq=6 ttl=53 time=37.022 ms
```

#### INPUT

- icmp (The Internet Control Message Protocol which): a protocol that devices within a network use to communicate problems with data transmission

```sh
iptables -t filter -A INPUT -p icmp --icmp-type echo-request -j DROP
# "-t filter" is a default so this command is the same
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

iptables -L
# Chain INPUT (policy ACCEPT)
# target     prot opt source               destination
# DROP       icmp --  anywhere             anywhere             icmp echo-request

iptables -vnL
# Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
#  pkts bytes target     prot opt in     out     source               destination
#   144 12096 DROP       icmp --  *      *       0.0.0.0/0            0.0.0.0/0            icmptype 8
```

#### OUTPUT

Navigate www.ubuntu.com on the browser, it will work

```sh
iptables -t filter -A OUTPUT -p tcp --dport 80 -d www.ubuntu.com -j DROP
iptables -t filter -A OUTPUT -p tcp --dport 443 -d www.ubuntu.com -j DROP

iptables -L -vn
# Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
#  pkts bytes target     prot opt in     out     source               destination
#   381 32004 DROP       icmp --  *      *       0.0.0.0/0            0.0.0.0/0            icmptype 8

# Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
#  pkts bytes target     prot opt in     out     source               destination

# Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
#  pkts bytes target     prot opt in     out     source               destination
#     0     0 DROP       tcp  --  *      *       0.0.0.0/0            185.125.190.21       tcp dpt:80
#     0     0 DROP       tcp  --  *      *       0.0.0.0/0            185.125.190.29       tcp dpt:80
#     0     0 DROP       tcp  --  *      *       0.0.0.0/0            185.125.190.20       tcp dpt:80
#     0     0 DROP       tcp  --  *      *       0.0.0.0/0            185.125.190.21       tcp dpt:443
#     0     0 DROP       tcp  --  *      *       0.0.0.0/0            185.125.190.20       tcp dpt:443
#     0     0 DROP       tcp  --  *      *       0.0.0.0/0            185.125.190.29       tcp dpt:443

# Output destinations are all for www.ubuntu.dom
```

Navigate www.ubuntu.com on the browser again and we cannot access now

### DELETE rules

> use `-D` flag. `-A OUTPUT -j ACCEPT` will just add ACCEPT

```sh
iptables -t filter -D OUTPUT -p tcp --dport 80 -d www.ubuntu.com -j DROP
```

### 191. Iptables Options (Flags) - Part 1

| Command            | Description                                                                                                  |
| ------------------ | ------------------------------------------------------------------------------------------------------------ |
| -A, --append       | Append one or more rules to the end of the selected chain.                                                   |
| -I, --insert       | Insert one or more rules in the selected chain as the given rule number.                                     |
| -L, --list         | List all rules in the selected chain. If no chain is selected, all chains are listed.                        |
| -F, --flush        | Flush the selected chain (all the chains in the table if none is given).                                     |
| -Z, --zero         | Zero the packet and byte counters in all chains, or only the given chain, or only the given rule in a chain. |
| -N, --new-chain    | Create a new user-defined chain by the given name.                                                           |
| -X, --delete-chain | Delete the optional user-defined chain specified.                                                            |
| -P, --policy       | Set the policy for the built-in (non-user-defined) chain to the given target.                                |
| -D, --delet        | Delete one or more rules from the selected chain.                                                            |
| -R, --replace      | Replace a rule in the selected chain.                                                                        |

#### -A option

```sh
# Before command this
iptables -A INPUT -p tcp --dport 25 -j DROP
iptables -A INPUT -p tcp --dport 80 -j DROP
apt install apache2

# -L: list, -v: verbose, -n: numiric
iptables -vnL
# Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
#  pkts bytes target     prot opt in     out     source               destination
#     0     0 DROP       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:25
#     0     0 DROP       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:80

# Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
#  pkts bytes target     prot opt in     out     source               destination

# Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
#  pkts bytes target     prot opt in     out     source               destination

## after namp from the other linux
iptables -vnL
# Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
#  pkts bytes target     prot opt in     out     source               destination
#     8   416 DROP       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:25
#    13   676 DROP       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:80
```

On the other terminal

```sh
apt-get install namp
nmap -p 25 170.64.181.165
# Starting Nmap 7.80 ( https://nmap.org ) at 2023-06-09 07:33 AEST
# Nmap scan report for 170.64.181.165
# Host is up (0.031s latency).

# PORT STATE SERVICE
# 25/tcp filtered smtp

# Nmap done: 1 IP address (1 host up) scanned in 0.75 seconds

nmap -p 80 170.64.181.165
# Starting Nmap 7.80 ( https://nmap.org ) at 2023-06-09 07:33 AEST
# Nmap scan report for 170.64.181.165
# Host is up (0.039s latency).

# PORT STATE SERVICE
# 80/tcp filtered http

# Nmap done: 1 IP address (1 host up) scanned in 0.62 seconds
```

#### -I option

- insert the rule at specific position
- it is important as the rules at the bottom part can be ignored

```sh
iptables -I INPUT -p udp --dport 69 -j DROP
iptables -I INPUT 3 -p udp --dport 69 -j DROP

iptables -vnL

iptables -A INPUT -p tcp --dport 80 -j ACCEPT
```

### 192. Iptables Options (Flags) - Part 2

```sh
iptables -nvL

# flush 'filter' table as default
iptables -F INPUT

iptables -nvL

iptables -t nat -F
```

#### -Z: reset packets and bytes

```sh
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT
ssh 192.168.0.20

iptable -Z

iptables -nvL
# Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
#  pkts bytes target     prot opt in     out     source               destination
#     0     0 ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:22
```

#### -N, -X

```sh
iptables -N MYCHAIN
iptables -vnL
# Chain MYCHAIN (0 references)
#  pkts bytes target     prot opt in     out     source               destination

# delete the chain
iptables -X MYCHAIN
```

#### -P

```sh
iptables -P FORWARD DROP
```

#### -D, -R

We don't usually use these commands

```sh
iptables -D OUTPUT 2
```

### 193. Where Do We Write Iptables Rules

```sh
iptable -A INPUT -p icmp -j DROP
```

> when the system is rebooted, all policy will be reset.\
> how to persist them?

```sh
mkdir scripts
cd scripts
vim firewall.sh
```

`#!/bin/bash` : shebang

```sh
#!/bin/bash

# flush all
iptables -F
iptables -t nat -F

# droppping incoming ssh traffic
# iptables -A INPUT -p tcp --dport 22 -j DROP

# droppping outgoing http and https traffic
iptables -A OUTPUT -p tcp --dport 80 -j DROP
iptables -A OUTPUT -p tcp --dport 443 -j DROP

# entire network
iptables -t nat -A POSTROUTING -s 10.0.0.0/8 -o enp0s3 -j SNAT --to-source 80.0.0.1
```

> ⚠️ if you run this script, you won't be able to connect via ssh until reboot!

```sh
chmod 700 firewall.sh
./firewall.sh
iptables -vnL
```

```sh
./firewall.sh
./firewall.sh
iptables -vnL
# it will append rules again and again.
# use `iptables -F`
```

### 194. Setting the Default Policy

- Policy specifies what happens to packets that are not matched against any rule
- By default policy is set to accept all traffic
- Policy can be changed only for INPUT, OUTPUT, and FORWARD chains
- Policy can be changed using -P option

```sh
iptables -vnL
# Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
#  pkts bytes target     prot opt in     out     source               destination

# on the other terminal
ping 170.64.181.165

# it drops all input chain
iptables -P INPUT DROP
iptables -vnL
# Chain INPUT (policy DROP 4 packets, 336 bytes)
#  pkts bytes target     prot opt in     out     source               destination

# it only accepts ssh connection (port 22), but still blocking everything else
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
```

> Be aware of that you could get blocked when you change the linux policy (e.g. if you're working via ssh but you block all input chains)

### 195. Deleting the Firewall (reset)

```sh
cd ~/scripts
vim delete_firewall.sh
```

```sh
#!/bin/bash

#1. Set the ACCEPT policy
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

#2. flush all tables
iptables -t filter -F
iptables -t nat -F
iptables -t mangle -F
iptables -t raw -F

#3. delete user-defined chains
iptables -X
```

```sh
chmod 700 delete_firewall.sh
./delete_firewall.sh
# and this is actually the default policy setup for linux system
```

### 196. Filter by IP Address

- Host address 192.168.0.1
- Network address: 10.0.0.0/8
- Domain name: www.linux.com

1. Match by Source IP or Network Address
   - Match: -s IP, --source IP
   - Example
     ```sh
     iptables -A INPUT -s 100.0.0.0/16 -j DROP
     ```
2. Match by Destination IP or Network Address
   - Match: -d IP, --destination IP
   - Example
     ```sh
     iptables -A FORWARD -d 80.0.0.1 -j DROP
     iptables -A OUTPUT -d www.ubuntu.com -j DROP
     ```

#### By source

```sh
# Linux 2: 192.168.0.20
ping 192.168.0.10
# ping will stop when ip is blocked
```

```sh
# Linux 1: 192.168.0.10
iptables -A INPUT -s 192.168.0.20 -j DROP
```

#### By Destination Network Address

```sh
# Linux 1: 192.168.0.10

ping 8.8.8.8
# PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
# 64 bytes from 8.8.8.8: icmp_seq=1 ttl=114 time=1.44 ms
# 64 bytes from 8.8.8.8: icmp_seq=2 ttl=114 time=0.986 ms

iptables -A OUTPUT -d 8.0.0.0/8 -j DROP

# ping won't work
ping 8.8.8.8
# PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.

iptables -vnL
# Chain OUTPUT (policy ACCEPT 186K packets, 26M bytes)
#  pkts bytes target     prot opt in     out     source               destination
#    21  1764 DROP       all  --  *      *       0.0.0.0/0            8.0.0.0/8
```

#### By Destination IP or domain

```sh
nslookup www.ubuntu.com
# Server:		127.0.0.53
# Address:	127.0.0.53#53

# Non-authoritative answer:
# Name:	www.ubuntu.com
# Address: 185.125.190.20
# Name:	www.ubuntu.com
# Address: 185.125.190.29
# Name:	www.ubuntu.com
# Address: 185.125.190.21
# Name:	www.ubuntu.com
# Address: 2620:2d:4000:1::28
# Name:	www.ubuntu.com
# Address: 2620:2d:4000:1::27
# Name:	www.ubuntu.com
# Address: 2620:2d:4000:1::26

dig www.ubuntu.com
# ;; ANSWER SECTION:
# www.ubuntu.com.		30	IN	A	185.125.190.20
# www.ubuntu.com.		30	IN	A	185.125.190.29
# www.ubuntu.com.		30	IN	A	185.125.190.21

###################################
# we could add IPs one by one
# iptables -A OUTPUT -d 185.125.190.20 -j DROP
# iptables -A OUTPUT -d 185.125.190.29 -j DROP
# iptables -A OUTPUT -d 185.125.190.21 -j DROP

# or
iptables -A OUTPUT -d www.ubuntu.com -j DROP

iptables -vnL
# Chain OUTPUT (policy ACCEPT 186K packets, 26M bytes)
#  pkts bytes target     prot opt in     out     source               destination
#     0     0 DROP       all  --  *      *       0.0.0.0/0            185.125.190.29
#     0     0 DROP       all  --  *      *       0.0.0.0/0            185.125.190.21
#     0     0 DROP       all  --  *      *       0.0.0.0/0            185.125.190.20
```

#### by Netmask

```sh
iptables -A OUTPUT -p tcp --dport 443 -d 0/0 -j ACCEPT

iptables -vnL
# Chain OUTPUT (policy ACCEPT 187K packets, 26M bytes)
#  pkts bytes target     prot opt in     out     source               destination
#     0     0 ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:443
```

```sh
# reset
./scripts/delete_firewall.sh

iptables -vnL
# Chain INPUT (policy ACCEPT 70 packets, 6928 bytes)
#  pkts bytes target     prot opt in     out     source               destination

# Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
#  pkts bytes target     prot opt in     out     source               destination

# Chain OUTPUT (policy ACCEPT 49 packets, 7415 bytes)
#  pkts bytes target     prot opt in     out     source               destination
```

### 197. Filter by Port

1. Match by a single port
   - Match: -p tcp --dport port, -p udp -sport port
   - Example
     ```sh
     iptables -A INPUT -s tcp --dport 22 -j DROP
     ```
2. Match by multiple ports
   - Match: -m multiport --sports | --dports port1,port2,...
   - Example
     ```sh
     iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -j DROP
     ```

```sh
# Linux 2: 192.168.0.20
nmap 192.168.0.10

# I've tested to itself (the linux 1)

# nmap 170.64.181.165
# Starting Nmap 7.92 ( https://nmap.org ) at 2023-06-18 21:52 UTC
# Nmap scan report for ubuntu-s-1vcpu-1gb-syd1-01 (170.64.181.165)
# Host is up (0.0000050s latency).
# Not shown: 996 closed tcp ports (reset)
# PORT    STATE SERVICE
# 22/tcp  open  ssh
# 53/tcp  open  domain
# 80/tcp  open  http
# 443/tcp open  https
```

```sh
# Linux 1: 192.168.0.10
iptables -A INPUT -p tcp --dport 25 -j DROP
iptables -vnL
# Chain INPUT (policy ACCEPT 479K packets, 119M bytes)
#  pkts bytes target     prot opt in     out     source               destination
#     0     0 DROP       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:25

nmap 170.64.181.165
# PORT    STATE    SERVICE
# 22/tcp  open     ssh
# 25/tcp  filtered smtp
# 53/tcp  open     domain
# 80/tcp  open     http
# 443/tcp open     https

nmap -p 55 170.64.181.165
# PORT   STATE  SERVICE
# 55/tcp closed isi-gl
```

```sh
# Linux 1: 192.168.0.10
iptables -A INPUT -p tcp --dport 80 -j DROP
iptables -vnL
# Chain INPUT (policy ACCEPT 482K packets, 119M bytes)
#  pkts bytes target     prot opt in     out     source               destination
#     2    88 DROP       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:25
#    18  1152 DROP       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:80
```

#### filter the specific ip

```sh
cd scripts
vim permit_ssh.sh
```

```sh
#!/bin/bash

iptables -F

# one of my machine
iptables -A INPIUT -p tcp --dport 22 -s 192.168.0.112 -j ACCEPT
iptables -A INPIUT -p tcp --dport 22 -j DROP
# iptables -A INPIUT -p tcp --dport 22 -s 0/0 -j DROP  # this is the same as above

iptables -A INPUT -p tcp -m multiport --dports 80,443 -j DROP
```

```sh
chmod 700 permit_ssh.sh
./permit_ssh.sh
```

```sh
# check if the port before/after running the script
# Linux 2: 192.168.0.20

# Before running the script
nmap -p 22 192.168.0.10
# PORT    STATE    SERVICE
# 22/tcp  open     ssh

# After running the script
nmap -p 22 192.168.0.10
# PORT    STATE    SERVICE
# 22/tcp  filtered     ssh

# Before running the script
nmap -p 80,443 192.168.0.10
# PORT    STATE    SERVICE
# 80/tcp  open     http
# 443/tcp open     https

# After running the script
nmap -p 80,443 192.168.0.10
# Starting Nmap 7.80 ( https://nmap.org ) at 2023-06-19 08:10 AEST
# Note: Host seems down. If it is really up, but blocking our ping probes, try -Pn
# Nmap done: 1 IP address (0 hosts up) scanned in 3.04 seconds

# but using ping, it is still accessible
nmap -p 80,443 192.168.0.10 -P0
# Starting Nmap 7.80 ( https://nmap.org ) at 2023-06-19 08:13 AEST
# Nmap scan report for 170.64.181.165
# Host is up.

# PORT STATE SERVICE
# 80/tcp filtered http
# 443/tcp filtered https

# Nmap done: 1 IP address (1 host up) scanned in 3.17 seconds
```

```sh
iptables -vnL
# Linux 1: 192.168.0.10
# Chain INPUT (policy ACCEPT 484K packets, 119M bytes)
#  pkts bytes target     prot opt in     out     source               destination
#     2    88 DROP       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:25
#   176 10912 DROP       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:80
#    11   628 DROP       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            multiport dports 80,443
```

### 198. Intro to Stateful Firewalls (Connection Tracking)

Connection tracking = Stateful Firewall

- Connection tracking = ability to maintain **state informatin** about connections
- Stateful firewalls are **more secure** than stateless firewalls
- Stateful firewalls decide to accept or to drop packets **based on the relations** these packets are with other packets.
- Netfilter is a stateful firewall

#### Packet states

1. NEW - the first packet from a connection
2. ESTABLISHED - packets that are part of an existing connection
3. RELATED - packets that are requesting a new connection and are already part of an existing connection (Ex: FTP)
4. INVALID - packets that are not part of any existing connection
5. UNTRACKED - packets marked within the raw table with the NOTTRACK target

Connection tracking can be used even if the protocol itself is stateless (EX: UDP, ICMP)

#### Commands

_-m state --state_ state, where state is a comma separated values of packet states written in UPPERCASE letter

```sh
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```

### 199. Implementing Stateful Firewalls with Iptables

```sh
cd ~/scripts/
vim stateful_firewall.sh
```

```sh
#!/bin/bash

iptables -F

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

iptables -A INPUT -p tcp --dport 22 -m state --state NEW -s 192.168.0.20 -j ACCEPT

iptables -A INPUT -m state --state INVALID -j DROP
iptables -A OUTPUT -m state --state INVALID -j DROP

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

iptables -P INPUT DROP
iptables -P OUTPUT DROP
```

```sh
chmod 700 stateful_firewall.sh
```

### 200. Filter by MAC Address

Match: -m mac --mac-source source_mac_address

```sh
iptables -A INPUT -i wlan0 -m mac --mac-source 08:00:27:55:6f:20 -j DROP
```

1. Drop packets from a specific mac address
2. Permit only a list of trusted host (MACs) through the firewall (NAT Router)

```sh
# Linux 2: 192.168.0.20
ping 192.168.0.10
ifconfig
```

```sh
# Linux 1: 192.168.0.10
ifconfig
iptables -A INPUT -i wlan0 -m mac --mac-source 08:00:27:55:6f:20 -j DROP

# ping wouldn't work
```

```sh
vim nat_filter.sh
```

```sh
#!/bin/bash

iptables -F FORWARD

PERMITTED_MACS="08:00:27:55:6f:20 08:00:27:55:6f:21 08:00:27:55:6f:22 08:00:27:55:6f:23"

for MAC in $PERMITTED_MACS
do
  iptables -A FORWARD -m mac --mac-source $MAC -j ACCEPT
  echo "$MAC permitted"
done

iptables -P FORWARD DROP
```

```sh
chmod 700 nat_filter.sh
./nat_filter.sh
```

> INPUT? FORWARD?

### 201. Match by Date and Time

`-m time` option

#### Time match options

```sh
iptables -m time --help

```

```sh
time match options:
    --datestart time     Start and stop time, to be given in ISO 8601
    --datestop time      (YYYY[-MM[-DD[Thh[:mm[:ss]]]]])
    --timestart time     Start and stop daytime (hh:mm[:ss])
    --timestop time      (between 00:00:00 and 23:59:59)
[!] --monthdays value    List of days on which to match, separated by comma
                         (Possible days: 1 to 31; defaults to all)
[!] --weekdays value     List of weekdays on which to match, sep. by comma
                         (Possible days: Mon,Tue,Wed,Thu,Fri,Sat,Sun or 1 to 7
                         Defaults to all weekdays.)
    --kerneltz           Work with the kernel timezone instead of UTC
```

#### By default it uses UTC, not system time

`--kerneltz` : makes netfilter use system time instead of UTC time (!!!)

```sh
date

vim 201_time.sh
```

```sh
#!/bin/bash

iptables -F

iptables -A INPUT -p tcp --dport 22 -m time --timestart 10:00 --timestop 16:00 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -m time -j DROP

iptables -A FORWARD -p tcp --dport 442 -d www.ubuntu.com -m time --timestart 18:00 --timestop 8:00 -j ACCEPT
iptables -A FORWARD -p tcp --dport 442 -d www.ubuntu.com -j DROP
```

```sh
chmod 700 time.sh
./time.sh
```

### 202. The ACCEPT and DROP Targets

Ping

- Source ➡️ ICMP echo-request
- ICMP echo-reply ⬅️ Destination

```sh
iptables -p icmp --help
# echo-request (ping)
# echo-reply (pong)

iptables -A INPUT -p icmp --icmp-type echo-request -s 192.168.0.20 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
```

Test `ping 192.168.0.10`

### 203. The LOG Target

- LOG is a non-terminating target
- It logs detailed information about packet headers
- Logs can be read with dmesg or from syslogd daemon
- LOG is used instead of DROP in the debugging phase
- ULOG has MySql support (extensive logging)

Options:

- `--log-prefix`
- `--log-level`

Example:

```sh
./delete_firewall.sh
iptables -A INPUT -p tcp --dport 22 --syn -j LOG --log-prefix="incoming ssh traffic:" --log-level info
iptables -A INPUT -p tcp --dport 22 -j DROP

# Try to ssh connect on the other linux

# check the log message
dmesg
dmesg | grep "ssh traffic" > ssh.txt
cat ssh.txt

# display last 10 lines in real time
tail -f /var/log/kern.log

# Try to ssh connect on the other linux
```

## Section 26: [EXTRA] Security: SSH Public Key Authentication

### 205. SSH Public Key Authentication Overview

#### SSH Public Key Authentication (PKA)

PKA or Public Key Authentication is an authentication method that uses a key pair for authentication instead of a password which is the default method.

##### Advantages:

- increased security
- authentication from within scripts or automation tools (automated backups, updates, network automation etc)

In PKA there are two types of keys generated:

- Private key (it stays on the SSH Client)
- Public key (it stays on the SSH Server)

### 206. Generating SSH Key Pair on Windows

Requirements

- ssh client that supports RSA authentication
- a private and a public key
- ssh server that supports SSH PKA

[puttygen.exe](https://www.puttygen.com/)

### 208. Generating SSH Key Pair on Linux

```sh
ssh-keygen -b 2048 -t rsa -C "linux user Jul 2023"

ls -l ~/.ssh/
# total 12
# -rw------- 1 root root  687 May 30 11:03 authorized_keys
# -rw------- 1 root root 1823 Jul 11 21:54 id_rsa
# -rw-r--r-- 1 root root  401 Jul 11 21:54 id_rsa.pub
```

### 209. Configuring SSH Public Key Authentication on Linux

```sh
# on the new linux: 192.168.8.177

# initially ssh is not up
systemctl status sshd
# Unit sshd.service could not be found.

systemctl -l --type service --all | grep ssh
# None

sudo apt-get install openssh-server

systemctl status ssh
# ● ssh.service - OpenBSD Secure Shell server
#      Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
#      Active: active (running) since Sat 2023-07-15 06:57:13 AEST; 27s ago
#        Docs: man:sshd(8)
#              man:sshd_config(5)
#    Main PID: 9398 (sshd)??????????????????????????????????????????c-2013 sshd[9398]: Server listening on 0.0.0.0 port 22.
# Jul 15 06:57:13 noah-mac-2013 sshd[9398]: Server listening on :: port 22.
# Jul 15 06:57:13 noah-mac-2013 systemd[1]: Started OpenBSD Secure Shell server.

ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: wlp3s0b1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 54:26:96:ce:99:0d brd ff:ff:ff:ff:ff:ff
    inet 192.168.8.177/24 brd 192.168.8.255 scope global dynamic noprefixroute wlp3s0b1
       valid_lft 85519sec preferred_lft 85519sec
    inet6 fde0:4007:5f3d:fc00:7ea5:10a5:2a81:1643/64 scope global temporary dynamic
       valid_lft 6721sec preferred_lft 3121sec
    inet6 fde0:4007:5f3d:fc00:d79d:71ba:12db:29b8/64 scope global dynamic mngtmpaddr noprefixroute
       valid_lft 6721sec preferred_lft 3121sec
    inet6 fe80::b268:8f80:4394:f252/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

```sh
# on the client: macbook
ssh-copy-id -i id_rsa.pub noah@192.168.8.177
# /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "id_rsa.pub"
# /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
# /usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys

# Number of key(s) added:        1

# Now try logging into the machine, with:   "ssh 'noah@192.168.8.177'"
# and check to make sure that only the key(s) you wanted were added.

ssh noah@192.168.8.177
```

```sh
# alternative way of copying publick key (instead of ssh-copy-id)
# on the client
scp -P 22 ~/.ssh/id_rsa.pub noah@192.168.8.177:~

# on the server
ls -l ~
# -rw-r--r-- 1 noah noah  582 Jul 15 07:24 id_rsa.pub
cat id_rsa.pub >> ~/.ssh/authorized_keys
```

```sh
# on the server
cat ~/.ssh/authorized_keys
```

#### Trouble shooting

```sh
# on client
# verbose
ssh -v noah@192.168.8.177

# if the permission of private key is too loose, it'd cause a problem
chmod 400 ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa #(default)
```

```sh
# on server, not allow password authentication
vim /etc/ssh/sshd_config
# PasswordAuthentication no

systemctl restart ssh
```
