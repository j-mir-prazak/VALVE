#!/bin/bash

Process="node"
counter=0

while true; do
  echo -e "\e[34m"
  echo "-----------------------------"
  echo "       Starting nodejs.      "
  echo "-----------------------------"
  echo ""
  echo ""
  "$Process" index.js
  echo ""
  counter=$(expr $counter + 1)
  echo "Error. Retrying. Rerun #$counter."
  echo  ""
  sleep 5
done
