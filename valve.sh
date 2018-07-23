#!/bin/bash

Process="node"
counter=0

function terminate {
	echo -e "\e[33m\n\n"
	echo -e "-----------------------------"
	echo -e "       VALVE TERMINATED.     "
	echo -e "-----------------------------"
	echo -e "\n\n"
	disown $PROC1;
	kill -2 $PROC1 2>/dev/null;
	trap SIGINT;
	}


trap terminate SIGINT
while true; do
  echo -e "\e[34m"
  echo "-----------------------------"
  echo "       Starting nodejs.      "
  echo "-----------------------------"
  echo ""
  echo ""
  $Process index.js
  echo ""
  counter=$(expr $counter + 1)
  echo "Error. Retrying. Rerun #$counter."
  echo  ""
  sleep 5
done &
PROC1=$!
wait
