cd C:\
if ( Test-Path -Path 'C:\openJava\' -PathType Container ) { 
    "C:\openJava\ already exists"
}
else {
    "Making directory: C:\openJava\"
    mkdir openJava
}

"Entering directory: C:\openJava\"
cd C:\openJava\

if ( Test-Path -Path 'C:\openJava\openjdk-15.0.1_windows-x64_bin.zip' -PathType Leaf ) { 
    "Java openJDK already downloaded"
}
else {
    "Java openJDK downloading..."
    curl https://download.java.net/java/GA/jdk15.0.1/51f4f36ad4ef43e39d0dfdbaf6549e32/9/GPL/openjdk-15.0.1_windows-x64_bin.zip -o openjdk-15.0.1_windows-x64_bin.zip
    "Java openJDK downloaded"
}


if ( Test-Path -Path 'C:\openJava\javafx.zip' -PathType Leaf ) { 
    "JavaFX already downloaded"
}
else {
    "JavaFX downloading..."
    curl https://gluonhq.com/download/javafx-16-sdk-windows/ -o javafx.zip
    "JavaFX downloaded"
}

if ( Test-Path -Path 'C:\openJava\openjdk-15.0.1_windows-x64_bin\' -PathType Container ) { 
    "Java openJDK already extracted"
}
else {
    "Java openJDK extracting..."
    Expand-Archive -LiteralPath C:\openJava\openjdk-15.0.1_windows-x64_bin.zip
    "Java openJDK extracted"
}

if ( Test-Path -Path 'C:\openJava\javafx\' -PathType Container ) { 
    "JavaFX already extracted"
}
else {
    "JavaFX extracting..."
    Expand-Archive -LiteralPath C:\openJava\javafx.zip
    "JavaFX extracted"
}

cd C:\
if ( Test-Path -Path 'C:\simFPGA\' -PathType Container ) { 
    "C:\simFPGA\ already exists"
}
else {
    "Making directory: C:\simFPGA\"
    mkdir simFPGA
}

"Entering directory: C:\simFPGA\"
cd C:\simFPGA\

if ( Test-Path -Path 'C:\simFPGA\simConsoleFPGA.zip' -PathType Leaf ) { 
    "simConsoleFPGA.zip already downloaded"
}
else {
    "simConsoleFPGA downloading..."
    curl https://github.com/intel/FPGA-Devcloud/raw/master/main/HandsFree/Simulator/DESim/SimConsoleFPGA.zip -o simConsoleFPGA.zip
    "simConsoleFPGA downloaded"
}

if ( Test-Path -Path 'C:\simFPGA\simConsoleFPGA\' -PathType Container ) { 
    "simConsoleFPGA already extracted"
}
else {
    "simConsoleFPGA extracting..."
    Expand-Archive -LiteralPath C:\simFPGA\simConsoleFPGA.zip
    "simConsoleFPGA extracted"
}


$JavaPathAdded = "False"
$ModelsimPathAdded = "False"
$Environment = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
 
$AddPathItems = ";C:\openJava\openjdk-15.0.1_windows-x64_bin\jdk-15.0.1\bin\;C:\intelFPGA_lite\20.1\modelsim_ase\win32aloem\;"



foreach ($path in ($Environment).Split(";")){

    if ($path -ceq 'C:\openJava\openjdk-15.0.1_windows-x64_bin\jdk-15.0.1\bin\'){
        $JavaPathAdded = "True"
    }
    if ($path -ceq 'C:\intelFPGA_lite\20.1\modelsim_ase\win32aloem\'){
        $ModelsimPathAdded = "True"
    }
}



if ($JavaPathAdded -eq "False") {
    $Environment = $Environment.Insert($Environment.Length,";C:\openJava\openjdk-15.0.1_windows-x64_bin\jdk-15.0.1\bin\")
    "Adding path variable C:\openJava\openjdk-15.0.1_windows-x64_bin\jdk-15.0.1\bin\"
} else {
    "Path variable C:\openJava\openjdk-15.0.1_windows-x64_bin\jdk-15.0.1\bin\ exists"
}

if ($ModelsimPathAdded -eq "False") {
    $Environment = $Environment.Insert($Environment.Length,";C:\intelFPGA_lite\20.1\modelsim_ase\win32aloem\")
    "Adding path variable C:\intelFPGA_lite\20.1\modelsim_ase\win32aloem\"
} else {
    "Path variable C:\intelFPGA_lite\20.1\modelsim_ase\win32aloem\ exists"
}


if ($JavaPathAdded -eq "False"){
#Set Updated Path
    [System.Environment]::SetEnvironmentVariable("Path", $Environment, "Machine")
} elseif ($ModelsimPathAdded -eq "False")
{
#Set Updated Path
    [System.Environment]::SetEnvironmentVariable("Path", $Environment, "Machine")
}

C:\openJava\openjdk-15.0.1_windows-x64_bin\jdk-15.0.1\bin\java --module-path "C:\openJava\javafx\javafx-sdk-16\lib" --add-modules=javafx.swing,javafx.graphics,javafx.fxml,javafx.media,javafx.web --add-reads javafx.graphics=ALL-UNNAMED --add-opens javafx.graphics/com.sun.javafx.scene.input=ALL-UNNAMED --add-opens javafx.controls/com.sun.javafx.charts=ALL-UNNAMED --add-opens javafx.graphics/com.sun.javafx.iio=ALL-UNNAMED --add-opens javafx.graphics/com.sun.javafx.iio.common=ALL-UNNAMED --add-opens javafx.graphics/com.sun.javafx.css=ALL-UNNAMED --add-opens javafx.base/com.sun.javafx.runtime=ALL-UNNAMED --add-opens javafx.graphics/com.sun.glass.ui=ALL-UNNAMED --add-opens javafx.graphics/com.sun.javafx.tk=ALL-UNNAMED -jar C:\simFPGA\simConsoleFPGA\SimConsoleFPGA\DESim\Simulator.jar