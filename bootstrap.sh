#!/bin/bash
export DISPLAY=:0

echo -ne "\e[35m"
echo -e "---------------------------"
echo -e "         BOOTSTRAP.        "
echo -e "---------------------------"

#cd /home/pi/valve
chmod +x -R *

import_folder="rpi_update"

### DECLARATION PART

function list_through_files {

	folder="$1"

	for a in "$folder/"* ; do

		if [ -d "$a" ] ; then
			if [ "$a" == "$folder/video" ] ; then
				update_assets "$a"
			else
				echo "COPING $a"
				gcp --force --recursive "$a" "./"
			fi
		else
			echo "COPING $a"
			gcp --force --recursive "$a" "./"
		fi
	done


}

##updates assets in up-to-date fashion
function update_assets {

	folder="$1"

	for v in "$folder/"* ; do

		if [ ! -d "$v" ] ; then
			if [ ! -f "./assets/$(basename "$v")" ] ; then
				echo -e "COPING $v"
				gcp "$v" "./assets/$(basename "$v")"

			fi
		else
			echo "COPING $v"
			gcp "$v" "./assets/$(basename "$v")"
		fi

	done

	for w in "./assets/"* ; do
		if [ ! -d "$w" ]; then
			if [ ! -f "$folder/$(basename "$w")" ] ; then
				echo -e "REMOVING $w"
				rm  "$w"
			fi
		fi
	done

}

### LOGIC PART


if [ ! -d assets ]
then
	echo -e "CREATING ASSETS DIRECTORY."
	mkdir assets
	chmod +x assets
fi


sleep 10

echo -e "CHECKING FOR FILES TO UPDATE."

for i in /media/* ; do

  if [ -d "$i/$import_folder/" ]; then

	echo "$i/$import_folder"

	list_through_files "$i/$import_folder"


  fi


  for j in "$i/"* ; do

     if [ -d "$j/$import_folder/" ]; then

        echo "$j/$import_folder"

	list_through_files "$j/$import_folder"


    fi

  done


done

chmod +x ./*

echo -e "PAUSING."
echo -e "10"
sleep 5
echo -e "5"
sleep 1
echo -e "4"
sleep 1
echo -e "3"
sleep 1
echo -e "2"
sleep 1
echo -e "\e[91m1"
sleep 1
echo -e "\e[31mLIFT OFF."
echo -e "\e[39m"

./valve.sh
