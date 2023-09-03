#!/bin/bash

echo -n "Enter your favorite pet: "
read PET

case "$PET" in
  dog)
    echo "Your favorite pet is the dog."
    ;;
  cat|Cat)
    echo "You like cats."
    ;;
  fish|"African Turtle")
    echo "Fish or turtles are great!"
    ;;
  *)
    echo "Your favorite pet is unknown!"
esac
