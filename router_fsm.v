module router_fsm(clock,resetn,pkt_valid,busy,parity_done,data_in,soft_reset_0,soft_reset_1,soft_reset_2,
fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,detect_add,ld_state,laf_state,
full_state,lfd_state,write_enb_reg,rst_int_reg);

input fifo_empty_0,fifo_empty_1,fifo_empty_2,clock,resetn,pkt_valid,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,
fifo_full,low_pkt_valid;
input [1:0]data_in;

output busy,detect_add,ld_state,laf_state,
full_state,lfd_state,write_enb_reg,rst_int_reg;

parameter DECODE_ADDRESS=3'b000,
			LOAD_FIRST_DATA = 3'b001,
			LOAD_DATA=3'b010,
			FIFO_FULL_STATE=3'b011,
			LOAD_AFTER_FULL =3'b100,
			LOAD_PARITY=3'b101,
			CHECK_PARITY_ERROR=3'b110,
			WAIT_TILL_EMPTY=3'b111;

reg[2:0]state=DECODE_ADDRESS;

always @(posedge clock)
begin
case(state)
DECODE_ADDRESS  :  begin if(soft_reset_0||soft_reset_1||soft_reset_2)
							state= DECODE_ADDRESS;
					if((pkt_valid&&(data_in==0)&&fifo_empty_0)||(pkt_valid&&(data_in==1)&&fifo_empty_1)
							||(pkt_valid&&(data_in==2)&&fifo_empty_2))
							state = LOAD_FIRST_DATA;
					if((pkt_valid&&(data_in==0)&&(!fifo_empty_0))||(pkt_valid&&(data_in==1)&&(!fifo_empty_1))
							||(pkt_valid&&(data_in==2)&&(!fifo_empty_2)))
							state = WAIT_TILL_EMPTY;
							
							end
					
								
							
LOAD_FIRST_DATA	:   state= LOAD_DATA;

LOAD_DATA    	:   begin if(soft_reset_0||soft_reset_1||soft_reset_2)
							state= DECODE_ADDRESS; 
					if(fifo_full)
					state=FIFO_FULL_STATE;
					else if(!fifo_full&&!pkt_valid)
					state=LOAD_PARITY;
					else
					state=LOAD_DATA;
					end
FIFO_FULL_STATE : begin  if(soft_reset_0||soft_reset_1||soft_reset_2)
							state= DECODE_ADDRESS;
					if(!fifo_full)
					state= LOAD_AFTER_FULL;
					else
					state= FIFO_FULL_STATE;
					end
LOAD_AFTER_FULL :   begin if(soft_reset_0||soft_reset_1||soft_reset_2)
							state= DECODE_ADDRESS;
							if(parity_done)
							state=DECODE_ADDRESS;
							else if(!parity_done&& !low_pkt_valid)
							state= LOAD_DATA;
							else if(!parity_done&& low_pkt_valid)
							state=LOAD_PARITY;
					end
LOAD_PARITY		:			begin if(soft_reset_0||soft_reset_1||soft_reset_2)
							state= DECODE_ADDRESS;
							else
							state= CHECK_PARITY_ERROR;
							end
CHECK_PARITY_ERROR:      begin if(soft_reset_0||soft_reset_1||soft_reset_2)
							state= DECODE_ADDRESS;
							if(fifo_full)
							state= FIFO_FULL_STATE;
							if(!fifo_full)
							state=DECODE_ADDRESS;
						end
WAIT_TILL_EMPTY	:    	begin  if(soft_reset_0||soft_reset_1||soft_reset_2)
							state= DECODE_ADDRESS;
							if((fifo_empty_0 && (data_in==0))||(fifo_empty_1 && (data_in==1))
							||(fifo_empty_2 && (data_in==2)))							
						state = LOAD_FIRST_DATA;
							else
							state = WAIT_TILL_EMPTY;
						end
default         :      state= DECODE_ADDRESS;    						
						
endcase


end
assign detect_add=(state==DECODE_ADDRESS)?1'b1:1'b0;
assign ld_state=(state==LOAD_DATA)?1'b1:1'b0;
assign lfd_state=(state==LOAD_FIRST_DATA)?1'b1:1'b0;
assign full_state=(state==FIFO_FULL_STATE)?1'b1:1'b0;
assign laf_state= (state==LOAD_AFTER_FULL)?1'b1:1'b0;
assign rst_int_reg=(state==CHECK_PARITY_ERROR)?1'b1:1'b0;
assign write_enb_reg=(state==LOAD_AFTER_FULL||state==LOAD_DATA||state==LOAD_PARITY)?1'b1:1'b0;
assign busy=(state==DECODE_ADDRESS||state==LOAD_DATA)?1'b1:1'b0;
endmodule
			
		



//if(state==DECODE_ADDRESS)assign detect_add=1'b1; 
//if(state==LOAD_FIRST_DATA)assign lfd_state=1'b1;
//if(state==LOAD_DATA) assign ld_state=1'b1;
//if(state==FIFO_FULL_STATE) assign full_state=1'b1;
//if(state==LOAD_AFTER_FULL) assign laf_state=1'b1;
//if(state==CHECK_PARITY_ERROR) assign rst_int_reg=1'b1;
//
//if(state==LOAD_AFTER_FULL||state==LOAD_DATA||state==LOAD_PARITY)
//assign write_enb_reg=1'b1;
//
//if(state==DECODE_ADDRESS||state==LOAD_DATA)
//assign busy=1'b0;
//else
//assign busy=1'b1;	





//if(state=DECODE_ADDRESS)assign detect_add=1'b1; 
//if(state=LOAD_FIRST_DATA)assign lfd_state=1'b1;
//if(state=LOAD_DATA) assign ld_state=1'b1;
//if(state=FIFO_FULL_STATE) assign full_state=1'b1;
//if(state=LOAD_AFTER_FULL) assign laf_state=1'b1;
//if(state=CHECK_PARITY_ERROR) assign rst_int_reg=1'b1;
//
//if(state=LOAD_AFTER_FULL||state=LOAD_DATA||state=LOAD_PARITY)
//assign write_enb_reg=1'b1;
//
//if(state=DECODE_ADDRESS||state=LOAD_DATA)
//assign busy=1'b0;
//else
//assign busy=1'b1;