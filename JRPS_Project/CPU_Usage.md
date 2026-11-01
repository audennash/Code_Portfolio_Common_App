#CPU Usage

## CPU Architecture Overview
CPU v1 and v2 use the instruction set given in ISA.csv. They use 32-bit operands, have a 32-bit address space, and have 32 registers. They connect to a main memory, which in turn can interface with the user. In each case, the CPU module is named `cpu`.

## CPU Interface
CPU v1 and v2 have subtly different interfaces due to the dynamic scheduling capabilities of the latter.

**Inputs shared by CPU v1 and CPU v2:**
- `cpu_run`: when asserted, tells the CPU to attempt to execute instructions and increase its program counter
- `cpu_reset`: when asserted, tells the CPU to flush all its registers and revert back to its default state
- `clk`: provides the CPU with an oscillating clock to keep track of time
- `mem_out` (*32 bits*): feeds the output of main memory into the CPU

**Outputs shared by CPU v1 and CPU v2:**
- `cpu_data` (*32 bits*): contains the data that main memory should write at cpu_addr, provided cpu_write is asserted
- `cpu_addr` (*32 bits*): tells main memory which address to access
- `cpu_write` (*32 bits*): if asserted, signifies to main memory that cpu_addr should be overwritten
- `halted:` signifies to the user that a HALT instruction has been reached (i.e., a program has terminated)

**Inputs, outputs, and parameters unique to CPU v2:**
- `mem_done` (*input*): tells the CPU that its request to main memory has completed (if asserted, this should be deasserted after one cycle)
- `cpu_req` (*output*): tells main memory that the CPU is accessing it (this output may be optional depending on the memory configuration)
- `first_port` (*parameter*): tells the CPU's memory control system which memory addresses are the input and output ports; by default, `first_port=252`
   - `first_port` and `first_port+1` are the input port addresses, and `first_port+2` and `first_port+3` are the output port addresses
   - these ports are controlled by the external memory system; this parameter is only used for cache coherency

## CPU Instructions
Instructions should be stored in the CPU's main memory, and should not be manually overwritten while the CPU is running. Unless the program counter is explicitly modified by a control instruction (`JUMP`, `BRZ`, or `BRNZ`), it will increase by 1 every time an instruction is issued.

ISA.csv gives one row to each operation, with every column corresponding to a parameter for that instruction. Each column specifies what that parameter does and which bits of the instruction it occupies. Most fields are self-explanatory, but a few clarifications about the spreadsheet are in order:
- If referenced, "operand 1" is by default the value of source register 1, and "operand 2" is the value of source register 2
- If parameter 5 is denoted "Swap SR1<->I.", then when asserted, operand 1 of the instruction will be the immediate, instead of source register 1
- If parameter 4 is denoted "Signed?", when asserted, the associated functional unit will perform a signed operation using 32-bit two's complement
- If parameter 4 is denoted "Arithmetic?", when asserted, an arithmetic (instead of logical) right shift will occur, wherein previously unoccupied bits will be filled with the MSB of operand 1

# Testbenches
Each CPU folder has a `CPU_Testbenches` subfolder, and other subfolders may have testbenches for other modules. With the exception of any testbench whose name contains "hello_world" or "exp" (which are their own programs) all testbenches are for debugging purposes. For some testbench `testbench.sv`, it can be run by running module `top_module_testbench`.
