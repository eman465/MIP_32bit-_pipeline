module testbench();

    reg clk = 0;
    reg reset = 0;
    wire [31:0] writedata;
    wire [31:0] dataadr;
    wire memwrite;

    top dut (
        .clk(clk),
        .reset(reset)
    );

    initial begin
        $readmemh("memfile.txt", dut.block_3.Memory,0,71);
        reset = 1;
        #22;
        reset = 0;
        forever begin
	@(negedge clk);
        if((dut.block_2.mem[84]===7))
        begin
         $display("THE SIMULATION HAS  SUCCESSEDED AT  TIME%0t ",$time);   
         $stop;
        end
	//else
	//$display("THE SIMULATION HAS NOT FINISHED  AT  TIME : %0t ",$time);   
        end
    end

    always begin
        #1 clk = ~clk;
    end

endmodule
