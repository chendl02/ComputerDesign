module HazardInspector(
    input rst,
    input Branch,
    input Whether_jump,
    input[4:0] RsAddr_id,
    input[4:0] RtAddr_id,
    input[4:0] RtAddr_ex,
    input MEM_MemRead_ex,
    input [4:0]RegWriteAddr_ex,
    
    output reg Keep_current_PC,
    output reg IFIDWrite,
    output reg stall,
    output reg flush
);

    always @(posedge rst)begin
            Keep_current_PC <= 1;
            IFIDWrite <= 1;
            stall <= 0;
            flush <= 0;
    end
    always @(*)
    begin
        if(MEM_MemRead_ex&&(RegWriteAddr_ex != 0)
		   &&((RtAddr_ex==RsAddr_id)||(RtAddr_ex==RtAddr_id)))
        begin
            Keep_current_PC<=0;
            IFIDWrite<=0;
            stall<=1;
            flush <= 0;
        end
        else if(Branch||Whether_jump) begin
            //flush the pipline(beq/bne/j/jal), Whether_jump = 1
            flush <= 1;
        end
        else 
        begin
            Keep_current_PC <= 1;
            IFIDWrite <= 1;
            stall <= 0;
            flush <= 0;
        end
    end
endmodule