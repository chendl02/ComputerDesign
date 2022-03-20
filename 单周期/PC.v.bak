// @Time    : 2022.3.20
// @Author  : chendelin
//module PC( clk, rst, PCWr, NPC, PC );
module PC( clk, rst, NPC, PC );           
   input         clk;
   input         rst;
   //input         PCWr;
   input  [31:0] NPC;
   output [31:0] PC;
   
   reg [31:0] PC;
   //reg [1:0] tmp;
               
               
   always @(posedge clk or posedge rst) begin
      PC <= NPC; 
      if ( rst ) 
         PC <= 32'h0000_0000;   
      //else if ( PCWr ) 
      //$display("PC = 0x%8X, IR = 0x%8X", U_MIPS.U_PC.PC, U_MIPS.instr );    
   end // end always
         
endmodule
