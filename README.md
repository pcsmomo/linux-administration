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

</details>
