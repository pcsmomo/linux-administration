#!/bin/bash

PS3="Choose your country: "
select COUNTRY in Germany French USA "United Kingdom" Quit
do
  # echo "COUNTRY is $COUNTRY"
  # echo "REPLY is $REPLY"
  case $REPLY in
    1)
      echo "You speak German."
      ;;
    2)
      echo "You speak French."
      ;;
    3)
      echo "You speak American English."
      ;;
    4)
      echo "You speak Briotish English."
      ;;
    5)
      echo "Quitting ..."
      break
      ;;
    *)
      echo "Invalid option $REPLY"
      ;;
  esac
done
