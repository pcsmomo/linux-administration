# linux-administration

Linux Administration: The Complete Linux Bootcamp for 2022 by Andrei Dumitrescu

# Details

<details open> 
  <summary>Click to Contract/Expend</summary>

## Section 15: Software Management

### 117. DPKG (Debian and Ubuntu Based Distros)

deb: is from Debra who is the name of Debian founder's wife

- dpkg: Debian Package Manager, low level package manager. dpkg works under the hood of APT
- apt: Advanced Package Tool, it manages remote repositories and resolves dependencies

```sh
# display information
dpkg --info google-chrome-stable_current_amd64.deb
# install
sudo dpkg -i google-chrome-stable_current_amd64.deb
```

```sh
# all installed packages
dpkg --get-selections
# a bit more detailed information
dpkg-query -l
dpkg-query -l | grep chrome
# google-chrome-stable

# all files from the package, chrome
dpkg -L google-chrome-stable
```

```sh
dpkg-query -l | grep ssh
# openssh-server
dpkg -L openssh-server
```

```sh
# 'ls' command belongs to the 'coreutils' package
which -a ls
dpkg -S /bin/ls
# coreutils: /bin/ls

# what's in the coreutils
dpkg -L coreutils | less
```

```sh
# delete(remove) package
sudo dpkg -r google-chrome-stable
# remove including configuration file
sudo dpkg -P google-chrome-stable
```

### 119. Using APT (Advanced Package Tool)

```sh
sudo su
apt update

# install
apt install apache2
systemctl status nginx
systemctl stop nginx
systemctl start apache2
systemctl status apache2
```

```sh
apt install gparted vlc
apt install /home/kimn/Downloads/google-chrome-stable_current_amd64.deb
```

```sh
# upgrade
apt list --upgradable
apt list --upgradable | grep python
apt install python3-ldb
apt full-upgrade
```

```sh
# remove
apt remove apache2  # exclude configuration files
apt purge gparted vlc # include configuration files
apt autoremove  # remove unlinked dependencies
```

```sh
# cache directory: all apt packages are here
ls -l /var/cache/apt/archieves
du -sh /var/cache/apt/archieves
sudo apt clean
```

```sh
# available apt list
sudo apt list
sudo apt list | wc -l
# 79663 : that many packages are available

# search specific one
sudo apt list | grep postfix  # popular email server
sudo apt search "transparent proxy"

# see installed packages
apt list --installed
apt list --installed | wc -l
# 1486

# show description
apt show apache2
apt show zzuf

# graphical package manager
sudo apt install synaptic
sudo synaptic
```

### 121. Compiling Programs from Source Code vs. Package Manager

- check the latest version on web
  - https://downloads.apache.org/httpd/
  - httpd-2.4.54.tar.gz

```sh
apt show apache2
# Version: 2.4.41-4ubuntu3.12
```

> There are a version difference

### 122. Compiling C Programs

1. Install the prerequisites: gcc, g++, make
   - Ubuntu: `sudo apt update && sudo apt install build-essential`
   - CentOS: `sudo dnf group install "Development Tools`
2. Download the source files from the official Website
3. Check the integrity of the tarball (hash or digital signature)
4. Extract the archive and move into the resulting directory
5. Run: `./configure --help` and set the required compilation options
6. Run: `make`
7. Run: `make install`

```sh
# for ubuntu
sudo apt update && sudo apt install build-essential
gcc --version
g++ --version
make --version

vim hello.c
gcc hello.c -o hello  # compile
./hello
# Hello, world!
```

```c
// hello.c
#include <stdio.h>

int main() {
  printf("Hello, world!\n");
  return 0;
}
```

### 123. Compiling Software From Source Code: Lab ProFTPD

```sh
# download ProFTPD v1.3.7e
wget -c ftp://ftp.proftpd.org/distrib/source/proftpd-1.3.7e.tar.gz

# check the hash
# 6e716a3b53ee069290399fce6dccf4c229fafe6ec2cb14db3778b7aa3f9a8c92
sha256sum proftpd-1.3.7e.tar.gz
# 6e716a3b53ee069290399fce6dccf4c229fafe6ec2cb14db3778b7aa3f9a8c92  proftpd-1.3.7e.tar.gz

# md5
# md5sum proftpd-1.3.7e.tar.gz
tar -xzvf proftpd-1.3.7e.tar.gz
# proftpd-1.3.7e folder is created
```

- src : source code
- configure : check requirements and configure it itself

```sh
./configure --help
# set up the configurations and check to build
./configure --prefix=/opt/proftpd
# compile - create required binaries
make  # using Makefile
# install
sudo make install

rm -rf proftpd-1.3.7e
cd /opt/proftpd
cd sbin/
pwd
# /opt/proftpd/sbin
# execute at background
sudo ./proftpd &
# check the process
ps -ef | grep proftpd
pgrep -l proftpd
# 44819 proftpd

# kill the process
kill 44819
sudo pkill proftpd
```

```sh
# run foreground with debugging mode
sudo ./proftpd -n

# connect it to check from the browser
ftp://localhost/
```

```sh
# configuration file
cat /opt/proftpd/etc/proftpd.conf | less
```

```sh
# configure and install the server in one command
./configure --prefix=/opt/proftpd && make && make install
```

## Section 17: System Administration

### 125. Task Automation and Scheduling Using Cron (crontab)

```sh
pgrep -l cron
# 643 anacron
# 646 cron

sudo ls /var/spool/cron/crontabs/
# list of crontabs

which crontab
# /usr/bin/crontab

ls -l /etc/crontab
# -rw-r--r-- 1 root root 1042 Feb 14  2020 /etc/crontab

crontab -l
# no crontab for kimn

# edit crontab script
crontab -e
2
```

[Crontab script examples](./_summary/crontab.sh)

```sh
# crontab -e
*/2 * * * * date >> /tmp/date_and_time.txt

# monitor the cron jobs
tail -f /var/log/syslog # on Ubuntu
tail -f /var/log/cron # on CentOS

cat /tmp/date_and_time.txt
```

#### remove crontab

```sh
crontab -r
```

#### allow/deny crontab for users

```sh
man crontab
# /etc/cron.allow
# /etc/cron.deny
```

#### helpful websites

- [Crontab Guru](https://crontab.guru)
- [Crontab Generator](https://crontab-generator.org)

#### apart from the crontab script, these also run

```sh
# scripts are in each folder: daily, hourly, montly, weekly
ls -l /etc | grep cron
# -rw-r--r--  1 root root     401 Jul 17  2019 anacrontab
# drwxr-xr-x  2 root root    4096 Jun  8  2022 cron.d
# drwxr-xr-x  2 root root    4096 Apr 18 16:08 cron.daily
# drwxr-xr-x  2 root root    4096 Feb 10  2021 cron.hourly
# drwxr-xr-x  2 root root    4096 Feb 10  2021 cron.monthly
# -rw-r--r--  1 root root    1042 Feb 14  2020 crontab
# drwxr-xr-x  2 root root    4096 Aug  2  2022 cron.weekly

# description when those schedule run
less /etc/crontab
```

### 127. Scheduling Tasks Using Anacron (anacron)

```sh
man anacron

cat /etc/anacrontab
# # /etc/anacrontab: configuration file for anacron

# # See anacron(8) and anacrontab(5) for details.

# SHELL=/bin/sh
# HOME=/root
# LOGNAME=root

# # These replace cron's entries
# 1	5	cron.daily	run-parts --report /etc/cron.daily
# 7	10	cron.weekly	run-parts --report /etc/cron.weekly
# @monthly	15	cron.monthly	run-parts --report /etc/cron.monthly
```

- 7: period
- 10: delay after starting computer
- cron.weekly: identifier
- command: period/delay/identifier/command

```sh
vim /etc/anacrontab
# #2      1       backup  /root/backup.sh
# 2       1       backup  date >> /tmp/anacron.txt

anacron -T
# -T     Anacrontab testing. The configuration file will be tested for validity. If there is
              # an  error  in  the  file,  an  error will be shown and anacron will return 1. Valid
              # anacrontabs will return 0.
```

> Basically anacron runs background.\
> If you want to see on terminal use `-d` option

```sh
sudo anacron -d
# Anacron 2.3 started on 2023-05-25
# Will run job `backup' in 1 min.
# Job `backup' started
# Job `backup' terminated
# Normal exit (1 job run)

cat /tmp/anacron.txt
# Thu 25 May 2023 09:01:41 AEST

# all jobs done
sudo anacron -d
# Anacron 2.3 started on 2023-05-25
# Normal exit (0 jobs run)
```

### 128. Mounting and Unmounting File Systems (df, mount, umount, fdisk, gparted)

```sh
man mount

mount
# sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
# proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
#
# ...
#
# nsfs on /run/snapd/ns/snap-store.mnt type nsfs (rw)

# partitions (-l: list, -t: type)
mount -l -t ext4
# /dev/sda5 on / type ext4 (rw,relatime,errors=remount-ro)
# /dev/sda5 on /var/snap/firefox/common/host-hunspell type ext4 (ro,noexec,noatime,errors=remount-ro)
mount -l -t vfat
# /dev/sda1 on /boot/efi type vfat (rw,relatime,fmask=0077,dmask=0077,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro)
```

#### Mount my USB

- Virtual machine -> Menu -> Devices -> {my device name}

```sh
# It is auto mounted
mount | grep media
# /dev/sdb1 on /media/kimn/NOAH type exfat (rw,nosuid,nodev,relatime,uid=1000,gid=1000,fmask=0022,dmask=0022,iocharset=utf8,errors=remount-ro,uhelper=udisks2)

# see what's in my usb
ls -l /dev/sdb1
# brw-rw---- 1 root disk 8, 16 May 25 09:14 /dev/sdb1

# to find the name of device file
sudo fdisk -l
#
# ...
#
# Device     Boot Start      End  Sectors  Size Id Type
# /dev/sdb1  *        2 30529535 30529534 14.6G  7 HPFS/NTFS/exFAT

# message log about devices
sudo dmesg
# [ 2101.638942] usb-storage 1-2:1.0: USB Mass Storage device detected
# [ 2101.643698] scsi host3: usb-storage 1-2:1.0
# [ 2101.644592] usbcore: registered new interface driver usb-storage
# [ 2101.649190] usbcore: registered new interface driver uas
# [ 2102.683901] scsi 3:0:0:0: Direct-Access     SanDisk  Cruzer Blade     1.27 PQ: 0 ANSI: 6
# [ 2102.766709] sd 3:0:0:0: Attached scsi generic sg2 type 0
# [ 2102.840649] sd 3:0:0:0: [sdb] 30529536 512-byte logical blocks: (15.6 GB/14.6 GiB)
# [ 2102.870263] sd 3:0:0:0: [sdb] Write Protect is off
# [ 2102.870267] sd 3:0:0:0: [sdb] Mode Sense: 43 00 00 00
# [ 2102.897544] sd 3:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
# [ 2103.124367]  sdb: sdb1
# [ 2103.297079] sd 3:0:0:0: [sdb] Attached SCSI removable disk
# [ 2104.889456] exFAT-fs (sdb1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
```

```sh
mkdir /home/kimn/Desktop/usb
sudo mount /dev/sdb1 /home/kimn/Desktop/usb
# it will appear on the desktop

# Now my usb has mounted to locations
ls ~/Desktop/usb/
# list...
ls /media/kimn/NOAH/
# list...

# mount -t vfat -l
mount -t exfat -l  # (or mount -t exFat -l)
# /dev/sdb1 on /media/kimn/NOAH type exfat (rw,nosuid,nodev,relatime,uid=1000,gid=1000,fmask=0022,dmask=0022,iocharset=utf8,errors=remount-ro,uhelper=udisks2) [NOAH]
# /dev/sdb1 on /home/kimn/Desktop/usb type exfat (rw,relatime,uid=1000,gid=1000,fmask=0022,dmask=0022,iocharset=utf8,errors=remount-ro) [NOAH]
```

#### Basically linux automatically detect the file type, however if it doesn't?

```sh
sudo mount -t exfat /dev/sdb1 /home/kimn/Desktop/usb
```

#### Unmount

```sh
# ! it's not unmount, but `umount`
sudo umount /home/kimn/Desktop/usb

# Lazy option (wait until file using finished)
sudo umount -l /home/kimn/Desktop/usb
# umount: /home/kimn/Desktop/usb: not mounted.
```

#### Mount it with read-only option

```sh
sudo mount -o ro /dev/sdb1 /home/kimn/Desktop/usb
# mount: /home/kimn/Desktop/usb: /dev/sdb1 already mounted on /media/kimn/NOAH.
# because it is already mount in another location

sudo umount /media/kimn/NOAH
sudo mount -o ro /dev/sdb1 /home/kimn/Desktop/usb

mount -t exfat -l
# /dev/sdb1 on /home/kimn/Desktop/usb type exfat (ro,relatime,fmask=0022,dmask=0022,iocharset=utf8,errors=remount-ro) [NOAH]
```

#### Remount it with different option

```sh
sudo mount -o rw,remount /dev/sdb1 /home/kimn/Desktop/usb
```

#### Mount ISO file in any location

```sh
mkdir ~/iso
sudo mount /path_to_iso_file /home/kimn/iso -o loop
```

#### Graphical partition managing tool - gparted

```sh
# fdisk is a powerful command, but you should be careful of losing your data
# a suggestion is to use graphical tool such as gparted
sudo fdisk

sudo apt install gparted

sudo gparted
```

### 129. Working With Device Files (dd)

```sh
man dd
df -h
```

#### practice with my usb

Plug in my USB and select it

- Virtual machine -> Menu -> Devices -> {my device name}

```sh
sudo fdisk -l
sudo lsblk

# if: input file, of: output file
sudo dd if=/dev/sdb1 of=/home/kimn/backup-usb.img status=progress
# 281268736 bytes (281 MB, 268 MiB) copied, 130 s, 2.2 MB/s

sudo dd if=/home/kimn/backup-usb.img of=/dev/sdb1 status=progress conf=sync
```

#### copy my partition root is mounted to usb

```sh
df -h
# ...
# /dev/sda5        98G   16G   77G  17% /
# ...

sudo dd if=/dev/sda5 of=/dev/sdb1 status=progress
```

#### backup master boot record (mbr)

```sh
# bs: block size, count: 1 (it will copy only one block)
sudo dd if=/dev/sda of=/root/mbr.dat bs=512 count=1

# Now if something goes wrong, we can restore it with the backup
sudo dd if=/root/mbr.dat of=/dev/sda bs=512 count=1
```

#### make bootable USB with linux ISO file (Mint Linux)

```sh
# unmount my usb
sudo umount /media/kimn/NOAH

# format my usb
mkfs.vfat /dev/sdb1

sudo dd if=/home/kimn/Download/linuxmint-20-cinammon-64bit.iso of=/dev/sdb1 status=progress
```

</details>
