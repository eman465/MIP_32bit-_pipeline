module ALU_M(input[31:0]SrcA,SrcB,input[2:0]ALUControl,output[31:0]ALU_Result);

reg [31:0]output_data_reg;
always @(*)
begin
  case(ALUControl)
    3'b000: output_data_reg = SrcA & SrcB  ;
    3'b001: output_data_reg = SrcA | SrcB ;
    3'b010: output_data_reg = SrcA + SrcB ;
    3'b110: output_data_reg = SrcA - SrcB ;
    3'b111: output_data_reg = SrcA < SrcB ;//$$ what is (set less than)

    default:output_data_reg = SrcA + SrcB ;//$$ what is the default
  endcase
end
assign ALU_Result = output_data_reg ;
endmodule
