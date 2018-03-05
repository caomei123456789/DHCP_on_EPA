/*******************************************************************
File name   			:	commen_data.v
Function    			:	1.output the commen data to other modules
 
Version maintenance	:	SYF
Version     			:	V1.1
data        			:	2014-2-14
*******************************************************************/

/***************************   modify record   *********************

**************************************************************************
**************************************************************************/
`include "../master_rtl/define/define.v"
module  commen_data_updown(
		input  wire i_clk,
		input  wire i_rst_n,
		
		input wire  i_read_flash_done,
		input wire  i_config_flag,

		output reg [`ADDR_SZ-1:0] o_emib_addr,		
		output reg  o_rd_ram_en,		
		input wire [15:0] i_emib_data,
		
		output reg [31:0] o_local_node_ip,		
		output reg [47:0] o_local_node_mac,
		output reg [15:0] o_device_type,
		output reg [15:0] o_device_state,
		output reg [31:0] o_macro_cycle_time_uplayer,
		output reg [31:0] o_real_cycle_time_uplayer,
		output reg [31:0] o_frt_send_time_uplayer,
		output reg [15:0] o_frt0_data_len_uplayer_local,
		output reg [15:0] o_frt0_data_len_uplayer_up,
		output reg [15:0] o_frt0_data_len_uplayer_down,
		output reg [15:0] o_frt0_data_len_uplayer_net,                //Modified by SYF 2014.5.22
		output reg [31:0] o_macro_cycle_time_downlayer,
		output reg [31:0] o_real_cycle_time_downlayer,
		output reg [31:0] o_frt_send_time_downlayer,
		output reg [15:0] o_frt0_data_len_downlayer_local,
		output reg [15:0] o_frt0_data_len_downlayer_up,
		output reg [15:0] o_frt0_data_len_downlayer_down,
		output reg [15:0] o_frt0_data_len_downlayer_net,              //Modified by SYF 2014.5.22
		//***********************************************             //Modified by SYF 2014.4.13
		output reg [15:0] o_num_link_obj_uplayer_local,
		output reg [15:0] o_num_link_obj_uplayer_net,
		output reg [15:0] o_num_device_uplayer,
		output reg [15:0] o_num_link_obj_downlayer_local,
		output reg [15:0] o_num_link_obj_downlayer_net,
		output reg [15:0] o_num_device_downlayer,
		//***********************************************
		output reg o_commen_data_rd_done
		
//		output reg [15:0] o_frt0_data_len,		
//		output reg [31:0] o_first_ip_mask,
//		output reg [31:0] o_second_ip_mask,
//		output reg [15:0] o_ptp_num,
//		output reg [15:0] o_com_num,

);

reg [5:0] State,Nextstate;
reg [5:0] State_dly1,State_dly2,State_dly3;

parameter IDLE = 6'b000000;
parameter GET_LOCAL_IP_LOW = 6'b000001;
parameter GET_LOCAL_IP_HIGH = 6'b000010;
parameter GET_LOCAL_MAC_LOW = 6'b000011;
parameter GET_LOCAL_MAC_MID = 6'b000100;
parameter GET_LOCAL_MAC_HIGH = 6'b000101;
parameter GET_DEVICE_TYPE = 6'b000110;
parameter GET_DEVICE_STATE = 6'b000111;
parameter GET_MACRO_TIME_LOW_UPLAYER = 6'b001000;
parameter GET_MACRO_TIME_HIGH_UPLAYER = 6'b001001;
parameter GET_REAL_TIME_LOW_UPLAYER = 6'b001011;
parameter GET_REAL_TIME_HIGH_UPLAYER = 6'b001100;
parameter GET_SEND_TIMEOFFSET_LOW_UPLAYER = 6'b001101;
parameter GET_SEND_TIMEOFFSET_HIGH_UPLAYER = 6'b001110;
parameter GET_SEND_DATALEN_UPLAYER_LOCAL = 6'b001111;
parameter GET_SEND_DATALEN_UPLAYER_UP = 6'b010000;
parameter GET_SEND_DATALEN_UPLAYER_DOWN = 6'b010001;
parameter GET_SEND_DATALEN_UPLAYER_NET = 6'b010010;                //Modified by SYF 2014.5.22
parameter GET_MACRO_TIME_LOW_DOWNLAYER = 6'b010011;
parameter GET_MACRO_TIME_HIGH_DOWNLAYER = 6'b010100;
parameter GET_REAL_TIME_LOW_DOWNLAYER = 6'b010101;
parameter GET_REAL_TIME_HIGH_DOWNLAYER = 6'b010110;
parameter GET_SEND_TIMEOFFSET_LOW_DOWNLAYER = 6'b010111;
parameter GET_SEND_TIMEOFFSET_HIGH_DOWNLAYER = 6'b011000;
parameter GET_SEND_DATALEN_DOWNLAYER_LOCAL = 6'b011001;
parameter GET_SEND_DATALEN_DOWNLAYER_UP = 6'b011010;
parameter GET_SEND_DATALEN_DOWNLAYER_DOWN = 6'b011011;
parameter GET_SEND_DATALEN_DOWNLAYER_NET = 6'b011100;              //Modifid by SYF 2014.5.22
//****************************************************
parameter GET_NUM_LINK_OBJ_UPLAYER_LOCAL = 6'b011101;                 //Modified by SYF 2014.4.13
parameter GET_NUM_LINK_OBJ_UPLAYER_NET = 6'b011110;
parameter GET_NUM_DEVICE_UPLAYER = 6'b011111;
parameter GET_NUM_LINK_OBJ_DOWNLAYER_LOCAL = 6'b100000;
parameter GET_NUM_LINK_OBJ_DOWNLAYER_NET = 6'b100001;
parameter GET_NUM_DEVICE_DOWNLAYER = 6'b100010;
//****************************************************
parameter GET_DONE = 6'b100011;


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
		Nextstate = GET_LOCAL_IP_LOW;	
		else
		Nextstate = IDLE;			
		end
	GET_LOCAL_IP_LOW:                 //get local mac low 16 bit 	
		begin
		Nextstate = GET_LOCAL_IP_HIGH;		
		end		
	GET_LOCAL_IP_HIGH:                 //get local mac low 16 bit 	
		begin
		Nextstate = GET_LOCAL_MAC_LOW;		
		end		
	GET_LOCAL_MAC_LOW:                 //get local mac low 16 bit 	
		begin
		Nextstate = GET_LOCAL_MAC_MID;		
		end		
	GET_LOCAL_MAC_MID:                 //get local ip low 16 bit 	
		begin
		Nextstate = GET_LOCAL_MAC_HIGH;		
		end
	GET_LOCAL_MAC_HIGH:                   //get local ip high 16 bit 
		begin
		Nextstate = GET_DEVICE_TYPE;			
		end
	GET_DEVICE_TYPE:                  //get  first mask low 16 bit	
		begin
 		Nextstate = GET_DEVICE_STATE;					
		end
	GET_DEVICE_STATE:                  //get  first mask  high 16 bit
		begin
 		Nextstate = GET_MACRO_TIME_LOW_UPLAYER;	 			
		end	
	GET_MACRO_TIME_LOW_UPLAYER:                    //get  second mask low 16 bit	
		begin
 		Nextstate = GET_MACRO_TIME_HIGH_UPLAYER;			
		end	
	GET_MACRO_TIME_HIGH_UPLAYER:                 //get  second mask high 16 bit	
		begin
 		Nextstate = GET_REAL_TIME_LOW_UPLAYER;		
		end	
	GET_REAL_TIME_LOW_UPLAYER:                        //get frt0 length
		begin
 		Nextstate = GET_REAL_TIME_HIGH_UPLAYER;			
		end	
	GET_REAL_TIME_HIGH_UPLAYER:	              //get sub net device number
		begin
 		Nextstate = GET_SEND_TIMEOFFSET_LOW_UPLAYER;			
		end			
	GET_SEND_TIMEOFFSET_LOW_UPLAYER:	              //get macro cycle time low 16 bit
		begin
 		Nextstate = GET_SEND_TIMEOFFSET_HIGH_UPLAYER;			
		end	
	GET_SEND_TIMEOFFSET_HIGH_UPLAYER:		           //get macro cycle time HIGH 16 bit
		begin
 		Nextstate = GET_SEND_DATALEN_UPLAYER_LOCAL;			
		end	
	GET_SEND_DATALEN_UPLAYER_LOCAL:						//get real time low 16 bit
		begin
 		Nextstate = GET_SEND_DATALEN_UPLAYER_UP;			
		end	
	GET_SEND_DATALEN_UPLAYER_UP:	              	//get real time high 16 bit
		begin
 		Nextstate = GET_SEND_DATALEN_UPLAYER_DOWN;			
		end	
	GET_SEND_DATALEN_UPLAYER_DOWN:	        	//get send  offset time  low 16 bit
      begin
 		Nextstate = GET_SEND_DATALEN_UPLAYER_NET;			
		end
	GET_SEND_DATALEN_UPLAYER_NET:	        	//Modified by SYF 2014.5.22
      begin
 		Nextstate = GET_MACRO_TIME_LOW_DOWNLAYER;			
		end
	GET_MACRO_TIME_LOW_DOWNLAYER:                    //get  second mask low 16 bit	
		begin
 		Nextstate = GET_MACRO_TIME_HIGH_DOWNLAYER;			
		end	
	GET_MACRO_TIME_HIGH_DOWNLAYER:                 //get  second mask high 16 bit	
		begin
 		Nextstate = GET_REAL_TIME_LOW_DOWNLAYER;		
		end	
	GET_REAL_TIME_LOW_DOWNLAYER:                        //get frt0 length
		begin
 		Nextstate = GET_REAL_TIME_HIGH_DOWNLAYER;			
		end	
	GET_REAL_TIME_HIGH_DOWNLAYER:	              //get sub net device number
		begin
 		Nextstate = GET_SEND_TIMEOFFSET_LOW_DOWNLAYER;			
		end			
	GET_SEND_TIMEOFFSET_LOW_DOWNLAYER:	              //get macro cycle time low 16 bit
		begin
 		Nextstate = GET_SEND_TIMEOFFSET_HIGH_DOWNLAYER;			
		end	
	GET_SEND_TIMEOFFSET_HIGH_DOWNLAYER:		           //get macro cycle time HIGH 16 bit
		begin
 		Nextstate = GET_SEND_DATALEN_DOWNLAYER_LOCAL;			
		end	
	GET_SEND_DATALEN_DOWNLAYER_LOCAL:						//get real time low 16 bit
		begin
 		Nextstate = GET_SEND_DATALEN_DOWNLAYER_UP;			
		end	
	GET_SEND_DATALEN_DOWNLAYER_UP:	              	//get real time high 16 bit
		begin
 		Nextstate = GET_SEND_DATALEN_DOWNLAYER_DOWN;			
		end	
	GET_SEND_DATALEN_DOWNLAYER_DOWN:	        	//get send  offset time  low 16 bit		
		begin
 		Nextstate = GET_SEND_DATALEN_DOWNLAYER_NET;		//Modified by SYF 2014.4.13	
		end
	GET_SEND_DATALEN_DOWNLAYER_NET:	        	//Modified by SYF 2014.5.22		
		begin
 		Nextstate = GET_NUM_LINK_OBJ_UPLAYER_LOCAL;		//Modified by SYF 2014.4.13	
		end
//******************************************	
   GET_NUM_LINK_OBJ_UPLAYER_LOCAL:
	   begin
		Nextstate = GET_NUM_LINK_OBJ_UPLAYER_NET;		   //Modified by SYF 2014.4.13	
		end
	GET_NUM_LINK_OBJ_UPLAYER_NET:
	   begin
		Nextstate = GET_NUM_DEVICE_UPLAYER;		         //Modified by SYF 2014.4.13	
		end
	GET_NUM_DEVICE_UPLAYER:
	   begin
		Nextstate = GET_NUM_LINK_OBJ_DOWNLAYER_LOCAL;	//Modified by SYF 2014.4.13	
		end
	GET_NUM_LINK_OBJ_DOWNLAYER_LOCAL:
	   begin
		Nextstate = GET_NUM_LINK_OBJ_DOWNLAYER_NET;		//Modified by SYF 2014.4.13	
		end
	GET_NUM_LINK_OBJ_DOWNLAYER_NET:
	   begin
		Nextstate = GET_NUM_DEVICE_DOWNLAYER;		      //Modified by SYF 2014.4.13	
		end
	GET_NUM_DEVICE_DOWNLAYER:
	   begin
		Nextstate = GET_DONE;		                     //Modified by SYF 2014.4.13	
		end
//******************************************	
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
	GET_LOCAL_IP_LOW:
		begin
		o_emib_addr <= `ADDR_SZ'h26;	
		o_rd_ram_en <= 1'b1;	
		end
	GET_LOCAL_IP_HIGH:
		begin
		o_emib_addr <= `ADDR_SZ'h27;	
		o_rd_ram_en <= 1'b1;		
		end
	GET_LOCAL_MAC_LOW:
		begin
		o_emib_addr <= `ADDR_SZ'h2c;//44
		o_rd_ram_en <= 1'b1;
		end		
	GET_LOCAL_MAC_MID:
		begin
		o_emib_addr <= `ADDR_SZ'h2d;//45
		o_rd_ram_en <= 1'b1;
		end	
	GET_LOCAL_MAC_HIGH:
		begin
		o_emib_addr <= `ADDR_SZ'h2e;//
		o_rd_ram_en <= 1'b1;
		end	
//	GET_FIRST_MASK_LOW:
//		begin
//		o_emib_addr <= `ADDR_SZ'd40;	
//		o_rd_ram_en <= 1'b1;			
//		end
//	GET_FIRST_MASK_HIGH:
//		begin
//		o_emib_addr <= `ADDR_SZ'd41;	
//		o_rd_ram_en <= 1'b1;			
//		end	
//	GET_SECOND_MASK_LOW:
//		begin
//		o_emib_addr <= `ADDR_SZ'd42;	
//		o_rd_ram_en <= 1'b1;		
//		end	
//	GET_SECOND_MASK_HIGH:
//		begin
//		o_emib_addr <= `ADDR_SZ'd43;	
//		o_rd_ram_en <= 1'b1;		
//		end		
//	GET_FRT0_LEN:
//		begin
//		o_emib_addr <= `ADDR_SZ'd498;	//50
//		o_rd_ram_en <= 1'b1;			
//		end	
   GET_DEVICE_TYPE:
		begin
		o_emib_addr <= `ADDR_SZ'h33;//
		o_rd_ram_en <= 1'b1;
		end
	GET_DEVICE_STATE:
		begin
		o_emib_addr <= `ADDR_SZ'h34;//
		o_rd_ram_en <= 1'b1;
		end
	GET_MACRO_TIME_LOW_UPLAYER:	
		begin
		o_emib_addr <= `ADDR_SZ'h51;	//d492
		o_rd_ram_en <= 1'b1;			
		end	
	GET_MACRO_TIME_HIGH_UPLAYER:	
		begin
		o_emib_addr <= `ADDR_SZ'h52;	//d493
		o_rd_ram_en <= 1'b1;			
		end	
	GET_REAL_TIME_LOW_UPLAYER:	
		begin
		o_emib_addr <= `ADDR_SZ'h53;	//d494
		o_rd_ram_en <= 1'b1;			
		end
	GET_REAL_TIME_HIGH_UPLAYER:	
		begin
		o_emib_addr <= `ADDR_SZ'h54;	//d495
		o_rd_ram_en <= 1'b1;			
		end	
	GET_SEND_TIMEOFFSET_LOW_UPLAYER:	
		begin
		o_emib_addr <= `ADDR_SZ'h57;	//d496
		o_rd_ram_en <= 1'b1;			
		end	
	GET_SEND_TIMEOFFSET_HIGH_UPLAYER:	
		begin
		o_emib_addr <= `ADDR_SZ'h58;	//d497
		o_rd_ram_en <= 1'b1;			
		end
	GET_SEND_DATALEN_UPLAYER_LOCAL:
		begin
		o_emib_addr <= `ADDR_SZ'h59;	//d498
		o_rd_ram_en <= 1'b1;			
		end
	GET_SEND_DATALEN_UPLAYER_UP:
		begin
		o_emib_addr <= `ADDR_SZ'h5a;	//50
		o_rd_ram_en <= 1'b1;			
		end	
	GET_SEND_DATALEN_UPLAYER_DOWN:
		begin
		o_emib_addr <= `ADDR_SZ'h5b;	//50
		o_rd_ram_en <= 1'b1;			
		end
	GET_SEND_DATALEN_UPLAYER_NET:              //Modified by SYF 2014.5.22
		begin
		o_emib_addr <= `ADDR_SZ'h5C;	//50         
		o_rd_ram_en <= 1'b1;			
		end
	GET_MACRO_TIME_LOW_DOWNLAYER:	
		begin
		o_emib_addr <= `ADDR_SZ'h5d;	//81      //Modified by SYF 2014.5.22  
		o_rd_ram_en <= 1'b1;			
		end	
	GET_MACRO_TIME_HIGH_DOWNLAYER:	
		begin
		o_emib_addr <= `ADDR_SZ'h5e;	//82      //Modified by SYF 2014.5.22
		o_rd_ram_en <= 1'b1;			
		end	
	GET_REAL_TIME_LOW_DOWNLAYER:	
		begin
		o_emib_addr <= `ADDR_SZ'h5f;	//83      //Modified by SYF 2014.5.22
		o_rd_ram_en <= 1'b1;			
		end
	GET_REAL_TIME_HIGH_DOWNLAYER:	
		begin
		o_emib_addr <= `ADDR_SZ'h60;	//84      //Modified by SYF 2014.5.22
		o_rd_ram_en <= 1'b1;			
		end	
	GET_SEND_TIMEOFFSET_LOW_DOWNLAYER:	
		begin
		o_emib_addr <= `ADDR_SZ'h61;	//87      //Modified by SYF 2014.5.22
		o_rd_ram_en <= 1'b1;			
		end	
	GET_SEND_TIMEOFFSET_HIGH_DOWNLAYER:	
		begin
		o_emib_addr <= `ADDR_SZ'h62;	//88      //Modified by SYF 2014.5.22
		o_rd_ram_en <= 1'b1;			
		end
	GET_SEND_DATALEN_DOWNLAYER_LOCAL:
		begin
		o_emib_addr <= `ADDR_SZ'h63;	//50      //Modified by SYF 2014.5.22
		o_rd_ram_en <= 1'b1;			
		end
	GET_SEND_DATALEN_DOWNLAYER_UP:
		begin
		o_emib_addr <= `ADDR_SZ'h64;	//50      //Modified by SYF 2014.5.22
		o_rd_ram_en <= 1'b1;			
		end	
	GET_SEND_DATALEN_DOWNLAYER_DOWN:
		begin
		o_emib_addr <= `ADDR_SZ'h65;	//50      //Modified by SYF 2014.5.22
		o_rd_ram_en <= 1'b1;			
		end
 	GET_SEND_DATALEN_DOWNLAYER_NET:
		begin
		o_emib_addr <= `ADDR_SZ'h66;	//50      //Modified by SYF 2014.5.22
		o_rd_ram_en <= 1'b1;			
		end		
//***************************************	          //Modified by SYF 2014.4.13
	GET_NUM_LINK_OBJ_UPLAYER_LOCAL:
	   begin
		o_emib_addr <= `ADDR_SZ'h77;	//50      //Modified by SYF 2014.5.22
		o_rd_ram_en <= 1'b1;			
		end
	GET_NUM_LINK_OBJ_UPLAYER_NET:
	   begin
		o_emib_addr <= `ADDR_SZ'h7c;	//50      //Modified by SYF 2014.5.22
		o_rd_ram_en <= 1'b1;			
		end
	GET_NUM_DEVICE_UPLAYER:
	   begin
		o_emib_addr <= `ADDR_SZ'h81;	//50      //Modified by SYF 2014.5.22
		o_rd_ram_en <= 1'b1;			
		end
	GET_NUM_LINK_OBJ_DOWNLAYER_LOCAL:
	   begin
		o_emib_addr <= `ADDR_SZ'h84;	//50      //Modified by SYF 2014.5.22
		o_rd_ram_en <= 1'b1;			
		end
	GET_NUM_LINK_OBJ_DOWNLAYER_NET:
	   begin
		o_emib_addr <= `ADDR_SZ'h89;	//50      //Modified by SYF 2014.5.22
		o_rd_ram_en <= 1'b1;			
		end
	GET_NUM_DEVICE_DOWNLAYER:
	   begin
		o_emib_addr <= `ADDR_SZ'h8e;	//50      //Modified by SYF 2014.5.22
		o_rd_ram_en <= 1'b1;			
		end
//***************************************
//	GET_COM_NUM:	
//		begin
//		o_emib_addr <= `ADDR_SZ'd499;	//88
//		o_rd_ram_en <= 1'b1;			
//		end	
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


//always @(posedge i_clk or negedge i_rst_n)
//begin
//	if(!i_rst_n)
//	begin
//	o_frt0_data_len <= 16'h0;
//	end
//	else if(State_dly3 == GET_FRT0_LEN)
//	begin
//	o_frt0_data_len <= i_emib_data[15:1];
//	end
//	else
//	begin
//	o_frt0_data_len <= o_frt0_data_len ;
//	end
//end

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
	o_local_node_ip <= o_local_node_ip;
	end
end 

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_local_node_mac <= 32'h0;
	end
	else if(State_dly3 == GET_LOCAL_MAC_HIGH)
	begin
	o_local_node_mac[15:0] <= i_emib_data;
	end
	else if(State_dly3 == GET_LOCAL_MAC_MID)
	begin
	o_local_node_mac[31:16] <= i_emib_data;
	end
	else if(State_dly3 ==  GET_LOCAL_MAC_LOW)
	begin
	o_local_node_mac[47:32] <= i_emib_data;
	end
	else
	begin
	o_local_node_mac <= o_local_node_mac ;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_device_type <= 16'h0;
	end
	else if(State_dly3 == GET_DEVICE_TYPE)
	begin
	o_device_type <= i_emib_data;
	end
	else
	begin
	o_device_type <= o_device_type;
	end
end

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
	o_device_state <= o_device_state;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_macro_cycle_time_uplayer <= 32'h000f4240;
	end
	else if(State_dly3 == GET_MACRO_TIME_HIGH_UPLAYER)
	begin
	o_macro_cycle_time_uplayer[15:0] <= i_emib_data;
	end
	else if(State_dly3 ==  GET_MACRO_TIME_LOW_UPLAYER)
	begin
	o_macro_cycle_time_uplayer[31:16] <= i_emib_data;
	end
	else
	begin
	o_macro_cycle_time_uplayer <= o_macro_cycle_time_uplayer;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_real_cycle_time_uplayer <= 32'h000c3500;
	end
	else if(State_dly3 == GET_REAL_TIME_HIGH_UPLAYER)
	begin
	o_real_cycle_time_uplayer[15:0] <= i_emib_data;
	end
	else if(State_dly3 == GET_REAL_TIME_LOW_UPLAYER)
	begin
	o_real_cycle_time_uplayer[31:16] <= i_emib_data;
	end
	else
	begin
	o_real_cycle_time_uplayer <= o_real_cycle_time_uplayer;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_frt_send_time_uplayer <= 32'h0003e800;
	end
	else if(State_dly3 == GET_SEND_TIMEOFFSET_HIGH_UPLAYER)
	begin
	o_frt_send_time_uplayer[15:0] <= i_emib_data;
	end
	else if(State_dly3 == GET_SEND_TIMEOFFSET_LOW_UPLAYER) 
	begin
	o_frt_send_time_uplayer[31:16] <= i_emib_data;
	end
	else
	begin
	o_frt_send_time_uplayer <= o_frt_send_time_uplayer;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_frt0_data_len_uplayer_local <= 16'h20;
	end
	else if(State_dly3 == GET_SEND_DATALEN_UPLAYER_LOCAL)
	begin
	o_frt0_data_len_uplayer_local <= i_emib_data[15:1];
	end
	else
	begin
	o_frt0_data_len_uplayer_local <= o_frt0_data_len_uplayer_local;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_frt0_data_len_uplayer_up <= 16'h0;
	end
	else if(State_dly3 == GET_SEND_DATALEN_UPLAYER_UP)
	begin
	o_frt0_data_len_uplayer_up <= i_emib_data[15:1];
	end
	else
	begin
	o_frt0_data_len_uplayer_up <= o_frt0_data_len_uplayer_up;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_frt0_data_len_uplayer_down <= 16'h0;
	end
	else if(State_dly3 == GET_SEND_DATALEN_UPLAYER_DOWN)
	begin
	o_frt0_data_len_uplayer_down <= i_emib_data[15:1];
	end
	else
	begin
	o_frt0_data_len_uplayer_down <= o_frt0_data_len_uplayer_down;
	end
end

always @(posedge i_clk or negedge i_rst_n)            //Modified by SYF 2014.5.22
begin
	if(!i_rst_n)
	begin
	o_frt0_data_len_uplayer_net <= 16'h0;
	end
	else if(State_dly3 == GET_SEND_DATALEN_UPLAYER_NET)
	begin
	o_frt0_data_len_uplayer_net <= i_emib_data[15:1];
	end
	else
	begin
	o_frt0_data_len_uplayer_net <= o_frt0_data_len_uplayer_net;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_macro_cycle_time_downlayer <= 32'h000f4240;
	end
	else if(State_dly3 == GET_MACRO_TIME_HIGH_DOWNLAYER)
	begin
	o_macro_cycle_time_downlayer[15:0] <= i_emib_data;
	end
	else if(State_dly3 ==  GET_MACRO_TIME_LOW_DOWNLAYER)
	begin
	o_macro_cycle_time_downlayer[31:16] <= i_emib_data;
	end
	else
	begin
	o_macro_cycle_time_downlayer <= o_macro_cycle_time_downlayer;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_real_cycle_time_downlayer <= 32'h000c3500;
	end
	else if(State_dly3 == GET_REAL_TIME_HIGH_DOWNLAYER)
	begin
	o_real_cycle_time_downlayer[15:0] <= i_emib_data;
	end
	else if(State_dly3 == GET_REAL_TIME_LOW_DOWNLAYER)
	begin
	o_real_cycle_time_downlayer[31:16] <= i_emib_data;
	end
	else
	begin
	o_real_cycle_time_downlayer <= o_real_cycle_time_downlayer;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_frt_send_time_downlayer <= 32'h0003e800;
	end
	else if(State_dly3 == GET_SEND_TIMEOFFSET_HIGH_DOWNLAYER)
	begin
	o_frt_send_time_downlayer[15:0] <= i_emib_data;
	end
	else if(State_dly3 == GET_SEND_TIMEOFFSET_LOW_DOWNLAYER) 
	begin
	o_frt_send_time_downlayer[31:16] <= i_emib_data;
	end
	else
	begin
	o_frt_send_time_downlayer <= o_frt_send_time_downlayer;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_frt0_data_len_downlayer_local <= 16'h0;
	end
	else if(State_dly3 == GET_SEND_DATALEN_DOWNLAYER_LOCAL)
	begin
	o_frt0_data_len_downlayer_local <= i_emib_data[15:1];
	end
	else
	begin
	o_frt0_data_len_downlayer_local <= o_frt0_data_len_downlayer_local;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_frt0_data_len_downlayer_up <= 16'h0;
	end
	else if(State_dly3 == GET_SEND_DATALEN_DOWNLAYER_UP)
	begin
	o_frt0_data_len_downlayer_up <= i_emib_data[15:1];
	end
	else
	begin
	o_frt0_data_len_downlayer_up <= o_frt0_data_len_downlayer_up;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_frt0_data_len_downlayer_down <= 16'h0;
	end
	else if(State_dly3 == GET_SEND_DATALEN_DOWNLAYER_DOWN)
	begin
	o_frt0_data_len_downlayer_down <= i_emib_data[15:1];
	end
	else
	begin
	o_frt0_data_len_downlayer_down <= o_frt0_data_len_downlayer_down;
	end
end

always @(posedge i_clk or negedge i_rst_n)           //Modified by SYF 2014.5.22
begin
	if(!i_rst_n)
	begin
	o_frt0_data_len_downlayer_net <= 16'h0;
	end
	else if(State_dly3 == GET_SEND_DATALEN_DOWNLAYER_NET)
	begin
	o_frt0_data_len_downlayer_net <= i_emib_data[15:1];
	end
	else
	begin
	o_frt0_data_len_downlayer_net <= o_frt0_data_len_downlayer_net;
	end
end

//****************************************                   //Modified by SYF 2014.4.13
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_num_link_obj_uplayer_local <= 16'h0;
	end
	else if(State_dly3 == GET_NUM_LINK_OBJ_UPLAYER_LOCAL)
	begin
	o_num_link_obj_uplayer_local <= i_emib_data;
	end
	else
	begin
	o_num_link_obj_uplayer_local <= o_num_link_obj_uplayer_local;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_num_link_obj_uplayer_net <= 16'h0;
	end
	else if(State_dly3 == GET_NUM_LINK_OBJ_UPLAYER_NET)
	begin
	o_num_link_obj_uplayer_net <= i_emib_data;
	end
	else
	begin
	o_num_link_obj_uplayer_net <= o_num_link_obj_uplayer_net;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_num_device_uplayer <= 16'h0;
	end
	else if(State_dly3 == GET_NUM_DEVICE_UPLAYER)
	begin
	o_num_device_uplayer <= i_emib_data;
	end
	else
	begin
	o_num_device_uplayer <= o_num_device_uplayer;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_num_link_obj_downlayer_local <= 16'h0;
	end
	else if(State_dly3 == GET_NUM_LINK_OBJ_DOWNLAYER_LOCAL)
	begin
	o_num_link_obj_downlayer_local <= i_emib_data;
	end
	else
	begin
	o_num_link_obj_downlayer_local <= o_num_link_obj_downlayer_local;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_num_link_obj_downlayer_net <= 16'h0;
	end
	else if(State_dly3 == GET_NUM_LINK_OBJ_DOWNLAYER_NET)
	begin
	o_num_link_obj_downlayer_net <= i_emib_data;
	end
	else
	begin
	o_num_link_obj_downlayer_net <= o_num_link_obj_downlayer_net;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_num_device_downlayer <= 16'h0;
	end
	else if(State_dly3 == GET_NUM_DEVICE_DOWNLAYER)
	begin
	o_num_device_downlayer <= i_emib_data;
	end
	else
	begin
	o_num_device_downlayer <= o_num_device_downlayer;
	end
end

//****************************************

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