`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Joshua Horwitz
// Create Date: 01/28/2015 08:53:02 PM
// 
//////////////////////////////////////////////////////////////////////////////////


module comparator(
    input FlagN,
    input FlagV,
    input FlagC,
    input bool0,
    output comparison
    );
    
    assign comparison = (bool0) ? (~FlagC) :
                        (~bool0) ? (FlagN ^ FlagV) : 1'bx;
    
endmodule
