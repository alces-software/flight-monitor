 #!/bin/sh
     
   if test -t 1; then
      exec 1>/dev/null
    fi
     
    if test -t 2; then
      exec 2>/dev/null
    fi
     
    "$@" &
    
#test -t 1 = checks whether the input is producing stdout (output to terminal) and sends it to /dev/null (which is the void)
#test -t 2 = checks if the input is producing stderr and sends it to /dev/null
#$@ takes in all inputs (including parameters) and stores them as an array in $@
#the follow & insures the process runs in the background

#take this script, call it bq (be quiet), then use it to run memtester in the background.
#so you can run "memtester <node> <time>" but to run in the background you run it as "bq memtester <node> <time>"
#solves that issue.
