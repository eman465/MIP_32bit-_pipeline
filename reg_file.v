module RFM( input rst,  input clk, input[31:0]input_data , input WEN , input[4:0]r_addr1,r_addr2,w_addr , output[31:0]output_data1,output_data2);
reg [31:0]Register_File[0:31];
reg [5:0] i;
always@(negedge clk or posedge rst ) begin
 if(rst)
 begin
  for(i=0 ; i<=31; i=i+1)
  begin
    Register_File[i]<=0;
  end
 end  else  if(WEN)  Register_File[w_addr]<=input_data;
 else  Register_File[w_addr]<=Register_File[w_addr];
end 
assign output_data1=(r_addr1===5'b0)?0:Register_File[r_addr1];
assign output_data2=(r_addr2===5'b0)?0:Register_File[r_addr2];
endmodule
