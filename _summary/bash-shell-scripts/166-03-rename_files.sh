#!/bin/bash

for file in *.txt
do
  mv "$file" "renamed_by_script_$file"
done
