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

</details>
