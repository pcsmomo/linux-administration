## Section 19: [EXTRA]: Configure a Linux Server from Scratch (VPS,DNS,WEB,PHP,MySql,Wordpress)

### 137. Running a Linux Server in the Cloud

- Digital Ocean -> Create a new Droplet
  - Ubuntu
  - Basic
- Connect it with web console

```sh
apt update && apt full-upgrade -y
```

```sh
ssh root@170.64.181.165
```

### 138. Securing SSH with Key Authentication

#### On the client

```sh
# -t: type, -b: length, -C: comment
ssh-keygen -t rsa -b 2048 -C 'keys generated on May 2023'

cat /Users/noah/.ssh/id_digital_ocean.pub
```

#### SSH setting on the Digital Ocean

- Digital Ocean -> Settings -> Security
  - add ssh key

```sh
ssh-copy-id root@170.64.181.165
# /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
# /usr/bin/ssh-copy-id: INFO: 2 key(s) remain to be installed -- if you are prompted now it is to install the new keys
# root@170.64.181.165's password:

# Number of key(s) added:        2

# Now try logging into the machine, with:   "ssh 'root@170.64.181.165'"
# and check to make sure that only the key(s) you wanted were added.
```

#### On the server side

```sh
ssh root@170.64.181.165

cat authorized_keys
```

> # so actually I can manually change this `authorized_keys` file for `root` or any users

#### Change ssh password option to null

```sh
vim /etc/ssh/sshd_config
# PasswordAuthentication no
systemctl restart ssh
```
