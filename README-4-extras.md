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
