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
