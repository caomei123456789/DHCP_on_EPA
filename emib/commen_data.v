/*******************************************************************
File name   			:	commen_data.v
Function    			:	1.output the commen data to other modules
 
Version maintenance	:	zourenbo
Version     			:	V1.0
data        			:	2010-12-13
*******************************************************************/

/***************************   modify record   *********************

**************************************************************************
**************************************************************************/
`include "../master_rtl/define/define.v"
module  commen_data(
		input  wire i_clk,
		input  wire i_rst_n,
		
		input  wire i_read_flash_done,
		input  wire i_config_flag,

		output reg  [`ADDR_SZ-1:0] o_emib_addr,		
		output reg  o_rd_ram_en,		
		input  wire [15:0] i_emib_data,
		
		output reg  [47:0] o_local_mac,
		output reg  [15:0] o_frt0_data_len,		
		output reg  [31:0] o_local_node_ip,
		output reg  [31:0] o_first_ip_mask,
		output reg  [31:0] o_second_ip_mask,
		output reg  [31:0] o_macro_cycle_time,
		output reg  [31:0] o_real_cycle_time,
		output reg  [31:0] o_frt_send_time,
		output reg  [15:0] o_ptp_num,
		output reg  [15:0] o_com_num,
		output reg  [15:0] o_device_num,              //modified by SYF 2013.11.4
		output reg  [15:0] o_device_state,
		output reg  o_commen_data_rd_done
);

reg [5:0] State,Nextstate;
reg [5:0] State_dly1,State_dly2,State_dly3;

parameter IDLE = 6'b0000;
parameter GET_LOCAL_MAC_LOW = 6'b10000;
parameter GET_LOCAL_MAC_MID = 6'b10001;
parameter GET_LOCAL_MAC_HIGH = 6'b10010;
parameter GET_LOCAL_IP_LOW = 6'b0001;
parameter GET_LOCAL_IP_HIGH = 6'b0010;
parameter GET_FIRST_MASK_LOW = 6'b0011;
parameter GET_FIRST_MASK_HIGH = 6'b0100;
parameter GET_SECOND_MASK_LOW = 6'b0101;
parameter GET_SECOND_MASK_HIGH = 6'b0110;
parameter GET_FRT0_LEN = 6'b0111;
parameter GET_SUBNET_HOST_NUM = 6'b1000;
parameter GET_MACRO_TIME_LOW = 6'b1001;
parameter GET_MACRO_TIME_HIGH = 6'b1010;
parameter GET_REAL_TIME_LOW = 6'b1011;
parameter GET_REAL_TIME_HIGH = 6'b1100;
parameter GET_SEND_TIMEOFFSET_LOW = 6'b1101;
parameter GET_SEND_TIMEOFFSET_HIGH = 6'b1110;
parameter GET_DEVICE_STATE = 6'b1111;
parameter GET_DONE = 6'b100000;
parameter GET_COM_NUM = 6'b100001;
parameter GET_DEVICE_NUM = 6'b100010;              //modified by SYF 2013.11.4


//state1
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	State <= IDLE;
	State_dly1 <= IDLE;
	State_dly2 <= IDLE;
	State_dly3 <= IDLE;
	end
	else
	begin
	State <= Nextstate;	
	State_dly1 <= State;	
	State_dly2 <= State_dly1;
	State_dly3 <= State_dly2;
	end
end

//state2
always @(*)
begin
	if(!i_rst_n)
	begin
	Nextstate = IDLE;
	end
	else
	case(State)
	IDLE:
		begin
		if(i_read_flash_done && i_config_flag)
		Nextstate = GET_LOCAL_MAC_LOW;	
		else
		Nextstate = IDLE;			
		end
	GET_LOCAL_MAC_LOW:                 //get local mac low 16 bit 	
		begin
		Nextstate = GET_LOCAL_MAC_MID;		
		end		
	GET_LOCAL_MAC_MID:                 //get local mac low 16 bit 	
		begin
		Nextstate = GET_LOCAL_MAC_HIGH;		
		end		
	GET_LOCAL_MAC_HIGH:                 //get local mac low 16 bit 	
		begin
		Nextstate = GET_LOCAL_IP_LOW;		
		end		
	GET_LOCAL_IP_LOW:                 //get local ip low 16 bit 	
		begin
		Nextstate = GET_LOCAL_IP_HIGH;		
		end
	GET_LOCAL_IP_HIGH:                   //get local ip high 16 bit 
		begin
		Nextstate = GET_FIRST_MASK_LOW;			
		end
	GET_FIRST_MASK_LOW:                  //get  first mask low 16 bit	
		begin
 		Nextstate = GET_FIRST_MASK_HIGH;					
		end
	GET_FIRST_MASK_HIGH:                  //get  first mask  high 16 bit
		begin
 		Nextstate = GET_SECOND_MASK_LOW;	 			
		end	
	GET_SECOND_MASK_LOW:                    //get  second mask low 16 bit	
		begin
 		Nextstate = GET_SECOND_MASK_HIGH;			
		end	
	GET_SECOND_MASK_HIGH:                 //get  second mask high 16 bit	
		begin
 		Nextstate = GET_FRT0_LEN;		
		end	
	GET_FRT0_LEN:                        //get frt0 length
		begin
 		Nextstate = GET_SUBNET_HOST_NUM;			
		end	
	GET_SUBNET_HOST_NUM:	              //get sub net device number
		begin
 		Nextstate = GET_MACRO_TIME_LOW;			
		end			
	GET_MACRO_TIME_LOW:	              //get macro cycle time low 16 bit
		begin
 		Nextstate = GET_MACRO_TIME_HIGH;			
		end	
	GET_MACRO_TIME_HIGH:		           //get macro cycle time HIGH 16 bit
		begin
 		Nextstate = GET_REAL_TIME_LOW;			
		end	
	GET_REAL_TIME_LOW:						//get real time low 16 bit
		begin
 		Nextstate = GET_REAL_TIME_HIGH;			
		end	
	GET_REAL_TIME_HIGH:	              	//get real time high 16 bit
		begin
 		Nextstate = GET_SEND_TIMEOFFSET_LOW;			
		end	
	GET_SEND_TIMEOFFSET_LOW:	        	//get send  offset time  low 16 bit
		begin
 		Nextstate = GET_SEND_TIMEOFFSET_HIGH;			
		end	
	GET_SEND_TIMEOFFSET_HIGH:	         //get send  offset time  high 16 bit
		begin
 		Nextstate = GET_COM_NUM;			
		end	
	GET_COM_NUM:
		begin
 		Nextstate = GET_DEVICE_NUM;
		end
	GET_DEVICE_NUM:							//modified by SYF 2013.11.4
		begin
		Nextstate = GET_DEVICE_STATE;			
		end		
	GET_DEVICE_STATE:	                  //get send  offset time  high 16 bit
		begin
 		Nextstate = GET_DONE;			
		end		
	GET_DONE:
		begin
 		Nextstate = IDLE;			
		end	
	default :
		Nextstate = IDLE;				
	endcase
	
end

//state3
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_emib_addr <= `ADDR_SZ'h0;
	o_rd_ram_en <= 1'b0;
	end
	else
	case(Nextstate)
	IDLE:
		begin
		o_emib_addr <= `ADDR_SZ'h0;
		o_rd_ram_en <= 1'b0;
		end
	GET_LOCAL_MAC_LOW:
		begin
		o_emib_addr <= `ADDR_SZ'd44;   //0x002c
		o_rd_ram_en <= 1'b1;
		end		
	GET_LOCAL_MAC_MID:
		begin
		o_emib_addr <= `ADDR_SZ'd45;   //0x002d
		o_rd_ram_en <= 1'b1;
		end	
	GET_LOCAL_MAC_HIGH:
		begin
		o_emib_addr <= `ADDR_SZ'd46;   //0x002e
		o_rd_ram_en <= 1'b1;
		end	
	GET_LOCAL_IP_LOW:
		begin
		o_emib_addr <= `ADDR_SZ'd38;	 //0x0026
		o_rd_ram_en <= 1'b1;	
		end
	GET_LOCAL_IP_HIGH:                
		begin
		o_emib_addr <= `ADDR_SZ'd39;	 //0x0027
		o_rd_ram_en <= 1'b1;		
		end
	GET_FIRST_MASK_LOW:
		begin
		o_emib_addr <= `ADDR_SZ'd40;	 //0x0028
		o_rd_ram_en <= 1'b1;			
		end
	GET_FIRST_MASK_HIGH:
		begin
		o_emib_addr <= `ADDR_SZ'd41;	 //0x0029
		o_rd_ram_en <= 1'b1;			
		end	
	GET_SECOND_MASK_LOW:
		begin
		o_emib_addr <= `ADDR_SZ'd42;	 //0x0030
		o_rd_ram_en <= 1'b1;		
		end	
	GET_SECOND_MASK_HIGH:
		begin
		o_emib_addr <= `ADDR_SZ'd43;	 //0x0031
		o_rd_ram_en <= 1'b1;		
		end		
	GET_FRT0_LEN:                     //modified by SYF 2013.10.17
		begin
		o_emib_addr <= `ADDR_SZ'd89;	 //0x0059
		o_rd_ram_en <= 1'b1;			
		end	
	GET_SUBNET_HOST_NUM:	
		begin
		o_emib_addr <= `ADDR_SZ'd47;	 //0x002f
		o_rd_ram_en <= 1'b1;			
		end	
	GET_MACRO_TIME_LOW:	             //modified by SYF 2013.10.17
		begin
		o_emib_addr <= `ADDR_SZ'd81;	//0x0051
		o_rd_ram_en <= 1'b1;			
		end	
	GET_MACRO_TIME_HIGH:	
		begin
		o_emib_addr <= `ADDR_SZ'd82;	//0x0052
		o_rd_ram_en <= 1'b1;			
		end	
	GET_REAL_TIME_LOW:	
		begin
		o_emib_addr <= `ADDR_SZ'd83;	//0x0053
		o_rd_ram_en <= 1'b1;			
		end
	GET_REAL_TIME_HIGH:	
		begin
		o_emib_addr <= `ADDR_SZ'd84;	//0x0054
		o_rd_ram_en <= 1'b1;			
		end	
	GET_SEND_TIMEOFFSET_LOW:	
		begin
		o_emib_addr <= `ADDR_SZ'd87;	//0x0057
		o_rd_ram_en <= 1'b1;			
		end	
	GET_SEND_TIMEOFFSET_HIGH:	
		begin
		o_emib_addr <= `ADDR_SZ'd88;	//0x0058
		o_rd_ram_en <= 1'b1;			
		end
	GET_COM_NUM:	
		begin
		o_emib_addr <= `ADDR_SZ'd106;	//0x006a
		o_rd_ram_en <= 1'b1;			
		end
	GET_DEVICE_NUM:                             //modified by SYF 2013.11.1
		begin
		o_emib_addr <= `ADDR_SZ'd111;	//0x006f
		o_rd_ram_en <= 1'b1;			
		end	
	GET_DEVICE_STATE:
		begin
		o_emib_addr <= `ADDR_SZ'd52;	//0x0034
		o_rd_ram_en <= 1'b1;			
		end
	GET_DONE:	
		begin
		o_emib_addr <= `ADDR_SZ'd00;	
		o_rd_ram_en <= 1'b0;			
		end		
	default :
		begin
		o_emib_addr <= `ADDR_SZ'd00;	
		o_rd_ram_en <= 1'b0;	
		end
	endcase	
end


always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_frt0_data_len <= 16'h0;
	end
	else if(State_dly3 == GET_FRT0_LEN)
	begin
	o_frt0_data_len <= i_emib_data[15:1];
	end
	else
	begin
	o_frt0_data_len <= o_frt0_data_len ;
	end
end

 

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_local_mac <= 32'h0;
	end
	else if(State_dly3 == GET_LOCAL_MAC_HIGH)
	begin
	o_local_mac[15:0] <= i_emib_data;
	end
	else if(State_dly3 == GET_LOCAL_MAC_MID)
	begin
	o_local_mac[31:16] <= i_emib_data;
	end
	else if(State_dly3 ==  GET_LOCAL_MAC_LOW)
	begin
	o_local_mac[47:32] <= i_emib_data;
	end
	else
	begin
	o_local_mac <= o_local_mac ;
	end
end


always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_ptp_num <= 16'h0;
	end
	else if(State_dly3 == GET_SUBNET_HOST_NUM)
	begin
	o_ptp_num <= i_emib_data;
	end
	else
	begin
	o_ptp_num <= o_frt0_data_len ;
	end
end


always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_local_node_ip <= 32'h0;
	end
	else if(State_dly3 == GET_LOCAL_IP_HIGH)
	begin
	o_local_node_ip[15:0] <= i_emib_data;
	end
	else if(State_dly3 ==  GET_LOCAL_IP_LOW)
	begin
	o_local_node_ip[31:16] <= i_emib_data;
	end
	else
	begin
	o_local_node_ip <= o_local_node_ip ;
	end
end


always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_first_ip_mask <= 32'h0;
	end
	else if(State_dly3 == GET_FIRST_MASK_HIGH)
	begin
	o_first_ip_mask[15:0] <= i_emib_data;
	end
	else if(State_dly3 ==  GET_FIRST_MASK_LOW)
	begin
	o_first_ip_mask[31:16] <= i_emib_data;
	end
	else
	begin
	o_first_ip_mask <= o_first_ip_mask ;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_second_ip_mask <= 32'h0;
	end
	else if(State_dly3 == GET_SECOND_MASK_HIGH)
	begin
	o_second_ip_mask[15:0] <= i_emib_data;
	end
	else if(State_dly3 ==  GET_SECOND_MASK_LOW)
	begin
	o_second_ip_mask[31:16] <= i_emib_data;
	end
	else
	begin
	o_second_ip_mask <= o_second_ip_mask ;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_macro_cycle_time <= 32'h000f4240;              //1ms
	end
	else if(State_dly3 == GET_MACRO_TIME_HIGH)
	begin
	o_macro_cycle_time[15:0] <= i_emib_data;
	end
	else if(State_dly3 ==  GET_MACRO_TIME_LOW)
	begin
	o_macro_cycle_time[31:16] <= i_emib_data;
	end
	else
	begin
	o_macro_cycle_time <= o_macro_cycle_time ;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_real_cycle_time <= 32'h000c3500;              //800us
	end
	else if(State_dly3 == GET_REAL_TIME_HIGH)
	begin
	o_real_cycle_time[15:0] <= i_emib_data;
	end
	else if(State_dly3 == GET_REAL_TIME_LOW)
	begin
	o_real_cycle_time[31:16] <= i_emib_data;
	end
	else
	begin
	o_real_cycle_time <= o_real_cycle_time ;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_frt_send_time <= 32'h0003e800;
	end
	else if(State_dly3 == GET_SEND_TIMEOFFSET_HIGH)
	begin
	o_frt_send_time[15:0] <= i_emib_data;
	end
	else if(State_dly3 == GET_SEND_TIMEOFFSET_LOW) 
	begin
	o_frt_send_time[31:16] <= i_emib_data;
	end
	else
	begin
	o_frt_send_time <= o_frt_send_time ;
	end
end


always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_com_num <= 16'h0;
	end
	else if(State_dly3 == GET_COM_NUM)
	begin
	o_com_num <= i_emib_data;
	end
	else
	begin
	o_com_num <= o_com_num ;
	end
end

//modified by SYF 2013.11.4
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_device_num <= 16'h0;
	end
	else if(State_dly3 == GET_DEVICE_NUM)
	begin
	o_device_num <= i_emib_data;
	end
	else
	begin
	o_device_num <= o_device_num ;
	end
end
////////////////////////////////////////////

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_device_state <= 16'h0;
	end
	else if(State_dly3 == GET_DEVICE_STATE)
	begin
	o_device_state <= i_emib_data;
	end
	else
	begin
	o_device_state <= o_device_state ;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_commen_data_rd_done <= 1'h0;
	end
	else if(State_dly3 == GET_DONE)
	begin
	o_commen_data_rd_done <= 1'b1;
	end
	else
	begin
	o_commen_data_rd_done <= o_commen_data_rd_done;
	end
end
endmodule 