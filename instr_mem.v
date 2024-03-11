module Instruction_Memory(clk,CLR,EN,instruction,PC);
input clk,CLR,EN;
input [31:0]PC;
output reg [31:0] instruction;
reg[7:0]Memory[0:1023];
always@(posedge clk)
begin
if (CLR) begin
instruction<=0;
end 
else begin
if (EN) 
instruction<={Memory[PC],Memory[PC+1],Memory[PC+2],Memory[PC+3]};
end
end
endmodule
