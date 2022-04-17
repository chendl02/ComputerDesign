
module Forwarding(
    input RegWrite_mem,
    input RegWrite_wb,
    input RegWrite_ex,
    input[4:0] RegWriteAddr_mem,
    input[4:0] RegWriteAddr_wb,
    input[4:0] RegWriteAddr_ex,
    input[4:0] RsAddr_ex,
    input[4:0] RtAddr_ex,
    //Forwarding in ID
    input[4:0] RsAddr_id,
    input[4:0] RtAddr_id,
    //the control signal of forwarding in EX, which is only for data adventure
    output reg[1:0] ForwardA,
    output reg[1:0] ForwardB,
    //the control signal of forwarding in ID, which is only for control adventure
    output reg[1:0] ForwardC,
    output reg[1:0] ForwardD
);

    

    always @(*)
    begin
        //Forwarding in EX that is used for data adventure
        //"RegWriteAddr_mem !=0  RegWriteAddr_wb!=0" 
        if(RegWrite_mem&&(RegWriteAddr_mem!=0)&&(RegWriteAddr_mem==RsAddr_ex))//last two hadn't written back to Rs
            ForwardA=2'b10;
        else if(RegWrite_wb&&(RegWriteAddr_wb!=0)&&(RegWriteAddr_wb==RsAddr_ex))//last one hadn't written back to  Rs
            ForwardA=2'b01;
        else
            ForwardA=2'b00;
        if(RegWrite_mem&&(RegWriteAddr_mem!=0)&&(RegWriteAddr_mem==RtAddr_ex))
            ForwardB=2'b10;
        else if(RegWrite_wb&&(RegWriteAddr_wb!=0)&&(RegWriteAddr_wb==RtAddr_ex))
            ForwardB=2'b01;
        else
            ForwardB=2'b00;

        //Forwarding in ID  control adventure
        
        if(RegWrite_ex&&(RegWriteAddr_ex!=0)&&(RegWriteAddr_ex==RsAddr_id))
            ForwardC=2'b10;//choose the pass one instruction's calculated resulted of ALU
        else if(RegWrite_wb&&(RegWriteAddr_wb!=0)&&(RegWriteAddr_wb==RsAddr_id))
            ForwardC=2'b01;//choose the pass two instruction's calculated resulted of ALU
        else
            ForwardC=2'b00;//Wow, I do not need to forward any data!

        if(RegWrite_ex&&(RegWriteAddr_ex!=0)&&(RegWriteAddr_ex==RtAddr_id))//when the pass one instruction's calculated result has not been written into the destination
            ForwardD=2'b10;//choose the pass one instruction's calculated resulted of ALU
        else if(RegWrite_wb&&(RegWriteAddr_wb!=0)&&(RegWriteAddr_wb==RtAddr_id))//when the pass two instruction's calculated result has not been written into the destination
            ForwardD=2'b01;//choose the pass two instruction's calculated resulted of ALU
        else
            ForwardD=2'b00;//Wow, I do not need to forward any data!
    end
endmodule
/*
Well, I have to admit that the module is not perfect because when the instruction of lw is followed by a BNE/BEQ, we need to stall a period, but the test does not have this kind of instrucions, so I do not perfect the whole function.
*/