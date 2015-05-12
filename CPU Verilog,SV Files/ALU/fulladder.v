`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Joshua Horwitz
// Create Date: 01/12/2015 03:42:31 PM
// //////////////////////////////////////////////////////////////////////////////////


module fulladder(
    input A,
    input B,
    input Cin,
    output Sum,
    output Cout
    );
    assign Sum = Cin ^ A ^ B;
    assign Cout = (Cin & (A ^ B)) | (A & B);
endmodule
