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

</details>
