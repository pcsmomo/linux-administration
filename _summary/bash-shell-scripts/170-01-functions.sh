#!/bin/bash

function print_something () {
  echo "I'm a simple function!"
}

display_something () {
  echo "Hello fuctions!"
}

create_files () {
  echo "Creating $1..."
  touch $1
  chmod 400 $1
  echo "Creating $2"
  touch $2
  chmod 600 $2
  return 10
}

function lines_in_file () {
  grep -c "$1" "$2"
}

print_something
display_something

create_files aa.txt bb.txt
# - `$?`: is the most recent foreground command exit status
echo $?

n=$(lines_in_file "chmod" "170-01-functions.sh")
echo $n

n2=$(lines_in_file "usb" "/var/log/dmesg")
echo $n2