`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Joshua Horwitz
// Create Date: 04/09/2015 07:21:01 PM
// 
//////////////////////////////////////////////////////////////////////////////////


module memIO #(
    parameter Abits = 32,
    parameter Dbits = 32,
    parameter Nloc = 32,
    parameter dmem_init = "dmem.txt",
    parameter screen_mem = "screentest_smem.txt"
)(
    input clk,
    input mem_wr,
    input [31:0] keyb_char,
    input [10:0] screen_addr,
    input [31:0] mem_addr,
    input [31:0] mem_writedata,
    output [31:0] to_mips,
    output [3:0] character_code
    );
    wire dmem_wr, smem_wr;
    wire [31:0] to_mips_character_code, mem_readdata;
    
    assign to_mips = (mem_addr[14:13] == 2'b11) ? keyb_char :
                     (mem_addr[14:13] == 2'b10) ? to_mips_character_code :
                     (mem_addr[14:13] == 2'b01) ? mem_readdata :
                     32'b0;
                     
    assign dmem_wr = (mem_wr && mem_addr[13]) ? 1'b1 : 1'b0;
    assign smem_wr = (mem_wr && mem_addr[14]) ? 1'b1 : 1'b0;
    
    screenmemory #(11, 4, 1200, screen_mem) scrmem(screen_addr, mem_addr, mem_writedata, smem_wr, clk, character_code, to_mips_character_code);
    dmem #(10, 32, 1024, dmem_init) datamem(clk, dmem_wr, mem_addr, mem_writedata, mem_readdata);
    
endmodule
