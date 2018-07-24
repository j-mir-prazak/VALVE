#!/bin/bash
MAINPID=$1
if [ -p input.pipe ]
then
	rm input.pipe
fi

mkfifo input.pipe

function terminate {

	echo -e "\e[33m\n\n" | tee -a output.file
	echo -e "-----------------------------" | tee -a output.file
	echo -e "      INPUT TERMINATED.      " | tee -a output.file
	echo -e "-----------------------------" | tee -a output.file
	echo -e "\n\n" | tee -a output.file

	trap SIGINT;
	trap SIGTERM;
	kill $$ 2>/dev/null
	# kill -2 $MAINPID
	}

trap terminate SIGINT
trap terminate SIGTERM

while true;
do read STRING <input.pipe;
 	if [ "$STRING" == "die-now" ]
 	then
		kill -SIGTERM $MAINPID 2>/dev/null
		kill -SIGTERM $$ 2>/dev/null
	fi
done
