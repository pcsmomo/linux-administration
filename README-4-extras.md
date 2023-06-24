```sh
ssh root@170.64.181.165
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
