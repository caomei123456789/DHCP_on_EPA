/*******************************************************************
File name   			:	emib.v
Function    			:	1.joins sub modules  together;
								2.provides pins connect with external module;
 
Version maintenance	:	zourenbo
Version     			:	V1.0
data        			:	2010-12-13
*******************************************************************/

/***************************   modify record   *********************

**************************************************************************
**************************************************************************/

`include "../master_rtl/define/define.v"
module  emib(
		input  wire i_clk,
		input  wire i_rst_n,

/***************MM signals*************************/	
		input  wire [15:0] dobjid,
		input  wire [15:0] subidx,
		input  wire i_rd_en,
		input  wire i_wr_en,
		input  wire [15:0] i_mm_data,
		output wire [`ADDR_SZ-1:0] base_addr,
		output wire [15:0] o_mm_data,
		input wire  i_rd_rsp_en,
		output wire o_write_done,
		output wire o_read_done,
		output wire o_write_error,
		output wire o_read_error,
		output wire [`ADDR_SZ-1:0] o_mm_data_len,
		
		input wire [15:0] i_frt_linknum_up,                          //modified by SYF 2014.4.25
		input wire [15:0] i_frt_linknum_down,                        //modified by SYF 2014.4.25
		input wire [15:0] i_frt_linknum_net_up,                      //Modified by SYF 2014.5.20
		input wire [15:0] i_frt_linknum_net_down,                    //Modified by SYF 2014.5.20
	   input wire [15:0] i_device_setnum_up,                        //modified by SYF 2014.4.25
		input wire [15:0] i_device_setnum_down,                      //modified by SYF 2014.4.25
		
/***************OPC signals*************************/
		input wire i_wr_ram_en,
		input wire [`RAM_WIDTH-1:0] i_opc_to_emib_data,
		input wire [`ADDR_SZ-1:0] i_opc_data_len,	
		input wire i_config_done,

/***************flash interface signals*************************/		
		input wire  [`ADDR_SZ-1:0] i_flash_raddr,
		output wire o_flash_rd_irq,
		input wire  i_flash_rd_en,
		output wire [15:0] o_flash_data,
		
		input wire  [`ADDR_SZ-1:0] i_flash_waddr,
		input wire  [15:0] i_flash_data,	
		input wire  i_flash_wr_en,
		output wire o_flash_wr_irq,
		input wire  i_read_flash_done,
		
		output wire [`ADDR_SZ-1:0] o_flash_addr_offset,
		output wire [`ADDR_SZ-1:0] o_flash_data_len,
		
/***************plant index signals*************************/		 //modified by SYF 2014.5.21		
		input wire  [`ADDR_SZ-1:0] i_emib_device_property_addr_up,
		input  wire i_plant_index_irq_up,
		output wire o_plant_index_done_up,
		output wire o_plant_index_error_up,
		
		input  wire [47:0] i_frt_mac_up,
		output wire [31:0] o_plant_ip_up,
		output wire [31:0] o_plant_toffset_up,
		output wire [15:0] o_plant_datalen_up,
		output wire [15:0] o_plant_interval_up,
      
		input wire  [`ADDR_SZ-1:0] i_emib_device_property_addr_down,
      input  wire i_plant_index_irq_down,
		output wire o_plant_index_done_down,
		output wire o_plant_index_error_down,
		
		input  wire [47:0] i_frt_mac_down,
		output wire [31:0] o_plant_ip_down,
		output wire [31:0] o_plant_toffset_down,
		output wire [15:0] o_plant_datalen_down,
		output wire [15:0] o_plant_interval_down,
		
/***************frt interface signals*************************/				
		input wire  [31:0] i_frt_ip_up,
		output wire [15:0] o_frt_type,
		input wire  [15:0] i_frt_service_role,	
		
		output wire [15:0] o_link_device_type_up,              //Modified by SYF 2014.5.8
		output wire [15:0] o_frt_offset_len_local_up,          //Modified by SYF 2014.5.21
		output wire [15:0] o_frt_data_offset_local_up,         //Modified by SYF 2014.5.21
		output wire [15:0] o_frt_save_offset_local_up,         //Modified by SYF 2014.5.21

		input wire  i_frt_index_irq_local_up,                  //Modified by SYF 2014.5.21
		output wire o_frt_index_done_local_up,                 //Modified by SYF 2014.5.21
		output wire o_frt_index_error_local_up,                //Modified by SYF 2014.5.21
		
		output wire [15:0] o_linkobj_net_num_up,               //Modified by SYF 2014.3.5
		input wire  i_frt_index_irq_net_up,                    //Modified by SYF 2014.3.5        
		output wire o_frt_index_done_net_up,                   //Modified by SYF 2014.3.5
		output wire o_frt_index_error_net_up,	                //Modified by SYF 2014.3.5
		output wire [15:0] o_frt_offset_len_net_up,            //Modified by SYF 2014.3.6
		output wire [15:0] o_frt_data_offset_net_up,
		output wire [15:0] o_frt_save_offset_net_up,
		input wire  i_flag_index_up,
/***************commen_data signals*************************/	    //Modified by SYF 2014.2.14
		output wire [31:0] o_local_node_ip,		
		output wire [47:0] o_local_node_mac,
		output wire [15:0] o_device_type,
		output wire [15:0] o_device_state,
		output wire [31:0] o_macro_cycle_time_uplayer,
		output wire [31:0] o_real_cycle_time_uplayer,
		output wire [31:0] o_frt_send_time_uplayer,
		output wire [15:0] o_frt0_data_len_uplayer_local,
		output wire [15:0] o_frt0_data_len_uplayer_up,
		output wire [15:0] o_frt0_data_len_uplayer_down,
		output wire [15:0] o_frt0_data_len_uplayer_net,               //Modified by SYF 2014.5.22
		output wire [31:0] o_macro_cycle_time_downlayer,
		output wire [31:0] o_real_cycle_time_downlayer,
		output wire [31:0] o_frt_send_time_downlayer,
		output wire [15:0] o_frt0_data_len_downlayer_local,
		output wire [15:0] o_frt0_data_len_downlayer_up,
		output wire [15:0] o_frt0_data_len_downlayer_down,
		output wire [15:0] o_frt0_data_len_downlayer_net,             //Modified by SYF 2014.5.22
		//***********************************************              //Modified by SYF 2014.4.13
		output wire [15:0] o_num_link_obj_uplayer_local,
		output wire [15:0] o_num_link_obj_uplayer_net,
		output wire [15:0] o_num_device_uplayer,
		output wire [15:0] o_num_link_obj_downlayer_local,
		output wire [15:0] o_num_link_obj_downlayer_net,
		output wire [15:0] o_num_device_downlayer,
		//***********************************************
		output wire o_commen_data_rd_done,
		input wire  [`ADDR_SZ-1:0] i_emib_num_link_obj_addr_up,     //Modified by SYF 2014.5.13
		input wire  [`ADDR_SZ-1:0] i_emib_local_addr_up,           //Modified by SYF 2014.3.14
		input wire  [`ADDR_SZ-1:0] i_emib_net_addr_up,              //Modified by SYF 2014.3.14

//Modified by SYF 2014.3.17  for CD interface
		input wire  [31:0] i_frt_ip_down,	
		output wire [15:0] o_link_device_type_down,               //Modified by SYF 2014.5.8
		output wire [15:0] o_frt_offset_len_local_down,           //Modified by SYF 2014.5.21
		output wire [15:0] o_frt_data_offset_local_down,	       //Modified by SYF 2014.5.21
		output wire [15:0] o_frt_save_offset_local_down,		    //Modified by SYF 2014.5.21
		input wire  i_frt_index_irq_local_down,		             //Modified by SYF 2014.5.21
		output wire o_frt_index_done_local_down,                  //Modified by SYF 2014.5.21
		output wire o_frt_index_error_local_down,		             //Modified by SYF 2014.5.21
		output wire [15:0] o_linkobj_net_num_down,                
		input wire  i_frt_index_irq_net_down,	
		output wire o_frt_index_done_net_down,        //Modified by SYF 2014.5.13
		output wire o_frt_index_error_net_down,       //Modified by SYF 2014.5.13
	   output wire [15:0] o_frt_offset_len_net_down,
		output wire [15:0] o_frt_data_offset_net_down,
		output wire [15:0] o_frt_save_offset_net_down,
		input wire  i_flag_index_down,
		input wire  [`ADDR_SZ-1:0] i_emib_num_link_obj_addr_down,     //Modified by SYF 2014.5.13
		input wire  [`ADDR_SZ-1:0] i_emib_local_addr_down,
		input wire  [`ADDR_SZ-1:0] i_emib_net_addr_down
		
);

reg config_done_flag;						//modified by guhao 20131220
wire o_config_done;                    //Modified by SYF 2014.5.28

/******************test**************************/


wire [`ADDR_SZ-1:0] emib_back_addr;
wire [15:0] emib_back_data;
wire emib_back_wr_en;


/******************end**************************/

wire [`ADDR_SZ-1:0] offset_addr;
wire [`ADDR_SZ-1:0] offset_len ;

wire [`ADDR_SZ-1:0]  add_addr_write,add_addr_read;

wire [3:0] subid_num;
wire error;




/******** emib_ram  signals *********/
wire  ram_rd_en,ram_wr_en;
wire  [15:0] ram_data_in,ram_data_out;
wire  [`ADDR_SZ-1:0] wr_ram_addr,rd_ram_addr ;
/*************** end **************/

wire [`ADDR_SZ-1:0] emib_wr_address,emib_rd_address,frt_emib_addr,commen_emib_addr;
wire [15:0] emib_wr_data,emib_rd_data,frt_emib_data ,commen_data;

wire  frt_rd_ram_en ,rd_en,wr_en,commen_rd_en ;

reg output_flag,output_flag_reg;

reg [15:0] config_status;

reg [`ADDR_SZ-1:0] i_flash_waddr_dly1;        //modified by SYF 2013.11.5

//assign emib_wr_address = base_addr + offset_addr+add_addr_write ;
//
//assign emib_rd_address = base_addr + offset_addr+add_addr_read ;

wire [`ADDR_SZ-1:0] plant_rd_ram_addr_up;            //modified by SYF 2014.5.28
wire plant_rd_ram_en_up;                             //modified by SYF 2014.5.28
wire [15:0] emib_back_ram_data_up;                   //modified by SYF 2014.5.28

wire [`ADDR_SZ-1:0] plant_rd_ram_addr_down;            //modified by SYF 2014.5.28
wire plant_rd_ram_en_down;                             //modified by SYF 2014.5.28
wire [15:0] emib_back_ram_data_down;                   //modified by SYF 2014.5.28


/*************************test**************************/
assign emib_back_addr =  i_flash_waddr_dly1 | i_flash_raddr ;            //modified by SYF 2013.11.5

assign emib_back_data =  o_flash_data | i_flash_data ;

assign emib_back_wr_en =  i_flash_rd_en | i_flash_wr_en ;

/*************************end**************************/

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	i_flash_waddr_dly1 <= `ADDR_SZ'b0;        //modified by SYF 2013.11.5
	end
	else
	begin
	i_flash_waddr_dly1 <= i_flash_waddr;      //modified by SYF 2013.11.5
	end
end
/******************************************************/

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		output_flag <= 1'b0;
	end
	else if(((dobjid == 16'h2)&&(subidx == 16'he)) || i_config_done )
	begin
		output_flag <= 1'b1;
	end
	else 
	begin
		output_flag <= 1'b0;
	end
end



always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		config_status <= 16'b0;
	end
	else if(i_flash_waddr_dly1 == `ADDR_SZ'd52)          //modified by SYF 2013.11.5
	begin
		config_status <= i_flash_data;
	end
	else 
	begin
		config_status <= 16'b0;
	end
end



always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		config_done_flag <= 1'b0;
	end
	else if(config_status == 16'h2)
	begin
		config_done_flag <= 1'b1;
	end
end

//
//always @(posedge i_clk or negedge i_rst_n)
//begin
//	if(!i_rst_n)
//	begin
//		output_flag_reg <= 1'b0;
//	end
//	else 
//	begin
//		output_flag_reg <= output_flag;
//	end
//end	



/***********emib ram*********/
emib_ram mem(
//	.aclr(i_rst_n),
	.clock(i_clk),
	.data(ram_data_in),
	.rdaddress(rd_ram_addr),
	.rden(ram_rd_en),
	.wraddress(wr_ram_addr),
	.wren(ram_wr_en),
	.q(ram_data_out)
	);
/**************end*************/



/************od module**************/
od      od1(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_dobjid(dobjid),
		.i_subidx(subidx),
		.i_frt_linknum_up(i_frt_linknum_up),                 //modified by SYF 2014.5.20
		.i_frt_linknum_down(i_frt_linknum_down),             //modified by SYF 2014.5.20
		.i_frt_linknum_net_up(i_frt_linknum_net_up),         //modified by SYF 2014.5.20
		.i_frt_linknum_net_down(i_frt_linknum_net_down),     //modified by SYF 2014.5.20
		.i_device_num_up(i_device_setnum_up),                //modified by SYF 2014.5.20
		.i_device_num_down(i_device_setnum_down),            //modified by SYF 2014.5.20
		.o_base_addr(base_addr),
		.o_offset_addr(offset_addr),
		.o_offset_len(offset_len),
		.o_error(error)
);
/**************end*************/


/************write emib module**************/
write_emib  write_emib1(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_wr_en(i_wr_en),
		.i_error(error),
		.i_mm_to_emib_data(i_mm_data),
		.i_mm_data_len(offset_len),
		
		.i_wr_ram_en(i_wr_ram_en),
		.i_opc_to_emib_data(i_opc_to_emib_data),
		.i_opc_data_len(i_opc_data_len),	
		
		.i_base_addr(base_addr),
		.i_offset_addr(offset_addr),
		
		.o_emib_data(emib_wr_data),
		.o_emib_addr(emib_wr_address),
		.o_wr_en(wr_en),
		.o_write_error(o_write_error),
		.o_write_done(o_write_done),
		.o_config_done(o_config_done)
);
/**************end*************/

/************read emib module**************/
read_emib  read_emib1(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_rd_en(i_rd_en),
		.i_error(error),
		.i_emib_to_mm_data(emib_rd_data),
		.i_mm_data_len(offset_len),
		.o_mm_data(o_mm_data),
		.o_mm_addr(emib_rd_address),
		.i_base_addr(base_addr),
		.i_offset_addr(offset_addr),
		.i_rd_rsp_en(i_rd_rsp_en),
		.o_rd_en(rd_en),
		.o_read_error(o_read_error),
		.o_read_done(o_read_done),
		.o_mm_data_len(o_mm_data_len)
);
/**************end*************/

/************frt link object index module**************/
frt_link_index		frt_link_index_local(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),		
		.i_frt_ip(i_frt_ip_up),
		.o_frt_type(o_frt_type),
		.i_frt_service_role(i_frt_service_role),
	   .o_link_device_type(o_link_device_type_up),                      //Modified by SYF 2014.5.28	
		.o_frt_offset_len_local(o_frt_offset_len_local_up),              //Modified by SYF 2014.5.21
		.o_frt_data_offset_local(o_frt_data_offset_local_up),	           //Modified by SYF 2014.5.21
		.o_frt_save_offset_local(o_frt_save_offset_local_up),		        //Modified by SYF 2014.5.21
		.i_frt_index_irq_local(i_frt_index_irq_local_up),		           //Modified by SYF 2014.5.21
		.o_frt_index_done_local(o_frt_index_done_local_up),              //Modified by SYF 2014.5.21
		.o_frt_index_error_local(o_frt_index_error_local_up),		        //Modified by SYF 2014.5.21
		.i_config_flag(config_done_flag),
		.i_ram_data(emib_back_data),
		.i_ram_addr(emib_back_addr),
		.i_wr_en	(emib_back_wr_en),
		.o_linkobj_net_num(o_linkobj_net_num_up),      //Modified by SYF 2014.3.5
		.i_frt_index_irq_net(i_frt_index_irq_net_up),	    //Modified by SYF 2014.3.5	
		.o_frt_index_done_net(o_frt_index_done_net_up),     //Modified by SYF 2014.3.5
		.o_frt_index_error_net(o_frt_index_error_net_up),	 //Modified by SYF 2014.3.5
	   .o_frt_offset_len_net(o_frt_offset_len_net_up),                  //Modofied by SYF 2014.3.6
		.o_frt_data_offset_net(o_frt_data_offset_net_up),
		.o_frt_save_offset_net(o_frt_save_offset_net_up),
		.i_flag_index(i_flag_index_up),
		.i_emib_num_link_obj_addr(i_emib_num_link_obj_addr_up),    //Modified by SYF 2014.5.13
		.i_emib_local_addr(i_emib_local_addr_up),          //Modified by SYF 2014.3.14
		.i_emib_net_addr(i_emib_net_addr_up),             //Modified by SYF 2014.3.14
		
		.i_plant_ram_addr(plant_rd_ram_addr_up),             //Modified by SYF 2014.5.22
		.i_plant_rd_ram_en(plant_rd_ram_en_up),              //Modified by SYF 2014.5.22
		.o_plant_ram_data(emib_back_ram_data_up)             //Modified by SYF 2014.5.22
		

); 
/**************end*************/

//Modified by SYF 2014.3.17 
/************frt link object index module**************/
frt_link_index	frt_link_index_net(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),		
		.i_frt_ip(i_frt_ip_down),	
	   .o_link_device_type(o_link_device_type_down),   //Modified by SYF 2014.5.8
		.o_frt_offset_len_local(o_frt_offset_len_local_down),             //Modified by SYF 2014.5.21
		.o_frt_data_offset_local(o_frt_data_offset_local_down),	         //Modified by SYF 2014.5.21
		.o_frt_save_offset_local(o_frt_save_offset_local_down),		      //Modified by SYF 2014.5.21
		.i_frt_index_irq_local(i_frt_index_irq_local_down),		         //Modified by SYF 2014.5.21
		.o_frt_index_done_local(o_frt_index_done_local_down),             //Modified by SYF 2014.5.21
		.o_frt_index_error_local(o_frt_index_error_local_down),		      //Modified by SYF 2014.5.21
		.i_config_flag(config_done_flag),
		.i_ram_data(emib_back_data),
		.i_ram_addr(emib_back_addr),
		.i_wr_en	(emib_back_wr_en),
		.o_linkobj_net_num(o_linkobj_net_num_down),      //Modified by SYF 2014.3.5
		.i_frt_index_irq_net(i_frt_index_irq_net_down),	    //Modified by SYF 2014.3.5	
		.o_frt_index_done_net(o_frt_index_done_net_down),     //Modified by SYF 2014.3.5
		.o_frt_index_error_net(o_frt_index_error_net_down),	 //Modified by SYF 2014.3.5
	   .o_frt_offset_len_net(o_frt_offset_len_net_down),                  //Modofied by SYF 2014.3.6
		.o_frt_data_offset_net(o_frt_data_offset_net_down),
		.o_frt_save_offset_net(o_frt_save_offset_net_down),
		.i_flag_index(i_flag_index_down),
   	.i_emib_num_link_obj_addr(i_emib_num_link_obj_addr_down),    //Modified by SYF 2014.5.13
		.i_emib_local_addr(i_emib_local_addr_down),          //Modified by SYF 2014.3.14
		.i_emib_net_addr(i_emib_net_addr_down),             //Modified by SYF 2014.3.14
		
		.i_plant_ram_addr(plant_rd_ram_addr_down),             //Modified by SYF 2014.5.22
		.i_plant_rd_ram_en(plant_rd_ram_en_down),              //Modified by SYF 2014.5.22
		.o_plant_ram_data(emib_back_ram_data_down)             //Modified by SYF 2014.5.22
); 
/**************end*************/ 
//End modified 


/************plant index module**************/           //modified by SYF 2013.11.6
plant_index		plant_index_up(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_config_flag(config_done_flag),
		.i_emib_device_property_addr(i_emib_device_property_addr_up),   //Modified by SYF 2014.5.21
		.i_ram_data(emib_back_ram_data_up),
		.o_emib_addr(plant_rd_ram_addr_up),
		.o_rd_ram_en(plant_rd_ram_en_up),		
		.i_plant_index_irq(i_plant_index_irq_up),
		.o_plant_index_done(o_plant_index_done_up),
		.o_plant_index_error(o_plant_index_error_up),
		.i_plant_mac(i_frt_mac_up),                           //Modified by SYF 2014.5.21
		.o_plant_ip(o_plant_ip_up),
		.o_plant_toffset(o_plant_toffset_up),
		.o_plant_datalen(o_plant_datalen_up),
		.o_plant_interval(o_plant_interval_up),               //Modified by SYF 2014.5.21
); 
/**************end*************/

/************plant index module**************/           //modified by SYF 2014.5.28
plant_index		plant_index_down(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_config_flag(config_done_flag),
		.i_emib_device_property_addr(i_emib_device_property_addr_down),   //Modified by SYF 2014.5.21
		.i_ram_data(emib_back_ram_data_down),
		.o_emib_addr(plant_rd_ram_addr_down),
		.o_rd_ram_en(plant_rd_ram_en_down),		
		.i_plant_index_irq(i_plant_index_irq_down),
		.o_plant_index_done(o_plant_index_done_down),
		.o_plant_index_error(o_plant_index_error_down),
		.i_plant_mac(i_frt_mac_down),                           //Modified by SYF 2014.5.21
		.o_plant_ip(o_plant_ip_down),
		.o_plant_toffset(o_plant_toffset_down),
		.o_plant_datalen(o_plant_datalen_down),
		.o_plant_interval(o_plant_interval_down),               //Modified by SYF 2014.5.21
); 
/**************end*************/

/************commen data output  module**************/             //Modified by SYF 2014.2.14
commen_data_updown  commen_data_updown(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),	
		
		.i_read_flash_done(i_read_flash_done),
		.i_config_flag(config_done_flag),
		
		.o_emib_addr(commen_emib_addr),		
		.o_rd_ram_en(commen_rd_en),		
		.i_emib_data(commen_data),
		
		.o_local_node_ip(o_local_node_ip),
		.o_local_node_mac(o_local_node_mac),
		.o_device_type(o_device_type),
		.o_device_state(o_device_state),			  
		.o_macro_cycle_time_uplayer(o_macro_cycle_time_uplayer),
		.o_real_cycle_time_uplayer(o_real_cycle_time_uplayer),
		.o_frt_send_time_uplayer(o_frt_send_time_uplayer),
		.o_frt0_data_len_uplayer_local(o_frt0_data_len_uplayer_local),
		.o_frt0_data_len_uplayer_up(o_frt0_data_len_uplayer_up),
		.o_frt0_data_len_uplayer_down(o_frt0_data_len_uplayer_down),
		.o_frt0_data_len_uplayer_net(o_frt0_data_len_uplayer_net),           //Modified by SYF 2014.5.22
		.o_macro_cycle_time_downlayer(o_macro_cycle_time_downlayer),
		.o_real_cycle_time_downlayer(o_real_cycle_time_downlayer),
		.o_frt_send_time_downlayer(o_frt_send_time_downlayer),
		.o_frt0_data_len_downlayer_local(o_frt0_data_len_downlayer_local),
		.o_frt0_data_len_downlayer_up(o_frt0_data_len_downlayer_up),
		.o_frt0_data_len_downlayer_down(o_frt0_data_len_downlayer_down),
		.o_frt0_data_len_downlayer_net(o_frt0_data_len_downlayer_net),        //Modified by SYF 2014.5.22
		//***********************************************              //Modified by SYF 2014.4.13
		.o_num_link_obj_uplayer_local(o_num_link_obj_uplayer_local),
		.o_num_link_obj_uplayer_net(o_num_link_obj_uplayer_net),
		.o_num_device_uplayer(o_num_device_uplayer),
		.o_num_link_obj_downlayer_local(o_num_link_obj_downlayer_local),
		.o_num_link_obj_downlayer_net(o_num_link_obj_downlayer_net),
		.o_num_device_downlayer(o_num_device_downlayer),
		//***********************************************
		.o_commen_data_rd_done(o_commen_data_rd_done)		
);
/**************end*************/



///************commen data output  module**************/
//commen_data  commen_data1(
//		.i_clk(i_clk),
//		.i_rst_n(i_rst_n),	
//		
//		.i_read_flash_done(i_read_flash_done),
//
//		.o_emib_addr(commen_emib_addr),		
//		.o_rd_ram_en(commen_rd_en),		
//		.i_emib_data(commen_data),
//		
//		.i_config_flag(config_done_flag),
//		
//		.o_local_mac(o_local_mac),
//		.o_frt0_data_len(o_frt0_data_len),		
//		.o_local_node_ip(o_local_node_ip),
//		.o_first_ip_mask(o_first_ip_mask),
//		.o_second_ip_mask(o_second_ip_mask),
//		.o_macro_cycle_time(o_macro_cycle_time),
//		.o_real_cycle_time(o_real_cycle_time),
//		.o_frt_send_time(o_frt_send_time),		
//		.o_ptp_num(o_ptp_num),
//		.o_com_num(o_com_num),
//		.o_device_num(o_device_num),                    //modified by SYF 2013.11.4
//		.o_device_state(device_state),
//		.o_commen_data_rd_done(o_commen_data_rd_done)
//);
///**************end*************/

 
 /************flash interface   module**************/
 emib_flash_interface flash_trig(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		
		.i_device_state((o_write_done || o_config_done)&& output_flag),
				
		.o_flash_rd_irq(o_flash_rd_irq),
		.i_flash_rd_en(i_flash_rd_en),	

		.i_flash_wr_en(i_flash_wr_en),
		.o_flash_wr_irq(o_flash_wr_irq),

		.i_write_done(o_write_done),
		.i_read_flash_done(i_read_flash_done),
		
		.i_emib_wr_address(emib_wr_address),
		.i_offset_len(offset_len),
		
		.o_flash_addr_offset(o_flash_addr_offset),
		.o_flash_data_len(o_flash_data_len) 

);
/**************end*************/ 
 
  /************bus  select   module**************/
  bus_select bus_select1(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),	
		
		.i_frt_rd_ram_en(frt_rd_ram_en),
		.i_frt_emib_addr_out(frt_emib_addr),
		.o_frt_emib_data(frt_emib_data),		
		
		.i_rd_en_out(rd_en),		
		.i_emib_rd_address(emib_rd_address),
		.o_emib_rd_data(emib_rd_data),

		
		.i_wr_en_out(wr_en),
		.i_emib_wr_address(emib_wr_address),
		.i_emib_wr_data(emib_wr_data),

		.i_flash_raddr(i_flash_raddr),
		.i_flash_rd_en(i_flash_rd_en),
		.o_flash_data(o_flash_data),
		
		.i_flash_waddr(i_flash_waddr_dly1),                //modified by SYF 2013.11.5
		.i_flash_data(i_flash_data),	
		.i_flash_wr_en(i_flash_wr_en),
		
		.i_commen_rd_en_out(commen_rd_en),
		.i_commen_emib_addr_out(commen_emib_addr),
		.o_commen_data(commen_data),
		
		.o_rd_ram_addr(rd_ram_addr),
 		.o_wr_ram_addr(wr_ram_addr),
		.i_ram_data_out(ram_data_out),
		.o_ram_data(ram_data_in),	
		.o_rd_en(ram_rd_en),
		.o_wr_en(ram_wr_en)
);
 /**************end*************/ 
 
endmodule
