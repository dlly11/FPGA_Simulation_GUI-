README

Tested working for Ubuntu 20.10 
Must have installed Quartus Lite + Modelsim and have added the Modelsim bin directory to the systems path variable 
See https://www.computerhope.com/issues/ch001647.htm

Also, if Modelsim fails to run, you may need extra libaries:
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 lib32ncurses5 libxft2 libxft2:i386 lib32ncurses5 libxext6 libxext6:i386


Setting up:
1) Open a terminal in this directory
2) Type bash setup_linux.sh - The first time this script runs it will download the necessary java libraries
3) If working correctly the GUI should have started

Running a default application:
1) Go to ~/fpga_gui/simFPGA/SimConsoleFPGA/demo/led_demo/sim/
2) Open a terminal
3) Type vsim -c -do linux_run_script.tcl

Making a new application:
1) Make a copy of "~\fpga_gui\simFPGA\SimConsoleFPGA\demo\led_demo\hello_demo\" to anywhere you would like
2) Use the hello.v in the new "hello_demo" folder as a template for you code - don't change the top level inputs and outputs
3) Add any extra modules/files to the "hello_demo" folder
4) In "hello_demo\sim" edit the linux_run_script.bat file. The verilog files need to be compiled. Near the top of the file there is a spot to add more files. (Use a bottom up approach)
5) Follow the setting up steps and the running a default application steps to run.
