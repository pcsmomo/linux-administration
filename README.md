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
- /boot: contains files required for starting your system.
- /home: is where you will find your users' home directories. Under this directory there is another directory for each user, if that particular user has a home directory. 
- /root: root has its home directory separated from the rest of the users' home directories
- dev: contains device files.
- etc: contains most, if not all system-wide configuration files.
- lib: contains shared library files used by different applications.
- media: is used for external storage will be automatically mounted.
- mnt: is like /media but it's not very often used these days.
- opt: 
- srv: 
- sys: 
- usr: 

```sh
# file system disk space usage
df -h
```

</details>
