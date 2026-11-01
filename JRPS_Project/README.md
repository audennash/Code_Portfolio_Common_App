This was my final project for my school's Junior Research Project Seminar (JRPS), in which I learned SystemVerilog and designed a dynamically scheduled processor.
For information about programming and using the CPUs, please consult CPU_Usage.md.
# Components
1. **Basic Modules:** I was introduced to logic design through Nand2Tetris (in which you build all chips and functionalities from NAND gates), so to improve at SystemVerilog, I implemented most of its basic functionalities (like basic gates, memory units, and arithmetic chips) from NANDs and DFFs.
2. **CPU v1:** This was the first iteration of my processor. It features an instruction cache, unified data/instruction memory, and distinct functional units instead of a unified ALU -- which made implementing dynamic scheduling in CPU v2 much easier -- but otherwise functions like a typical non-pipelined processor.
3. **CPU v2:** This was the second iteration of my processor. It has separate data and instruction caches, and is dynamically scheduled through a scoreboard.
