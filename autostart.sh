#!/bin/bash
cd /home/pi/valve

pid=$$
if [ -p input.pipe ]
then
	rm input.pipe
fi

mkfifo input.pipe

while true;
do read STRING <input.pipe;
 	if [ "$STRING" == "die-now" ]
 	then
			terminate
  		kill -s SIGINT "$pid"
	fi
done &

if [ -f output.file ]
then
	echo -ne "" > output.file
fi

echo -ne "\n\e[94m" >> output.file
date >> output.file

if [ -z $1 ]
then
echo -e "-----------------------------" >> output.file
echo -e "    STARTED BY LXSESSION.    " >> output.file
fi
echo -e "-----------------------------" >> output.file
echo -e "          AUTOSTART.         " >> output.file
echo -e "-----------------------------" >> output.file
echo -e "" >> output.file
echo -e "" >> output.file

function terminate {
	disown $PROC1;
	disown $PROC2;
	kill -9 $PROC1 2>/dev/null;
	kill -9 $PROC2 2>/dev/null;
	echo -e "\e[33m\n\n-----------------------------\n      PROCESS TERMINATED.    \n-----------------------------\n\n" | tee -a output.file;
	trap SIGINT;
	}

(./bootstrap.sh >> output.file) &
PROC1=$!
(tail -f output.file) &
PROC2=$!
trap '' SIGINT
trap terminate SIGINT
wait
