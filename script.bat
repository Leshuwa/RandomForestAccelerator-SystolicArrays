@echo off
for %%x in (%*) do (
	ghdl -s --std=08 %%x.vhd
	if errorlevel 1 (
	echo Syntax-check Failed
	exit 1 )
	echo Syntax-check OK
	ghdl -a --std=08 %%x.vhd
	if errorlevel 1 (
	echo Analysis Failed
	exit 1)
	echo Analysis OK
	ghdl -e --std=08 %%x
	if errorlevel 1 (
	echo Build Failed
	exit 1)
	echo Build OK
	ghdl -r --std=08 %%x --vcd=testbench.vcd
	if errorlevel 1 (
	echo VCD-Dump Failed
	exit 1)
	echo VCD-Dump OK
	gtkwave testbench.vcd
	if errorlevel 1 (
	echo Starting GTKWave Failed
	exit 1 )
	echo Starting GTKWave
)