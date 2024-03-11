module Program_counter(PC,PCF,reset,CLK,EN);
input EN;
input reset;
input CLK;
input [31:0] PC;
output reg [31:0] PCF ;

always@(posedge CLK)begin
if(reset)
PCF<=32'h00000000;
else
if(EN)
PCF<=PC;
else 
PCF<=PCF;
end

endmodule
