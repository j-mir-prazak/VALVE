#!/bin/bash
if [ ! -z $1 ]
then
	echo "faking it"
fi

pipe=$1

if [ ! -z "$pipe" ]
then
	rm "$pipe"
fi

mkfifo "$pipe"

while true;
	do
		cat "$pipe"
	done
