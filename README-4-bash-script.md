```sh
ssh noah@192.168.8.177
```

## Section 20: Bash Shell Scripting

### 149. Bash Aliases

```sh
alias
# alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# alias egrep='egrep --color=auto'
# alias fgrep='fgrep --color=auto'
# alias grep='grep --color=auto'
# alias l='ls -CF'
# alias la='ls -A'
# alias ll='ls -alF'
# alias ls='ls --color=auto'

ls
# Desktop  Documents  Downloads  id_rsa.pub  Music  Pictures  Public  Templates  udemy  Videos

# the original ls command displays all list in black color
\ls
# Desktop  Documents  Downloads  id_rsa.pub  Music  Pictures  Public  Templates  udemy  Videos
```

```sh
# create a volatile alias (on for the current terminal)
alias c="clear"
c
alias cl="clear"
```

#### to create permanent aliases

- `~/.bash_profile`: is executed only once when you log in to your account.
- `~/.bashrc`: is executed each time you open a new terminal window

```sh
vim ~/.bashrc
# alias now="date +%F\ %T"

source ~/.bashrc  # or . ~/.bashrc
now
```

#### other useful aliases

```sh
alias server1="ssh -p 2234 user1@38.10.20.6"
server1

alias ports="netstat -tupan"
ports

alias update="sudo apt update && sudo apt dist-upgrade -y && sudo apt clean"
update

alias lt="ls -hSF --size -1"
lt
# total 40K
# 4.0K Desktop/
# 4.0K Documents/
# 4.0K Downloads/
# 4.0K Music/
# 4.0K Pictures/
# 4.0K Public/
# 4.0K Templates/
# 4.0K udemy/
# 4.0K Videos/
# 4.0K id_rsa.pub
```

#### apt vs apt-get

- `apt`:` (newer version), is more automated and user-friendly
- `apt-get`: gives you more control over package management process

### 151. Intro to Bash Shell Scripting

```sh
echo $0
# bash
cat /etc/shells
# # /etc/shells: valid login shells
# /bin/sh
# /bin/bash
# /usr/bin/bash
# /bin/rbash
# /usr/bin/rbash
# /bin/dash
# /usr/bin/dash
cat /etc/passwd
# noah:x:1000:1000:noah,,,:/home/noah:/bin/bash
```

```sh
mkdir 20-scripts
vim 151-first_script.sh
```

```sh
./151-first_script.sh
/home/noah/scripts/151-first_script.sh

# however this won't work
# without specific path, it will look for under the PATH only
151-first_script.sh

echo $PATH
# /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
```

### 152. The Bash Shebang and Comments

```sh
which bash
# /usr/bin/bash
which -a bash
# /usr/bin/bash
# /bin/bash
ls -li /bin/bash /usr/bin/bash
# 262722 -rwxr-xr-x 1 root root 1183448 Apr 18  2022 /bin/bash
# 262722 -rwxr-xr-x 1 root root 1183448 Apr 18  2022 /usr/bin/bash
```

```sh
vim 151-first_script.sh
# add #!/bin/bash

./151-first_script.sh
# it works as the same as before because bash is the default
```

````sh
vim 152-python.sh

```py
import sys
print(sys.version)
```

./152-python.sh
# ./152-script.sh: line 1: import: command not found
# ./152-script.sh: line 2: syntax error near unexpected token `sys.version'
# ./152-script.sh: line 2: `print(sys.version)'

which python3
/usr/bin/python3

# add python path to the script
```py
#!/usr/bin/python3
```

./152-python.sh
# 3.8.10 (default, May 26 2023, 14:05:08)
# [GCC 9.4.0]
````

#### Comments

on the first line with `#!` is for Shebang, otherwise `#` is for comments

#### Configureation

- `:set nu`: display line number

or make it permanent

````sh
vim ~/.vimrc

```sh
set nu
```
````

> However, it doesn't work for me! (becuase of nvim)\
> https://stackoverflow.com/a/46994483/11390254 > \
> Note, you can simply add `source ~/.vimrc` in `~/.config/nvim/init.vim` to source configs without relying on symbolic links.

### 153. Running Scripts

we can use command `bash`, `python3` to run script without specific path

```sh
./first_script.sh
# total 4
# -rw-rw-r-- 1 noah noah 10 Jul 18 08:45 file.txt
# some text
first_script.sh
# first_script.sh: command not found
bash first_script.sh
# total 4
# -rw-rw-r-- 1 noah noah 10 Jul 18 08:46 file.txt
# some text
python3 152-script.sh
# 3.8.10 (default, May 26 2023, 14:05:08)
# [GCC 9.4.0]
```

It can run without execution permission

```sh
ls -l first_script.sh
# -rwx------ 1 noah noah 88 Jul 17 06:57 first_script.sh
chmod -x first_script.sh
ls -l first_script.sh
# -rw------- 1 noah noah 88 Jul 17 06:57 first_script.sh

# it will override the shebang
bash first_script.sh
# total 4
# -rw-rw-r-- 1 noah noah 10 Jul 18 08:47 file.txt
# some text

./first_script.sh
# bash: ./first_script.sh: Permission denied

# it ignores permission as well
source first_script.sh
# total 4
# -rw-rw-r-- 1 noah noah 10 Jul 18 08:47 file.txt
# some text
```

#### the difference between `./first_script.sh` and `source first_script.sh`

- `./first_script.sh` will run in a new shell
- `source first_script.sh` will be executed in the current shell(=terminal)

### 154. Variables in Bash

```sh
os=Linux

# doesn't allow space
os = Linux
# os: command not found

distro="MX Linux"
age=30

# doesn't allow number first
4you=True
# 4you=True: command not found

# doesn't allow symbols except `_`
a.b=100
# a.b=100: command not found
Anne@
# Anne@: command not found
Anne@Marry=d
# Anne@Marry=d: command not found

you4=False
server_name="Apache 2.4"
A=34
```

```sh
echo $age
# 30
echo $os
# Linux
echo $you4
# False
echo "I'm learning $os and I'm $age old."
# I'm learning Linux and I'm 30 old.

# single qoute doesn't work
echo '$os something $age'
# $os something $age

echo "The value of \$os is $os"
# The value of $os is Linux

distro="Ubuntu"
my_distro="$os $distro"
echo $my_distro
# Linux Ubuntu
```

#### check defined variables

```sh
set

set | grep distro
# distro=Ubuntu
# my_distro='Linux Ubuntu'

# unset variable
unset distro
echo $distro
#
```

#### env variables introduces by operating system are in CAPITAL letters

```sh
echo $PATH
# /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
echo $USER
# noah
echo $HOME
# /home/noah
echo $HISTFILE
# /home/noah/.bash_history
echo $HISTSIZE
# 1000
```

> so it'd be better to use lower case variable

#### Make constants (Read-only)

```sh
declare -r logdir="/var/log"
ls $logdir

# can't override the constants
logdir=abc
# -bash: logdir: readonly variable
```

#### Create a new script

```sh
nvim 154-file_stat.sh
```

```sh
#!/bin/bash
filename="/etc/passwd"
echo "Number of lines:"
wc -l $filename
echo "####################"
echo "First 5 lines:"
head -n 5 $filename

echo "####################"
echo "Last 7 lines:"
tail -n 7 $filename
```

```sh
chmod +x 154-file_stat.sh
./154-file_stat.sh
```

### 155. Environment Variables

- Environment variables
  - defined for the current shell and are inherited by any child shells or processes.
  - they are used to pass information to processes that are spawned from the current shell
  - displayed using `env` and `printenv`
- Shell variables
  - are contained exclusively within the shell in which they were set or defined
  - displayed using set

#### configuration files

- User configuration file: `~/.bashrc`
- System-wide configuration file: `/etc/bash.bashrc` and `/etc/profile`

```sh
# see all env variables
env | less
env | grep USER

printenv
printenv SHELL
printenv SHELL PWD LC_TIME
```

```sh
# see all shell variables
set
abc=123
env | grep abc
set | grep abc
# abc=123

# set posix (Potable Operating System Interface) mode (not displaying shell functions)
set -o posix
set | less  # display only environment/shell variables`
```

```sh
# Add new path to PATH
vim ~/.bashrc
export PATH=$PATH:~/scripts
export MYVAR=342

source ~/.bashrc

# if you want to change bash for all users, modify these
ls -l /etc/profile
# -rw-r--r-- 1 root root 581 Dec  6  2019 /etc/profile
ls -l /etc/bash.bashrc
# -rw-r--r-- 1 root root 2319 Feb 25  2020 /etc/bash.bashrc

# environment variables here
ls -l /etc/environment
```

### 156. Getting User Input

```sh
read name
# Noah
echo $name
# Noah
read -p "Enter the IP address: " ip
# Enter the IP address: 192.168.8.112
ping -c 1 $ip
# PING 192.168.8.112 (192.168.8.112) 56(84) bytes of data.
# 64 bytes from 192.168.8.112: icmp_seq=1 ttl=128 time=109 ms

# --- 192.168.8.112 ping statistics ---
# 1 packets transmitted, 1 received, 0% packet loss, time 0ms
# rtt min/avg/max/mdev = 109.066/109.066/109.066/0.000 ms
```

```sh
vim 156-block_ip.sh
```

```sh
#!/bin/bash
read -p "Enter the IP address of domain to block: " ip
iptables -I INPUT -s $ip -j DROP
echo "The packets from $ip will be dropped."
```

```sh
chmod +x 156-block_ip.sh
sudo ./156-block_ip.sh
# Enter the IP address of domain to block: 1.1.1.1
# The packets from 1.1.1.1 will be dropped.

# delete all filters
sudo iptables -t filter -F
```

#### Input password

```sh
read -s -p "Enter password: " pswd
# Enter password:
echo $pswd
```

### 157. Special Variables and Positional Arguments

`./script.sh filename1 dir1 10.0.0.1`

- `$0`: is the name of the script itself (script.sh)
- `$1`: is the first positional argument (filename1)
- `$2`: is the second positional argument (dir)
- `$3`: is the last positional argument (10.0.0.1)
- `$9`: would be the ninth argument and ${10} the tenth

and

- `$#`: is the number of the positional arguments
- `"$*"`: is a string representation of all positional arguments: `$1`, `$2`, `$3` ...
- `$?`: is the most recent foreground command exit status

### example 1. display arguments

```sh
vim 157-arguments.sh
```

```sh
#!/bin/bash
echo "\$0 is $0"
echo "\$1 is $1"
echo "\$2 is $2"
echo "\$3 is $3"
echo "\$* is $*"
echo "\$# is $#"
```

```sh
chmod +x 157-arguments.sh
./arguments.sh
# $0 is ./157-arguments.sh
# $1 is
# $2 is
# $3 is
# $* is
# $# is 0
./157-arguments.sh linux windows mac 10
# $0 is ./157-arguments.sh
# $1 is linux
# $2 is windows
# $3 is mac
# $* is linux windows mac 10
# $# is 4
```

#### example 2. display and compress file

```sh
vim 157-display_and_compress.sh
```

```sh
#!/bin/bash
echo "Displaying the contents of $1 ..."
sleep 2
cat $1
echo
echo "Compressing $1 ..."
sleep 2
tar -czvf "$1.tar.gz" $1
```

```sh
chmod +x 157-display_and_compress.sh
./157-display_and_compress.sh 157-arguments.sh
# Displaying the contents of 157-arguments.sh ...
# Compressing 157-arguments.sh ...
# 157-arguments.sh
ls
# 157-arguments.sh  157-arguments.sh.tar.gz  157-display_and_compress.sh
sudo ./157-display_and_compress.sh /etc/passwd
ls /etc/passwd*
# /etc/passwd  /etc/passwd-  /etc/passwd.tar.gz
```

### example 3.

```sh
cat 156-block_ip.sh
cp 156-block_ip.sh 157-drop_ip.sh
vim 157-drop_ip.sh
```

```sh
#!/bin/bash
echo "Dropping packets from $1"
iptables -I INPUT -s $1 -j DROP
echo "The packets from $1 will be dropped."
```

```sh
sudo ./157-drop_ip.sh 4.4.4.4
# Dropping packets from 4.4.4.4
# The packets from 4.4.4.4 will be dropped.
```

### 160. Testing Conditions For Numbers

```sh
vim 160-age.sh
chmod +x 160-age.sh

/160-age.sh
# Enter your age: 10
# You are a minor.
./160-age.sh
# Enter your age: 50
# You are major.
./160-age.sh
# Enter your age: 18
# Congratulations, you're just become major!
```
