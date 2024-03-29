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
vim 157-01-arguments.sh
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
chmod +x 157-01-arguments.sh
./arguments.sh
# $0 is ./157-01-arguments.sh
# $1 is
# $2 is
# $3 is
# $* is
# $# is 0
./157-01-arguments.sh linux windows mac 10
# $0 is ./157-01-arguments.sh
# $1 is linux
# $2 is windows
# $3 is mac
# $* is linux windows mac 10
# $# is 4
```

#### example 2. display and compress file

```sh
vim 157-02-display_and_compress.sh
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
chmod +x 157-02-display_and_compress.sh
./157-02-display_and_compress.sh 157-01-arguments.sh
# Displaying the contents of 157-01-arguments.sh ...
# Compressing 157-01-arguments.sh ...
# 157-01-arguments.sh
ls
# 157-01-arguments.sh  157-01-arguments.sh.tar.gz  157-02-display_and_compress.sh
sudo ./157-02-display_and_compress.sh /etc/passwd
ls /etc/passwd*
# /etc/passwd  /etc/passwd-  /etc/passwd.tar.gz
```

### example 3.

```sh
cat 156-block_ip.sh
cp 156-block_ip.sh 157-03-drop_ip.sh
vim 157-03-drop_ip.sh
```

```sh
#!/bin/bash
echo "Dropping packets from $1"
iptables -I INPUT -s $1 -j DROP
echo "The packets from $1 will be dropped."
```

```sh
sudo ./157-03-drop_ip.sh 4.4.4.4
# Dropping packets from 4.4.4.4
# The packets from 4.4.4.4 will be dropped.
```

### 158. Coding - Variables in Bash

```sh
##########################
## Bash Variables
##########################

# defining a variable: variable_name=value
# variable names should start with a letter or underscore and can contain letters, digits and underscore
os="Kali Linux"
version=10

# referencing the value of a variable (getting the variable value): $variable_name
echo $os
echo $version

# defining a read-only variable (constant)
declare -r temperature=100

# removing (unsetting) a variable
unset version

# listing all environment variables
env
printenv

# searching for an environment variable
printenv PATH
env | grep -i path

# creating new environment variables for the user: in ~/.bashrc add export MYVAR=”value”
export IP="80.0.0.1"

# changing the PATH
export PATH=$PATH:~/scripts   # in ~/.bashrc

# getting user input
read MY_VAR
echo $MY_VAR

# displaying a message
read -p "Enter the IP address: " ip
ping -c 1 $ip

read -s -p "Enter password:" pswd
echo $pswd

### SPECIAL VARIABLES AND POSITIONAL ARGUMENTS ###
./script.sh filename1 dir1
$0 => the name of the script itself (script.sh)
$1 => the first positional argument (filename1)
$2 => the second positional argument (dir1)
...
${10} => the tenth argument of the script
${11} => the eleventh argument of the script
$# => the number of the positional arguments
"$*" => string representation of all positional argument
$? => the most recent foreground command exit status
```

### 160. Testing Conditions For Numbers

```sh
man test
```

- `n1 -eq n2`: True if the integers n1 and n2 are algebraically equal.
- `n1 -ne n2`: True if the integers n1 and n2 are not algebraically equal.
- `n1 -gt n2`: True if the integer n1 is algebraically greater than the integer n2.
- `n1 -ge n2`: True if the integer n1 is algebraically greater than or equal to the integer n2.
- `n1 -lt n2`: True if the integer n1 is algebraically less than the integer n2.
- `n1 -le n2`: True if the integer n1 is algebraically less than or equal to the integer n2.

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

### 161. Multiple Conditions and Nested If Statements

```sh
./160-age.sh
# Enter your age: 101
# Invalid age.
```

```sh
vim 161-display-nested-if.sh
chmod +x 161-display-nested-if.sh
```

#### Block indentation in VIM

1. Select with Shift + V
2. Define the selection with arrow keys
3. Press > (Shift + .)

```sh
./161-nested-if.sh
# The script should be run with an argument.
```

### 162. Command Substitution

```sh
now=`date`
now1="`date`"
now2="$(date)"
echo $now
echo $now1
echo $now2

users="$(who)"
echo $users
users1="`who`"
echo $users1

output="$(ps -ef | grep bash)"
echo "$output"
```

```sh
man date
date +%F
# 2023-07-26

date +%F_%H%M
# 2023-07-26_08_26

sudo tar -czvf etc-$(date +%F_%H%M%S).tar.gz /etc/
sudo tar -czvf etc-$(date +%F_%H%M%S).tar.gz /etc/
ls -l
# -rw-r--r-- 1 root root 1264740 Jul 26 08:30 etc-2023-07-26_083023.tar.gz
# -rw-r--r-- 1 root root 1264740 Jul 26 08:30 etc-2023-07-26_083031.tar.gz
```

### 163. Comparing Strings in If Statements

```sh
nvim 163-01-compare_strings.sh
chmod +x 163-01-compare_strings.sh

./163-01-compare_strings.sh
# String1: abc
# S†ring2: abc
# The strings are equal.
# The strings are equal.
./163-01-compare_strings.sh
# String1: abc
# S†ring2: abd
# The strings are not equal.
# The strings are not equal.
# The strings are NOT equal.
```

```sh
# these two syntax are the same
if [[ "$str1" != "$str2" ]]
then
fi

if [[ "$str1" != "$str2" ]];then
fi
```

```sh
nvim 163-02-substrings.sh
chmod +x 163-02-substrings.sh

./163-02-substrings.sh
# The substring Linux is there.
```

```sh
if [[ "$str1" == *"Linux"* ]]
then
fi
```

- `-n STRING`: the length of STRING is nonzero
- `-z STRING`: the length of STRING is zero

```sh
nvim 163-03-empty_string.sh
chmod +x 163-03-empty_string.sh
```

### 164. Lab: Testing Network Connections

```sh
nvim 164-connection_testing.sh
chmod +x 164-connection_testing.sh

# echo $output
./164-connection_testing.sh 8.8.8.8
# PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data. 64 bytes from 8.8.8.8: icmp_seq=1 ttl=56 time=8.63 ms 64 bytes from 8.8.8.8: icmp_seq=2 ttl=56 time=10.0 ms 64 bytes from 8.8.8.8: icmp_seq=3 ttl=56 time=10.1 ms --- 8.8.8.8 ping statistics --- 3 packets transmitted, 3 received, 0% packet loss, time 2003ms rtt min/avg/max/mdev = 8.634/9.593/10.134/0.680 ms0
```

#### if you want to print line by line

```sh
# echo "$output"
./164-connection_testing.sh 8.8.8.8
# PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
# 64 bytes from 8.8.8.8: icmp_seq=1 ttl=56 time=10.9 ms
# 64 bytes from 8.8.8.8: icmp_seq=2 ttl=56 time=8.67 ms

# --- 8.8.8.8 ping statistics ---
# 3 packets transmitted, 2 received, 33.3333% packet loss, time 2003ms
# rtt min/avg/max/mdev = 8.674/9.783/10.892/1.109 ms
```

#### add if condition

```sh
./164-connection_testing.sh 8.8.8.8
# The network connection to 8.8.8.8 is working.
./164-connection_testing.sh 1.2.3.4
# The network connection to 1.2.3.4 is not working.
```

### 165. Coding - If...Elif...Else Statements

```sh
################
### TESTING CONDITIONS => man test

### For numbers (integers) ###
# -eq   equal to
# -ne   not equal to
# -lt   less than
# -le   less than or equal to
# -gt   greater than
# -ge   greater than or equal to

# For files:
# -s    file exists and is not empty
# -f    file exists and is not a directory
# -d    directory exists
# -x    file is executable by the user
# -w    file is writable by the user
# -r    file is readable by the user

# For Strings
# =     the equality operator for strings if using single square brackets [ ]
# ==    the equality operator for strings if using double square brackets [[ ]]
# !=    the inequality operator for strings
# -n $str   str is nonzero length
# -z $str   str is zero length

# &&  => the logical and operator
# ||  => the logical or operator
```

### 166. For Loops

```sh
nvim 166-01-for.sh
chmod +x 166-01-for.sh
```

### from bash version 4, increment

```sh
# default, increment by 1
for num in {3..7}

# Bash version 4, we can add increment number
for num in {10..100..5}
# zsh doesn't work this..
```

```sh
nvim 166-02-for.sh
chmod +x 166-02-for.sh
```

```sh
nvim 166-03-rename_files.sh
chmod +x 166-03-rename_files.sh
```

```sh
nvim 166-04-c_style_for_loop.sh
chmod +x 166-04-c_style_for_loop.sh
```

### 167. Lab: Dropping a List of IP addresses Using a For Loop

```sh
cat 157-03-drop_ip.sh

# we're going to enhance this script
nvim 167-01-drop_ips.sh
chmod +x 167-01-drop_ips.sh
sudo ./167-01-drop_ips.sh

cp 167-01-drop_ips.sh 167-02-deny_packets.sh
nvim 167-02-deny_packets.sh
nvim 167-02-ips.txt
sudo ./167-02-deny_packets.sh

# delete(=Flush) all filters
sudo iptables -t filter -F
```

### 168. While Loops

```sh
nvim 168-01-while.sh
chmod +x 168-01-while.sh
```

```sh
a=5
b=6
c=$((a+b))
echo $c
# 11
let d=a+b
echo $d
# 11
```

### 169. Case Statement

```sh
nvim 169-01-favorite-pet.sh
chmod +x 169-01-favorite-pet.sh

./169-01-favorite-pet.sh
# Enter your favorite pet:d og
# Your favorite pet is the dog.
./169-01-favorite-pet.sh
# Enter your favorite pet: cat
# You like cats.
./169-01-favorite-pet.sh
# Enter your favorite pet: African Turtle
# Fish or turtles are great!
./169-01-favorite-pet.sh
# Enter your favorite pet: no
# Your favorite pet is unknown!
```

```sh
nvim 169-02-signal.sh
chmod +x 169-02-signal.sh

sleep 1001 &
# [1] 5861
pgrep sleep
# 5861

./169-02-signal.sh 1 5861
# Sending the SIGHUP signal to 5861
# [1]+  Hangup                  sleep 1001

pgrep sleep
# (nothing)

./169-02-signal.sh 1
# Run the script with 2 arguments: Signals and PID.
```

#### Signals

```sh
kill -1
#  1) SIGHUP	 2) SIGINT	 3) SIGQUIT	 4) SIGILL	 5) SIGTRAP
#  6) SIGABRT	 7) SIGBUS	 8) SIGFPE	 9) SIGKILL	10) SIGUSR1
# 11) SIGSEGV	12) SIGUSR2	13) SIGPIPE	14) SIGALRM	15) SIGTERM
# 16) SIGSTKFLT	17) SIGCHLD	18) SIGCONT	19) SIGSTOP	20) SIGTSTP
# 21) SIGTTIN	22) SIGTTOU	23) SIGURG	24) SIGXCPU	25) SIGXFSZ
# 26) SIGVTALRM	27) SIGPROF	28) SIGWINCH	29) SIGIO	30) SIGPWR
# 31) SIGSYS	34) SIGRTMIN	35) SIGRTMIN+1	36) SIGRTMIN+2	37) SIGRTMIN+3
# 38) SIGRTMIN+4	39) SIGRTMIN+5	40) SIGRTMIN+6	41) SIGRTMIN+7	42) SIGRTMIN+8
# 43) SIGRTMIN+9	44) SIGRTMIN+10	45) SIGRTMIN+11	46) SIGRTMIN+12	47) SIGRTMIN+13
# 48) SIGRTMIN+14	49) SIGRTMIN+15	50) SIGRTMAX-14	51) SIGRTMAX-13	52) SIGRTMAX-12
# 53) SIGRTMAX-11	54) SIGRTMAX-10	55) SIGRTMAX-9	56) SIGRTMAX-8	57) SIGRTMAX-7
# 58) SIGRTMAX-6	59) SIGRTMAX-5	60) SIGRTMAX-4	61) SIGRTMAX-3	62) SIGRTMAX-2
# 63) SIGRTMAX-1	64) SIGRTMAX
```

- https://faculty.cs.niu.edu/~hutchins/csci480/signals.htm

| #   | Signal Name | Default Action | Comment                                                       | POSIX |
| --- | ----------- | -------------- | ------------------------------------------------------------- | ----- |
| 1   | SIGHUP      | Terminate      | Hang up controlling terminal or process                       | Yes   |
| 2   | SIGINT      | Terminate      | Interrupt from keyboard, Control-C                            | Yes   |
| 3   | SIGQUIT     | Dump           | Quit from keyboard, Control-\                                 | Yes   |
| 4   | SIGILL      | Dump           | Illegal instruction                                           | Yes   |
| 5   | SIGTRAP     | Dump           | Breakpoint for debugging                                      | No    |
| 6   | SIGABRT     | Dump           | Abnormal termination                                          | Yes   |
| 6   | SIGIOT      | Dump           | Equivalent to SIGABRT                                         | No    |
| 7   | SIGBUS      | Dump           | Bus error                                                     | No    |
| 8   | SIGFPE      | Dump           | Floating-point exception                                      | Yes   |
| 9   | SIGKILL     | Terminate      | Forced-process termination                                    | Yes   |
| 10  | SIGUSR1     | Terminate      | Available to processes                                        | Yes   |
| 11  | SIGSEGV     | Dump           | Invalid memory reference                                      | Yes   |
| 12  | SIGUSR2     | Terminate      | Available to processes                                        | Yes   |
| 13  | SIGPIPE     | Terminate      | Write to pipe with no readers                                 | Yes   |
| 14  | SIGALRM     | Terminate      | Real-timer clock                                              | Yes   |
| 15  | SIGTERM     | Terminate      | Process termination                                           | Yes   |
| 16  | SIGSTKFLT   | Terminate      | Coprocessor stack error                                       | No    |
| 17  | SIGCHLD     | Ignore         | Child process stopped or terminated or got a signal if traced | Yes   |
| 18  | SIGCONT     | Continue       | Resume execution, if stopped                                  | Yes   |
| 19  | SIGSTOP     | Stop           | Stop process execution, Ctrl-Z                                | Yes   |
| 20  | SIGTSTP     | Stop           | Stop process issued from tty                                  | Yes   |
| 21  | SIGTTIN     | Stop           | Background process requires input                             | Yes   |
| 22  | SIGTTOU     | Stop           | Background process requires output                            | Yes   |
| 23  | SIGURG      | Ignore         | Urgent condition on socket                                    | No    |
| 24  | SIGXCPU     | Dump           | CPU time limit exceeded                                       | No    |
| 25  | SIGXFSZ     | Dump           | File size limit exceeded                                      | No    |
| 26  | SIGVTALRM   | Terminate      | Virtual timer clock                                           | No    |
| 27  | SIGPROF     | Terminate      | Profile timer clock                                           | No    |
| 28  | SIGWINCH    | Ignore         | Window resizing                                               | No    |
| 29  | SIGIO       | Terminate      | I/O now possible                                              | No    |
| 29  | SIGPOLL     | Terminate      | Equivalent to SIGIO                                           | No    |
| 30  | SIGPWR      | Terminate      | Power supply failure                                          | No    |
| 31  | SIGSYS      | Dump           | Bad system call                                               | No    |
| 31  | SIGUNUSED   | Dump           | Equivalent to SIGSYS                                          | No    |

- POSIX real-time signals
  - From 34) SIGRTMIN

### 170. Functions in Bash

```sh
nvim 170-01-functions.sh
chmod +x 170-01-functions.sh

./170-01-functions.sh
# I'm a simple function!
# Hello fuctions!
# Creating aa.txt...
# Creating bb.txt
# 10
# 3
```

> Bash function doesn't allow return value /
> we can use `$?` instead

```sh
grep -c chmod 170-01-functions.sh
# 3
grep -c usb /var/log/dmesg
```

### 171. Variable Scope in Functions

- `local` keyword

```sh
nvim 171-variable_scope.sh
chmod +x 171-variable_scope.sh

./171-variable_scope.sh
# Inside func1: var1=XX, var2=YY
# After calling func1: var1=XX, var2=BB
```

### 172. Menus in Bash. The Select Statement

```sh
nvim 172-menus.sh
chmod +x 172-menus.sh

./172-menus.sh
# 1) Germany
# 2) French
# 3) USA
# 4) United Kingdom
# 5) Quit
# Choose your country: 3
# You speak American English.
# Choose your country: 7
# Invalid option 7
# Choose your country: 5
# Quitting ...
```

### 173. Lab: System Administration Script using Menus

```sh
nvim 173-system_administration.sh
chmod +x 173-system_administration.sh


./173-system_administration.sh
# 1) Add User
# 2) List All Processes
# 3) Kill Process
# 4) Install Program
# 5) Quit
Your choice: 1
Enter the username: noah
# The username noah already exists.
Your choice: 1
Enter the username: u100
[sudo] password for noah:
# The user u100 was added successfully.
# u100:x:1001:1001::/home/u100:/bin/bash
Your choice: 2
# Listing all processes...
# UID          PID    PPID  C STIME TTY          TIME CMD
# root           1       0  0 Jul30 ?        00:00:07 /sbin/init splash
# root           2       0  0 Jul30 ?        00:00:00 [kthreadd]
# ...
# noah       14622   14580  0 20:50 pts/1    00:00:00 /bin/bash ./173-system_administration.sh
# root       14636       2  0 20:50 ?        00:00:00 [kworker/u8:3-events_unbound]
# noah       14638   14622  0 20:50 pts/1    00:00:00 ps -ef
Your choice: 3
# Enter the process to kill: sleep
Your choice: 4
# Enter the program to install: nmap
# Hit:1 http://au.archive.ubuntu.com/ubuntu focal InRelease
# Get:2 http://au.archive.ubuntu.com/ubuntu focal-updates InRelease [114 kB]
# ...
# Setting up liblinear4:amd64 (2.3.0+dfsg-3build1) ...
# Setting up nmap (7.80+dfsg1-2build1) ...
# Processing triggers for man-db (2.9.1-1) ...
# Processing triggers for libc-bin (2.31-0ubuntu9.9) ...
Your choice: 5
# Quitting...
```

```sh
# on the other terminal
sleep 100
# Terminated
```

### 174. Intro to Bash Arrays

- `[@]` or `[*]`: all values
- `![@]`: all indexes
- `#[@]`: length of the array

```sh
ages=(20 22 40 38)
echo $ages
# 20
echo ${ages[@]}
# 20 22 40 38
echo ${ages[*]}
# 20 22 40 38
echo ${!ages[*]}
# 0 1 2 3
echo ${#ages[*]}
# 4
echo ${ages[0]}
# 20
echo ${ages[2]}
# 40

# invalid index will dis  paly nothing
echo ${ages[100]}
#
echo ${ages[-1]}
# 38
echo ${ages[-2]}
# 40
numbers[0]=100
numbers[1]=200
echo ${numbers[@]}
# 100 200
numbers[1]=600
echo ${numbers[@]}
# 100 600 400
```

```sh
declare -a names
names[0]="Dan"
names[1]="Alina"
names[2]="Diana"
echo ${names[@]}
# Dan Alina Diana

# set the index higher then the length
names[7]="Maya"
# it displays all elements but the index is different
echo ${names[@]}
# Dan Alina Diana Maya
echo ${!names[@]}
# 0 1 2 7
unset names[1]
echo ${names[@]}
# Dan Diana Maya
echo ${!names[@]}
# 0 2 7
```

### 175. Arrays In Depth

```sh
years=(2019 2020 2021 2022 2023)

# add more elements
years+=(2024)
years+=(2025 2026 2027)

echo ${years[@]}
# 2019 2020 2021 2022 2023 2024 2025 2026 2027
echo ${years[@]:2}
# 2021 2022 2023 2024 2025 2026 2027
echo ${years[@]:2:4}
# 2021 2022 2023 2024
```

#### Associative Arrays (looks like Object/Dict, but array)

- `[@]` or `[*]`: all values
- `![@]`: all keys (indexes)
- `#[@]`: length of the array

```sh
declare -A userdata
userdata[username]="youradmin"
userdata[password]="fdsa4."
userdata[uid]="1010"

echo ${userdata[username]}
# youradmin
echo ${userdata[@]}
# fdsa4. 1010 youradmin
echo ${!userdata[@]}
# password uid username
userdata[login]="$(date --utc +%s)"
echo ${userdata[@]}
# fdsa4. 1691095988 1010 youradmin
userdata[login]="$(date +%T)"
echo ${userdata[@]}
# fdsa4. 06:57:30 1010 youradmin

# add more elements
userdata+=([shell]="Bash" [admin]="False")
echo ${userdata[@]}
# False fdsa4. 06:57:30 Bash 1010 youradmin
echo ${!userdata[@]}
# admin password login shell uid username
```

##### read-only associative array

cannot modify or add elements

```sh
declare -r -A SUPERSTARS=(
> [Germany]="Boney M"
> [USA]="Bon Jovi"
> [England]="The Beatles"
> )
echo ${SUPERSTARS[@]}
# Bon Jovi The Beatles Boney M
SUPERSTARS[USA]="Metallica"
# -bash: SUPERSTARS: readonly variable
```

##### remove an element

```sh
unset userdata[password]
echo ${userdata[@]}
# False 06:57:30 Bash 1010 youradmin
```

### 176. Using the Readarray Command

```sh
readarray months
# Jan
# Feb
# Mar
# Apr
# May
# Jun
# ^C
echo ${months[@]}
# Jan Feb Mar Apr May Jun
echo ${!months[@]}
# 0 1 2 3 4 5
echo ${#months[@]}
# 6
```

#### readarray from file

```sh
cat months.txt
# Janumary
# February
# March
# April
# May
# June
# July
# August
# September
# October
# November
# December


echo ${months[@]}
# Janumary February March April May June July August September October November December
echo ${!months[@]}
# 0 1 2 3 4 5 6 7 8 9 10 11

# trailing \n
echo ${months[@]@Q}
# $'Janumary\n' $'February\n' $'March\n' $'April\n' $'May\n' $'June\n' $'July\n' $'August\n' $'September\n' $'October\n' $'November\n' $'December\n'
```

```sh
# replace trailing \n to \t
readarray -t months< <(cat months.txt)
echo ${months[@]}
# Janumary February March April May June July August September October November December
echo ${months[@]@Q}
# 'Janumary' 'February' 'March' 'April' 'May' 'June' 'July' 'August' 'September' 'October' 'November' 'December'
```

#### other examples

```sh
readarray users< <(cut -d: -f1 /etc/passwd)
echo ${users[@]}
# root daemon bin sys sync games man lp mail news uucp proxy www-data backup list irc gnats nobody systemd-network systemd-resolve systemd-timesync messagebus syslog _apt tss uuidd tcpdump avahi-autoipd usbmux rtkit dnsmasq cups-pk-helper speech-dispatcher avahi kernoops saned nm-openvpn hplip whoopsie colord geoclue pulse gnome-initial-setup gdm noah systemd-coredump fwupd-refresh sshd u100

readarray -t files< <(ls /etc)
echo ${files[@]}
```

### 177. Iterating Over Arrays

```sh
# read all files under /etc
nvim 177-array_iterate.sh
chmod +x 177-array_iterate.sh

./177-array_iterate.sh
```

### 178. Project: Account Creation

```sh
nvim 178-users.txt

nvim 178-01-users_and_groups.sh
chmod +x 178-01-users_and_groups.sh

sudo ./178-01-users_and_groups.sh
[sudo] password for noah:
# Group management added successfully!
# User john added successfully!
# #####################
# Group programming added successfully!
# User diana added successfully!
# #####################
# Group accounting added successfully!
# User paul added successfully!
# #####################
```

```sh
nvim 178-02-delete_users_and_groups.sh
chmod +x 178-02-delete_users_and_groups.sh

sudo ./178-02-delete_users_and_groups.sh
```

### 179. Running a DoS Attack Without root Access (ulimit)

```sh
nvim 179-bomb.sh
chmod +x 179-bomb.sh

# if I run this script, my ubuntu will not respond
# it is basically execution of unlimited loop

cat 179-bomb.sh
# $0 && $0 &
```

#### Prevent this type of user bomb

```sh
ulimit -u
# 30932

ulimit -a
# core file size          (blocks, -c) 0
# data seg size           (kbytes, -d) unlimited
# scheduling priority             (-e) 0
# file size               (blocks, -f) unlimited
# pending signals                 (-i) 30932
# max locked memory       (kbytes, -l) 65536
# max memory size         (kbytes, -m) unlimited
# open files                      (-n) 1024
# pipe size            (512 bytes, -p) 8
# POSIX message queues     (bytes, -q) 819200
# real-time priority              (-r) 0
# stack size              (kbytes, -s) 8192
# cpu time               (seconds, -t) unlimited
# max user processes              (-u) 30932
# virtual memory          (kbytes, -v) unlimited
# file locks                      (-x) unlimited
```

Let's limit the number of available processes for this user

- noah: user name
- @admins: group name

```sh
sudo vim /etc/security/limits.conf

# noah            hard    nproc           2000
# @admins         hard    nproc           4000

# after change this file, the user has to get logged in again.

./179-bomb.sh
# this sripts will get error instead of taking all resources.
```
