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

# Expects VHDL-files (*.vhdl) from anywhere within specified source directory.
#  First file will be selected as main testbench.
SRCS=("randomForest" "majorityVote" "decisionTreeMemory" "node" "comparator")

# Sources root directory
SRCSDIR="src/vhdl"

# Working directory; specifies where testbench and compile output will be put.
WORKDIR="out"



#-------------------------------------------------------------------------------
# Runs GHDL command with given arguments and appends result to the print stream.
#
#  $1 - GHDL command arguments for execution
#-------------------------------------------------------------------------------

runGHDL()
{
    # Run specified command
    local output="$(ghdl $1)"
    local result=$?

    # Print command execution status, aborting upon failure
    if [ $result -eq 0 ] #&& [ -z "$output" ]
    then
        printf "OK\n"
    else
        printf "ERROR ($result):\n$output\n"
        exit $result
    fi
}



#-------------------------------------------------------------------------------
# GHDL compilation and simulation
#-------------------------------------------------------------------------------

# Create working directory, if not existent.
if [[ ! -d "$WORKDIR" ]]
then
    mkdir "$WORKDIR"
fi

# Run syntax check and analysis on all files.
printf "Syntax check and analysis..\n"
for (( i = ${#SRCS[@]} - 1; i >= 0; --i ))
do
    files="$SRCSDIR/${SRCS[$i]}.vhdl"
    
    for (( j = i + 1; j < ${#SRCS[@]}; j++ ))
    do
        files="$files $SRCSDIR/${SRCS[$j]}.vhdl"
    done
    
    printf "    Checking  \"${SRCS[$i]}\".. "
    runGHDL "-s -fsynopsys --workdir=$WORKDIR --std=08 $files $SRCSDIR/${SRCS[$i]}_tb.vhdl"
    printf "    Analysing \"${SRCS[$i]}\".. "
    runGHDL "-a -fsynopsys --workdir=$WORKDIR --std=08 $files $SRCSDIR/${SRCS[$i]}_tb.vhdl"
done

# Build testbench.
printf "Building.. "
runGHDL "-m -fsynopsys --workdir=$WORKDIR --std=08 ${SRCS[0]}_tb"

# Dump VCD testbench.
printf "Dumping VCD.. "
runGHDL "-r -fsynopsys --workdir=$WORKDIR --std=08 ${SRCS[0]}_tb --vcd=$WORKDIR/testbench.vcd"

#  # Run syntax checks for all files.
#  printf "Checking syntax..\n"
#  
#  for file in "${SRCS[@]}"
#  do
#      printf "    $file.. "
#      runGHDL "-s -fsynopsys --workdir=$WORKDIR --std=08 $SRCSDIR/${file}.vhdl $SRCSDIR/${file}_tb.vhdl"
#  done
#
#  # Run analysis next.
#  printf "Analysing..\n"
#  for file in "${SRCS[@]}"
#  do
#       printf "    $file.. "
#       runGHDL "-a -fsynopsys --workdir=$WORKDIR --std=08 $SRCSDIR/${file}.vhdl $SRCSDIR/${file}_tb.vhdl"
#  done
#
#  # Build testbenches.
#  printf "Building..\n"
#  for file in "${SRCS[@]}"
#  do
#      printf "    $file.. "
#      runGHDL "-m -fsynopsys --workdir=$WORKDIR --std=08 ${file}_tb"
#  done
#
#  # Dump VCD testbench.
#  printf "Dumping VCD..\n"
#  for file in "${SRCS[@]}"
#  do
#      printf "    $file.. "
#      runGHDL "-r -fsynopsys --workdir=$WORKDIR --std=08 ${file}_tb --vcd=$WORKDIR/testbench.vcd"
#  done

# Upon reaching this point, we have been successful. Start GtkWave.
printf "Starting GtkWave..\n"
gtkwave "$WORKDIR/testbench.vcd"

