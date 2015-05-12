`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Joshua Horwitz
// Create Date: 04/08/2015 09:38:46 PM
// 
//////////////////////////////////////////////////////////////////////////////////


module screenmemory #(
    parameter Abits = 11,          // Number of bits in address
    parameter Dbits = 4,         // Number of bits in data
    parameter Nloc = 1200,
    parameter mem_init
)(
    input [Abits-1:0] screen_addr,
    input [31:0] mips_addr, mem_writedata,
    input mem_wr, clock,
    output [Dbits-1:0] character_code,
    output [31:0] to_mips_character_code
    );
    
    always_ff @(posedge clock)                               // Memory write: only when wr==1, and only at posedge clock
          if(mem_wr)
             mem[mips_addr[10:0]] <= mem_writedata[3:0];
    
    reg [Dbits-1:0] mem [Nloc-1:0];                                      // The actual registers where data is stored
    initial $readmemh(mem_init, mem, 0, Nloc-1);
    
    assign to_mips_character_code = {28'b0, mem[mips_addr[10:0]]};
    assign character_code = mem[screen_addr];
endmodule
