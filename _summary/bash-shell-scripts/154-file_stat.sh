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
