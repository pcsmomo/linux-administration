#!/bin/bash

var1="AA"
var2="BB"

function func1() {
  var1="XX"
  local var2="YY"
  echo "Inside func1: var1=$var1, var2=$var2"
}

func1
echo "After calling func1: var1=$var1, var2=$var2"