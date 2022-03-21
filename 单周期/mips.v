// @Time    : 2022.3.20
// @Author  : chendelin
module mips( clk, rst );
   input   clk;
   input   rst;

//RF
   wire RFWr;
   wire [31:0] WD;//writedata
   wire [31:0] RD1;
   wire [31:0] RD2;
   wire [4:0] rs;
   wire [4:0] rt;
   wire [4:0] rd;
   wire [4:0] A3;
//DM
   wire DMWr;
   //wire [9:0]Address;//ALUDOUT
   //wire [31:0]din;
   wire [31:0]dout;
//IM
  //wire [31:0] im_out;//IM
//PC
   //wire PCWr;
   wire [31:0] PC;
   wire [31:0] NPC;
//NPC
   wire [25:0]IMM;//immediate
//EXTENDER
 
   wire [15:0] Imm16;
   wire [31:0] Imm32;
//ALU
   wire [31:0]ALUdin1;
   wire [31:0]ALUdin2;
   wire [31:0]ALUdout;
   wire Zero;
//Ctrl
    wire [5:0]Op;
    wire [5:0]Funct;
    wire [2:0]  NPCOp;
    wire [1:0]RegDst;
    wire [1:0]MemToReg;
    wire ALUSrc1 ;
    wire ALUSrc2;
    wire [4:0]ALUOp;
    wire [1:0] EXTOp;
//IR
   // wire IRWr;
    wire [31:0]im_dout;
    wire [31:0]instr;
    wire jal;
   assign Op = instr[31:26];
   assign Funct = instr[5:0];
   assign rs = instr[25:21];
   assign rt = instr[20:16];
   assign rd = instr[15:11];
   assign Imm16 = instr[15:0];
   assign IMM = instr[25:0];
   



//PC?????
   PC U_PC (
      .clk(clk), .rst(rst), .NPC(NPC), .PC(PC)
   );
//NPC?????
    NPC U_NPC(
    .PC(PC), .NPCOp(NPCOp), .IMM(IMM), .NPC(NPC), .Zero(Zero),.JR(RD1)
    );
//IM?????
   im_4k U_IM ( 
      .addr(PC[11:2]) , .dout(im_dout)
   );
//RF?????
   RF U_RF (
      .A1(rs), .A2(rt), .A3(A3), .WD(WD), .clk(clk), 
      .RFWr(RFWr), .RD1(RD1), .RD2(RD2),.jal(jal)
   );
//DM?????
   dm_4k U_DM(
      .addr(ALUdout[11:2]), .din(RD2), .dout(dout), .DMWr(DMWr), .clk(clk)
   );
//EXT ?????
   EXT U_EXT(
      .Imm16(Imm16), .Imm32(Imm32), .EXTOp(EXTOp)
   );
//ALU?????
   alu U_ALU(
      .A(ALUdin1), .B(ALUdin2), .ALUOp(ALUOp), .C(ALUdout), .Zero(Zero)
   );
//IR?????
   IR U_IR(
    .clk(clk), .rst(rst),.im_dout(im_dout), .instr(instr)
   );
//Ctrl?????
    Ctrl U_CTRL(
    .Op(Op), .Func(Funct),
    .NPCOp(NPCOp),
    .RegW(RFWr),
    .MemW(DMWr),
    .EXTOp(EXTOp),
    .ALUOp(ALUOp),
    .RegDst(RegDst),
    .ALUSrc1(ALUSrc1),
    .ALUSrc2(ALUSrc2),
    .MemToReg(MemToReg),
    .jal(jal)
    );
//MUX ?????
//1.RegDst MUX
    mux4_5 U_MUX_RegDst(
    .d0(rt),.d1(rd), .d2(5'b1), .d3(5'b0),.s(RegDst), .y(A3)
    );
//2.ALUScr MUX
    mux2_32 U_MUX_ALUSrc1(
    .d0(RD2), .d1(Imm32), .s(ALUSrc1), .y(ALUdin2)
    );
    mux2_32 U_MUX_ALUSrc2(
    .d0(RD1), .d1(Imm32), .s(ALUSrc2), .y(ALUdin1)
    );

//3.MemToReg MUXIRWr
    mux4_32 U_MUX_MemToReg(
    .d0(ALUdout), .d1(dout), .d2(PC + 4), .d3(32'b0), .s(MemToReg), .y(WD)
    );

/*NPCOp MUX????????NPC?????case???????
          mux4 U_MUX_NPCOp(
          .d0(), .d1(), .d2(), .d3(), .s(NPCOp), .y()
          );*/


endmodule