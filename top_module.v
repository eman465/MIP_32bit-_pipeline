module top(clk,reset);

input clk,reset;

wire StallD,StallF;
wire ForwardAD,ForwardBD;
wire jump;
wire [1:0] ForwardAE,ForwardBE;
wire RegWriteD,MemtoRegD,MemWriteD,BranchD,ALUSrcD,RegDstD;
wire [2:0] ALUControlID;
wire [31:0] PC,PCF,PC2,PCJump;
wire [31:0] RD;
wire [31:0] SrCBE;
wire [31:0] SrCAE;
wire [31:0] instruction;
wire [31:0] ALU_Result;
reg RegDstE;
reg [31:0] SignImmE;
wire [31:0] SignImmD;
wire [31:0] RD1,RD2;
reg RegWriteE;
wire [31:0] x,y;
wire EqualID,pCScrD;
wire [31:0] PCBranchD;
wire [31:0] PCPlus4F;
reg [31:0] PCPlus4D;
wire [4:0] RsD,RtD,RdD;
reg [4:0] RsE,RtE,RdE;
wire [4:0] WriteRegE;
reg MemwriteE,ALUSrcE;
reg [31:0] RD1E,RD2E;
wire [31:0] WriteDataE;
reg [31:0] ReadDataW;
reg MemtoRegW;
reg [31:0] ALUOutW;
reg [31:0] WriteDataM;
reg MemtoRegE;
reg [2:0] ALUControlE;
reg [31:0] ALUOutM;
reg [4:0] WriteRegM;
reg RegWriteM;
reg MemtoRegM;
reg MemwriteM;
reg RegWriteW;
reg [4:0] WriteRegW;
wire [31:0] ResultW;

control_unit block_1(reset,instruction[31:26],instruction[5:0],RegWriteD,MemtoRegD,MemWriteD,BranchD,ALUControlID,ALUSrcD,RegDstD,jump);
data_memory block_2(ALUOutM,WriteDataM,MemwriteM,RD,clk);
Instruction_Memory block_3 (clk,(pCScrD||jump),!StallD,instruction,PCF);
ALU_M block_4 (SrCAE,SrCBE,ALUControlE,ALU_Result);
RFM block_5 (reset,clk ,ResultW,RegWriteW, instruction[25:21],instruction[20:16],WriteRegW, RD1,RD2);
SE block_6 (instruction[15:0],SignImmD);
Program_counter block_7 (PC,PCF,reset,clk,!StallF);
Hzard_unit block_8(reset,RsE,RtE,WriteRegM,WriteRegW,RegWriteM,RegWriteW,ForwardAE,ForwardBE,RsD,RtD,MemtoRegE,
StallF,StallD,FlushE,ForwardAD,ForwardBD,BranchD,RegWriteE,WriteRegE,MemtoRegM);

always @(posedge clk) begin
    if(pCScrD||jump)//5
      PCPlus4D<=0;
    if(FlushE|reset) begin
        RegWriteE<=0;
        MemtoRegE<=0;
        ALUControlE<=0;
        MemwriteE<=0;
        ALUSrcE<=0;
        RegDstE<=0;
        RsE<=0;
        RtE<=0;
        RdE<=0;
        SignImmE<=0;
        RD1E<=0;
        RD2E<=0;
    end else begin
        RegWriteE<=RegWriteD;
        MemtoRegE<=MemtoRegD;
        ALUControlE<=ALUControlID;
        MemwriteE<=MemWriteD;
        ALUSrcE<=ALUSrcD;
        RegDstE<=RegDstD;
        RsE<=RsD;
        RtE<=RtD;
        RdE<=RdD;   
        SignImmE<=SignImmD; 
        RD1E<=RD1;
        RD2E<=RD2;
        if(!StallD)//6
        PCPlus4D<=PCPlus4F;
    end
end

always @(posedge clk) begin
    if(reset) begin
        ALUOutM<=0;
        WriteRegM<=0;
        WriteDataM<=0;
        RegWriteM<=0;
        MemtoRegM<=0;
        MemwriteM<=0;   
    end else begin
        ALUOutM<=ALU_Result;
        WriteRegM<=WriteRegE;
        WriteDataM<=WriteDataE;
        RegWriteM<=RegWriteE;
        MemtoRegM<=MemtoRegE;
        MemwriteM<=MemwriteE; 
    end 
end

always @(posedge clk) begin
    if(reset) begin
        ReadDataW<=0;
        WriteRegW<=0;
        RegWriteW<=0;
        MemtoRegW<=0;
        ALUOutW<=0;    
    end else begin
        ReadDataW<=RD;
        WriteRegW<=WriteRegM;
        RegWriteW<=RegWriteM;
        MemtoRegW<=MemtoRegM;
        ALUOutW<=ALUOutM;   
    end
end

assign x=(ForwardAD)? ALUOutM:RD1 ;
assign y=(ForwardBD)? ALUOutM:RD2 ;
assign EqualID=(x==y);
assign pCScrD=(EqualID & BranchD);
assign PCBranchD= {SignImmD[29:0],2'b0} + PCPlus4D;
assign PCJump = {PCPlus4F[31:28],instruction[25:0],2'b00};//1
assign PCPlus4F=4+PCF;
assign PC2=(pCScrD)? PCBranchD:PCPlus4F;//2
assign PC = (jump)? PCJump:PC2;//3
assign RsD=instruction[25:21];
assign RtD=instruction[20:16];
assign RdD=instruction[15:11];
assign WriteRegE=(RegDstE)?RdE:RtE;
assign ResultW=(MemtoRegW)?ReadDataW:ALUOutW;
assign SrCAE=(ForwardAE==0)?RD1E:(ForwardAE==2'b01)?ResultW:(ForwardAE==2'b10)?ALUOutM:SrCAE;
assign WriteDataE=(ForwardBE==0)?RD2E:(ForwardBE==2'b01)?ResultW:(ForwardBE==2'b10)?ALUOutM:WriteDataE;
assign SrCBE=(ALUSrcE)?SignImmE:WriteDataE;

endmodule
