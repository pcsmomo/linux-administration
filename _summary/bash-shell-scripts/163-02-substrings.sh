#!/bin/bash

str1="Nowadays, Linux powers the servers of the Internet."

if [[ "$str1" == *"Linux"* ]]
then
  echo "The substring Linux is there."
else
  echo "The substring Linux IS NOT there."
fi
