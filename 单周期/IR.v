// @Time    : 2022.3.20
// @Author  : chendelin
module IR (clk, rst,  im_dout, instr);
               
   input         clk;
   input         rst;
   //input         IRWr; 
   input  [31:0] im_dout;
   output [31:0] instr;
   
   reg [31:0] instr;
               
   always @(posedge clk or posedge rst) begin
      instr <= im_dout;
      if ( rst ) 
         instr <= 0;
     
         
   end // end always
      
endmodule
