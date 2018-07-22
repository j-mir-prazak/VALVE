#!/bin/bash
export DISPLAY=:0

echo -ne "\n\e[94m"
echo -e "-----------------------------"
echo -e "          AUTOSTART.         "
echo -e "-----------------------------"
echo -e ""

cd /home/pi/valve
if [ -z output.file ]
then
	echo "" > output.file
fi

(./bootstrap.sh > output.file) &
PROC1=$!
(tail -f output.file) &
PROC2=$!
trap '' SIGINT
trap 'disown $PROC2; disown $PROC1; kill -9 $PROC1 2>/dev/null; kill -9 $PROC2 2>/dev/null; echo -e "\e[33m\n\n-----------------------------\n      PROCESS TERMINATED.    \n-----------------------------\n\n" | tee -a output.file; trap SIGINT' SIGINT
wait
