README

Tested working for Windows 10
Requires Quartus Lite 20.1 
Must have installed Quartus Lite + Modelsim to "C:/intelFPGA_lite/20.1"

Setting up:
1) Right click "setup_script.ps1"
2) Click "Run with PowerShell" - First time running will take a while (downloads necessary files)
2.5) If the script stalls, press the down arrow key in powershell - it should keep printing to screen
3) If working correctly the GUI should have started

Running a default application:
1) Go to "C:\simFPGA\simConsoleFPGA\SimConsoleFPGA\demo\hello_demo\sim"
2) Double click "demo.bat"
3) Simulation should start running in GUI

Making a new application:
1) Make a copy of "C:\simFPGA\simConsoleFPGA\SimConsoleFPGA\demo\hello_demo\" to anywhere you would like
2) Use the hello.v in the new "hello_demo" folder as a template for you code - don't change the top level inputs and outputs
3) Add any extra modules/files to the "hello_demo" folder
4) In "hello_demo\sim" edit the demo.bat file. The verilog files need to be compiled, so use the "vlog ../<filename.v>" command. Add files as a bottom up approach.
5) Follow the setting up steps and the running a default application steps to run.
