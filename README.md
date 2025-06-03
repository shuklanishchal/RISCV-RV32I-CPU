# RISC-V Multi-Cycle RV32I CPU

This is my implementation of a RISC-V Multi-Cycle RV32I CPU. This version is complete with the ability to compile C code onto the CPU and have waveform simulations and testbench code for each module.

The code for the CPU is written entirely in SystemVerilog, with the code for compiling written in a mixture of C and RISC-V Assembly.

## Prerequisites
- Icarus Verilog
    - Windows/Linux: Follow the steps in the README [here](https://github.com/steveicarus/iverilog).
    - Mac: Open Terminal and run `brew install icarus-verilog`.
- RISC-V GNU Toolchain
    - Windows/Linux: Follow the steps in the README [here](https://github.com/riscv-collab/riscv-gnu-toolchain). **Make sure to follow instructions for Linux (Newlib/Multilib).**
    - Mac: Follow the steps in the README [here](https://github.com/riscv-software-src/homebrew-riscv).

## Usage

### First Use

1. Clone this repository.
2. Add the file path to the binaries of the RISC-V GNU Toolchain to the `RISCV_FILEPATH` variable in the Makefile (line 2).
3. Add the file path to the C library for RISC-V RV32I to the `RISCV_C_LIB` variable in the Makefile (line 4).
4. `cd` to the repository in the command line.
5. Run `make`.

This CPU was designed to let the user know exactly how instructions are being executed. This is why after running `make`, you will find the object dump for the compiled files and what the CPU is doing on each program counter and instruction.

### Testing

Every module in this repository that is used for the CPU has a testbench. If you want to make changes to any module and/or its testbench and test them, run `make` for the appropriate module to compile the testbench results.

For example, if you were to make a change to `data_mem.sv` found in the `memory` folder, run `make data_mem` to compile the changes and run the appropriate testbench.

## How It Works

When `make` is run from the command line, this is how everything runs on the CPU:

1. `test.c` from the `c_code` folder and `start.s` from the `util` folder compile together, putting `start.s` above `test.c` with help from a linker script (`ld.script` from the `util` folder). The compiler from the RISC-V GNU Toolchain is used for this.
2. The executable from Step 1 is then used to create a temporary binary file (`test.bin`), which is then converted into a hexadecimal file (`code.hex`) with the help of `dumphex.c` from the `util` folder. This is used to convert the code from C to hexadecimal RISC-V RV32I instructions.
3. This code is then read in by `inst_mem.sv` in the `memory` folder and stored in the instruction memory module in multiples of 4.
4. Each instruction is fed through the multi-cycle CPU as such:
    - The instruction is fetched in multiples of 4 from the instruction memory.
    - The instruction is then decoded using `inst_decoder.sv` and `alu_decoder.sv` from the `decoders` folder. `inst_decoder` decodes the instruction into values such as its opcode, funct3, funct7, immediate, etc. `alu_decoder` decodes which operation in the ALU will be run (if any).
    - The instruction is then executed. If the ALU needs to be used, the ALU is executed in this stage.
    - Any reading and writing to the data memory is handled next by interfacing with `data_mem.sv` from the `memory` folder.
    - The result from the ALU and/or the memory operation is then written back to registers if needed.
5. This continues until the `ebreak` instruction is executed, at which point the CPU terminates.

## Additional Notes

- This project is still under development, with some key features still missing. I plan on implementing pipelining and branch prediction to this CPU soon!
- One of the main goals for this project was to implement all ALU operations using purely gate-level logic. Be sure to check out the `alu_ops` folder to see the gate-level logic!
