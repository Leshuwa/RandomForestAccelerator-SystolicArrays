#!/bin/sh
#
#===============================================================================
#
#           FILE:   runtest.sh
#
#          USAGE:   runtest.sh
#
#    DESCRIPTION:   Runs GHDL compilation and simulation procedures for preset
#                    VHDL source files and opens GtkWave for inspection of the
#                    generated results.
#                   Stores recorded signals in 'testbench.vcd', overriding any
#                    previously existing file with that name upon execution.
#
#         AUTHOR:   Immanuel Dick (immanuel.dick@tu-dortmund.de)
#        COMPANY:   TU Dortmund, Dortmund
#        VERSION:   1.0
#        CREATED:   2022/06/08 13:45:30
#       REVISION:   2022/06/08 13:45:30
# 
#===============================================================================

WORKDIR="out"
VHDL_TEST="src/vhdl/randomForest_tb"
VHDL_SRCS="src/vhdl/randomForest.vhdl src/vhdl/majorityVote.vhdl src/vhdl/decisionTreeMemory.vhdl src/vhdl/node.vhdl src/vhdl/comparator.vhdl"


#-------------------------------------------------------------------------------
# Prints the given step description and executes given command.
#
#  $1 - Command description, will be printed to console
#  $2 - Command to execute, with any necessary arguments
#-------------------------------------------------------------------------------
step()
{
	# Print step description without new line
	printf "$1.. "

	# Runs the command specified by second argument
    local output="$($2)"
    local result=$?

    # Print command execution status, aborting upon failure
    if [ $result -eq 0 ] && [ -z "$output" ]
    then
        printf "OK\n"
    else
        printf "FAILED ($result):\n$output\n"
        exit $result
    fi
}



#-------------------------------------------------------------------------------
# GHDL compilation and simulation
#-------------------------------------------------------------------------------

# Run GHDL pipeline.
step "Checking syntax" "ghdl -s -v -fsynopsys --workdir=$WORKDIR --std=08 $VHDL_SRCS $VHDL_TEST.vhdl"
step "Analysing"       "ghdl -a -v -fsynopsys --workdir=$WORKDIR --std=08 $VHDL_SRCS $VHDL_TEST.vhdl"
step "Building"        "ghdl -m -v -fsynopsys --workdir=$WORKDIR --std=08 $VHDL_TEST"
step "Dumping VCD"     "ghdl -r -v -fsynopsys --workdir=$WORKDIR --std=08 $VHDL_TEST --vcd=testbench.vcd"


# Upon reaching this point, we have been successful. Start GtkWave.
printf "Starting GtkWave..\n"
gtkwave "$WORKDIR/testbench.vcd"

