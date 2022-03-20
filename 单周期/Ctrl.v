// @Time    : 2022.3.20
// @Author  : chendelin
module Ctrl(Op,Func,
            NPCOp,
            RegDst,RegW,
            MemW,MemToReg,
            ALUSrc1,ALUSrc2,ALUOp,
            EXTOp
            );
input [5:0]Op;
input [5:0]Func;

output  [2:0]NPCOp;

output [1:0]RegDst;
output RegW;
output MemW;
output [1:0]MemToReg;
output ALUSrc1,ALUSrc2;
output [4:0]ALUOp;
output [1:0]EXTOp;

 wire R_type=~|Op;//R
 wire I_lw=Op[5]&&~Op[4]&&~Op[3]&&~Op[2]&&Op[1]&&Op[0];//100011
 wire I_sw=Op[5]&&~Op[4]&&Op[3]&&~Op[2]&&Op[1]&&Op[0];//101011
 wire I_add=R_type&&Func[5]&&~Func[4]&&~Func[3]&&~Func[2]&&~Func[1]&&~Func[0]; //100000
 wire I_sub=R_type&&Func[5]&&~Func[4]&&~Func[3]&&~Func[2]&&Func[1]&&~Func[0]; //100010
 wire I_addu=R_type&&Func[5]&&~Func[4]&&~Func[3]&&~Func[2]&&~Func[1]&&Func[0];//100001
 wire I_subu=R_type&&Func[5]&&~Func[4]&&~Func[3]&&~Func[2]&&Func[1]&&Func[0];//100011
 wire I_ori=~Op[5]&&~Op[4]&&Op[3]&&Op[2]&&~Op[1]&&Op[0];//001101
 wire I_beq=~Op[5]&&~Op[4]&&~Op[3]&&Op[2]&&~Op[1]&&~Op[0];//000100

 wire I_lui=~Op[5]&&~Op[4]&&Op[3]&&Op[2]&&Op[1]&&Op[0];//001111
 wire I_sll=R_type&&~Func[5]&&~Func[4]&&~Func[3]&&~Func[2]&&~Func[1]&&~Func[0];//000000
 wire I_srl=R_type&&~Func[5]&&~Func[4]&&~Func[3]&&~Func[2]&&Func[1]&&~Func[0];//000010
 wire I_slt=R_type&&Func[5]&&~Func[4]&&Func[3]&&~Func[2]&&Func[1]&&~Func[0];//101010
 wire I_sra=R_type&&~Func[5]&&~Func[4]&&~Func[3]&&~Func[2]&&Func[1]&&Func[0];//000011
 wire I_jr=R_type&&~Func[5]&&~Func[4]&&Func[3]&&~Func[2]&&~Func[1]&&~Func[0];//001000
 wire I_addi=~Op[5]&&~Op[4]&&Op[3]&&~Op[2]&&~Op[1]&&~Op[0];//001000
 wire I_jal=~Op[5]&&~Op[4]&&~Op[3]&&~Op[2]&&Op[1]&&Op[0];//000011
 wire I_slti=~Op[5]&&~Op[4]&&Op[3]&&~Op[2]&&Op[1]&&~Op[0];//001010
 wire I_bne=~Op[5]&&~Op[4]&&~Op[3]&&Op[2]&&~Op[1]&&Op[0];//000101
 wire I_j=~Op[5]&&~Op[4]&&~Op[3]&&~Op[2]&&Op[1]&&~Op[0];//000010

//NPC
assign NPCOp[0]=I_beq|I_bne;
assign NPCOp[1]=I_j|I_jal|I_bne;
assign NPCOp[2]=I_jr;


//Reg
assign RegDst[0] = R_type; 
assign RegDst[1] = I_jal;
assign RegW = R_type|I_lw|I_ori|I_addi;  

//Mem
assign MemW = I_sw;  //sw
assign MemToReg[0] = I_lw;  //lw
assign MemToReg[1] = I_jal;
//ALU
assign ALUOp[0] =I_addu|I_subu|I_slt|I_beq|I_sll|I_sra|I_ori|I_j|I_jr;
assign ALUOp[1] =I_add|I_subu|I_srl|I_beq|I_sra|I_lui|I_j|I_addi|I_sw|I_lw;
assign ALUOp[2] =I_bne|I_sub|I_slti|I_ori|I_lui|I_j;
assign ALUOp[3] =I_slt|I_beq|I_bne|I_jal|I_jr|I_addi;
assign ALUOp[4] =I_sll|I_srl|I_sra|I_slti|I_ori|I_lui|I_jal|I_j|I_jr|I_addi;

assign ALUSrc1 = I_lw|I_sw|I_ori|I_lui|I_slti|I_addi;  //lw?sw??
assign ALUSrc2 =I_sll|I_srl|I_sra;
//EXT
assign EXTOp[0] = I_addi|I_lw|I_sw|I_beq|I_slti;  
assign EXTOp[1] = I_lui;

endmodule

