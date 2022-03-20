// @Time    : 2022.3.20
// @Author  : chendelin
`include "ctrl_encode_def.v"

module NPC(PC, NPCOp, IMM, NPC,Zero,JR);
    
   input  [31:0] PC;
   input  [2:0]  NPCOp;
   input  [25:0] IMM;      // immediate
   input          Zero;
   input [31:0]JR;
   output reg [31:0] NPC;
   
   wire [31:0] PCPLUS4;
   
   assign PCPLUS4 = PC + 4; // pc + 4
   
   always @(*) begin
      case (NPCOp)
          `NPC_PLUS4:  NPC = PCPLUS4;//000
          `NPC_BRANCH:     NPC = (Zero==1)?(PCPLUS4 +{{14{IMM[15]}},IMM[15:0],2'b00}):PCPLUS4;//001
          `NPC_JUMP:    NPC = {PC[31:28], IMM[25:0], 2'b00};//010
	  `NPC_BNE:    NPC = (Zero!=1)?(PCPLUS4 +{{14{IMM[15]}},IMM[15:0],2'b00}):PCPLUS4;//011
	  `NPC_JR:     NPC = JR;//100
      endcase
   end // end always
   
endmodule
