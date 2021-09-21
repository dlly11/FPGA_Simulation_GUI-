MODELSIM_DIR =/opt/intelFPGA/20.1/modelsim_ase/bin/..
 
# Copyright (c) 2020 FPGAcademy
# Please see license at https://github.com/fpgacademy/DESim



ifeq ($(OS),Windows_NT)
	MODELSIM_DIR = C:\intelFPGA\19.1\modelsim_ae
endif

CFLAGS = -m32 -c -Wall -g -fno-diagnostics-show-caret -fpic -Iinclude -I$(MODELSIM_DIR)/include
LDFLAGS = -m32 -g -shared -lmtipli

ifeq ($(OS),Windows_NT)
	CFLAGS += -static
	LDFLAGS +=  -static -lws2_32
	LDFLAGS += -L$(MODELSIM_DIR)/win32aloem
else
	LDFLAGS += -L$(MODELSIM_DIR)/linuxaloem
endif

all: dist/simfpga.vpi

utils.o: utils.c include/utils.h
	gcc utils.c $(CFLAGS)

fpga_output_device.o: fpga_output_device.cpp include/fpga_output_device.h
	g++ fpga_output_device.cpp $(CFLAGS)

fpga_input_device.o: fpga_input_device.cpp include/fpga_input_device.h
	g++ fpga_input_device.cpp $(CFLAGS)

fpga_inout_device.o: fpga_inout_device.cpp include/fpga_inout_device.h
	g++ fpga_inout_device.cpp $(CFLAGS)

keyboard_input.o: keyboard_input.cpp include/keyboard_input.h
	g++ keyboard_input.cpp $(CFLAGS)

fpga.o: fpga.cpp include/fpga*.h include/keyboard_input.h include/utils.h include/helper.h
	g++ fpga.cpp $(CFLAGS)

sim_task.o: sim_task.cpp include/sim_task.h include/fpga.h include/utils.h include/helper.h
	g++ sim_task.cpp $(CFLAGS)

dist/simfpga.vpi: sim_task.o utils.o fpga.o fpga_output_device.o fpga_input_device.o keyboard_input.o fpga_inout_device.o
	g++ -o dist/simfpga.vpi fpga_inout_device.o keyboard_input.o fpga_input_device.o fpga_output_device.o fpga.o sim_task.o utils.o $(LDFLAGS)

update_demos: dist/simfpga.vpi
	cp dist/simfpga.vpi ../demos/accumulate/sim/.
	cp dist/simfpga.vpi ../demos/addern/sim/.
	cp dist/simfpga.vpi ../demos/counter/sim/.
	cp dist/simfpga.vpi ../demos/display/sim/.
	cp dist/simfpga.vpi ../demos/GPIO/gpio_bidir_demo/sim/.
	cp dist/simfpga.vpi ../demos/GPIO/gpio_in_demo/sim/.
	cp dist/simfpga.vpi ../demos/GPIO/gpio_out_demo/sim/.
	cp dist/simfpga.vpi ../demos/LED_HEX/sim/.
	cp dist/simfpga.vpi ../demos/ps2_demo/sim/.
	cp dist/simfpga.vpi ../demos/vga_demo/sim/.

clean:
	rm -rf *.o
	rm -rf dist/*.vpi

