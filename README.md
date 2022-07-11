# RandomForestAccelerator

![Screenshot](https://github.com/SanadMarji7/RandomForestAccelerator/blob/main/Random%20Forest%20Structure.png?raw=true)


## Project Focus

* Review and simplify provided code base
* Create testbenches for all components
* Modify random forest testbench to support automatic tests
* Implement support for systolic arrays
* Demonstrate a sensible way to embed in an MIPS architecture


## Requirements

* Python
* GHDL
* GTKWave
* VHDL (Version 2008 or above)


## Compile and Run Tests

Execute `runtests.sh` in the project's root directory to compile all VHDL sources and to simulate their testbenches.

    $ ./runtests.sh

This automatically generates VCD files for each VHDL file and its associated testbench, including required dependencies.
You can then view testbenches in GTKWave using

    $ gtkwave "out/VHDL_FILE.vcd"

where `VHDL_FILE` corresponds to the name of either VHDL file in the project.


## References

1. Marji, S., Abbas, K., Kabaweh, M. B. E. -- Digital Design for Machine Learning  
   https://github.com/TUD-MLA/RandomForestAccelerator

2. SciKit-Learn -- Random Forest Classifier  
   https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.RandomForestClassifier.html

3. Mao, L. -- Quantization of Data  
   https://leimao.github.io/article/Neural-Networks-Quantization

4. Louppe, G. -- Understanding Random Forests  
   https://arxiv.org/pdf/1407.7502.pdf
  
5. Kulaga, R., Gorgon, M. -- FPGA Implementation of Decision Trees [...] in Vivado  
   https://www.researchgate.net/publication/276511609_FPGA_Implementation_of_Decision_Trees_and_Tree_Ensembles_for_Character_Recognition_in_Vivado_Hls

