/*******************************************************************
File name   			:	dpram.v
Function    			:	store the data from controller and fpga;
 
Version maintenance	:	caogang
Version     			:	V1.0
data        			:	2011-02-13
*******************************************************************/

/***************************   modify record   *********************

**************************************************************************
**************************************************************************/
`include "../master_rtl/define/define.v"
module  dpram(
			input wire i_clk_50,              //Modified by SYF 2014.6.18
			input wire i_clk_100,
			input wire i_rst_n,
			input wire i_macrocycle_b,
			input wire i_device_type,         //Modified by SYF 2014.6.18
			//cpu
			input wire [`DPRAM_ADDR_DEPTH-1:0] i_addr_cpu,        //Modified by SYF 2014.5.20  //[11:0]
			inout wire [15:0] b_data_cpu,
			input wire i_rd_wr_cpu,
			input wire i_oe_cpu,
			input wire i_cpu_cs,//low active
			output reg o_busy_cpu,//low active
			//
			 
			//*************************************************   //Modified by SYF 2014.5.21
			//frt-dpram
			input wire i_wr_en_frt_a_up,                              //Modified by SYF 2014.5.20
			input wire i_rd_en_frt_a_up,                              //Modified by SYF 2014.5.20
			input wire [`DPRAM_ADDR_DEPTH-1:0] i_addr_frt_a_up,       //Modified by SYF 2014.5.20
			input wire [15:0] i_data_frt_a_up,                        //Modified by SYF 2014.5.20	
			output wire [15:0] o_data_dpram_a_up,                         //Modified by SYF 2014.5.20
			
			input wire  i_wr_en_frt_b_up,                                //Modified by SYF 2014.5.20
			input wire  i_rd_en_frt_b_up,                                //Modified by SYF 2014.5.20
			input wire	[`DPRAM_ADDR_DEPTH-1:0] i_addr_frt_b_up,  //11   //Modified by SYF 2014.5.20
			input wire  [15:0] i_data_frt_b_up,                          //Modified by SYF 2014.5.20
			output wire [15:0] o_data_dpram_b_up,                         //Modified by SYF 2014.5.20
         //*************************************************
			
		   input wire  i_wr_en_frt_a_down,
			input wire  i_rd_en_frt_a_down,
		  	input wire	[`DPRAM_ADDR_DEPTH-1:0] i_addr_frt_a_down,  //11   //Modified by SYF 2014.5.20
			input wire  [15:0] i_data_frt_a_down,
			output wire [15:0] o_data_dpram_a_down, 
			
			input wire  i_wr_en_frt_b_down,
			input wire  i_rd_en_frt_b_down,
			input wire	[`DPRAM_ADDR_DEPTH-1:0] i_addr_frt_b_down, //11    //Modified by SYF 2014.5.20
			input wire  [15:0] i_data_frt_b_down,
			output wire [15:0] o_data_dpram_b_down                       //Modified by SYF 2014.5.20
			/*********************************************/	
);	


wire [15:0] data_cpu;
reg  [`DPRAM_ADDR_DEPTH-1:0] addr_dpram_a_up,addr_dpram_b_up;           //Modified by SYF 2014.5.20
reg link_rd_dpram_en;
reg [31:0]link_dpram_ip;
reg [2:0]cnt/*synthesis preserve*/;
wire rd_en_frt_a_up;
reg dpram_valid_dly;
reg macrocycle_b_dly;



assign rd_en_frt_a_up = i_rd_en_frt_a_up;        //Modified by SYF 2014.5.20
//原有dpram	
//dp_ram  dp_ram(	
//	.address_a(addr_dpram_a_up),
//	.address_b(i_addr_frt_b_up),       //Modified by SYF 2014.5.28
//	.clock_a(i_clk_100),
//	.clock_b(i_device_type ? i_clk_100 : i_clk_50),          //Modified by SYF 2014.6.18
//	.data_a(i_data_frt_a_up),
//	.data_b(i_data_frt_b_up),
//	.rden_a(rd_en_frt_a_up),
//	.rden_b(i_rd_en_frt_b_up),         //Modified by SYF 2014.5.28
//	.wren_a(i_wr_en_frt_a_up),
//	.wren_b(i_wr_en_frt_b_up),
//	.q_a(o_data_dpram_a_up),
//	.q_b(o_data_dpram_b_up)
//	);
reg  wr_en_frt_b_up;                                //Modified by SYF 2014.5.20
reg  rd_en_frt_b_up;                               //Modified by SYF 2014.5.20
reg	[`DPRAM_ADDR_DEPTH-1:0] addr_frt_b_up;  //11   //Modified by SYF 2014.5.20
reg  [15:0] data_frt_b_up;                          //Modified by SYF 2014.5.20

reg EC_data_valid,CE_data_valid;
always @(*)
begin
	if(!i_rst_n)
		addr_dpram_a_up = `DPRAM_ADDR_DEPTH'h0;
	else if(i_wr_en_frt_a_up && i_device_type)
		addr_dpram_a_up = i_addr_frt_a_up; 
	else if(i_rd_en_frt_a_up && i_device_type)  
		addr_dpram_a_up = i_addr_frt_a_up; 	
	//data from EPA to CPU;CPU read first;
	else if(!i_rd_en_frt_b_up && !i_device_type)
		if(i_wr_en_frt_a_up)
			addr_dpram_a_up = i_addr_frt_a_up;
	else if(i_rd_en_frt_b_up && !i_device_type)
		begin
			if(i_wr_en_frt_a_up && i_addr_frt_b_up > 14'hd00 && i_addr_frt_b_up < 14'hf00)
				addr_dpram_a_up = i_addr_frt_a_up; 
			else if(i_wr_en_frt_a_up && i_addr_frt_b_up > 14'hb00 && i_addr_frt_b_up < 14'hd00)
				addr_dpram_a_up = i_addr_frt_a_up + 14'h200; 	
		end
   //data from CPU to EPA;CPU write first;
	else if(!i_wr_en_frt_b_up && !i_device_type)
		begin
			if(i_rd_en_frt_a_up && !CE_data_valid)
				addr_dpram_a_up = i_addr_frt_a_up;
			else if(i_rd_en_frt_a_up && CE_data_valid)
				addr_dpram_a_up = i_addr_frt_a_up + 14'h200;
		end	
	else if(i_wr_en_frt_b_up && !i_device_type)	
		begin
			if(i_rd_en_frt_a_up && i_addr_frt_b_up > 14'h1100 && i_addr_frt_b_up < 14'h1300)
				addr_dpram_a_up = i_addr_frt_a_up; 
			else if(i_rd_en_frt_a_up && i_addr_frt_b_up > 14'hf00 && i_addr_frt_b_up < 14'h1100)
				addr_dpram_a_up = i_addr_frt_a_up + 14'h200; 
		end
	else
		addr_dpram_a_up = `DPRAM_ADDR_DEPTH'h0;          //Modified by SYF 2014.5.20
end

always @(posedge i_clk_100,negedge i_rst_n)
begin
	if(!i_rst_n)
		EC_data_valid <= 1'b0;
	else if(i_wr_en_frt_a_up && i_addr_frt_a_up > 14'hd00 && i_addr_frt_a_up < 14'hf00)
		EC_data_valid <= 1'b1;
	else if(i_rd_en_frt_b_up && i_addr_frt_b_up > 14'hd00 && i_addr_frt_b_up < 14'hf00)
		EC_data_valid <= 1'b0;
	else 
		EC_data_valid <= EC_data_valid;
end

always @(*)
begin
	if(!i_rst_n)
		addr_dpram_b_up = `DPRAM_ADDR_DEPTH'h0;
	else if(i_wr_en_frt_b_up && i_device_type)
		addr_dpram_b_up = i_addr_frt_b_up; 
	else if(i_rd_en_frt_b_up && i_device_type)  
		addr_dpram_b_up = i_addr_frt_b_up; 	
	//data from CPU to EPA;EPA read first;
	else if(!i_rd_en_frt_a_up && !i_device_type)
			if(i_wr_en_frt_b_up)
				addr_dpram_b_up = i_addr_frt_b_up;
	else if(i_rd_en_frt_a_up && !i_device_type)
		begin
			if(i_wr_en_frt_b_up && i_addr_frt_a_up > 14'h1100 && i_addr_frt_a_up < 14'h1300)
				addr_dpram_b_up = i_addr_frt_b_up;
			else if(i_wr_en_frt_b_up && i_addr_frt_a_up > 14'hf00 && i_addr_frt_a_up < 14'h1100)
				addr_dpram_b_up = i_addr_frt_b_up + 14'h200;
		end
   //data from CPU to EPA;EPA write first;
	else if(!i_wr_en_frt_a_up && !i_device_type)
		begin
			if(i_rd_en_frt_b_up && !EC_data_valid)
				addr_dpram_b_up = i_addr_frt_b_up;
			else if(i_rd_en_frt_b_up && EC_data_valid)
				addr_dpram_b_up = i_addr_frt_b_up + 14'h200;
		end	
	else if(i_wr_en_frt_a_up && !i_device_type)	
		begin
			if(i_rd_en_frt_b_up && i_addr_frt_a_up > 14'hd00 && i_addr_frt_a_up < 14'hf00)
				addr_dpram_b_up = i_addr_frt_b_up; 
			else if(i_rd_en_frt_b_up && i_addr_frt_a_up > 14'hb00 && i_addr_frt_a_up < 14'hd00)
				addr_dpram_b_up = i_addr_frt_b_up + 14'h200; 
		end
	else
		addr_dpram_b_up = `DPRAM_ADDR_DEPTH'h0;          //Modified by SYF 2014.5.20
end

always @(posedge i_clk_100,negedge i_rst_n)
begin
	if(!i_rst_n)
		CE_data_valid <= 1'b0;
	else if(i_wr_en_frt_b_up && i_addr_frt_b_up > 14'h1100 && i_addr_frt_b_up < 14'h1300)
		CE_data_valid <= 1'b1;
	else if(i_rd_en_frt_a_up && i_addr_frt_a_up > 14'h1100 && i_addr_frt_a_up < 14'h1300)
		CE_data_valid <= 1'b0;
	else
		CE_data_valid <= CE_data_valid;
end

dp_ram  dp_ram(	
	.clock_a(i_clk_100),
	.data_a(i_data_frt_a_up),
	.wren_a(i_wr_en_frt_a_up),
	.address_a(addr_dpram_a_up),//写地址从0xb00开始，读取从0xf00开始
	.rden_a(rd_en_frt_a_up),
	.q_a(o_data_dpram_a_up),
	
	.clock_b(i_clk_100),
	.data_b(i_data_frt_b_up),
	.wren_b(i_wr_en_frt_b_up),
	.address_b(addr_dpram_b_up),
	.rden_b(i_rd_en_frt_b_up),
	.q_b(o_data_dpram_b_up)
	);


//Modified by SYF 2014.5.20	
dp_ram2  dp_ram2(	
	.address_a(i_addr_frt_a_down),      //Modified by SYF 2014.5.26
	.address_b(i_addr_frt_b_down),      //Modified by SYF 2014.5.26
	.clock_a(i_clk_100),
	.clock_b(i_clk_100),
	.data_a(i_data_frt_a_down),
	.data_b(i_data_frt_b_down),
	.rden_a(i_rd_en_frt_a_down),
	.rden_b(i_rd_en_frt_b_down),        //Modified by SYF 2014.5.28
	.wren_a(i_wr_en_frt_a_down),
	.wren_b(i_wr_en_frt_b_down),
	.q_a(o_data_dpram_a_down),
	.q_b(o_data_dpram_b_down)
	);
	endmodule
	