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
module  frt_link_index(
		input  wire i_clk,
		input  wire i_rst_n,
		
		input wire [31:0] i_frt_ip,
		output reg [15:0] o_frt_type,
		input wire [15:0] i_frt_service_role,
		
		input wire i_config_flag,
			
		output reg [15:0] o_link_device_type,           //Modified by SYF 2014.5.8
		output reg [15:0] o_frt_offset_len_local,       //Modified by SYF 2014.5.21
		output reg [15:0] o_frt_data_offset_local,      //Modified by SYF 2014.5.21
		output reg [15:0] o_frt_save_offset_local,      //Modified by SYF 2014.5.21
				
		input wire i_frt_index_irq_local,               //Modified by SYF 2014.5.21
		
		output reg o_frt_index_done_local,              //Modified by SYF 2014.5.21
				
		input wire [15:0] i_ram_data,
		input wire [`ADDR_SZ-1:0] i_ram_addr,
		input wire i_wr_en,
		output reg o_frt_index_error_local,                     //Modified by SYF 2014.5.21
		
		output reg [15:0] o_linkobj_net_num,                    //Modified by SYF 2014.3.4
		output reg [15:0] o_linkobj_net_save_offset,            //Modified by SYF 2014.3.4
		input wire i_frt_index_irq_net,                         //Modified by SYF 2014.3.5
		output reg o_frt_index_done_net,                        //Modified by SYF 2014.3.5
		output reg o_frt_index_error_net,                       //Modified by SYF 2014.3.5
	   output reg [15:0] o_frt_offset_len_net,                 //Modofied by SYF 2014.3.6
		output reg [15:0] o_frt_data_offset_net,
		output reg [15:0] o_frt_save_offset_net,
		input wire i_flag_index,
		input wire [`ADDR_SZ-1:0] i_emib_num_link_obj_addr,    //Modified by SYF 2014.5.13
		input wire [`ADDR_SZ-1:0] i_emib_local_addr,           //Modified by SYF 2014.3.14
		input wire [`ADDR_SZ-1:0] i_emib_net_addr,              //Modified by SYF 2014.3.14
		
		input wire [`ADDR_SZ-1:0] i_plant_ram_addr,             //Modified by SYF 2014.5.22
		input wire i_plant_rd_ram_en,                           //Modified by SYF 2014.5.22
		output wire [15:0] o_plant_ram_data                     //Modified by SYF 2014.5.22
);
reg [4:0] State,Nextstate;


reg [`ADDR_SZ-1:0] o_emib_addr;
//		
reg o_rd_ram_en;
//		
wire [15:0] i_emib_data;


reg [31:0] ip_list;
reg [15:0] link_cnt;
reg [15:0] turn_cnt;
reg [15:0] cnt_irq_net;

//
reg [15:0] role_list,type_list;

wire [`ADDR_SZ-1:0] rd_ram_addr;                         //Modified by SYF 2014.5.22
wire rd_ram_en;                                          //Modified by SYF 2014.5.22

assign o_plant_ram_data = i_emib_data;                   //modified by SYF 2014.5.22
assign rd_ram_addr = i_plant_rd_ram_en? i_plant_ram_addr : o_emib_addr;     //modified by SYF 2013.5.22
assign rd_ram_en = i_plant_rd_ram_en | o_rd_ram_en;      //modified by SYF 2013.5.22

parameter  IDLE = 5'b00000;
parameter  GET_DATA = 5'b00001;
parameter  GET_LINK_CNT = 5'b00010;
parameter  GET_IP_H = 5'b00011;
parameter  GET_IP_L = 5'b00100;
parameter  COMPARE_IP = 5'b00101;
parameter  OUTPUT_DEVICE_TYPE = 5'b00110;
parameter  OUTPUT_DATA_LEN = 5'b00111;
parameter  OUTPUT_DATA_OFFSET = 5'b01000;
parameter  OUTPUT_SAVE_OFFSET = 5'b01001;
parameter  OUTPUT_LINKOBJ_NET_NUM = 5'b01010;              //Modified by SYF 2014.3.4
parameter  OUTPUT_LINKOBJ_NET_SAVE_OFFSET = 5'b01011;      //Modified by SYF 2014.3.4
parameter  GET_NEXT_IP = 5'b01100;
//Modified by SYF 2014.3.5
parameter  COMPARE_NET = 5'b01101;
parameter  OUTPUT_DATA_LEN_NET = 5'b01110;
parameter  OUTPUT_DATA_OFFSET_NET = 5'b01111;
parameter  OUTPUT_SAVE_OFFSET_NET = 5'b10000;
parameter  COMPARE_DONE_WAIT = 5'b10001;
parameter  COMPARE_DONE_NET = 5'b10010;
parameter  COMPARE_ERROR = 5'b10011;

//state1
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	State <= IDLE;
	end
	else
	begin
	State <= Nextstate;	
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
	case(State)//
	IDLE:
		begin
		if(i_frt_index_irq_local && i_config_flag)      //Modified by SYF 2014.5.21
		Nextstate = GET_DATA;	   
		else
		Nextstate = IDLE;			
		end	
	GET_DATA:
		begin
      Nextstate = GET_LINK_CNT;
		end	
   GET_LINK_CNT:
	   begin
		Nextstate = GET_IP_H;
		end
	GET_IP_H:                      
		begin
		Nextstate = GET_IP_L;
		end
	GET_IP_L:                       
		begin
		Nextstate = COMPARE_IP;
		end	
	COMPARE_IP:                     
		begin
		if(ip_list == i_frt_ip)
		Nextstate = OUTPUT_DEVICE_TYPE;	
      else if(turn_cnt >= link_cnt - 1'b1)
		Nextstate = COMPARE_ERROR;	
		else	
		Nextstate = GET_NEXT_IP;
		end
   OUTPUT_DEVICE_TYPE:
	   begin
 		Nextstate = OUTPUT_DATA_LEN;	
		end	
	OUTPUT_DATA_LEN:               //output data length
		begin
 		Nextstate = OUTPUT_DATA_OFFSET;	
		end	
	OUTPUT_DATA_OFFSET:           //output data offset
		begin
 		Nextstate = OUTPUT_SAVE_OFFSET;	
		end		
	OUTPUT_SAVE_OFFSET:                          
		begin
 		Nextstate = OUTPUT_LINKOBJ_NET_NUM;                //Modified by SYF 2014.3.4            
		end
	OUTPUT_LINKOBJ_NET_NUM:
		begin
 		Nextstate = OUTPUT_LINKOBJ_NET_SAVE_OFFSET;                //Modified by SYF 2014.3.4            
		end	
	OUTPUT_LINKOBJ_NET_SAVE_OFFSET:
		begin
 		Nextstate = COMPARE_NET;   //COMPARE_DONE;                 //Modified by SYF 2014.3.4            
		end	
	GET_NEXT_IP:  //compare next ip
		begin
		Nextstate = GET_IP_H;			
		end		
//	COMPARE_DONE:                    //compare done        
//		Nextstate = IDLE;	
		
/***********************************************/
/* Modified by SYF 2014.3.6                    */
/***********************************************/
	COMPARE_NET:
		begin
		if((o_linkobj_net_num - cnt_irq_net)>0)
      begin
 		  if(i_frt_index_irq_net)
        Nextstate = OUTPUT_DATA_LEN_NET;		
		  else
		  Nextstate = COMPARE_NET;	
		end
		else if((i_flag_index == 0) || ((o_linkobj_net_num - cnt_irq_net)==0))
		Nextstate = COMPARE_DONE_NET;
		else 
		Nextstate = COMPARE_ERROR;
		end
   OUTPUT_DATA_LEN_NET:
	   begin
		Nextstate = OUTPUT_DATA_OFFSET_NET;
		end
	OUTPUT_DATA_OFFSET_NET:                      
		begin
		Nextstate = OUTPUT_SAVE_OFFSET_NET;
		end
	OUTPUT_SAVE_OFFSET_NET:                      
		begin
		Nextstate = COMPARE_DONE_WAIT;
      end
   COMPARE_DONE_WAIT:
		begin
		Nextstate = COMPARE_NET;
      end
	COMPARE_DONE_NET:                        
		Nextstate = IDLE;	
/***********************************************/
/* End Modified                                */
/***********************************************/		
	COMPARE_ERROR:
		Nextstate = IDLE;	
	default :
		Nextstate = IDLE;				
	endcase
	
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_emib_addr <= i_emib_local_addr;   
	o_frt_index_done_local <= 1'b0;                  //Modified by SYF 2014.5.21
	o_rd_ram_en <= 1'b0;
	o_frt_index_error_local <= 1'b0;	                //Modified by SYF 2014.5.21
	turn_cnt <= 16'b0;
	o_frt_index_done_net <= 1'b0;       
	o_frt_index_error_net <= 1'b0;
	cnt_irq_net <= 16'b0;
	end
	else
	case(Nextstate)
	IDLE:
		begin
		o_emib_addr <= i_emib_local_addr;      //Modified by SYF 2014.3.14     `ADDR_SZ'd499;
		o_frt_index_done_local <= 1'b0;        //Modified by SYF 2014.5.21
		o_rd_ram_en <= 1'b0;
		o_frt_index_error_local <= 1'b0;	      //Modified by SYF 2014.5.21
		turn_cnt <= 16'b0;
		o_frt_index_done_net <= 1'b0;       
		o_frt_index_error_net <= 1'b0;
		cnt_irq_net <= 16'b0;
		end	
	GET_DATA:
		begin
		o_emib_addr <= i_emib_num_link_obj_addr;                //`ADDR_SZ'h77;         //Modified by SYF 2014.5.13
		o_frt_index_done_local <= 1'b0;                         //Modified by SYF 2014.5.21
		o_rd_ram_en <= 1'b1;
		o_frt_index_error_local <= 1'b0;	                       //Modified by SYF 2014.5.21
		end
	GET_LINK_CNT:
      begin
	   o_emib_addr <= i_emib_local_addr;    //`ADDR_SZ'h100;    //Modified by SYF 2014.5.13
		o_rd_ram_en <= 1'b1;
		end	
	GET_IP_H:
		begin
		o_emib_addr <= o_emib_addr + `ADDR_SZ'd01; 
		o_rd_ram_en <= 1'b1;
		end
	GET_IP_L:
		begin
		o_emib_addr <= o_emib_addr;   
		o_rd_ram_en <= 1'b1;
		end
	COMPARE_IP:
		begin
		o_emib_addr <= o_emib_addr + `ADDR_SZ'd01;               //Modified by SYF 2014.3.4   103       
		o_rd_ram_en <= 1'b1;  
		end
   OUTPUT_DEVICE_TYPE:
		begin
		o_emib_addr <= o_emib_addr + `ADDR_SZ'd01;
		o_rd_ram_en <= 1'b1;
		end
	OUTPUT_DATA_LEN:
		begin
		o_emib_addr <= o_emib_addr + `ADDR_SZ'd01;
		o_rd_ram_en <= 1'b1;
		end	
	OUTPUT_DATA_OFFSET:
		begin
		o_emib_addr <= o_emib_addr + `ADDR_SZ'd01;           //105
		o_rd_ram_en <= 1'b1;
		end
	OUTPUT_SAVE_OFFSET:
		begin
		o_emib_addr <= o_emib_addr+ `ADDR_SZ'd01;           //106
		o_rd_ram_en <= 1'b1;
		end
	OUTPUT_LINKOBJ_NET_NUM:	                             //Modified by SYF 2014.3.4
		begin
		o_emib_addr <= o_emib_addr+ `ADDR_SZ'd01;
		o_rd_ram_en <= 1'b1;
		end	
   OUTPUT_LINKOBJ_NET_SAVE_OFFSET:                      //Modified by SYF 2014.3.4    108
		begin
		o_emib_addr <= o_emib_addr;  //+ `ADDR_SZ'd01;    //Modified by SYF 2014.5.26
		o_rd_ram_en <= 1'b1;
		end	
 	GET_NEXT_IP:	
		begin
		o_emib_addr <= o_emib_addr + `ADDR_SZ'd06;        //Modified by SYF 2014.5.26
		o_rd_ram_en <= 1'b1;
		turn_cnt <= turn_cnt +1'b1;
		end		

/**************************************/
/* Modified by SYF 2014.3.6           */
/**************************************/
	COMPARE_NET:
		begin
		o_emib_addr <= i_emib_net_addr + o_linkobj_net_save_offset[15:0] + 4*cnt_irq_net;
    	o_frt_index_done_local <= 1'b1;                  //Modified by SYF 2014.5.21
		o_frt_index_done_net <= 1'b0;
		o_rd_ram_en <= 1'b1;
		o_frt_index_error_net <= 1'b0;
		end
	OUTPUT_DATA_LEN_NET:
      begin
	   o_emib_addr <= o_emib_addr + `ADDR_SZ'd01;
		o_rd_ram_en <= 1'b1;
		end			
	OUTPUT_DATA_OFFSET_NET:
		begin
		o_emib_addr <= o_emib_addr + `ADDR_SZ'd01;
		o_rd_ram_en <= 1'b1;
		end
	OUTPUT_SAVE_OFFSET_NET:
		begin
		o_emib_addr <= o_emib_addr;
		o_rd_ram_en <= 1'b1;
		end
	COMPARE_DONE_WAIT:
	   begin
		cnt_irq_net <= cnt_irq_net + 1'b1; 
		o_frt_index_done_net <= 1'b1; 
		end
	COMPARE_DONE_NET:
		begin
		o_emib_addr <= i_emib_local_addr;
		o_frt_index_done_local <= 1'b0;               //Modified by SYF 2014.5.21
		o_frt_index_error_local <= 1'b0;              //Modified by SYF 2014.5.21
		o_rd_ram_en <= 1'b0;	
		turn_cnt <= 16'b0;
		o_frt_index_done_net <= 1'b0;       
		o_frt_index_error_net <= 1'b0;
		o_rd_ram_en <= 1'b0;
		cnt_irq_net <= 16'b0;
		end		
/**************************************/
/* End Modified                       */
/**************************************/

	COMPARE_ERROR:
		begin
		o_emib_addr <= i_emib_local_addr;
		o_rd_ram_en <= 1'b0;	
		o_frt_index_done_local <= 1'b0;             //Modified by SYF 2014.5.21
		o_frt_index_error_local <= 1'b1;            //Modified by SYF 2014.5.21
		turn_cnt <= 16'b0;
		o_frt_index_done_net <= 1'b0;               // Modified by SYF 2014.3.7
		o_frt_index_error_net <= 1'b1;
		cnt_irq_net <= 16'b0;
		end
	default :
		begin
		o_emib_addr <= i_emib_local_addr;
		o_frt_index_done_local <= 1'b0;             //Modified by SYF 2014.5.21
		o_frt_index_error_local <= 1'b1;		        //Modified by SYF 2014.5.21
		o_rd_ram_en <= 1'b0;
		turn_cnt <= 16'b0;
		o_frt_index_done_net <= 1'b0;               // Modified by SYF 2014.3.7
		o_frt_index_error_net <= 1'b1;
		cnt_irq_net <= 16'b0;
		end
	endcase
end


/*********************************************************/
always @(posedge i_clk or negedge i_rst_n)    //2013.6.9  by shi yu feng
begin
	if(!i_rst_n)
	begin
	link_cnt <=  16'h0 ;
	end
	else if(State == GET_LINK_CNT)
	begin
	link_cnt <=  i_emib_data ;	
	end
	else if(State == IDLE)
	begin
	link_cnt <=  16'h0 ;
	end	
end
/*********************************************************/

/******************ip list in ram*************************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	ip_list <=  32'h0 ;
	end
	else if(State == GET_IP_H)
	begin
	ip_list[31:16] <=  i_emib_data ;	
	end
	else if(State == GET_IP_L)
	begin
	ip_list[15:0] <=  i_emib_data ;	
	end	
	else if(State == IDLE)
	begin
	ip_list <=  32'h0 ;
	end	
end
/******************end***********************/


/***************output device type******************/   //Modified by SYF 2014.5.8
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_link_device_type <=  16'h0 ;
	end
	else if(State == OUTPUT_DEVICE_TYPE)
	begin
	o_link_device_type  <=  i_emib_data[15:0];	
	end
	else
	begin
	o_link_device_type  <=  o_link_device_type;	
	end	
end
/******************end***********************/

/***************output frt data  len******************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_frt_offset_len_local <=  16'h0 ;                             //Modified by SYF 2014.5.21
	end
	else if(State == OUTPUT_DATA_LEN)
	begin
	o_frt_offset_len_local  <=  i_emib_data[15:1] ;	               //Modified by SYF 2014.5.21
	end
	else
	begin
	o_frt_offset_len_local  <=  o_frt_offset_len_local ;	         //Modified by SYF 2014.5.21
	end	
end
/******************end***********************/

/***************output frt data offset ******************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_frt_data_offset_local <=  16'h0 ;                           //Modified by SYF 2014.5.21
	end
	else if(State == OUTPUT_DATA_OFFSET)
	begin
	o_frt_data_offset_local  <=  i_emib_data[15:1] ;	           //Modified by SYF 2014.5.21
	end
	else 
	begin
	o_frt_data_offset_local  <=  o_frt_data_offset_local ;	     //Modified by SYF 2014.5.21
	end	
end
/******************end***********************/


/***************output frt data  len******************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_frt_save_offset_local <=  16'h0 ;                              //Modified by SYF 2014.5.21
	end
	else if(State == OUTPUT_SAVE_OFFSET)
	begin
	o_frt_save_offset_local  <=  i_emib_data[15:1] ;	              //Modified by SYF 2014.5.21
	end
	else
	begin
	o_frt_save_offset_local  <=  o_frt_save_offset_local ;	        //Modified by SYF 2014.5.21
	end	
end
/******************end***********************/

/***************output frt data  len******************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_linkobj_net_num <=  16'h0 ;
	end
	else if(State == OUTPUT_LINKOBJ_NET_NUM)                 //Modified by SYF 2014.3.4
	begin
	o_linkobj_net_num  <=  i_emib_data[15:0];	
	end
	else
	begin
	o_linkobj_net_num  <=  o_linkobj_net_num;	
	end	
end
/******************end***********************/

/***************output frt data  len******************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_linkobj_net_save_offset <=  16'h0 ;
	end
	else if(State == OUTPUT_LINKOBJ_NET_SAVE_OFFSET)                 //Modified by SYF 2014.3.4
	begin
	o_linkobj_net_save_offset  <=  i_emib_data[15:1];	
	end
	else
	begin
	o_linkobj_net_save_offset  <=  o_linkobj_net_save_offset;	
	end	
end
/******************end***********************/

/********************************************/
/* Modified by SYF 2014.3.6                 */
/********************************************/

/***************output frt data  len******************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_frt_offset_len_net <=  16'h0 ;
	end
	else if(State == OUTPUT_DATA_LEN_NET)
	begin
	o_frt_offset_len_net  <=  i_emib_data[15:1] ;	
	end
	else
	begin
	o_frt_offset_len_net  <=  o_frt_offset_len_net ;	
	end	
end
/******************end***********************/

/***************output frt data offset ******************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_frt_data_offset_net <=  16'h0;
	end
	else if(State == OUTPUT_DATA_OFFSET_NET)
	begin
	o_frt_data_offset_net  <=  i_emib_data[15:1] ;	
	end
	else 
	begin
	o_frt_data_offset_net  <=  o_frt_data_offset_net ;	
	end	
end
/******************end***********************/


/***************output frt data  len******************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_frt_save_offset_net <=  16'h0;
	end
	else if(State == OUTPUT_SAVE_OFFSET_NET)
	begin
	o_frt_save_offset_net  <=  i_emib_data[15:1] ;	
	end
	else
	begin
	o_frt_save_offset_net  <=  o_frt_save_offset_net ;	
	end	
end
/******************end***********************/

/********************************************/
/* End Modified                             */
/********************************************/

emib_ram emib_back(
//	.aclr(i_rst_n),
	.clock(i_clk),
	.data(i_ram_data),
	.rdaddress(rd_ram_addr),      //Modified by SYF 2014.5.22
	.rden(rd_ram_en),             //Modified by SYF 2014.5.22    //o_rd_ram_en
	.wraddress(i_ram_addr),
	.wren(i_wr_en),
	.q(i_emib_data)
	);

endmodule 