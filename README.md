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

</details>
