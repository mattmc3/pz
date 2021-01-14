#!/usr/bin/env zsh
0=${(%):-%N}
##source ${0:a:h}/lib/async.zsh
fpath+="${0:a:h:h}/functions"
# cat "${0:h}/functions/async"
#autoload -Uz "${0:h}/functions/async"
autoload -Uz async && async
autoload -Uz foo
async_init

# Initialize a new worker (with notify option)
async_start_worker my_worker -n

# Create a callback function to process results
COMPLETED=0
completed_callback() {
	COMPLETED=$(( COMPLETED + 1 ))
	print $@
}

function foo() {
  echo "bar"
}

# Register callback function for the workers completed jobs
async_register_callback my_worker completed_callback

# Give the worker some tasks to perform
async_job my_worker print hello
async_job my_worker eval 'echo $fpath'
async_job my_worker foo
async_job my_worker sleep 0.3

# Wait for the two tasks to be completed
while (( COMPLETED < 4 )); do
	print "Waiting..."
	sleep 0.1
done

print "Completed $COMPLETED tasks!"

# Output:
#	Waiting...
#	print 0 hello 0.001583099365234375
#	Waiting...
#	Waiting...
#	sleep 0 0.30631208419799805
#	Completed 2 tasks!
