if [ -f output.file ]
then
	echo "" > output.file
fi

while true; do
echo "hello"
sleep 0.5
done >>output.file
