`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Joshua Horwitz
// 3/18/2015 
//
//////////////////////////////////////////////////////////////////////////////////

module dmem #(
   parameter Abits = 32,          // Number of bits in address
   parameter Dbits = 32,         // Number of bits in data
   parameter Nloc = 32,           // Number of memory locations
   parameter dmem_init = "dmem.txt"
)(
   input clock,
   input mem_wr,
   input [Abits-1:0] mem_addr,
   input [Dbits-1:0] mem_writedata,
   output [Dbits-1:0] mem_readdata
   );
   
   
   reg [Dbits-1:0] mem [Nloc-1:0];                                      // The actual registers where data is stored
   initial $readmemh(dmem_init, mem, 0, Nloc-1);        // Data to initialize registers

   always_ff @(posedge clock)                               // Memory write: only when wr==1, and only at posedge clock
         mem[mem_addr[4:0]] <= (mem_wr) ?  mem_writedata : mem[mem_addr[4:0]];
   
   assign mem_readdata = mem[mem_addr[4:0]];                              
   
endmodule