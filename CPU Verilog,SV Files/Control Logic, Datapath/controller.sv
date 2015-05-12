`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Joshua Horwitz
// 3/26/2015 
//
//////////////////////////////////////////////////////////////////////////////////

// These are non-R-type, so check op code
`define LW     6'b 100011
`define SW     6'b 101011
`define ADDI   6'b 001000
`define ADDIU  6'b 001001
`define SLTI   6'b 001010
`define ORI    6'b 001101
`define BEQ    6'b 000100
`define BNE    6'b 000101
`define J      6'b 000010
`define JAL    6'b 000011
`define LUI    6'b 001111

// These are all R-type, i.e., op=0, so check the func field
`define ADD    6'b 100000
`define SUB    6'b 100010
`define AND    6'b 100100
`define OR     6'b 100101
`define XOR    6'b 100110
`define NOR    6'b 100111
`define SLT    6'b 101010
`define SLTU   6'b 101011
`define SLL    6'b 000000
`define SRL    6'b 000010
`define SRA    6'b 000011
`define JR     6'b 001000  


module controller(
   input  [5:0] op, 
   input  [5:0] func,
   input  Z,
   output [1:0] pcsel,
   output [1:0] wasel, 
   output sext,
   output bsel,
   output [1:0] wdsel, 
   output reg [4:0] alufn,
   output wr,
   output werf, 
   output [1:0] asel
   ); 

  assign pcsel = ((op == 6'b000000) && (func == `JR)) ? 2'b11   // controls 4-way multiplexor
               : ((op == 6'b000010) || (op == 6'b000011)) ? 2'b10 //J & JAL
               : (((op == 6'b000100) && (Z)) || ((op == 6'b000101) && (~Z))) ? 2'b01 //BEQ && BNE
               : 2'b00;

  reg [9:0] controls;
  assign {werf, wdsel[1:0], wasel[1:0], asel[1:0], bsel, sext, wr} = controls[9:0];

  always_comb
     case(op)                                     // non-R-type instructions
        `LW: controls <= 10'b1_10_01_00_1_1_0;
        `SW: controls <= 10'b0_01_xx_00_1_1_1;
        `ADDI: controls <= 10'b1_01_01_00_1_1_0;
        `SLTI: controls <= 10'b1_01_01_00_1_1_0;
        `ORI: controls <= 10'b1_01_01_00_1_1_0;
        `ADDIU: controls <= 10'b1_01_01_00_1_0_0;
        `J: controls <= 10'b0_xx_xx_xx_x_x_0;
        `JAL: controls <= 10'b1_00_10_xx_x_x_0;
        `BEQ: controls <= 10'b0_10_01_00_0_1_0;
        `BNE: controls <= 10'b0_10_01_00_0_1_0;
        
        6'b000000:                                    
            case(func)
                `ADD: controls <= 10'b1_01_00_00_0_x_0;
                `SUB: controls <= 10'b1_01_00_00_0_x_0;
                `AND: controls <= 10'b1_01_00_00_0_x_0;
                `OR: controls <= 10'b1_01_00_00_0_x_0;
                `XOR: controls <= 10'b1_01_00_00_0_x_0;
                `NOR: controls <= 10'b1_01_00_00_0_x_0;
                `SLT: controls <= 10'b1_01_00_00_0_x_0;
                `SLTU: controls <= 10'b1_01_00_00_0_x_0;
                `SLL: controls <= 10'b1_01_00_01_0_x_0;
                `SRL: controls <= 10'b1_01_00_01_0_x_0;
                `SRA: controls <= 10'b1_01_00_01_0_x_0;
                `JR: controls <= 10'b0_xx_xx_xx_x_x_0;
                
            default:   controls <= 10'b0_xx_xx_xx_x_x_0; // unknown instruction, turn off register and memory writes
         endcase
      default: controls <= 10'b0_xx_xx_xx_x_x_0; // unknown instruction, turn off register and memory writes
    endcase
    

  always_comb
    case(op) //Non R-Type
        `LW: alufn <= 5'b0xx01;
        `SW: alufn <= 5'b0xx01;
        `ADDI: alufn <= 5'b0xx01;
        `SLTI: alufn <= 5'b1x011;
        `BEQ: alufn <= 5'b1xx01;
        `BNE: alufn <= 5'b1xx01;
        6'b000000: //R-Type
            case(func)
                `ADD: alufn <= 5'b0xx01;
                `SUB: alufn <= 5'b1xx01;
                `AND: alufn <= 5'bx0000;
                `OR: alufn <= 5'bx0100;
                `XOR: alufn <= 5'bx1000;
                `NOR: alufn <= 5'bx1100;
                `SLT: alufn <= 5'b1x011;
                `SLTU: alufn <= 5'b1x111;
                `SLL: alufn <= 5'bx0010;
                `SRL: alufn <= 5'bx1010;
                `SRA: alufn <= 5'bx1110;
            default:   alufn <= 5'bxxxxx; // ???
          endcase
        default: alufn <= 5'bxxxxx;          // J, JAL
    endcase
    
endmodule
