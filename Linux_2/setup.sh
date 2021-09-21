#!/bin/bash -x


# Setup install directories - Feel free to change
export INSTALL_DIRECTORY=(~/fpga_gui)
export JAVA_DIRECTORY=($INSTALL_DIRECTORY/openJava)
export SIMULATOR_DIRECTORY=($INSTALL_DIRECTORY/DESim)
export DESIM_GITHUB=(https://github.com/fpgacademy/DESim)


# Find the Modelsim Install directory
MODELSIM_INSTALL_PATH=`which vsim`
MODELSIM_PATH=`find $MODELSIM_INSTALL_PATH -name vsim  -exec dirname {} \; | grep bin`
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
    mkdir $INSTALL_DIRECTORY
fi


if [ -d $JAVA_DIRECTORY ]
then
    echo "$JAVA_DIRECTORY exists"
else
    echo "$JAVA_DIRECTORY does not exist: creating..."
    mkdir $JAVA_DIRECTORY
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

if [ -d $SIMULATOR_DIRECTORY ]
then
    echo "$SIMULATOR_DIRECTORY exists"
else
    echo "$SIMULATOR_DIRECTORY does not exist: creating..."
    `git clone $DESIM_GITHUB $SIMULATOR_DIRECTORY`
fi


if [ -f Makefile ]
then
    echo "Makefile for linux exists"
else
    touch Makefile
    echo "MODELSIM_DIR =$MODELSIM_PATH/.." >> Makefile
    cat Makefile_base >> Makefile
fi

`\cp -f Makefile $SIMULATOR_DIRECTORY/backend/`
`\cp -f $MODELSIM_PATH/../include/vpi_compatibility.h $SIMULATOR_DIRECTORY/backend/include/`
`\cp -f $MODELSIM_PATH/../include/vpi_user.h $SIMULATOR_DIRECTORY/backend/include/`
`\cp -f fpga_inout_device.h $SIMULATOR_DIRECTORY/backend/include/`
`\cp -f fpga_output_device.h $SIMULATOR_DIRECTORY/backend/include/`

cd $SIMULATOR_DIRECTORY/backend/
mkdir dist
make clean
echo "Cleaned"
make all
make update_demos

cd ~/workspace/FPGA_Simulation_GUI-/Linux_2
