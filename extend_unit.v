module SE(input[15:0]extend ,output[31:0]extended );
reg [31:0]extended_reg;
always@(*)
begin
  if(extend[15]==0)
    extended_reg = {16'b0000000000000000,extend};
  else
    extended_reg = {16'b1111111111111111,extend};
end
assign extended = extended_reg;
endmodule
