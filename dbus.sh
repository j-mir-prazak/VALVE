#!/bin/bash

case $1 in
volume)
variable=`dbus-send --print-reply=literal --session --reply-timeout=500 --dest=$2 /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"Volume"`

;;

setVolume)
variable=`dbus-send --print-reply=literal --session --reply-timeout=500 --dest=$2 /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Set string:"org.mpris.MediaPlayer2.Player" string:"Volume" variant:double:$3`

;;

pid)
variable=`dbus-send --print-reply --session --dest=org.freedesktop.DBus --reply-timeout=500 /org/freedesktop/DBus org.freedesktop.DBus.GetConnectionUnixProcessID string:$2`

;;


*)
	variable=`dbus-send --print-reply --session --dest=org.freedesktop.DBus --reply-timeout=500 /org/freedesktop/DBus org.freedesktop.DBus.ListNames`
	;;
esac


echo "$variable"
