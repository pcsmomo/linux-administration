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

130. Getting System Hardware Information (lwhw, lscpu, lsusb, lspci,dmidecode,hdparm)

```sh
lshw
# kimn-virtualbox
#     description: Project-Id-Version: lshwReport-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>PO-Revision-Date: 2012-02-02 13:04+0000Last-Translator: Joel Addison <jaddi27@gmail.com>Language-Team: English (Australia) <en_AU@li.org>MIME-Version: 1.0Content-Type: text/plain; charset=UTF-8Content-Transfer-Encoding: 8bitX-Launchpad-Export-Date: 2023-02-09 12:36+0000X-Generator: Launchpad (build 77239e4aa149cc645d32cd0d9466bc0d9f82abaa)
#     product: VirtualBox
#     vendor: innotek GmbH
#     version: 1.2
#     serial: 0
#     width: 64 bits
#     capabilities: smbios-2.5 dmi-2.5 smp vsyscall32
#     configuration: family=Virtual Machine uuid=b9b4272d-e873-440d-a1e5-def5b2968179
#   *-core
#        description: Motherboard
#        product: VirtualBox
#        vendor: Oracle Corporation
#        physical id: 0
#        version: 1.2
#        serial: 0
#      *-firmware
#           description: BIOS
#           vendor: innotek GmbH
#           physical id: 0
#           version: VirtualBox
#           date: 12/01/2006
#           size: 128KiB
#           capacity: 128KiB
#           capabilities: isa pci cdboot bootselect int9keyboard int10video acpi
#      *-memory
#           description: System memory
#           physical id: 1
#           size: 8GiB
#      *-cpu
#           product: 11th Gen Intel(R) Core(TM) i7-1185G7 @ 3.00GHz
#           vendor: Intel Corp.
#           physical id: 2
#           bus info: cpu@0
#           version: 6.140.1
#           width: 64 bits
#           capabilities: fpu fpu_exception wp vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp x86-64 constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 movbe popcnt aes rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single ibrs_enhanced fsgsbase bmi1 bmi2 invpcid rdseed clflushopt md_clear flush_l1d arch_capabilities
#           configuration: microcode=4294967295
#      *-pci
#           description: Host bridge
#           product: 440FX - 82441FX PMC [Natoma]
#           vendor: Intel Corporation
#           physical id: 100
#           bus info: pci@0000:00:00.0
#           version: 02
#           width: 32 bits
#           clock: 33MHz
#         *-isa
#              description: ISA bridge
#              product: 82371SB PIIX3 ISA [Natoma/Triton II]
#              vendor: Intel Corporation
#              physical id: 1
#              bus info: pci@0000:00:01.0
#              version: 00
#              width: 32 bits
#              clock: 33MHz
#              capabilities: isa bus_master
#              configuration: latency=0
#            *-pnp00:00
#                 product: PnP device PNP0303
#                 physical id: 0
#                 capabilities: pnp
#                 configuration: driver=i8042 kbd
#            *-pnp00:01
#                 product: PnP device PNP0f03
#                 physical id: 1
#                 capabilities: pnp
#                 configuration: driver=i8042 aux
#         *-ide
#              description: IDE interface
#              product: 82371AB/EB/MB PIIX4 IDE
#              vendor: Intel Corporation
#              physical id: 1.1
#              bus info: pci@0000:00:01.1
#              logical name: scsi0
#              version: 01
#              width: 32 bits
#              clock: 33MHz
#              capabilities: ide isa_compat_mode pci_native_mode bus_master emulated
#              configuration: driver=ata_piix latency=64
#              resources: irq:0 ioport:1f0(size=8) ioport:3f6 ioport:170(size=8) ioport:376 ioport:d000(size=16)
#            *-cdrom
#                 description: DVD reader
#                 product: CD-ROM
#                 vendor: VBOX
#                 physical id: 0.0.0
#                 bus info: scsi@0:0.0.0
#                 logical name: /dev/cdrom
#                 logical name: /dev/sr0
#                 version: 1.0
#                 capabilities: removable audio dvd
#                 configuration: ansiversion=5 status=nodisc
#         *-display
#              description: VGA compatible controller
#              product: SVGA II Adapter
#              vendor: VMware
#              physical id: 2
#              bus info: pci@0000:00:02.0
#              logical name: /dev/fb0
#              version: 00
#              width: 32 bits
#              clock: 33MHz
#              capabilities: vga_controller bus_master rom fb
#              configuration: depth=32 driver=vmwgfx latency=64 resolution=2048,2048
#              resources: irq:18 ioport:d010(size=16) memory:e0000000-e0ffffff memory:f0000000-f01fffff memory:c0000-dffff
#         *-network
#              description: Ethernet interface
#              product: 82540EM Gigabit Ethernet Controller
#              vendor: Intel Corporation
#              physical id: 3
#              bus info: pci@0000:00:03.0
#              logical name: enp0s3
#              version: 02
#              serial: 08:00:27:3b:7b:03
#              size: 1Gbit/s
#              capacity: 1Gbit/s
#              width: 32 bits
#              clock: 66MHz
#              capabilities: pm pcix bus_master cap_list ethernet physical tp 10bt 10bt-fd 100bt 100bt-fd 1000bt-fd autonegotiation
#              configuration: autonegotiation=on broadcast=yes driver=e1000 driverversion=5.15.0-72-generic duplex=full ip=10.0.2.15 latency=64 link=yes mingnt=255 multicast=yes port=twisted pair speed=1Gbit/s
#              resources: irq:19 memory:f0200000-f021ffff ioport:d020(size=8)
#         *-generic
#              description: System peripheral
#              product: VirtualBox mouse integration
#              vendor: InnoTek Systemberatung GmbH
#              physical id: 4
#              bus info: pci@0000:00:04.0
#              logical name: input7
#              logical name: /dev/input/event6
#              logical name: /dev/input/js1
#              version: 00
#              width: 32 bits
#              clock: 33MHz
#              capabilities: pci
#              configuration: driver=vboxguest latency=0
#              resources: irq:20 ioport:d040(size=32) memory:f0400000-f07fffff memory:f0800000-f0803fff
#         *-multimedia
#              description: Multimedia audio controller
#              product: 82801AA AC'97 Audio Controller
#              vendor: Intel Corporation
#              physical id: 5
#              bus info: pci@0000:00:05.0
#              logical name: card0
#              logical name: /dev/snd/controlC0
#              logical name: /dev/snd/pcmC0D0c
#              logical name: /dev/snd/pcmC0D0p
#              logical name: /dev/snd/pcmC0D1c
#              version: 01
#              width: 32 bits
#              clock: 33MHz
#              capabilities: bus_master
#              configuration: driver=snd_intel8x0 latency=64
#              resources: irq:21 ioport:d100(size=256) ioport:d200(size=64)
#         *-usb
#              description: USB controller
#              product: KeyLargo/Intrepid USB
#              vendor: Apple Inc.
#              physical id: 6
#              bus info: pci@0000:00:06.0
#              version: 00
#              width: 32 bits
#              clock: 33MHz
#              capabilities: ohci bus_master cap_list
#              configuration: driver=ohci-pci latency=64
#              resources: irq:22 memory:f0804000-f0804fff
#            *-usbhost
#                 product: OHCI PCI host controller
#                 vendor: Linux 5.15.0-72-generic ohci_hcd
#                 physical id: 1
#                 bus info: usb@1
#                 logical name: usb1
#                 version: 5.15
#                 capabilities: usb-1.10
#                 configuration: driver=hub slots=12 speed=12Mbit/s
#               *-usb
#                    description: Human interface device
#                    product: VirtualBox USB Tablet
#                    vendor: VirtualBox
#                    physical id: 1
#                    bus info: usb@1:1
#                    logical name: input6
#                    logical name: /dev/input/event5
#                    logical name: /dev/input/js0
#                    logical name: /dev/input/mouse1
#                    version: 1.00
#                    capabilities: usb-1.10 usb
#                    configuration: driver=usbhid maxpower=100mA speed=12Mbit/s
#         *-bridge
#              description: Bridge
#              product: 82371AB/EB/MB PIIX4 ACPI
#              vendor: Intel Corporation
#              physical id: 7
#              bus info: pci@0000:00:07.0
#              version: 08
#              width: 32 bits
#              clock: 33MHz
#              capabilities: bridge
#              configuration: driver=piix4_smbus latency=0
#              resources: irq:9
#         *-sata
#              description: SATA controller
#              product: 82801HM/HEM (ICH8M/ICH8M-E) SATA Controller [AHCI mode]
#              vendor: Intel Corporation
#              physical id: d
#              bus info: pci@0000:00:0d.0
#              logical name: scsi2
#              version: 02
#              width: 32 bits
#              clock: 33MHz
#              capabilities: sata pm ahci_1.0 bus_master cap_list emulated
#              configuration: driver=ahci latency=64
#              resources: irq:21 ioport:d240(size=8) ioport:d248(size=4) ioport:d250(size=8) ioport:d258(size=4) ioport:d260(size=16) memory:f0806000-f0807fff
#            *-disk
#                 description: ATA Disk
#                 product: VBOX HARDDISK
#                 vendor: VirtualBox
#                 physical id: 0.0.0
#                 bus info: scsi@2:0.0.0
#                 logical name: /dev/sda
#                 version: 1.0
#                 serial: VB37ec5929-4a8c69b8
#                 size: 100GiB (107GB)
#                 capabilities: partitioned partitioned:dos
#                 configuration: ansiversion=5 logicalsectorsize=512 sectorsize=512 signature=fc397e11
#               *-volume:0 UNCLAIMED
#                    description: Windows FAT volume
#                    vendor: mkfs.fat
#                    physical id: 1
#                    bus info: scsi@2:0.0.0,1
#                    version: FAT32
#                    serial: fdda-ce92
#                    size: 510MiB
#                    capacity: 512MiB
#                    capabilities: primary bootable fat initialized
#                    configuration: FATs=2 filesystem=fat
#               *-volume:1
#                    description: Extended partition
#                    physical id: 2
#                    bus info: scsi@2:0.0.0,2
#                    logical name: /dev/sda2
#                    size: 99GiB
#                    capacity: 99GiB
#                    capabilities: primary extended partitioned partitioned:extended
#                  *-logicalvolume
#                       description: EXT4 volume
#                       vendor: Linux
#                       physical id: 5
#                       logical name: /dev/sda5
#                       logical name: /
#                       logical name: /var/snap/firefox/common/host-hunspell
#                       version: 1.0
#                       serial: 069472ce-60db-4c90-9354-d93e5e011682
#                       size: 99GiB
#                       capacity: 99GiB
#                       capabilities: journaled extended_attributes large_files huge_files dir_nlink recover 64bit extents ext4 ext2 initialized
#                       configuration: created=2021-07-26 16:02:05 filesystem=ext4 lastmountpoint=/ modified=2023-05-27 09:02:24 mount.fstype=ext4 mount.options=ro,noexec,noatime,errors=remount-ro mounted=2023-05-27 09:02:25 state=mounted
#   *-input:0
#        product: Power Button
#        physical id: 1
#        logical name: input0
#        logical name: /dev/input/event0
#        capabilities: platform
#   *-input:1
#        product: Sleep Button
#        physical id: 2
#        logical name: input1
#        logical name: /dev/input/event1
#        capabilities: platform
#   *-input:2
#        product: AT Translated Set 2 keyboard
#        physical id: 3
#        logical name: input2
#        logical name: /dev/input/event2
#        logical name: input2::capslock
#        logical name: input2::numlock
#        logical name: input2::scrolllock
#        capabilities: i8042
#   *-input:3
#        product: ImExPS/2 Generic Explorer Mouse
#        physical id: 4
#        logical name: input4
#        logical name: /dev/input/event4
#        logical name: /dev/input/mouse0
#        capabilities: i8042
#   *-input:4
#        product: Video Bus
#        physical id: 5
#        logical name: input5
#        logical name: /dev/input/event3
#        capabilities: platform

lshw -json | less
lshw -html > hw.html
```

```sh
inxi -Fx
# System:
#   Host: kimn-VirtualBox Kernel: 5.15.0-72-generic x86_64 bits: 64
#     compiler: gcc v: 11.3.0 Desktop: GNOME 42.5
#     Distro: Ubuntu 22.04.2 LTS (Jammy Jellyfish)
# Machine:
#   Type: Virtualbox System: innotek GmbH product: VirtualBox v: 1.2
#     serial: <superuser required>
#   Mobo: Oracle model: VirtualBox v: 1.2 serial: <superuser required>
#     BIOS: innotek GmbH v: VirtualBox date: 12/01/2006
# Battery:
#   ID-1: BAT0 charge: 50.0 Wh (100.0%) condition: 50.0/50.0 Wh (100.0%)
#     volts: 10.0 min: 10.0 model: innotek 1 status: Full
# CPU:
#   Info: dual core model: 11th Gen Intel Core i7-1185G7 bits: 64 type: MCP
#     arch: Tiger Lake rev: 1 cache: L1: 160 KiB L2: 2.5 MiB L3: 24 MiB
#   Speed (MHz): avg: 1805 min/max: N/A cores: 1: 1805 2: 1805 bogomips: 7219
#   Flags: ht lm nx pae sse sse2 sse3 sse4_1 sse4_2 ssse3
# Graphics:
#   Device-1: VMware SVGA II Adapter driver: vmwgfx v: 2.19.0.0 bus-ID: 00:02.0
#   Display: wayland server: X.Org v: 1.22.1.1 with: Xwayland v: 22.1.1
#     compositor: gnome-shell driver: X: loaded: vmware
#     unloaded: fbdev,modesetting,vesa gpu: vmwgfx resolution: 2024x1162~60Hz
#   OpenGL: renderer: llvmpipe (LLVM 15.0.6 128 bits) v: 4.5 Mesa 22.2.5
#     direct render: Yes
# Audio:
#   Device-1: Intel 82801AA AC97 Audio vendor: Dell driver: snd_intel8x0
#     v: kernel bus-ID: 00:05.0
#   Sound Server-1: ALSA v: k5.15.0-72-generic running: yes
#   Sound Server-2: PulseAudio v: 15.99.1 running: yes
#   Sound Server-3: PipeWire v: 0.3.48 running: yes
# Network:
#   Device-1: Intel 82540EM Gigabit Ethernet driver: e1000 v: kernel port: d020
#     bus-ID: 00:03.0
#   IF: enp0s3 state: up speed: 1000 Mbps duplex: full mac: 08:00:27:3b:7b:03
#   Device-2: Intel 82371AB/EB/MB PIIX4 ACPI type: network bridge
#     driver: piix4_smbus v: N/A port: N/A bus-ID: 00:07.0
# Drives:
#   Local Storage: total: 100 GiB used: 470.19 GiB (470.2%)
#   ID-1: /dev/sda vendor: VirtualBox model: VBOX HARDDISK size: 100 GiB
# Partition:
#   ID-1: / size: 97.38 GiB used: 15.67 GiB (16.1%) fs: ext4 dev: /dev/sda5
#   ID-2: /boot/efi size: 511 MiB used: 4 KiB (0.0%) fs: vfat dev: /dev/sda1
# Swap:
#   ID-1: swap-1 type: file size: 2 GiB used: 0 KiB (0.0%) file: /swapfile
# Sensors:
#   Message: No sensor data found. Is lm-sensors configured?
# Info:
#   Processes: 222 Uptime: 13m Memory: 7.76 GiB used: 1.77 GiB (22.9%)
#   Init: systemd runlevel: 5 Compilers: gcc: 11.3.0 Packages: 1725 Shell: Bash
#   v: 5.1.16 inxi: 3.3.13
```

```sh
sudo lshw -C cpu
  # *-cpu
  #      product: 11th Gen Intel(R) Core(TM) i7-1185G7 @ 3.00GHz
  #      vendor: Intel Corp.
  #      physical id: 2
  #      bus info: cpu@0
  #      version: 6.140.1
  #      width: 64 bits
  #      capabilities: fpu fpu_exception wp vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp x86-64 constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 movbe popcnt aes rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single ibrs_enhanced fsgsbase bmi1 bmi2 invpcid rdseed clflushopt md_clear flush_l1d arch_capabilities
  #      configuration: microcode=4294967295

sudo lscpu
# Architecture:            x86_64
#   CPU op-mode(s):        32-bit, 64-bit
#   Address sizes:         39 bits physical, 48 bits virtual
#   Byte Order:            Little Endian
# CPU(s):                  2
#   On-line CPU(s) list:   0,1
# Vendor ID:               GenuineIntel
#   Model name:            11th Gen Intel(R) Core(TM) i7-1185G7 @ 3.00GHz
#     CPU family:          6
#     Model:               140
#     Thread(s) per core:  1
#     Core(s) per socket:  2
#     Socket(s):           1
#     Stepping:            1
#     BogoMIPS:            3609.60
#     Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
#                          pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm co
#                          nstant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known
#                          _freq pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 movbe popcnt
#                           aes rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_singl
#                          e ibrs_enhanced fsgsbase bmi1 bmi2 invpcid rdseed clflushopt m
#                          d_clear flush_l1d arch_capabilities
# Virtualization features:
#   Hypervisor vendor:     KVM
#   Virtualisation type:   full
# Caches (sum of all):
#   L1d:                   96 KiB (2 instances)
#   L1i:                   64 KiB (2 instances)
#   L2:                    2.5 MiB (2 instances)
#   L3:                    24 MiB (2 instances)
# NUMA:
#   NUMA node(s):          1
#   NUMA node0 CPU(s):     0,1
# Vulnerabilities:
#   Itlb multihit:         Not affected
#   L1tf:                  Not affected
#   Mds:                   Not affected
#   Meltdown:              Not affected
#   Mmio stale data:       Not affected
#   Retbleed:              Mitigation; Enhanced IBRS
#   Spec store bypass:     Vulnerable
#   Spectre v1:            Mitigation; usercopy/swapgs barriers and __user pointer saniti
#                          zation
#   Spectre v2:            Mitigation; Enhanced IBRS, RSB filling, PBRSB-eIBRS SW sequenc
#                          e
#   Srbds:                 Not affected
#   Tsx async abort:       Not affected

# json format
lscpu -J
```

```sh
sudo dmidecode -t memory
# dmidecode 3.3
# Getting SMBIOS data from sysfs.
# SMBIOS 2.5 present.

sudo dmidecode -t memory | grep -i size

dmidecode -t memory | grep -i max
        # Maximum Memory Module Size: 32768 MB
        # Maximum Total Memory Size: 491520 MB
        # Maximum Capacity: 17 GB
```

#### alternatively

```sh
top

free -m
#                total        used        free      shared  buff/cache   available
# Mem:            7950        1299        4731          82        1919        6322
# Swap:           2047           0        2047
```

#### Other devices such as graphic card and so on

```sh
lspci
# 00:00.0 Host bridge: Intel Corporation 440FX - 82441FX PMC [Natoma] (rev 02)
# 00:01.0 ISA bridge: Intel Corporation 82371SB PIIX3 ISA [Natoma/Triton II]
# 00:01.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)
# 00:02.0 VGA compatible controller: VMware SVGA II Adapter
# 00:03.0 Ethernet controller: Intel Corporation 82540EM Gigabit Ethernet Controller (rev 02)
# 00:04.0 System peripheral: InnoTek Systemberatung GmbH VirtualBox Guest Service
# 00:05.0 Multimedia audio controller: Intel Corporation 82801AA AC'97 Audio Controller (rev 01)
# 00:06.0 USB controller: Apple Inc. KeyLargo/Intrepid USB
# 00:07.0 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 08)
# 00:0d.0 SATA controller: Intel Corporation 82801HM/HEM (ICH8M/ICH8M-E) SATA Controller [AHCI mode] (rev 02)
lspci | grep -i wireless
lspci | grep -i vga
```

#### usb port

```sh
lsusb
# Bus 001 Device 002: ID 80ee:0021 VirtualBox USB Tablet
# Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

# Details
lsusb -v | less
```

#### Disks more

```sh
lshw -C disk
  # *-cdrom
  #      description: DVD reader
  #      product: CD-ROM
  #      vendor: VBOX
  #      physical id: 0.0.0
  #      bus info: scsi@0:0.0.0
  #      logical name: /dev/cdrom
  #      logical name: /dev/sr0
  #      version: 1.0
  #      capabilities: removable audio dvd
  #      configuration: ansiversion=5 status=nodisc
  # *-disk
  #      description: ATA Disk
  #      product: VBOX HARDDISK
  #      vendor: VirtualBox
  #      physical id: 0.0.0
  #      bus info: scsi@2:0.0.0
  #      logical name: /dev/sda
  #      version: 1.0
  #      serial: VB37ec5929-4a8c69b8
  #      size: 100GiB (107GB)
  #      capabilities: partitioned partitioned:dos
  #      configuration: ansiversion=5 logicalsectorsize=512 sectorsize=512 signature=fc397e11

sudo lshw -C disk -short
# H/W path            Device      Class       Description
# =======================================================
# /0/100/1.1/0.0.0    /dev/cdrom  disk        CD-ROM
# /0/100/d/0.0.0      /dev/sda    disk        107GB VBOX HARDDISK

lsblk
sudo fdisk -l
sudo fdisk -l //dev/sda
# Disk //dev/sda: 100 GiB, 107374182400 bytes, 209715200 sectors
# Disk model: VBOX HARDDISK
# Units: sectors of 1 * 512 = 512 bytes
# Sector size (logical/physical): 512 bytes / 512 bytes
# I/O size (minimum/optimal): 512 bytes / 512 bytes
# Disklabel type: dos
# Disk identifier: 0xfc397e11

# Device     Boot   Start       End   Sectors  Size Id Type
# //dev/sda1 *       2048   1050623   1048576  512M  b W95 FAT32
# //dev/sda2      1052670 209713151 208660482 99.5G  5 Extended
# //dev/sda5      1052672 209713151 208660480 99.5G 83 Linux
```

#### hdparm - get/set SATA/IDE device parameters

```sh
sudo hdparm -i /dev/sda
# /dev/sda:

#  Model=VBOX HARDDISK, FwRev=1.0, SerialNo=VB37ec5929-4a8c69b8
#  Config={ Fixed }
#  RawCHS=16383/16/63, TrkSize=0, SectSize=512, ECCbytes=0
#  BuffType=DualPortCache, BuffSize=256kB, MaxMultSect=128, MultSect=128
#  CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=209715200
#  IORDY=yes, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
#  PIO modes:  pio0 pio3 pio4
#  DMA modes:  mdma0 mdma1 mdma2
#  UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5 *udma6
#  AdvancedPM=no WriteCache=enabled
#  Drive conforms to: unknown:  ATA/ATAPI-1,2,3,4,5,6

#  * signifies the current active mode

# details in different format
sudo hdparm -I /dev/sda

# benchmark
hdparm -t --direct /dev/sda
# /dev/sda:
#  Timing O_DIRECT disk reads: 3054 MB in  3.01 seconds = 1015.00 MB/sec
```

```sh
# it doesn't work for me
iw list
```

#### where all devices information are?

```sh
ls /proc/

cat /proc/cpuinfo
cat /proc/meminfo
cat /proc/partitions

# kernul version
cat /proc/version
uname
# Linux
uname -r
# 5.15.0-72-generic
uname -a
# Linux kimn-VirtualBox 5.15.0-72-generic #79-Ubuntu SMP Wed Apr 19 08:22:18 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
```

#### check the battery condition?

```sh
sudo apt install acpi

acpi
# Full, 100%
acpi -bi
# Battery 0: Full, 100%
# Battery 0: design capacity 5000 mAh, last full capacity 5000 mAh = 100%
acpi -B
# acpi: invalid option -- 'B'
# Usage: acpi [OPTION]...
# Shows information from the /proc filesystem, such as battery status or
# thermal information.

#   -b, --battery            battery information
#   -i, --details            show additional details if available:
#                              - battery capacity information
#                              - temperature trip points
#   -a, --ac-adapter         ac adapter information
#   -t, --thermal            thermal information
#   -c, --cooling            cooling information
#   -V, --everything         show every device, overrides above options
#   -s, --show-empty         show non-operational devices
#   -f, --fahrenheit         use fahrenheit as the temperature unit
#   -k, --kelvin             use kelvin as the temperature unit
#   -d, --directory <dir>    path to ACPI info (/sys/class resp. /proc/acpi)
#   -p, --proc               use old proc interface instead of new sys interface
#   -h, --help               display this help and exit
#   -v, --version            output version information and exit

# By default, acpi displays information on installed system batteries.
# Non-operational devices, for example empty battery slots are hidden.
# The default unit of temperature is degrees celsius.

# Report bugs to Michael Meskes <meskes@debian.org>.
```

### 132. Intro to systemd

#### Systemd vs SysVInit

- Most modern Linux distributions are using `SystemD` as the default init system and service manager
- It replaced the old `SysVint` script system, but it's backward compatible with SysVinit
- `systemd` starts with PID 1 as the first process, than takes over and continues to mount the host's file systems and starts services
- systemd starts the services in parallel (sysvinit doesn't)
- Statistics
  - systemd-analyze
  - systemd-analyze blame

```sh
ps -ef | less
# UID          PID    PPID  C STIME TTY          TIME CMD
# root           1       0  0 May27 ?        00:00:03 /sbin/init splash
# root           2       0  0 May27 ?        00:00:00 [kthreadd]
# root           3       2  0 May27 ?        00:00:00 [rcu_gp]
# ...

man init  # which means systemd

systemd --version
# systemd 249 (249.11-0ubuntu3.9)
# +PAM +AUDIT +SELINUX +APPARMOR +IMA +SMACK +SECCOMP +GCRYPT +GNUTLS +OPENSSL +ACL +BLKID +CURL +ELFUTILS +FIDO2 +IDN2 -IDN +IPTC +KMOD +LIBCRYPTSETUP +LIBFDISK +PCRE2 -PWQUALITY -P11KIT -QRENCODE +BZIP2 +LZ4 +XZ +ZLIB +ZSTD -XKBCOMMON +UTMP +SYSVINIT default-hierarchy=unified

systemd-analyze
# Startup finished in 2.653s (kernel) + 23.562s (userspace) = 26.215s
# graphical.target reached after 23.531s in userspace

systemd-analyze blame
# 19.876s plymouth-quit-wait.service
# 15.216s vboxadd.service
#  6.519s apt-daily.service
#  2.655s snapd.service
#  1.755s plocate-updatedb.service
# ...
```

### 133. Service Management (systemd and systemctl)

```sh
man systemctl

sudo su

apt update && apt install nginx

# systemctl status nginx.service  # the same
systemctl status nginx
# ● nginx.service - A high performance web server and a reverse proxy server
#      Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
#      Active: active (running) since Sat 2023-05-27 09:17:16 AEST; 1 day 5h ago
#        Docs: man:nginx(8)
#     Process: 859 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
#     Process: 881 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
#    Main PID: 882 (nginx)
#       Tasks: 3 (limit: 9453)
#      Memory: 9.3M
#         CPU: 74ms
#      CGroup: /system.slice/nginx.service
#              ├─882 "nginx: master process /usr/sbin/nginx -g daemon on; master_process on;"
#              ├─883 "nginx: worker process" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" ""
#              └─884 "nginx: worker process" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" ""

# May 27 09:17:15 kimn-VirtualBox systemd[1]: Starting A high performance web server and a reverse proxy server...
# May 27 09:17:16 kimn-VirtualBox systemd[1]: Started A high performance web server and a reverse proxy server.

systemctl stop nginx

systemctl start nginx
systemctl restart nginx

# if you want to apply changed configurations without restarting
systemctl reload nginx

# reload if possible, if not it will restart
systemctl reload-or-restart nginx

# start nginx automatically when the system reboot
systemctl enable nginx
systemctl is-enable nginx
# enabled
systemctl disable nginx
```

```sh
# This will link these unit files to /dev/null, making it impossible to start them.
systemctl mask nginx
systemctl start nginx
# Failed to start nginx.service: Unit nginx.service is masked.
systemctl unmask nginx
```

```sh
# List units that systemd currently has in memory.
systemctl list-units
systemctl list-units --all
```

</details>
