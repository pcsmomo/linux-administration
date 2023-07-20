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
