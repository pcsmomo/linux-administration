#!/bin/bash

readarray accounts< <(cat ./178-users.txt)

for account in "${accounts[@]}"
do
  # echo $account
  user=$(echo $account | cut -d: -f1)
  group=$(echo $account | cut -d: -f2)

  # user
  if [[ -n "$(grep -w $user /etc/passwd)" ]]
  then
    deluser $user
    echo "User $user deleted successfully!"
  else
    echo "User $user doesn't exist"
  fi

  # group
  if [[ -n "$(grep -w $group /etc/group)" ]]
  then
    delgroup $group
    echo "Group $group deleted successfully!"
  else
    echo "Group $group doesn't exist"
  fi

  echo "#####################"
  sleep 1
done
