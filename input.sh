#!/bin/bash
MAINPID=$1
if [ -p input.pipe ]
then
	rm input.pipe
fi

mkfifo input.pipe

while true;
do read STRING <input.pipe;
 	if [ "$STRING" == "die-now" ]
 	then
		kill -SIGTERM $MAINPID 2>/dev/null
		kill $$ 2>/dev/null
	fi
done
