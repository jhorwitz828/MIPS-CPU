`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Joshua Horwitz
// Create Date: 04/08/2015 09:38:46 PM
// 
//////////////////////////////////////////////////////////////////////////////////

`include "display640x480.sv"

module vgadisplaydriver#(
    parameter bitmap_init
)(
    input clk,
    input [3:0] character_code,
    output [10:0] screen_addr,
    output [3:0] Red,
    output [3:0] Green,
    output [3:0] Blue,
    output hsync, vsync
    );
    
    wire [`xbits-1:0] x;
    wire [`ybits-1:0] y;
    wire active_video;
    wire [11:0] bitmap_addr;
    wire [11:0] color_value;
    wire [`xbits-1:0] j = x >> 4;
    wire [`ybits-1:0] k = y >> 4;
    wire [3:0] xOffset = x[3:0];
    wire [3:0] yOffset = y[3:0];
    
    assign Red = (active_video) ? color_value[11:8] : 4'b0;
    assign Green = (active_video) ? color_value[7:4] : 4'b0;
    assign Blue = (active_video) ? color_value[3:0] : 4'b0;
    assign screen_addr = ((j) + (40 * k));
    assign bitmap_addr = {character_code, yOffset, xOffset};
    
    bitmapmemory #(12, 12, 2560, bitmap_init) bitmap_mem(bitmap_addr, color_value);
    vgatimer myvgatimer(clk, hsync, vsync, active_video, x, y);

endmodule
