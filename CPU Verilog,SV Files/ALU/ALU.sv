`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Joshua Horwitz
// Create Date: 01/28/2015 07:59:09 PM
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU #(parameter N=32)(
    input [N-1:0] A, B,
    output [N-1:0] R,
    input [4:0] ALUfn,
    output FlagZ
    );
    
    wire subtract, bool1, bool0, shft, math;
    assign {subtract, bool1, bool0, shft, math} = ALUfn[4:0];
    
    wire [N-1:0] addsubResult, shiftResult, logicalResult;
    wire compResult;
    
    addsub #(N) AS(A, B, subtract, addsubResult, FlagN, FlagC, FlagV);
    shifter #(N) S(B, A[$clog2(N) - 1:0], ~bool1, ~bool0, shiftResult);
    logical #(N) L(A, B, {bool1, bool0}, logicalResult);
    comparator C(FlagN, FlagV, FlagC, bool0, compResult);
    
    assign R = (~shft & math) ? addsubResult :
               (shft & ~math) ? shiftResult :
               (~shft & ~math) ? logicalResult : 
               (shft & math) ? {{(N-1){1'b0}}, compResult}: 32'bz;
    
    assign FlagZ = ~|R;
endmodule
