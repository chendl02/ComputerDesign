// @Time    : 2022.3.20
// @Author  :chendelin
 module mips_tb();
    
   reg clk, rst;
    
   mips U_MIPS(
      .clk(clk), .rst(rst)
   );
    
   initial begin
      $readmemh( "Test_Signal.txt" , U_MIPS.U_IM.imem ) ;
      $monitor("PC = 0x%8X, IR = 0x%8X", U_MIPS.U_PC.PC, U_MIPS.instr ); 
      clk = 1 ;
      rst = 0 ;
      #5 ;
      rst = 1 ;
      #20 ;
      rst = 0 ;
   end
  
   always
	   #(50) clk = ~clk;

   
endmodule
