#!/bin/bash
read -p "Enter your age: " age

if [[ $age -lt 18 ]] && [[ $age -ge 0 ]]
then
  echo "You are a minor."
elif [[ $age -eq 18 ]]
then
  echo "Congratulations, you're just become major!"
elif [[ $age -gt 18 && $age -le 100 ]]
then
  echo "You are major."
else
  echo "Invalid age."
fi

# if [[ $age -lt 18 ]]
# then
#   echo "You are a minor."
# elif [[ $age -ge 18 && $age -lt 40 ]]
# then
#   echo "You are an adult."
# else
#   echo "You are old."
# fi