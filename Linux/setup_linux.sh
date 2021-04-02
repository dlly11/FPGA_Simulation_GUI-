#!/bin/bash

# Setup install directories - Feel free to change
export INSTALL_DIRECTORY=(~/fpga_gui)
export JAVA_DIRECTORY=($INSTALL_DIRECTORY/openJava)
export SIMULATOR_DIRECTORY=($INSTALL_DIRECTORY/simFPGA)

MODELSIM_INSTALL_PATH=`which vsim`

if [ -z $MODELSIM_INSTALL_PATH ]; then
    echo "Modelsim directory is not in the system PATH"
    echo "Instructions: https://www.computerhope.com/issues/ch001647.htm"
    echo "Please add the modelsim bin directory"
    echo "To test open a terminal and type \"vsim\""
    echo "If the Modelsim GUI opens, then you can continue."
    exit 1
fi
echo "Modelsim install directory: $MODELSIM_INSTALL_PATH"



echo "GUI install directory: $INSTALL_DIRECTORY"

if [ -d $INSTALL_DIRECTORY ]
then
    echo "$INSTALL_DIRECTORY exists"
else
    echo "$INSTALL_DIRECTORY does not exist: creating..."
    `mkdir $INSTALL_DIRECTORY`
fi


if [ -d $JAVA_DIRECTORY ]
then
    echo "$JAVA_DIRECTORY exists"
else
    echo "$JAVA_DIRECTORY does not exist: creating..."
    `mkdir $JAVA_DIRECTORY`
fi

if [ -d $SIMULATOR_DIRECTORY ]
then
    echo "$SIMULATOR_DIRECTORY exists"
else
    echo "$SIMULATOR_DIRECTORY does not exist: creating..."
    `mkdir $SIMULATOR_DIRECTORY`
fi



if [ -f $SIMULATOR_DIRECTORY/SimConsoleFPGA.zip ]
then
    echo "SimConsoleFPGA.zip exists"
else
    echo "SimConsoleFPGA.zip does not exist: downloading..."
    `wget https://github.com/intel/FPGA-Devcloud/raw/master/main/HandsFree/Simulator/DESim/SimConsoleFPGA.zip -P $SIMULATOR_DIRECTORY/`
fi

if [ -d $SIMULATOR_DIRECTORY/SimConsoleFPGA ]
then
    echo "Directory SimConsoleFPGA exists"
else
    echo "Directory  SimConsoleFPGA does not exist: extracting..."
    `unzip $SIMULATOR_DIRECTORY/SimConsoleFPGA.zip -d $SIMULATOR_DIRECTORY`
fi


if [ -f $JAVA_DIRECTORY/openjdk-15.0.1_linux-x64_bin.tar.gz ]
then
    echo "openjdk-15.0.1_linux-x64_bin.tar.gz exists"
else
    echo "openjdk-15.0.1_linux-x64_bin.tar.gz does not exist: downloading..."
    `wget https://download.java.net/java/GA/jdk15.0.1/51f4f36ad4ef43e39d0dfdbaf6549e32/9/GPL/openjdk-15.0.1_linux-x64_bin.tar.gz -P $JAVA_DIRECTORY/`
fi

if [ -d $JAVA_DIRECTORY/jdk-15.0.1 ]
then
    echo "Directory jdk-15.0.1 exists"
else
    echo "Directory  jdk-15.0.1 does not exist: extracting..."
    `tar -xzf $JAVA_DIRECTORY/openjdk-15.0.1_linux-x64_bin.tar.gz -C $JAVA_DIRECTORY`
fi


if [ -f $JAVA_DIRECTORY/JavaFX.zip ]
then
    echo "JavaFX.zip exists"
else
    echo "JavaFX.zip does not exist: downloading..."
    `wget https://gluonhq.com/download/javafx-16-sdk-linux/ -O $JAVA_DIRECTORY/JavaFX.zip`
fi

if [ -d $JAVA_DIRECTORY/javafx-sdk-16 ]
then
    echo "Directory javafx-sdk-16 exists"
else
    echo "Directory  javafx-sdk-16 does not exist: extracting..."
    `unzip $JAVA_DIRECTORY/JavaFX.zip -d $JAVA_DIRECTORY`
fi

if [ -f $SIMULATOR_DIRECTORY/SimConsoleFPGA/demo/hello_demo/sim/linux_run_script.tcl ]
then
    echo ""
else
    `cp linux_run_script.tcl $SIMULATOR_DIRECTORY/SimConsoleFPGA/demo/hello_demo/sim/linux_run_script.tcl` 
fi    

if [ -f $SIMULATOR_DIRECTORY/SimConsoleFPGA/demo/led_demo/sim/linux_run_script.tcl ]
then
    echo ""
else
    `cp linux_run_script.tcl $SIMULATOR_DIRECTORY/SimConsoleFPGA/demo/led_demo/sim/linux_run_script.tcl` 
fi    

if [ -f $SIMULATOR_DIRECTORY/SimConsoleFPGA/demo/vga_demo/sim/linux_run_script.tcl ]
then
    echo ""
else
    `cp linux_run_script.tcl $SIMULATOR_DIRECTORY/SimConsoleFPGA/demo/vga_demo/sim/linux_run_script.tcl` 
fi    

`$JAVA_DIRECTORY/jdk-15.0.1/bin/java --module-path "$JAVA_DIRECTORY/javafx-sdk-16/lib" --add-modules=javafx.swing,javafx.graphics,javafx.fxml,javafx.media,javafx.web --add-reads javafx.graphics=ALL-UNNAMED --add-opens javafx.graphics/com.sun.javafx.scene.input=ALL-UNNAMED --add-opens javafx.controls/com.sun.javafx.charts=ALL-UNNAMED --add-opens javafx.graphics/com.sun.javafx.iio=ALL-UNNAMED --add-opens javafx.graphics/com.sun.javafx.iio.common=ALL-UNNAMED --add-opens javafx.graphics/com.sun.javafx.css=ALL-UNNAMED --add-opens javafx.base/com.sun.javafx.runtime=ALL-UNNAMED --add-opens javafx.graphics/com.sun.glass.ui=ALL-UNNAMED --add-opens javafx.graphics/com.sun.javafx.tk=ALL-UNNAMED -jar $SIMULATOR_DIRECTORY/SimConsoleFPGA/DESim/Simulator.jar`
