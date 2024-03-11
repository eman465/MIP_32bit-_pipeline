module control_unit(reset,Op,Funct,RegWriteD,MemtoRegD,MemWriteD,BranchD,ALUControlID,ALUSrcD,RegDstD,jump);
input reset; 
input [5:0] Op,Funct ;
reg [1:0]ALUOp;
output reg RegWriteD,MemtoRegD,MemWriteD,BranchD,ALUSrcD,RegDstD,jump;
output reg  [2:0]ALUControlID;

always@(*) begin
if(reset)
begin
MemtoRegD=0;
MemWriteD=0;
BranchD=0;
ALUSrcD=0;
RegDstD=0;
RegWriteD=0;
jump = 0;
end else 
begin
ALUOp=0;
case(Op)
'b000000:  begin
MemtoRegD=0;
MemWriteD=0;
BranchD=0;
ALUSrcD=0;
RegDstD=1;
RegWriteD=1;
ALUOp=2;
jump = 0;
end 
'b100011:  begin
MemtoRegD=1;
MemWriteD=0;
BranchD=0;
ALUSrcD=1;
RegDstD=0;
RegWriteD=1;
ALUOp=0;
jump = 0;
end 
'b101011:  begin
MemtoRegD=0;
MemWriteD=1;
BranchD=0;
ALUSrcD=1;
RegDstD=0;
RegWriteD=0;
ALUOp=0;
jump = 0;
end 
'b000100:  begin
MemtoRegD=0;
MemWriteD=0;
BranchD=1;
ALUSrcD=0;
RegDstD=0;
RegWriteD=0;
ALUOp=1;
jump = 0;
end 
'b001000:  begin
MemtoRegD=0;
MemWriteD=0;
BranchD=0;
ALUSrcD=1;
RegDstD=0;
RegWriteD=1;
ALUOp=0;
jump = 0;
end 
'b000010:  begin
MemtoRegD=0;
MemWriteD=0;
BranchD=0;
ALUSrcD=0;
RegDstD=0;
RegWriteD=0;
ALUOp=0;
jump = 1;
end 
default:
begin
MemtoRegD='b0;
MemWriteD='b0;
BranchD='b0;
ALUSrcD='b0;
RegDstD='b0;
RegWriteD='b0;
ALUOp='b0;
jump = 0;
end

endcase
end
end
always@(*) begin
case(ALUOp)
0:begin
ALUControlID=3'b010;
end
1:begin//1 or 3
ALUControlID=3'b110;
end
(2'b10 || 2'b11):begin
case (Funct)
'b100000: ALUControlID=3'b010;
'b100010: ALUControlID=3'b110;
'b100100:ALUControlID=3'b000;
'b100101:ALUControlID=3'b001;
'b101010:ALUControlID=3'b111;
default: ALUControlID=3'b100;
endcase
end
default:begin
case (Funct)
'b100000: ALUControlID=3'b010;
'b100010: ALUControlID=3'b110;
'b100100:ALUControlID=3'b000;
'b100101:ALUControlID=3'b001;
'b101010:ALUControlID=3'b111;
default: ALUControlID=3'b100;
endcase
end
endcase
end
endmodule
