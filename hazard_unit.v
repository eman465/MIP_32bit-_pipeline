module Hzard_unit(reset,rsE,rtE,WriteRegM,WriteRegW,RegWriteM,RegWriteW,ForwardAE,ForwardBE,rsD,rtD,MemtoRegE,
                  StallF,StallD,FlushE,ForwardAD,ForwardBD,BranchD,RegWriteE,WriteRegE,MemtoRegM);

//forwading data hazared
input reset;
input [4:0]rsE,rtE;
input [4:0]WriteRegM,WriteRegW,WriteRegE;
input RegWriteM,RegWriteW,RegWriteE;
output reg [1:0]ForwardAE,ForwardBE;
output reg ForwardAD,ForwardBD;
//forwading data hazared with stall
input [4:0]rsD,rtD;
input MemtoRegE,MemtoRegM,BranchD;
output reg StallF,StallD,FlushE;

reg lwstall,branchstall;

always@(*)begin
if(reset)
begin
ForwardAE=0;
ForwardBE=0;
ForwardAD=0;
ForwardBD=0;
StallF=0;
StallD=0;
FlushE=0;
branchstall=0;
end 
else 
begin
if  ( (rsE != 0) & (rsE == WriteRegM)& RegWriteM )  
ForwardAE = 2'b10;
else if ( (rsE != 0) & (rsE == WriteRegW) & RegWriteW)
ForwardAE = 2'b01;
else
 ForwardAE = 2'b00;

if  (((rtE != 0) & (rtE == WriteRegM) & RegWriteM)) 
ForwardBE = 2'b10;
else if ( ((rtE != 0) & (rtE == WriteRegW) & RegWriteW) )
ForwardBE = 2'b01;
else
 ForwardBE = 2'b00;
 
 ForwardAD = ((rsD!=0)&(rsD==WriteRegM)&(RegWriteM));
 
 ForwardBD =((rtD!=0)&(rtD==WriteRegM)&(RegWriteM));
  
if((BranchD && RegWriteE && (WriteRegE==rsD || WriteRegE==rtD))||(BranchD && MemtoRegM && (WriteRegM==rsD || WriteRegM==rtD)))
   branchstall = 1'b1;
else   branchstall=  1'b0;


lwstall = ((rsD == rtE) | (rtD == rtE)) & MemtoRegE;
StallF  = lwstall || branchstall ;
StallD  = lwstall || branchstall ;
FlushE  = lwstall || branchstall ;
end
end
endmodule
