#!/bin/sh
#
#===============================================================================
#
#           FILE:   runtests.sh
#
#          USAGE:   runtests.sh [-v|--verbose]
#
#    DESCRIPTION:   Runs GHDL compilation and simulation procedures for preset
#                    VHDL source files and opens GtkWave for inspection of the
#                    generated results.
#                   Stores recorded signals in 'testbench.vcd', overriding any
#                    previously existing file with that name upon execution.
#
#         AUTHOR:   Immanuel Dick (immanuel.dick@tu-dortmund.de)
#        COMPANY:   TU Dortmund, Dortmund
#        VERSION:   1.3
#        CREATED:   2022/06/08 13:45:30
#       REVISION:   2022/07/16 21:45:00
# 
#===============================================================================

# Expects VHDL-files (*.vhdl) from anywhere within specified source directory.
#  Listed files descend the dependency tree in given order.
SRCS=("randomForest" "majorityVote" "decisionTree" "node" "comparator_n_bit" "comparator_1_bit" "decisionTreeMemory")

# Sources root directory
SRCSDIR="src/vhdl"

# Working directory; specifies where testbench and compile output will be put.
WORKDIR="out"



#-------------------------------------------------------------------------------
# Runs GHDL command with given arguments and appends result to the print stream.
#
#  $1 - GHDL command arguments for execution
#  $2 - Pass '1' to print command output (e.g. errors); defaults to '0'
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
    if [ ! -z "$output" ] && [ $2 -eq 1 ]
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

# Handle verbosity script argument.
if [[ $# -gt 0 ]] && ([[ "$1" == "-v" ]] || [[ "$1" == "--verbose" ]])
then
    verbose=1
else
    verbose=0
fi

# Run syntax check and analysis on all files.
printf "\n"
printf "  ===========================\n"
printf "  == Building VHDL sources ==\n"
printf "  ===========================\n"
printf "\n"

for (( i = ${#SRCS[@]} - 1; i >= 0; --i ))
do
    # Print current file
    printf "\n"
    printf "File \"$SRCSDIR/${SRCS[$i]}.vhdl\"\n"
    
    # These contain arguments to GHDL
    files="$SRCSDIR/${SRCS[$i]}.vhdl"
    testbenchPath="$SRCSDIR/testbench/${SRCS[$i]}_tb.vhdl"

    # Gather dependencies
    for (( j = i + 1; j < ${#SRCS[@]}; j++ ))
    do
        files="$files $SRCSDIR/${SRCS[$j]}.vhdl"
    done
    
    # Clear the testbench path if the file does not exist
    if [[ ! -f "$testbenchPath" ]]
    then
        testbenchPath=""
    fi
    
    # Syntax check
    printf "  Syntax check.. "
    runGHDL "-s --workdir=$WORKDIR --std=08 $files $testbenchPath" $verbose
    
    # Analysis
    printf "  Analysis..     "
    runGHDL "-a --workdir=$WORKDIR --std=08 $files $testbenchPath" $verbose
    
    # Build
    printf "  Building..     "
    if [[ -z "$testbenchPath" ]]
    then
        printf "SKIPPED (No testbench)\n"
    else
        runGHDL "-e --workdir=$WORKDIR --std=08 -o $WORKDIR/${SRCS[i]}_tb ${SRCS[i]}_tb" $verbose
    fi
    
    # Dump VCD testbench
    printf "  Dumping VCD..  "
    if [[ -z "$testbenchPath" ]]
    then
        printf "SKIPPED (No testbench)\n"
    else
        cd "$WORKDIR"
        runGHDL "-r --workdir=. --std=08 ${SRCS[i]}_tb --vcd=${SRCS[i]}.vcd" $verbose
        cd ".."
    fi
    
done

printf "\n"
printf "  ====================\n"
printf "  == BUILD COMPLETE ==\n"
printf "  ====================\n"
printf "\n"

# Hint at optional extra output in case of warnings and errors
if [[ $verbose -eq 0 ]]
then
    printf "To get extra debug output from steps with WARNING and ERROR status, run this script again as\n"
    printf "\n"
    printf "  \$ $BASH_SOURCE --verbose\n"
    printf "\n"
fi

# Suggest testbench execution in GTKWave
printf "View testbenches in GTKWave by running e.g.\n"
printf "\n"
printf "  \$ gtkwave \"$WORKDIR/${SRCS[0]}.vcd\"\n"
printf "\n"
