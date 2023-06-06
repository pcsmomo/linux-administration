## Section 19: [EXTRA]: Configure a Linux Server from Scratch (VPS,DNS,WEB,PHP,MySql,Wordpress)

### 137. Running a Linux Server in the Cloud

- Digital Ocean -> Create a new Droplet
  - Ubuntu
  - Basic
- Connect it with web console

```sh
apt update && apt full-upgrade -y
```

```sh
ssh root@170.64.181.165
```

### 138. Securing SSH with Key Authentication

#### On the client

```sh
# -t: type, -b: length, -C: comment
ssh-keygen -t rsa -b 2048 -C 'keys generated on May 2023'

cat /Users/noah/.ssh/id_digital_ocean.pub
```

#### SSH setting on the Digital Ocean

- Digital Ocean -> Settings -> Security
  - add ssh key

```sh
ssh-copy-id root@170.64.181.165
# /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
# /usr/bin/ssh-copy-id: INFO: 2 key(s) remain to be installed -- if you are prompted now it is to install the new keys
# root@170.64.181.165's password:

# Number of key(s) added:        2

# Now try logging into the machine, with:   "ssh 'root@170.64.181.165'"
# and check to make sure that only the key(s) you wanted were added.
```

#### On the server side

```sh
ssh root@170.64.181.165

cat authorized_keys
```

> # so actually I can manually change this `authorized_keys` file for `root` or any users

#### Change ssh password option to null

```sh
vim /etc/ssh/sshd_config
# PasswordAuthentication no
systemctl restart ssh
```

### 139. Getting a Domain Name

[namecheap - Domain](https://namecheap.com/)

```sh
sudo apt update && sudo apt install wireshark
  # │ Dumpcap can be installed in a way that allows members of the "wireshark" system group to capture packets. This is recommended over the alternative   │
  # │ of running Wireshark/Tshark directly as root, because less of the code will run with elevated privileges.                                            │
  # │                                                                                                                                                      │
  # │ For more detailed information please see /usr/share/doc/wireshark-common/README.Debian.gz once the package is installed.                             │
  # │                                                                                                                                                      │
  # │ Enabling this feature may be a security risk, so it is disabled by default. If in doubt, it is suggested to leave it disabled.                       │
  # │                                                                                                                                                      │
  # │ Should non-superusers be able to capture packets?

  # <Yes>
```

> wireshark wouldn't run on cloud server as it needs qt(?)\
> I run it on my vm

```sh
sudo wireshark
```

Type `dns || http` to the wire shark search bar

#### get info about domain

```sh
ping kali.org
# PING kali.org (50.116.58.136): 56 data bytes
# 64 bytes from 50.116.58.136: icmp_seq=0 ttl=45 time=299.091 ms
# 64 bytes from 50.116.58.136: icmp_seq=1 ttl=45 time=234.872 ms
# 64 bytes from 50.116.58.136: icmp_seq=2 ttl=45 time=240.775 ms
# --- kali.org ping statistics ---
# 5 packets transmitted, 5 packets received, 0.0% packet loss
# round-trip min/avg/max/stddev = 234.872/281.729/358.536/44.975 ms

nslookup kali.org
# Server:		10.24.0.1
# Address:	10.24.0.1#53

# Non-authoritative answer:
# Name:	kali.org
# Address: 50.116.58.136

dig kali.org
# ; <<>> DiG 9.10.6 <<>> kali.org
# ;; global options: +cmd
# ;; Got answer:
# ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 33436
# ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

# ;; OPT PSEUDOSECTION:
# ; EDNS: version: 0, flags:; udp: 4096
# ;; QUESTION SECTION:
# ;kali.org.			IN	A

# ;; ANSWER SECTION:
# kali.org.		41	IN	A	50.116.58.136

# ;; Query time: 18 msec
# ;; SERVER: 10.24.0.1#53(10.24.0.1)
# ;; WHEN: Wed May 31 07:34:08 AEST 2023
# ;; MSG SIZE  rcvd: 61

host kali.org
# kali.org has address 50.116.58.136
# kali.org mail is handled by 10 alt1.aspmx.l.google.com.
# kali.org mail is handled by 15 alt2.aspmx.l.google.com.
# kali.org mail is handled by 20 alt3.aspmx.l.google.com.
# kali.org mail is handled by 25 alt4.aspmx.l.google.com.
# kali.org mail is handled by 5 aspmx.l.google.com.
```

#### Setting DNS on namecheap

- Digital Ocean -> Domain List -> Manage domain -> Advanced DNS
  - Personal DNS Server -> Add Nameserver
    - Nameserver: ns1 (usually ns1)
    - ID Address: 170.64.181.165 (IP address of my ubuntu machine on digital ocean)
  - Add one more with the same IP (as adding two dns server is recommended by digital ocean)
    - Nameserver: ns2
    - ID Address: 170.64.181.165 (IP address of my ubuntu machine on digital ocean)
  - Search 'Standard Nameserver' to check my dns server is added
- Domain
  - Nameservers: Custom DNS
    - ns1.ticketing-prod.site
    - ns2.ticketing-prod.site

> It would take up to 24 hours to get effected by changed setting\
> which is called DNS propagation

```sh
dig -t ns ticketing-prod.site
# ; <<>> DiG 9.10.6 <<>> -t ns ticketing-prod.site
# ;; global options: +cmd
# ;; Got answer:
# ;; ->>HEADER<<- opcode: QUERY, status: SERVFAIL, id: 57175
# ;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1

# ;; OPT PSEUDOSECTION:
# ; EDNS: version: 0, flags:; udp: 512
# ;; QUESTION SECTION:
# ;ticketing-prod.site.		IN	NS

# ;; Query time: 802 msec
# ;; SERVER: 10.24.0.1#53(10.24.0.1)
# ;; WHEN: Wed May 31 08:43:38 AEST 2023
# ;; MSG SIZE  rcvd: 48
```

If it is correctly applied, we will get answers

```sh
dig -t ns ticketing-prod.site
```

### 140. Diving into the DNS Protocol and Installing a DNS Server (Bind9)

[Bind 9 - DNS system](https://www.isc.org/bind/)

#### Install bind 9

```sh
ssh root@170.64.181.165

apt update && apt install bind9 bind9utils bind9-doc

systemctl status bind9
# ● named.service - BIND Domain Name Server
#      Loaded: loaded (/lib/systemd/system/named.service; enabled; preset: enabled)
#      Active: active (running) since Wed 2023-05-31 10:21:18 UTC; 50s ago
```

> We installed `bind9`, but the daemon name is `bind`

#### Configure DNS service

```sh
vim /etc/default/named
# change Option to use ipv4
OPTION="-u bind -4"

systemctl reload-or-restart bind9

# check google.com IP via my DNS server
dig -t a @localhost google.com
# ;; ANSWER SECTION:
# google.com.		300	IN	A	172.217.167.78

# check google.com IP via 1.1.1.1 cloudflare DNS server
dig -t a @1.1.1.1 google.com
# ;; ANSWER SECTION:
# google.com.		281	IN	A	172.217.24.46
```

#### Bind server configuration

```sh
cat /etc/bind/named.conf
# include "/etc/bind/named.conf.options";   # general server configurations
# include "/etc/bind/named.conf.local";     # domains hosted on the server
# include "/etc/bind/named.conf.default-zones"; # root server and default zone (we don't touch really)

ps -ef | grep named
# bind       37965       1  0 10:21 ?        00:00:00 /usr/sbin/named -u bind
```

#### DNS Query

1. Recursive
   - A recursive query is a kind of query in the DNS server that received your query, will do all the job, fetching the answer, and giving it back to you.
   - In the end, you'll get the final answer
2. Iterative
   - The DNS name server will not go and fetch the complete answer for your query \
     but will give back a referral to the other DNS servers, which might have the answer
   - Now it's your job to query those servers and find the answer

#### DNS Forwarder

A `forwarder` is another DNS server that will be queried recursively by our server.

- A DNS server, configured to use a forwarder, behaves as follows:
  1. When the DNS server receives a query, it attempts to resolve this query.
  2. If the query cannot be resolved using local data, the DNS server forwards the query recursively to the DNS server that is designated as a forwarder.
  3. If the forwarder is not unavailable, the DNS server attempts to resolve the query by itself, using iterative queries.

```sh
vim /etc/bind/named.conf.options
# add below next line of `listen-on-v6 { any; };`
  forwarders {
    8.8.8.8;
    8.8.4.4;
  };

systemctl reload-or-restart bind9
systemctl status bind9

dig @localhost -t a parrotlinux.org
# ;; ANSWER SECTION:
# parrotlinux.org.	30	IN	A	143.42.34.14
```

### 141. Setting Up the Authoritative BIND9 DNS Server

```sh
# They are Authoritative DNS servers
dig -t ns google.com
# ;; ANSWER SECTION:
# google.com.		86400	IN	NS	ns3.google.com.
# google.com.		86400	IN	NS	ns1.google.com.
# google.com.		86400	IN	NS	ns2.google.com.
# google.com.		86400	IN	NS	ns4.google.com.

# and this is the IP address of the DNS server
dig -t a ns1.google.com.
# ;; ANSWER SECTION:
# ns1.cisco.com.		600	IN	A	72.163.5.201

dig -t ns linux.com
# ;; ANSWER SECTION:
# linux.com.		3600	IN	NS	ns3.dnsimple.com.
# linux.com.		3600	IN	NS	ns2.dnsimple.com.
# linux.com.		3600	IN	NS	ns1.dnsimple.comns1.dnsimple.com.
# linux.com.		3600	IN	NS	ns4.dnsimple-edge.org.

dig -t a ns1.dnsimple.com
# ;; ANSWER SECTION:
# ns1.dnsimple.com.	52289	IN	A	162.159.24.4
```

#### Configure our bind9 as an Authoritative DNS server

```sh
systemctl status bind9
systemctl enable bind9
# Failed to enable unit: Refusing to operate on alias name or linked unit file: bind9.service

vim /etc/bind/named.conf.local
# Add below ⬇️
# zone "ticketing-prod.site" {
#         type master;
#         file "/etc/bind/db.ticketing-prod.site";
# };

cp /etc/bind/db.empty /etc/bind/db.ticketing-prod.site
vim /etc/bind/db.ticketing-prod.site
# Change like below ⬇️
# $TTL    86400
# @       IN      SOA     ns1.ticketing-prod.site. root.localhost. (
#                               1         ; Serial
#                          604800         ; Refresh
#                           86400         ; Retry
#                         2419200         ; Expire
#                           86400 )       ; Negative Cache TTL
# ;
# @       IN      NS      ns1.ticketing-prod.site.
# ;@      IN      NS      ns2.ticketing-prod.site.
# ns1     IN      A       170.64.181.165
# mail    IN      MX 10   mail.ticketing-prod.site.
# ticketing-prod.site.    IN      A       170.64.181.165
# www     IN      A       170.64.181.165
# mail    IN      A       170.64.181.165
# external        IN      A       91.189.88.1

named-checkconf
named-checkzone ticketing-prod.site /etc/bind/db.ticketing-prod.site
# zone ticketing-prod.site/IN: loaded serial 1
# OK

systemctl restart bind9
systemctl status bind9
# May 31 11:14:53 ubuntu-s-1vcpu-1gb-syd1-01 named[38392]: zone ticketing-prod.site/IN: loaded serial 1

dig @localhost -t ns ticketing-prod.site
# ;; ANSWER SECTION:
# ticketing-prod.site.	86400	IN	NS	ns1.ticketing-prod.site.

dig @localhost -t a www.ticketing-prod.site
# ;; ANSWER SECTION:
# www.ticketing-prod.site. 86400	IN	A	170.64.181.165
```

- SOA : Start of Authority
- @ : my domain name -> ticketing-prod.site

#### Test it from my local machine

```sh
dig -t ns ticketing-prod.site
# ;; ANSWER SECTION:
# ticketing-prod.site.	60	IN	NS	ns1.ticketing-prod.site.

dig -t a ticketing-prod.site
# ;; ANSWER SECTION:
# ticketing-prod.site.	60	IN	A	170.64.181.165
```

#### Add another domain for a test

```sh
vim /etc/bind/db.ticketing-prod.site
# Add below ⬇️
# public-dns      IN      A       8.8.8.8

systemctl restart bind9

dig -t a public-dns.ticketing-prod.site
# ;; ANSWER SECTION:
# public-dns.ticketing-prod.site.	60 IN	A	8.8.8.8
```

### 142. Installing a Web Server (Apache2)

Apache2 vs Nginx

```sh
apt update && apt install apache2
systemctl status apache2
# ● apache2.service - The Apache HTTP Server
#      Loaded: loaded (/lib/systemd/system/apache2.service; enabled; preset: enabled)
#      Active: active (running) since Wed 2023-05-31 21:25:17 UTC; 1min 6s ago
systemctl enable apache2
```

#### make firewall to allow apache2

```sh
man ufw
# This program is for managing a Linux firewall and aims to provide an easy to use interface for the user.

ufw status
# Status: inactive

ufw allow 'Apache Full'
# Rules updated
# Rules updated (v6)
```

#### Check my address

```sh
id addr
# 170.64.181.165

# If I use private server?
curl -4 ident.me
# 170.64.181.165
```

Navigate `170.64.181.165` or `ticketing-prod.site` on the browser

Ta-da! Apache2 webserver is running!

### 143. Setting Up Virtual Hosting

```sh
# apache work directory
ls /var/www/html/index.html
echo "Hello, that's me" > /var/www/html/me.txt

mkdir /var/www/ticketing-prod.site

# check the apache user and group
ps -ef | grep apache2
# root       40303       1  0 May31 ?        00:00:05 /usr/sbin/apache2 -k start
# www-data   40305   40303  0 May31 ?        00:00:00 /usr/sbin/apache2 -k start
# www-data   40306   40303  0 May31 ?        00:00:00 /usr/sbin/apache2 -k start
# www-data   40397       1  0 May31 ?        00:00:04 /usr/bin/htcacheclean -d 120 -p /var/cache/apache2/mod_cache_disk -l 300M -n
# root       51422   51398  0 21:45 pts/0    00:00:00 grep --color=auto apache2

# change the ownership recursively (user.group)
chown -R www-data.www-data /var/www/ticketing-prod.site/
chmod 755 /var/www/ticketing-prod.site/
vim /var/www/ticketing-prod.site/index.html
# write any content
```

#### Configure for virtual hosting

```sh
cd /etc/apache2
vim sites-available/ticketing-prod.site.conf
# <VirtualHost *:80>
# 	ServerName ticketing-prod.site
# 	ServerAlias www.ticketing-prod.site
# 	DocumentRoot /var/www/ticketing-prod.site

# 	ServerAdmin webmaster@ticketing-prod.site
# 	ErrorLog /var/log/apache2/ticketing-prod_site_error.log
# 	CustomLog /var/log/apache2/ticketing-prod_site_access.log combined
# </VirtualHost>

# enable the conf (without .conf)
a2ensite ticketing-prod.site
# Enabling site ticketing-prod.site.
# To activate the new configuration, you need to run:
#   systemctl reload apache2
```

#### Disable the default config

```sh
ls -l /etc/apache2/sites-enabled
# total 0
# lrwxrwxrwx 1 root root 35 May 31 21:25 000-default.conf -> ../sites-available/000-default.conf
# lrwxrwxrwx 1 root root 43 Jun  1 22:26 ticketing-prod.site.conf -> ../sites-available/ticketing-prod.site.conf

a2dissite 000-default
# Site 000-default disabled.
# To activate the new configuration, you need to run:
#   systemctl reload apache2

systemctl reload apache2
```

Navigate "http://ticketing-prod.site/"

Ta-da! It works!!

> if you want to run more services, you can add configure file as the same as above

### 144. Securing Apache with OpenSSL and Digital Certificates

[Let's Encrypt - free SSL/TLS certificate](https://letsencrypt.org/)

```sh
apt update && apt install certbot python3-certbot-apache
certbot -d ticketing-prod.site
# Saving debug log to /var/log/letsencrypt/letsencrypt.log
# Enter email address (used for urgent renewal and security notices)
#  (Enter 'c' to cancel): dkim12444@gmail.com

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Please read the Terms of Service at
# https://letsencrypt.org/documents/LE-SA-v1.3-September-21-2022.pdf. You must
# agree in order to register with the ACME server. Do you agree?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# (Y)es/(N)o: Y

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Would you be willing, once your first certificate is successfully issued, to
# share your email address with the Electronic Frontier Foundation, a founding
# partner of the Let's Encrypt project and the non-profit organization that
# develops Certbot? We'd like to send you email about our work encrypting the web,
# EFF news, campaigns, and ways to support digital freedom.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# (Y)es/(N)o: Y
# Account registered.
# Requesting a certificate for ticketing-prod.site

# Successfully received certificate.
# Certificate is saved at: /etc/letsencrypt/live/ticketing-prod.site/fullchain.pem
# Key is saved at:         /etc/letsencrypt/live/ticketing-prod.site/privkey.pem
# This certificate expires on 2023-08-31.
# These files will be updated when the certificate renews.
# Certbot has set up a scheduled task to automatically renew this certificate in the background.

# Deploying certificate
# Successfully deployed certificate for ticketing-prod.site to /etc/apache2/sites-available/ticketing-prod.site-le-ssl.conf
# Congratulations! You have successfully enabled HTTPS on https://ticketing-prod.site

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# If you like Certbot, please consider supporting our work by:
#  * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
#  * Donating to EFF:                    https://eff.org/donate-le
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

On the video, there was option to choose redict or not when "http://" request comes, \
but my version of certbot doesn't have the option initially

It's done????? What!

#### What certbot did?

```sh
# 1. Create {domain name}-le-ssl.conf file
ls -l /etc/apache2/sites-available/
# total 20
# -rw-r--r-- 1 root root 1332 Mar  1 23:01 000-default.conf
# -rw-r--r-- 1 root root 6340 Mar  1 23:01 default-ssl.conf
# -rw-r--r-- 1 root root  550 Jun  2 07:08 ticketing-prod.site-le-ssl.conf
# -rw-r--r-- 1 root root  509 Jun  2 07:08 ticketing-prod.site.conf

cat /etc/apache2/sites-available/ticketing-prod.site-le-ssl.conf
# <IfModule mod_ssl.c>
# <VirtualHost *:443>
# 	ServerName ticketing-prod.site
# 	ServerAlias www.ticketing-prod-site
# 	DocumentRoot /var/www/ticketing-prod.site

# 	ServerAdmin webmaster@ticketing-prod.site
# 	ErrorLog /var/log/apache2/ticketing-prod_site_error.log
# 	CustomLog /var/log/apache2/ticketing-prod_site_access.log combined

# SSLCertificateFile /etc/letsencrypt/live/ticketing-prod.site/fullchain.pem
# SSLCertificateKeyFile /etc/letsencrypt/live/ticketing-prod.site/privkey.pem
# Include /etc/letsencrypt/options-ssl-apache.conf
# </VirtualHost>
# </IfModule>

cat /etc/apache2/sites-available/ticketing-prod.site.conf
# ...
# RewriteEngine on
# RewriteCond %{SERVER_NAME} =ticketing-prod.site [OR]
# RewriteCond %{SERVER_NAME} =www.ticketing-prod.site
# RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
# </VirtualHost>


# 2. enable the site
ls -l /etc/apache2/sites-enabled
# total 4
# lrwxrwxrwx 1 root root 60 Jun  2 07:08 ticketing-prod.site-le-ssl.conf -> /etc/apache2/sites-available/ticketing-prod.site-le-ssl.conf
# lrwxrwxrwx 1 root root 43 Jun  1 22:26 ticketing-prod.site.conf -> ../sites-available/ticketing-prod.site.conf
```

#### Renew the certificate

> Let's encrypt certificate is valid for 90 days. \
> Before it gets expired, we can renew it.

```sh
systemctl status certbot.timer
# ● certbot.timer - Run certbot twice daily
#      Loaded: loaded (/lib/systemd/system/certbot.timer; enabled; preset: enabled)
#      Active: active (waiting) since Fri 2023-06-02 07:05:25 UTC; 54min ago
#       Until: Fri 2023-06-02 07:05:25 UTC; 54min ago
#     Trigger: Fri 2023-06-02 21:08:04 UTC; 13h left
#    Triggers: ● certbot.service

# Jun 02 07:05:25 ubuntu-s-1vcpu-1gb-syd1-01 systemd[1]: Started Run certbot twice daily.

certbot renew --dry-run
# Saving debug log to /var/log/letsencrypt/letsencrypt.log

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Processing /etc/letsencrypt/renewal/ticketing-prod.site.conf
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Account registered.
# Simulating renewal of an existing certificate for ticketing-prod.site

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Congratulations, all simulated renewals succeeded:
#   /etc/letsencrypt/live/ticketing-prod.site/fullchain.pem (success)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```
