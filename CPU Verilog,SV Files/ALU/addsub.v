`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Joshua Horwitz
// Create Date: 01/28/2015 06:58:00 PM
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module addsub #(parameter N=32)(
    input [N-1:0] A, B,
    input Subtract,
    output [N-1:0] Result,
    output FlagN, FlagC, FlagV
    );
    
    wire [N-1:0] ToBornottoB = {N{Subtract}} ^ B;
    adder #(N) add(A, ToBornottoB, Subtract, Result, FlagN, FlagC, FlagV);
endmodule
