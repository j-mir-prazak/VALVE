#!/bin/bash
pid=$1

if [ -f input.pipe ]
then
	echo "exists"
	rm input.pipe
fi

mkfifo input.pipe

while true;
do read STRING <input.pipe;
 	if [ "$STRING" == "die-now" ]
 	then
  		kill -s SIGINT "$pid"
	fi
done &
