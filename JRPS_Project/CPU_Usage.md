# CPU Architecture Overview
CPU v1 and v2 use the instruction set given in ISA.csv. They use 32-bit operands, have a 32-bit address space, and have 32 registers. They connect to a main memory, which in turn can interface with the user.

# CPU Interface
CPU v1 and v2 have subtly different interfaces due to the dynamic scheduling capabilities of the latter.
**Inputs shared by CPU v1 and CPU v2:**
- **cpu_run:** when asserted, tells the CPU to attempt to execute instructions and increase its program counter
- **cpu_reset:** when asserted, tells the CPU to flush all its registers and revert back to its default state
- **clk:** provides the CPU with an oscillating clock to keep track of time
- **mem_out (32 bits):** feeds the output of main memory into the CPU

**Outputs shared by CPU v1 and CPU v2:**
- **cpu_data (32 bits):** contains the data that main memory should write at cpu_addr, provided cpu_write is asserted
- **cpu_addr (32 bits):** tells main memory which address to access
- **cpu_write (32 bits):** if asserted, signifies to main memory that cpu_addr should be overwritten
- **halted:** signifies to the user that a HALT instruction has been reached (i.e., a program has terminated)

**Inputs and outputs unique to CPU v2:**
- **mem_done (input):** tells the CPU that its request to main memory has completed (if asserted, this should be deasserted after one cycle)
- **cpu_req (output):** tells main memory that the CPU is accessing it (this output may be optional depending on the memory configuration)

# CPU Instructions

   
