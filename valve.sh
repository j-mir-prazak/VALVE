#!/bin/bash

# set here the path to the directory containing your videos

# you can probably leave this alone
Process="node"
counter=0
# our loop
while true; do
  echo -e "\e[34m"
  echo "---------------------------"
  echo "      Starting nodejs.     "
  echo "---------------------------"
  echo ""
  echo ""
  "$Process" index.js
  echo ""
  counter=$(expr $counter + 1)
  echo "Error. Retrying. Rerun #$counter."
  echo  ""
  sleep 5
done
