module router_sync(detect_add,data_in,write_enb_reg,clock,resetn,vld_out_0,vld_out_1,vld_out_2,read_enb_0,read_enb_1,
read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,write_enb,fifo_full,soft_reset_0,soft_reset_1,soft_reset_2);

input detect_add,clock,resetn,write_enb_reg,resetn,read_enb_0,read_enb_1,
read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2;
input [1:0]data_in;

output vld_out_0,vld_out_1,vld_out_2;
output reg soft_reset_0=1'b0,soft_reset_1=1'b0,soft_reset_2=1'b0;
output reg fifo_full=1'bz;
output reg [2:0]write_enb;

reg[1:0]mem;///internal 2 bit memory of Synchronizer

integer N0=0,N1=0,N2=0;//////For counters



always @(posedge clock)//how to use resetn????

begin


//----------Reading DATA----------
if((detect_add&&write_enb_reg)==1'b0)
mem<=data_in;

case(mem)/////For write_enb to FIFOs
00 : write_enb=3'b001;
01 : write_enb=3'b010;
10 : write_enb=3'b101;
default : write_enb=3'bzzz;
endcase

case(mem)//////////////for fifo_full Pin
00 : fifo_full=full_0;
01 : fifo_full=full_1;
10 : fifo_full=full_2;

default : fifo_full=1'bz;
endcase

end






///------soft reset logic----------




always @(posedge clock)
begin

if(!read_enb_0)
begin
if((vld_out_0)&&(N0==0))
begin
if(N0==30)
soft_reset_0=1'b1;

else
begin
N0=N0+1;///////////Counter please put N0=0 initially
soft_reset_0=1'b0;
end

end
end
//-----if(!read_enb_0) ends-------
else
soft_reset_0=1'b0;

end




//---------For read_enb_1--------
always @(posedge clock)
begin

if(!read_enb_1)
begin
if((vld_out_1)&&(N1==0))
begin
if(N1==30)
soft_reset_1=1'b1;

else
begin
N1=N1+1;///////////Counter N1=0 initially DONE
soft_reset_1=1'b0;
end

end
end
//-----if(!read_enb_1) ends-------
else
soft_reset_1=1'b0;

end




//---------For read_enb_2--------
always @(posedge clock)
begin

if(!read_enb_2)
begin
if((vld_out_2)&&(N2==0))
begin
if(N2==30)
soft_reset_2=1'b1;

else
begin
N2=N2+1;///////////Counter N2=0 initially DONE
soft_reset_2=1'b0;
end

end
end
//-----if(!read_enb_2) ends-------
else
soft_reset_2=1'b0;

end




assign vld_out_0=!empty_0;
assign vld_out_1=!empty_1;
assign vld_out_2=!empty_2;



endmodule
