# linux-administration

Linux Administration: The Complete Linux Bootcamp for 2022 by Andrei Dumitrescu

# Details

<details open> 
  <summary>Click to Contract/Expend</summary>

## Section 2: Setting Up the Environment

### 5. Linux Distributions

- .rpm: Redhat Package Manager
  - Redhat: commercial
  - CentOS: based on redhat but free
  - `yum`
- .deb: Debian package manager
  - Ubuntu
  - `apt-get`

[Linux Distributions](https://distrowatch.com/)

### 7. Things to Do After Installing Ubuntu

1. update and upgrade apt packages

```sh
sudo apt update
apt list --upgradable
sudo apt full-upgrade
```

2. Insert Guest Addition or install it

```sh
sudo bash /media/kimn/VBox_GAs_6.1.24/VBoxLinuxAdditions.run
# if I get an error run first:
# sudo apt-get install build-essential gcc make perl dkms
reboot
```

- and eject the Guest Addition image

3. Take a snapshot(back up) at this moment

- backup: Virtual Box menu bar -> Machine -> Take Snapshot
- restore: Image -> Snapshots -> Select the target -> Restore

### 8. Installing CentOS in a VM

- Installation
  1. Installation Destination
     - Select ATA VBOX HARDDISK
     - Storage Configuration - Automatic
     - Done
  2. Network & hostname
     - Ethernet -> On -> Done
     - Host name -> centos8 -> Apply
     - Done
  3. Software Selection
     - O, Server with GUI
     - Server : no gui
  4. User Creation
     - Make this user administrator
- Once installation is done, remove optical disk from virtual drive

### 11. Terminals, Consoles, Shells and Commands

Ctrl + Alt + T : terminal

- A *Terminal Emulator* and is a crucial part of any Linux system because it basically allows you to access the system through a shell
- A *shell* is a program that takes commands from the user and gives them to the operating system's kernel to execute. It's also called the command interpreter. The shell gets started when the user logs in or starts the terminal
- Linux is a case-sensitive operating system (windows is not)

```sh
ps
#   PID TTY          TIME CMD
#  2469 pts/0    00:00:00 bash
#  4186 pts/0    00:00:00 ps
```

```sh
sudo apt update && sudo apt install terminator
```

### 12. Linux Command Structure

```sh
# count 1 - only one ping
ping -c 1 8.8.8.8
# PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
# 64 bytes from 8.8.8.8: icmp_seq=1 ttl=115 time=31.8 ms

# --- 8.8.8.8 ping statistics ---
# 1 packets transmitted, 1 received, 0% packet loss, time 0ms
# rtt min/avg/max/mdev = 31.750/31.750/31.750/0.000 ms
ping -c 1 127.0.0.1

# list directory contents
man ls
ls -a
ls --all
ls -l -all -h /var/
ls -alh /var/

# report file system disk space usage
man df
df -h
df -hi -all
```

### 13. Getting Help, Man Pages (man, type, help, apropos)

- Press h: you will see all short-cuts
- Search: /
  - /pattern          *  Search forward for (N-th) matching line.
  - ?pattern          *  Search backward for (N-th) matching line.
  - n                 *  Repeat previous search (for N-th occurrence).
  - N                 *  Repeat previous search in reverse direction.

- man
  ```sh
  type df
  # df is /usr/bin/df
  type rm
  # rm is /usr/bin/rm
  type apt
  # apt is /usr/bin/apt
  ```
- help
  ```sh
  type cd
  # cd is a shell builtin
  type alias
  # alias is a shell builtin
  type umask
  # umask is a shell builtin
  help alias
  # alias: alias [-p] [name[=value] ... ]
  ```
- the way both work
  ```sh
  rm --help
  cd --help
  ```

```sh
# To see what's available to see
man -k ifconfig
man -k uname
man -k "copy files"

# apropos = man -k
apropos ifconfig
apropos -k uname
```

### 15. Mastering the Terminal: The TAB Key

```sh
if # double tab
# if        ifconfig 
```

### 18. Mastering the Terminal: The Bash History

```sh
# command history
cat ~/.bash_history
# in the file
echo $HISTFILESIZE
# 2000

history
 # in memory
echo $HISTSIZE
# 1000
```

> `.bash_history` file will be updated when logging out the user

```sh
history
! 349 # execute the specific command number
!! # execute the last command
!-7 # execute 7th previous command
!ping # execute the last ping command
!ping:p # print the last ping command with full options, not executing
```

- Ctrl + R : search in history
- Ctrl + G : leave from the search

```sh
# delete a specific command in history
history -d 361
history -c # delete entire history
```

### 19. Running Commands Without Leaving a Trace

```sh
# download google image
wget https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png

# add white space not to add this command to the history in Ubuntu as default
 wget https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png
history
```

```sh
# in CentOS, as default $HISCONTROL is 'ignoredups' not 'ignoreboth'
 wget https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png
history

HISTCONTROL=ignorespace
 wget https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png
history

# append HISTCONTROL option to .bashrc file 
echo "HISTCONTROL=ignoreboth" >> ~/.bashrc
```

- $HISTCONTROL
  - `echo $HISTCONTROL`
  - `HISTCONTROL=ignorespace`
  - ignorespace :
  - ignoredups
  - ignoreboth

### 20. Recording the Date and Time for Each Line in History

```sh
HISTTIMEFORMAT="%d/%m/%y %T "
echo "HISTTIMEFORMAT=\"%d/%m/%y %T \"" >> .bashrc

```


## Section 5: The Linux File System

### 25. Intro to The Linux Files System

- /bin: contains binaries or user executable files which are available to all users.
- /sbin: contains applications that only the superuser (hence the initial s) will need.
  - for e.g) ifconfig
- /boot: contains files required for starting your system.
- /home: is where you will find your users' home directories. Under this directory there is another directory for each user, if that particular user has a home directory. 
- /root: root has its home directory separated from the rest of the users' home directories
- /dev: contains device files.
- /etc: contains most, if not all system-wide configuration files.
- /lib: contains shared library files used by different applications.
- /media: is used for external storage will be automatically mounted.
- /mnt: is like /media but it's not very often used these days. (cd-rom or floppy disk)
- /tmp: contains temporary files, usually saved there by applications that are running.
  - Non-priviledged users may also store files here temporarily.
- /proc: is a virtual directory. It contains information about your compouter hardware, 
  - such as information about your CPU, RAM memory or Kernel. 
  - The files and directories are generated when your computer starts, 
  - or on the fly, as your system is running and things change. 
- /sys: contains information about devices, drivers, and some kernel features.
- /srv: contains data for servers.
- /run: is a temporary file system which runs in RAM
- /usr: contains many other subdirectories binaries files, shared libraries and so on.
  - On some distributions like Cent OS many commands are saved in /usr/bin and /usr/sbin instead of /bin and /sbin
- /var: typically contains variable-length files such as logs which are files that register events that happen on the system.

```sh
# file system disk space usage
df -h

# first partition of hard drive 
ls -l /dev/sda1

# cpu information and ram information
cat /proc/cpuinfo
cat /proc/meminfo

# see logs
cat /var/log/auth.log
```

### 27. Absolute vs. Relative Paths. Walking through the File System (pwd, cd, tree)

```sh
sudo tail /var/log/boot.log
ls /etc/cron.daily

# tree command
sudo apt install tree
tree /etc       # => Ex: tree .
tree -d /etc    # => prints only directories
tree -df /etc   # => prints absolute paths
```

## 29. The LS Command In Depth (ls)

```sh
ls /etc/ /var/ .
ls -ld /etc # only directories
ls -lh /etc # human readable
ls -lSh /etc # order by file size
ls -lX /etc # order by extension
ls --hide=*.conf /etc # hide .conf file
ls -lR /etc/  # recursively display under the path

# size indicates differently
ls -lh /
# drwxr-xr-x 128 root root  12K Feb  3 08:19 etc
du -sh /etc
# 11M	/etc

# default ls alias
type ls
# ls is aliased to `ls --color=auto'
```

### 31. Understanding File Timestamps: atime, mtime, ctime (stat, touch, date)

1. atime: (ls -lu) The access timestamp is the last time the file was read
2. mtime: (ls -l, ls -lt) The modified timestamp is the last time the contents of the file was modified 
3. ctime: (ls -lc) The changed timestamp ctime is the last time when some metadata related to the file was changed 

```sh
stat /etc/passwd
#   File: /etc/passwd
#   Size: 2780      	Blocks: 8          IO Block: 4096   regular file
# Device: 805h/2053d	Inode: 1574499     Links: 1
# Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
# Access: 2022-02-04 08:15:34.812933718 +1100
# Modify: 2021-07-26 16:12:32.396190867 +1000
# Change: 2021-07-26 16:12:32.396190867 +1000
#  Birth: -

ls -l --full-time /etc/
# change timestamp
touch ~/linux.txt
# stat ~/linux.txt
touch -a ~/linux.txt
# stat ~/linux.txt
touch -m ~/linux.txt
# stat ~/linux.txt
touch -m -t 202202040823.00 ~/linux.txt # specific modified timestamp
touch -d "2020-02-04 08:30:33" ~/linux.txt  # access timestamp

touch ubuntu.txt
touch linux.txt -r ubuntu.txt
```

```sh
# date
date
# Fri 04 Feb 2022 08:32:02 AEDT
date -u
# Thu 03 Feb 2022 21:32:05 UTC
```

### 32. Sorting Files by Timestamp

```sh
ls -lt  # sorted by and show modification time
ls -lu  # sorted by and show the access time
ls -lu -r # reverse sorted
ls -ltur
ls -ltu --reverse
```

### 33. File Types in Linux (ls -F, file)

```sh
# files with no extensions
ls /etc/passwd
ls /etc/passwd
ls -l /etc/group
ls /var/log/syslog
ls -l /bin

# file details
file ~/Desktop/linux.jpeg
mv ~/Desktop/linux.jpeg ~/Desktop/linux.png
file ~/Desktop/linux.png
# the results are the same

### file types
ls -l 
# 1. block devices
ls -l /dev/sda1
# brw-rw---- 1 root disk 8, 1 Feb  7 17:23 /dev/sda1
# 2. char type
ls -l /dev/
# crw-------  1 root    root     10, 249 Feb  7 17:23 zfs

# 3. socket type
ls -l /run/
# srw-rw-rw-  1 root              root     0 Feb  7 17:23 snapd.socket
# 4. pipe type
# prw-------  1 root              root     0 Feb  7 17:23 initctl 

# -F option : display indicator
ls -lF
ls -lF /run/

# symbolic link
ls -F /usr/bin/ls

# all file information
file /run/*
```

### 35. Viewing Files - Part 1 (cat)

```sh
cat /var/log/auth.log
cat -n /etc/passwd
cat /etc/hosts /etc/host.conf > my_host.txt
```

### 36. Viewing Files - Part 2 (less)

```sh
less /var/log/dmesg
# Press 'h' to see short cuts
```

> `man` command is using `less` as default

### 37. Viewing Files - Part 3 (tail, head, watch)

```sh
# display last 10 lins
tail /etc/passwd
tail -n 2 /etc/group
# from line 20 to the end
tail -n +20 /var/log/syslog
# watching - attached mode to see your login
tail -f /var/log/auth.log
sudo su # put wrong/correct passwords to see the log changing
```

```sh
head /etc/passwd
head -n 3 /etc/group
head -7 /etc/group
```

```sh
# it runs 'ls' every 2 seconds 
watch ls
# highlight the changed line
watch -n 3 -d ls -l
watch -n 1 -d ifconfig  # if run firefox browser, we can see the changed packets
```

### 39. Creating Files and Directories (touch, mkdir)

```sh
touch report.txt logs
stat report.txt logs
touch rePort.txt
touch reporT.txt
# case sensitive
```

```sh
mkdir -v dir2   # showing message
mkdir -p first/second/third # it will create all directories
three first
```

### 40. Copying Files and Directories (cp)

```sh
cp -v /etc/group ./users.txt  # display message
cp -i /etc/group ./users.txt  # ask if duplicated on prompt
cp learning_linux.txt logs users.txt first/ # copy 3 files to the first folder 
cp -i learning_linux.txt logs users.txt first/
sudo cp -r /etc/ ~/Desktop/ # copy all files in the etc to Desktop
sudo cp users.txt u.txt # the owner changes to the root user
sudo cp -p users.txt u1.txt # the owner remain same
```

### 41. Moving and Renaming Files and Directories (mv)

```sh
mv -i dir1/dir2/a.txt dir1/ # ask if duplicated on prompt
mv -n dir1/dir2/a.txt dir1/ # do not overwrite an existing file
mv -u dir1/b.txt dir1/dir2/ # move  only  when  the  SOURCE file is newer than the destination file or when the destination file is missing

# rename
mv dir1/a.txt dir/abc.txt
mv dir1/ dir10

# move and rename at the same time
mv dir10/c.txt dir10/dir2/cc.txt
```

### 42. Removing Files and Directories (rm, shred)

```sh
rm -i dir10/dir2/b.txt  # interact
rm -v dir10/b.txt # message
rm -r dir10 # recursive
rm -rf Music/ Pictures/ # -f is force
rm -ri file dir/  # remove file/directory recursive with prompting

echo *.txt  # to see what files are matching
```

```sh
# secure removal of a file (verdose with 100 rounds of overwriting)
shred -vu -n 100 passwd
```

### 44. Working With Pipes in Linux (|, wc)

1. STDIN (0) - Standard Input
2. STDOUT (1) - Standard Output
3. STDERR (2) - Standard Error

```sh
ls -lSh /etc/
ls -lSh /etc/ | head  # display top 10 list
ls -lSh /etc/ | head -n 20 | tail -n 1

cat -n /var/log/auth.log  # with line number
cat -n /var/log/auth.log | grep -a "authentication failure"
cat -n /var/log/auth.log | grep -a "authentication failure" | wc -l # print line count

wc /etc/passwd
wc -l /etc/group  # display only line count
wc -w /usr/share/dict/american-english  # word count
wc -c /usr/share/dict/american-english  # character count
```

### 45. Command Redirection (>, >>, 2> &>, cut, tee)

```sh
ls -l > ls.txt
ifconfig > ls.txt # overwrite

ls -l >> output.txt
ifconfig >> output.txt  # append
```

```sh
tty
# /dev/pts/0

# open the new terminal
ifconfig > /dev/pts/0 # dispaly to the first terminal
```

```sh
tail -n 3 /etc/shadow # Permission denied
tail -n 3 /etc/shadow 2> error.txt
tail -n 3 /etc/shadow 2>> error.txt # append
tail -n 2 /etc/passwd /etc/shadow > output.txt 2> error.txt # output goes to output.txt and error goes to the error.txt
tail -n 2 /etc/passwd /etc/shadow > output.txt 2>&1 # consider STDERR (2) as STDOUT (1)
```

```sh
ifconfig | grep ether > mac.txt
ifconfig | grep ether | cut -d" " -f10 > mac.txt # cut only mac address, split with " " and take the 10th field
cat /etc/passwd
cut -d":" -f1 /etc/passwd # split with ":" and take the 1st field
cut -d":" -f3 /etc/passwd # split with ":" and take the 3rd field
```

```sh
ifconfig | grep ether
ifconfig | grep ether > mac.txt
ifconfig | grep ether | tee mac.txt # combine those two command above. display and save
who | tee -a m.txt  # append
uname -r  # display kernel version
uname -r | tee -a mac.txt kernel.txt  # append to two files
```

### 47. Finding Files and Directories - Part 1 (locate, which)

```sh
sudo apt install mlocate
sudo updatedb
ls /var/lib/mlocate

locate passwords
locate eahorse
locate -b eahorse
locate -b *eahorse*
locate -b '\eahorse'  # back slush matches the exact name

touch myfile123x
locate myfile123x  # can't find anything
sudo updatedb
locate myfile123x # found!

rm myfile123x
locate myfile123x # hm.. still there
locate -e myfile123x

locate Rainshadow # nothing found
locate -i Rainshadow

locate -b -r '^shadow\.[0-9]'

which ls
# /usr/bin/ls
which rm
# /usr/bin/rm
which -a find
# /usr/bin/find
# /bin/find  
ls -l /bin/find
# -rwxr-xr-x 1 root root 320160 Feb 18  2020 /bin/find
ls -ld /bin
# lrwxrwxrwx 1 root root 7 Jul 26  2021 /bin -> usr/bin

which pwd ifconfig find grep firefox
# /usr/bin/pwd
# /usr/sbin/ifconfig
# /usr/bin/find
# /usr/bin/grep
# /usr/bin/firefox
```

### 49. Finding Files and Directories - Part 2 (find)

```sh
man find
mkdir projects
touch projects/report.txt
touch projects/todo.txt
tree projects
find . -name todo.txt
find . -iname todo.txt  # case insensitive
find . -name todo  # found nothing
find . -name todo*
find . -name todo.txt -delete

find /etc/ -name passwd
sudo find /etc/ -name passwd -ls
find /etc/ -type d  # list up directories recursively
find /etc/ -type d -maxdepth 2 # depth 2
find /etc/ -type d -maxdepth 2 -perm 755 | wc -l

sudo find /var/ -type f -size 100k -ls  # around 100k
sudo find /var/ -type f -size +10M -ls  # larger than 10m
sudo find /var/ -type f -size -10k -ls  # smaller than 10k
sudo find /var/ -type f -size +5M -size -10M -ls

sudo find /var -type f -mtime 0 -ls # files modified less than 24 hours
sudo find /var -type f -mtime 1 -ls # files modified less than 48 hours
sudo find /var -type f -mtime +1 -ls # files modified at least 2 days ago
sudo find /var -type f -mmin -50 -ls # modificatino time is less than 50 minutes

sudo find /var/ -type f -user gdm -ls # search by the owner

sudo find /etc/ -type f -not -group root -ls # files "not beloned" to the root group
```

### 50. Find and Exec

```sh
sudo find /etc -type f -mtime 0
sudo find /etc -type f -mtime 0 -exec cat {} \; # display contents of the results found
sudo mkdir /root/backup
sudo find /etc/ -mtime -7 -type f -exec cp {} /root/backup \;   # copy files changed in the last 7 days to the /root/backup
```

### 51. Searching for String Patterns in Text Files (grep)

```sh
grep user /etc/ssh/ssh_config
grep "command line" /etc/ssh/ssh_config
grep "SSH" /etc/ssh/ssh_config  # no result
grep -i "SSH" /etc/ssh/ssh_config  # case insensitive
grep -i -n "SSH" /etc/ssh/ssh_config  # line number

grep body /etc/passwd   # find partial
grep -w body /etc/passwd  # whole word

grep kernel /var/log/dmesg
grep -v kernel /var/log/dmesg # invert : not including kernel

grep root /var/log/auth.log # it works, but in the lecture the auth.log file is data not ASCII text
file /var/log/auth.log
# /var/log/auth.log: ASCII text
grep -a root /var/log/auth.log  # to search binary file

sudo grep -R 127.0.0.1 /etc  # search recursively in the /etc folder
grep -s -R 127.0.0.1 /etc  # suppress nonexist messages

grep -c error /var/log/syslog # count
grep error /var/log/syslog | wc -l

dmesg # print or control the kernel ring buffer
dmesg | grep error
dmesg | grep -A 3 -B 4 error  # print after 3 lines, before 4 lines together
dmesg | grep -C 3 error  # print before/after 3 lines together

sudo netstat -tupan # list all open ports
sudo netstat -tupan | grep 53
sudo netstat -tupan | grep 80

ls -RF /etc/  # all file recursively
ls -RF /etc/ | grep / # only directories
ls -RF /etc/ | grep -v / | grep -v "^$" # invert directories and invert empty strings
sudo ls -RF /etc/ | grep -v / | grep -v "^$" | wc -l  # count
sudo ls -RF /etc/ | grep -v / | grep -v "^$" | sort -r  # desc sort by file name
sudo ls -RF /etc/ | grep -v / | grep -v "^$" | sort -r | less # display less
sudo ls -RF /etc/ | grep -v / | grep -v "^$" | sort | less # ascending order
sudo ls -RF /etc/ | grep -v / | grep -v "^$" | sort > result.txt # save it into the file
```

### 53. Searching for Strings in Binary Files (strings)

```sh
which ls
sudo apt install binutils
strings /usr/bin/ls
strings /usr/bin/ls | less

# my partition
df -h
# /dev/sda5 : my main partition
sudo strings -a /dev/sda5

# look into computer memory
ls -l /dev/mem
man mem # for more information
sudo strings /dev/mem | less
```

</details>
