# Insert the file path to your RISC-V GNU toolchain executables below (found in the bin folder)
RISCV_FILEPATH=/usr/local/opt/riscv-gnu-toolchain/bin/riscv64-unknown-elf
# Insert the file path to your RISC-V rv32i C Library (libc.a) below (should be installed with the RISC-V GNU toolchain)
RISCV_C_LIB=/usr/local/opt/riscv-gnu-toolchain/riscv64-unknown-elf/lib/rv32i/ilp32

RISCV_FLAGS=-march=rv32i -mabi=ilp32 # Flags to compile code into RISC-V rv32i (integers, longs, pointers all 32 bit)
IVERILOG=iverilog -g2012 -o # Icarus Verilog command to compile SystemVerilog code

all: cpu

# Run the CPU
cpu: compiler
	$(IVERILOG) cpu_core  run_cpu.sv cpu_core.sv alu_ops/*.sv decoders/*.sv memory/*.sv
	vvp cpu_core
	rm cpu_core
	rm memory/code.hex

# Generate the .hex file that SystemVerilog uses to load the instruction memory
compiler:
	gcc -o dumphex util/dumphex.c
	$(RISCV_FILEPATH)-as $(RISCV_FLAGS) -c util/start.s -o start.o
	$(RISCV_FILEPATH)-gcc $(RISCV_FLAGS) -I $(RISCV_C_LIB) -c c_code/test.c -o test.o
	$(RISCV_FILEPATH)-gcc $(RISCV_FLAGS) -T util/ld.script -o test start.o test.o
	$(RISCV_FILEPATH)-objcopy -O binary test test.bin
	./dumphex -i test.bin -o code.hex
	mv code.hex memory
	rm test.bin
	rm start.o
	rm test.o
	rm dumphex
	$(RISCV_FILEPATH)-objdump -d test
	rm test

# Compile the testbench for the adders, outputs VCD files to testbench_vcd folder
adders:
	$(IVERILOG) adder_bit32 testbench_sv/adder_bit32_testbench.sv alu_ops/adder_bit32.sv alu_ops/adder.sv
	$(IVERILOG) adder testbench_sv/adder_testbench.sv alu_ops/adder.sv
	vvp adder_bit32
	vvp adder
	rm adder_bit32
	rm adder

# Compile the testbench for the barrel shifter, outputs VCD files to testbench_vcd folder
shifter:
	$(IVERILOG) barrel_shifter testbench_sv/barrel_shifter_testbench.sv alu_ops/barrel_shifter.sv
	vvp barrel_shifter
	rm barrel_shifter

# Compile the testbench for the comparators, outputs VCD files to testbench_vcd folder
comparator:
	$(IVERILOG) comparator_4bit testbench_sv/comparator_4bit_testbench.sv alu_ops/comparator_4bit.sv alu_ops/and3.sv alu_ops/and4.sv alu_ops/or4.sv
	vvp comparator_4bit
	$(IVERILOG) comparator_32bit testbench_sv/comparator_32bit_testbench.sv alu_ops/comparator_32bit.sv alu_ops/comparator_4bit.sv alu_ops/and3.sv alu_ops/and4.sv alu_ops/or4.sv
	vvp comparator_32bit
	rm comparator_4bit
	rm comparator_32bit

# Compile the testbench for the ALU, outputs VCD files to testbench_vcd folder
alu:
	$(IVERILOG) alu testbench_sv/alu_testbench.sv alu_ops/*.sv
	vvp alu
	rm alu

# Compile the testbench for the data memory, outputs VCD files to testbench_vcd folder
data_mem:
	$(IVERILOG) data_mem testbench_sv/data_mem_testbench.sv memory/data_mem.sv
	vvp data_mem
	rm data_mem

# Test the instruction memory loader
inst_mem: tester
	$(IVERILOG) inst_mem testbench_sv/inst_mem_testbench.sv memory/inst_mem.sv
	vvp inst_mem
	rm inst_mem

# Test the instruction decoder
inst_decoder:
	$(IVERILOG) inst_decoder testbench_sv/inst_decoder_testbench.sv decoders/inst_decoder.sv
	vvp inst_decoder
	rm inst_decoder

clean:
	rm -r testbench_vcd
	mkdir testbench_vcd