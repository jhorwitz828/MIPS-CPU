`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Joshua Horwitz
// 4/6/2015 
//
//////////////////////////////////////////////////////////////////////////////////

module top #(
    parameter imem_init="final_imem",
    parameter dmem_init="dmem.txt",
    parameter scrmem_init="screenmem_init_final.txt",		// text file to initialize screen memory
    parameter bitmap_init="bmem_init.txt"			// text file to initialize bitmap memory
)(
    input clk, ps2_clk, ps2_data, reset,
    output [3:0] Red, Blue, Green,
    output hsync, vsync,
    output [7:0] segments, digitselect
);
   
   wire [31:0] pc, instr, mem_writedata, mem_readdata, mem_addr, reg_writedata, debug_pc, keyb_char;
   wire mem_wr;
   wire [10:0] screen_addr;
   wire [3:0] character_code;
   

   // Uncomment *only* one of the following two lines:
   //    when synthesizing, use the first line
   //    when simulating, get rid of the clock divider, and use the second line
   //
   clockdivider_Nexys4 clkdv(clk, clk100, clk50, clk25, clk12);
   //assign clk100=clk; assign clk50=clk; assign clk25=clk; 
   //assign clk12=clk;

   // For synthesis:  use an appropriate clock frequency(ies) below
   //   clk100 will work for only the most efficient designs (hardly anyone)
   //   clk50 or clk 25 should work for the vast majority
   //   clk12 should work for everyone!
   //
   // Use the same clock frequency for the MIPS and data memory/memIO modules
   // The vgadisplaydriver should keep the 100 MHz clock.
   // For example:

   mips mips(clk12, reset, pc, instr, mem_wr, mem_addr, mem_writedata, mem_readdata, reg_writedata, debug_pc);
   imem #(10, 32, 1024, imem_init) imem(pc[31:0], instr);
   memIO #(32, 32, 32, dmem_init, scrmem_init) memIO(clk12, mem_wr, keyb_char, screen_addr, mem_addr, mem_writedata, mem_readdata, character_code);
   vgadisplaydriver #(bitmap_init) display(clk100, character_code, screen_addr, Red, Green, Blue, hsync, vsync);
   display8digit PCdisplay(keyb_char, clk100, segments, digitselect);
   keyboard keyboard(clk, ps2_clk, ps2_data, keyb_char);

endmodule