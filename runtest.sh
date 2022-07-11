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
#  Listed files descend the dependency tree in given order.
SRCS=("randomForest" "majorityVote" "decisionTree" "node" "comparator" "decisionTreeMemory")

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
    # Run GHDL command with given arguments.
    local output="$(ghdl $1 2>&1)"
    local result=$?

    # Print command execution status.
    if [ $result -ne 0 ]
    then
        printf "ERROR ($result)\n"
	elif [ ! -z "$output" ]
	then
		printf "WARNING\n"
    else
        printf "OK\n"
    fi
    
    # Optionally print command output with indentation.
    if [ ! -z "$output" ]
    then
        # Split output on newline character
        IFS=$'\n'
        lines=(${output//;/ })
        unset IFS
        
        for line in "${lines[@]}"
        do
            printf "    $line\n"
        done
    fi
    
    # Exit upon failure.
    if [ $result -ne 0 ]
    then
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
printf "\n"
printf "  ===========================\n"
printf "  == Building VHDL sources ==\n"
printf "  ===========================\n"
printf "\n"

for (( i = ${#SRCS[@]} - 1; i >= 0; --i ))
do
	# Display current file
	printf "\n"
	printf "File \"$SRCSDIR/${SRCS[$i]}.vhdl\"\n"

    # Gather file dependencies
    files="$SRCSDIR/${SRCS[$i]}.vhdl"
    for (( j = i + 1; j < ${#SRCS[@]}; j++ ))
    do
        files="$files $SRCSDIR/${SRCS[$j]}.vhdl"
    done
    
    # Syntax check
    printf "  Syntax check.. "
    runGHDL "-s --workdir=$WORKDIR --std=08 $files $SRCSDIR/${SRCS[$i]}_tb.vhdl"
    
    # Analysis
    printf "  Analysis..     "
    runGHDL "-a --workdir=$WORKDIR --std=08 $files $SRCSDIR/${SRCS[$i]}_tb.vhdl"
	
	# Build
	printf "  Building..     "
	runGHDL "-e --workdir=$WORKDIR --std=08 -o $WORKDIR/${SRCS[i]}_tb ${SRCS[i]}_tb"
	
	# Dump VCD testbench
	printf "  Dumping VCD..  "
	cd "$WORKDIR"
	runGHDL "-r --workdir=. --std=08  ${SRCS[i]}_tb --vcd=${SRCS[i]}.vcd"
	cd ".."
done

printf "\n"
printf "  ====================\n"
printf "  == BUILD COMPLETE ==\n"
printf "  ====================\n"
printf "\n"

# Suggest testbench execution in GTKWave
printf "You can now view testbenches in GTKWave by running e.g.\n"
printf "\n"
printf "    gtkwave \"$WORKDIR/${SRCS[0]}.vcd\"\n"
printf "\n"
