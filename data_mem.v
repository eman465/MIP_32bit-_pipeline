//eman hussein 
module data_memory(A,WD,WE,RD,CLK);
input [31:0] A,WD;
input WE;
input CLK;
output [31:0] RD;
reg [31:0] mem [0:1023];

always@(posedge CLK)begin
if(WE)
mem[A]<=WD;
end
assign RD=mem[A];
endmodule
