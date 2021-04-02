#!/usr/bin/tclsh
#^ Probably not needed with Modelsim
set RUN_SIM 1
set SERVER_OPEN 0
set ADD_WAVES 0
set QUIT_ON_FINISH 1
set RUN_SPEED 10ns

set src_files(0) ../hello.v
set src_files(1) ../tb.v
set top_level_entity tb 


# Use this to grab line from stdin (nonblocking)
proc grab_line {message} {
    puts -nonewline $message
    flush stdout
    fconfigure stdin -blocking 0 -buffering line
    gets stdin in_string
    return $in_string
}

# Connect to the GUI server 
proc gui_client {host port} {
    set s [socket -async $host $port]
    global SERVER_OPEN
    set SERVER_OPEN 1
    fconfigure $s -blocking 0 -buffering line
    return $s
}

# Stop simulating
proc end_simulation {server} {
    close $server
    global RUN_SIM
    global SERVER_OPEN
    set RUN_SIM 0
    set SERVER_OPEN 0
}

# Send a message to the server
proc send_message {message server} {
    puts $server $message
}

# TODO: GPIO bus
proc initialise_fpga {} {
    for {set i 0} {$i < 10} {incr i} {
        force SW($i) "0"
    }

    for {set i 0} {$i < 4} {incr i} {
        force KEY($i) "1"
    }
}
# Handle the signals - TODO: Finish all the signals, namely GPIO 
proc signal_parse {in_string server} {

    puts $in_string
    set chr [string index $in_string 0 ]
    switch $chr {
        K {
            force KEY([string index $in_string 4]) [string index $in_string 6]
        }

        S { 
            force SW([string index $in_string 3]) [string index $in_string 5]
        }

        G {
            #force SW([string index $in_string 3]) [string index $in_string 5]
        }

        e {
            end_simulation $server
        }
    }

}
# Open a connection to the server
set s [gui_client localhost 54321]

# Compile and start sim
vlib work
for { set index 0 }  { $index < [array size src_files] }  { incr index } {
   vlog $src_files($index)
}
vsim $top_level_entity

if {$ADD_WAVES == 1} {
    add wave *
}

# Initialise I/O
set leds_prev [examine LED]
set hex_prev [examine -radix hex HEX]

set leds_current [examine LED]
set hex_current [examine -radix hex HEX]
set x_current [examine -radix hex x]
set y_current [examine -radix hex y]
set colour_current [examine -radix hex colour]
set plot_current [examine plot]
set vga_current [examine vga_resetn]

initialise_fpga

while {$RUN_SIM==1} {

    # Read the outputs from the testbench
    set leds_prev $leds_current
    set leds_current [examine LED]
    set hex_prev $hex_current
    set hex_current [examine -radix hex HEX]

    # Pixels must be sent in this format otherwise GUI closes the connection
    set x_current [format %03s [examine -radix unsigned x]]
    set y_current [format %03s [examine -radix unsigned y]]
    set colour_current [format %01s [examine -radix unsigned colour]]
    set pixel "$x_current $y_current $colour_current" 

    set plot_current [examine plot]
    

    # TODO: Get GPIO ports working

    
    #after 500 


    if {$SERVER_OPEN == 1} {

        gets $s line
        if {$line != ""} {
            #puts $line
            signal_parse $line $s
        }
    }

    if {$SERVER_OPEN == 1} {
        # Check to see if values have changed
        
        if [ expr [string compare $leds_current $leds_prev] != 0] {
            send_message "l$leds_current" $s
        }

        if [ expr [string compare $hex_current $hex_prev] != 0] {
            send_message "h$hex_current" $s
        }

        # If pixel is valid and plotting is on send a pixel
        if {$plot_current=="St1" && [ string first "x" $pixel ]==-1 && [ string first "z" $pixel ]==-1  && [ string first "Z" $pixel ]==-1} {
            send_message "c $pixel" $s
        }   
        set str [grab_line ""]
        if [expr [string compare $str ""] != 0] {
            puts $str
            end_simulation $s
        }
    }
   
    # This must match the clock period for the VGA to work correctly, otherwise just make faster
    #run 10ns
    run $RUN_SPEED
}

if {$QUIT_ON_FINISH==1} {
    quit -f
}
