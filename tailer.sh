(bash/valve.sh > output.file) & PROC1=$!;(tail -f output.file) & PROC2=$!; trap 'kill $PROC1 $PROC2; echo "terminated"; trap SIGINT' SIGINT; wait

