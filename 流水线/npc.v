`include "ctrl_encode_def.v"

module npc(
    input [31:0] IDRealRs,//outa Gpr[rs]
    input [31:0] oldPC,
    input [31:0] id_pc,
    input [31:0] Instr,
	input beq_zero, 
    input [1:0] PC_sel, //Decide the final input of PC
    output reg [31:0] newPC
    );

	always @(oldPC or Instr or beq_zero or PC_sel or IDRealRs)
    begin
		case(PC_sel)
			2'b00: newPC = oldPC + 4;
			2'b01:
				if(beq_zero == 1) newPC = id_pc + 4 + {{14{Instr[15]}},Instr[15:0],2'b00};//control the instruction of BEQ and BNE
				//this expression means : if (rs != rt) PC <- PC+4 + (sign-extend)immediate<<2 
				else newPC = oldPC + 4;	
			2'b10:	 newPC = {id_pc[31:28], Instr[25:0], 2'b00};//that means we jump to the postion defined by the  {id_pc[31:28], Instr[25:0], 2'b00}
            2'b11:   newPC = IDRealRs;// jr get the data (new PC address)directly,which means jump to the position defined by $rs
		endcase
        
	end	 

endmodule