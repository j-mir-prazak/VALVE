#!/bin/bash

Process="node"
counter=0

function terminate {

	kill -SIGINT $PROC1
	kill -SIGTERM $PROC1
	echo -e "\e[33m\n\n"
	echo -e "-----------------------------"
	echo -e "       VALVE TERMINATED.     "
	echo -e "-----------------------------"
	echo -e "\n\n"
	trap SIGTERM
	trap SIGINT
	kill -SIGTERM $$
	}

trap terminate SIGINT
# trap 'echo int; kill -SIGINT $PROC1' SIGINT
trap terminate SIGTERM


function looping {
	while true; do
	  echo -e "\e[34m"
	  echo "-----------------------------"
	  echo "       Starting nodejs.      "
	  echo "-----------------------------"
	  echo ""
	  echo ""
	  node index.js &
		PROC2=$!
		trap 'kill -SIGTERM $PROC2; trap SIGINT; break' SIGINT
		trap 'kill -SIGTERM $PROC2; trap SIGTERM; break' SIGTERM
		wait
		echo ""
	  counter=$(expr $counter + 1)
	  echo "Error. Retrying. Rerun #$counter."
	  echo  ""
	  sleep 5
	done
}

looping &
PROC1=$!
wait
