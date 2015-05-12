`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Joshua Horwitz
// Create Date: 02/25/2015 07:30:03 PM
// 
//////////////////////////////////////////////////////////////////////////////////

`include "display640x480.sv"

module vgatimer(
    input clk,
    output hsync, vsync, activevideo,
    output [`xbits-1:0] x,
    output [`ybits-1:0] y
    );
    
    reg[1:0] clk_count = 0;
    always_ff @(posedge clk)
        clk_count <= clk_count + 2'b01;
    assign Every2ndTick = (clk_count[0] == 1'b1);
    assign Every4thTick = (clk_count[1:0] == 2'b11);
    
    xycounter #(`WholeLine, `WholeFrame) xy (clk, Every4thTick, x, y);
    
    assign hsync = (x > `WholeLine - `hBackPorch - `hSyncPulse - 1 && x < `hSyncStart + `hSyncPulse ) ? 0 : 1;
    assign vsync = (y > `WholeFrame - `vBackPorch - `vSyncPulse - 1 && y < `vSyncStart + `vSyncPulse) ? 0 : 1;
    assign activevideo = (x < `WholeLine  - `hFrontPorch - `hSyncPulse - `hBackPorch && y < `WholeFrame - `vFrontPorch - `vSyncPulse - `vBackPorch)? 1 : 0;
    
endmodule
