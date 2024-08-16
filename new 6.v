module router_fifo(clk,rstn,rstsoft,wr_en,rd_en,data_in,lfd,emp,full,data_out);
input clk,rstn,rstsoft,wr_en,rd_en,[8:0]data_in,lfd;
output emp,full,reg[8:0]data_out;

reg [8:0]fifo[15:0];


reg [8:0]temp=data_in;
reg [8:0]header;

integer N;
if(lfd==1'b1)///decoding of header
header=data_in;
N=header[7:2];///number of payloads getting stored in N
integer wr_ptr=0,i;

always@(posedge clk)
begin

if(!rstn)
begin
full=1'b0;
emp=1'b1;
data_out=8'b0;
rd_ptr=0;
wr_ptr=0;
end


if(wr_en&&!full)
begin
fifo[wr_ptr]<={bit,data_in};
wr_ptr<=wr_ptr+1;
end

if(rd_en&&!emp)
begin
data_out<=fifo[rd_ptr];
rd_ptr<=rd_ptr+1;
end

else if(emp)
data_out<=8'bz;
else
dataout<=data_out;

end

assign emp=(rd_ptr==wr_ptr);
assign full= (rd_ptr-wr_ptr=16) ? 1'b1 :1'bo;

//if((wr_en==1'b1)&&(full==1'b0))
//begin
//for (i=wr_ptr;i<16;i=i+1)
//fifo[i]=data_in;
//wr_ptr=i;//updating the wr_ptr
//if(wr_ptr==15)

if(timeout or emp=1)



end

endmodule
//
//
//if((wr_en==1'b1)&&(full==1'b0))
//begin
//if(lfd==1'b1)
//header=data_in;
//
//else
//for(i=0;i<N+1;i=i+1) ///upto N+1 since parity needs also to be considered
//fifo[i]=data_in///data;
//end
//