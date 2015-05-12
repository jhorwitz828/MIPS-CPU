`timescale 1ns / 1ps

// Josh Horwitz
// April 8, 2015
//

module keyboard(
   input clk,
   input ps2_clk,
   input ps2_data,
   output reg [31:0] keyb_char = 0
   );

   reg [31:0] temp_char = 0;
   reg [9:0] bits = 0;
   reg [3:0] count = 0;
   reg [1:0] ps2_clk_prev2 = 2'b11;
   reg [19:0] timeout = 0;
   
   always_ff @(posedge clk)
      ps2_clk_prev2 <= {ps2_clk_prev2[0], ps2_clk};
      
   always_ff @(posedge clk)
   begin
      if((count == 11) || (timeout[19] == 1))
      begin
         count <= 0;
         if((temp_char[7:0] == 8'hE0) || (temp_char[7:0] == 8'hF0)) begin       // if previous byte was E0 or F0
            temp_char[31:0] <= {temp_char[23:0], bits[7:0]};                    // shift the new byte in from the right, i.e., continue scancode
            if((bits[7:0] != 8'hE0) && (bits[7:0] != 8'hF0))                    // if new byte is not E0 or F0
               keyb_char <= {temp_char[23:0], bits[7:0]};                       // update output
         end
         else begin                                                             // previous byte was not E0 or F0
            temp_char[31:0] <= {24'b0, bits[7:0]};                              // new byte is the start of a new scancode
            if((bits[7:0] != 8'hE0) && (bits[7:0] != 8'hF0))                    // if new byte is not E0 or F0
               keyb_char <= {24'b0, bits[7:0]};                                 // update output      
         end
      end
      else
      begin
         if(ps2_clk_prev2 == 2'b10)
         begin
            count <= count + 1;
            bits <= {ps2_data, bits[9:1]};
         end
      end
   end
   
   always_ff @(posedge clk)
      timeout <= (count != 0) ? timeout + 1 : 0;

endmodule