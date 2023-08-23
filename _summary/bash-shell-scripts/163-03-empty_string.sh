#!/bin/bash

my_str="abc"

if [[ -z "$my_str" ]]
then
  echo "String is zero length."
else
  echo "String IS NOT zero length."
fi

if [[ -n "$my_str" ]]
then
  echo "String IS NOT zero length."
else
  echo "String is zero length."
fi
