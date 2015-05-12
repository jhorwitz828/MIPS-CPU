`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Joshua Horwitz
// Create Date: 01/28/2015 07:07:51 PM
// 
//////////////////////////////////////////////////////////////////////////////////


module shifter #(parameter N=32)(
    input signed [N-1:0] IN,
    input [$clog2(N)-1:0] shamt,
    input left,
    input logical,
    output [N-1:0] OUT
    );
    
    assign OUT = left ? (IN << shamt) :
            (logical ? IN >> shamt : IN >>> shamt);
endmodule
