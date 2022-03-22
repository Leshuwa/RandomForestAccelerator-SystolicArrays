# RandomForestAccelerator

![Screenshot](https://github.com/SanadMarji7/RandomForestAccelerator/blob/main/Random%20Forest%20Structure.png?raw=true)

## Requirements
* **PYTHON**
* **GHDL**
* **GTKWave**
* **VHDL**

## Quick Instruction

### cloning repository

      $ git clone https://github.com/SanadMarji7/RandomForestAccelerator.git 
      $ cd RandomForestAccelerator  

### compiling VHDL code and looking on wave diagrams in GTKWave

      $ ghdl -s test_file.vhdl                 #Syntax Check  
      $ ghdl -a test_file.vhdl                 #Analyse  
      $ ghdl -e test_file.vhdl                 #Build   
      $ ghdl -r test_file --vcd=testbench.vcd  #VCD-Dump  
      $ gtkwave testbench.vcd                  #Start GTKWave  

there are two options to compile and run the project. either use VIVADO IDE or compile and run on GTK WAVE. either ways you have to have
VHDL 2008-recent Version for the design to run.
   
### compiling the project
      to compile the files of the project run the following commands:
      $ ghdl -s --std=08 majorityVote.vhd
      $ ghdl -a --std=08 majorityVote.vhd
      $ ghdl -s --std=08 DT.vhd
      $ ghdl -a --std=08 DT.vhd
      $ ghdl -s --std=08 DT_memory.vhd
      $ ghdl -a --std=08 DT_memory.vhd
      $ ghdl -s --std=08 node.vhd
      $ ghdl -a --std=08 node.vhd
      $ ghdl -s --std=08 Random_Forest_accelerator.vhd
      $ ghdl -a --std=08 Random_Forest_accelerator.vhd
      $ ghdl -s --std=08 Comparator.vhdl
      $ ghdl -a --std=08 Comparator.vhdl
      
if you have vhdl version 08 or higher you dont need the extra "--std=08" to compile.

### After compiling all the files run the script using the following command:
      please note that script should be in same folder as the testbench.
      $ ./script RF_tb
      

also note that the "random-forest.txt" file should be in the same folder as all other vhdl files in order for it to run.

## References

1. scikit-learn for Random Forest Classifier 
   https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.RandomForestClassifier.html

2. Quantization of data  
   https://leimao.github.io/article/Neural-Networks-Quantization/

3. understanding Random Forests
   https://arxiv.org/pdf/1407.7502.pdf
  
4. different implementation of decision Trees on vivado
   https://www.researchgate.net/publication/276511609_FPGA_Implementation_of_Decision_Trees_and_Tree_Ensembles_for_Character_Recognition_in_Vivado_Hls

