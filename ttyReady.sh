#!/bin/bash
if [ ! -z $1 ]
then
	tty=$1
	echo -ne ready? > "$tty"
fi
