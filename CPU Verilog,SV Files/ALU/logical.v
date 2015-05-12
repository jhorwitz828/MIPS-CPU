`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Joshua Horwitz
// Create Date: 01/28/2015 07:02:18 PM
// 
//////////////////////////////////////////////////////////////////////////////////


module logical #(parameter N=32)(
    input [N-1:0] A, B,
    input [1:0] op,
    output [N-1:0] R
    );
    
    assign R =      (op == 2'b00) ? A & B :
                    (op == 2'b01) ? A | B :
                    (op == 2'b10) ? B ^ A :
                    (op == 2'b11) ? ~(A | B) : 32'bx;
endmodule
