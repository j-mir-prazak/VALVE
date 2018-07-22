#!/bin/bash
cd /home/pi/valve

if [ -f output.file ]
then
	echo -ne "" > output.file
fi

echo -ne "\n\e[94m" >> output.file
date >> output.file

if [ ! -z $1 ]
then
echo -e "-----------------------------" >> output.file
echo -e "    STARTED BY LXSESSION.    " >> output.file
fi
echo -e "-----------------------------" >> output.file
echo -e "          AUTOSTART.         " >> output.file
echo -e "-----------------------------" >> output.file
echo -e "" >> output.file
echo -e "" >> output.file


(./bootstrap.sh >> output.file) &
PROC1=$!
(tail -f output.file) &
PROC2=$!
trap '' SIGINT
trap 'disown $PROC2; disown $PROC1; kill -9 $PROC1 2>/dev/null; kill -9 $PROC2 2>/dev/null; echo -e "\e[33m\n\n-----------------------------\n      PROCESS TERMINATED.    \n-----------------------------\n\n" | tee -a output.file; trap SIGINT' SIGINT
wait
