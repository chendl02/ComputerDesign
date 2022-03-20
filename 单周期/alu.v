`include "ctrl_encode_def.v"
// @Time    : 2022.3.20
// @Author  : chendelin
module alu (A, B, ALUOp, C, Zero);
           
   input  [31:0] A, B;
   input  [4:0]  ALUOp;//?????????????????[1:0]
   output  [31:0] C;
   output  Zero;
   output reg [31:0] C;
       
   always @( A or B or ALUOp ) begin
      case ( ALUOp )
         `ALUOp_ADDU: C = A + B;
         `ALUOp_SUBU: C = A - B;
         `ALUOp_ADD : C = $signed(A) + $signed(B);
         `ALUOp_SUB : C = $signed(A) - $signed(B);
         `ALUOp_SLT : C = (A < B)? 32'd1:32'd0;
         `ALUOp_SLTI: C = (A < B)? 32'd1:32'd0;
         `ALUOp_EQL: C = A-B;
         `ALUOp_BNE: C = A-B;
         `ALUOp_SLL : C = B<<(A[10:6]);
         `ALUOp_SRL : C = B>>(A[10:6]);
         `ALUOp_SRA: C = ($signed(B))>>(A[10:6]);
         `ALUOp_LUI: C = B;
	 `ALUOp_AND: C = A & B;
	 `ALUOp_OR: C = A | B;
	 `ALUOp_ORI:C=A|B;
	 `ALUOp_J : C = A;
	 `ALUOp_JR : C = A;
	 `ALUOp_JAL : C = A;
	 `ALUOp_ADDI: C = A + B;
	 //`ALUOp_SW :C = A + B;
         default: C=A;
      endcase
   end // end always;
   
   assign Zero = (A == B) ? 1 : 0;

endmodule
    
