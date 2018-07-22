#!/bin/bash
export DISPLAY=:0

cd /home/pi/valve
if [ -z output.file ]
then
	echo "" > output.file
fi

(./bootstrap.sh > output.file) &
PROC1=$!
(tail -f output.file) &
PROC2=$!
trap 'kill $PROC1; kill $PROC2; echo -e "\e[33m\n\n-----------------------------\n      PROCESS TERMINATED.    \n-----------------------------" | tee -a output.file; trap SIGINT' SIGINT
wait
