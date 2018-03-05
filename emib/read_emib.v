/*******************************************************************
File name   			:	read_emib.v
Function    			:	1.read  data from emib to mm module
 
Version maintenance	:	zourenbo
Version     			:	V1.0
data        			:	2010-12-13
*******************************************************************/

/***************************   modify record   *********************

**************************************************************************
**************************************************************************/

`include "../master_rtl/define/define.v"
module  read_emib 
		(
		input wire i_clk,
		input wire i_rst_n,
		input wire i_rd_en,
		input wire i_error,
		input wire [`RAM_WIDTH-1:0] i_emib_to_mm_data,
		input wire [`ADDR_SZ-1:0] i_mm_data_len,
		output wire [`RAM_WIDTH-1:0] o_mm_data,//2 clk
		output wire [`ADDR_SZ-1:0] o_mm_addr,
		
		input wire 	[`ADDR_SZ-1:0] i_base_addr,
		input wire 	[`ADDR_SZ-1:0] i_offset_addr,
		
		input wire i_rd_rsp_en,//
		output reg o_rd_en,
		output reg o_read_error,
		output reg o_read_done,
		output reg [`ADDR_SZ-1 : 0]o_mm_data_len
);

reg [`ADDR_SZ-1:0] ptr_read;
reg [2:0] Nextstate,State;
reg [2:0] State_dly1,State_dly2,State_dly3;

reg [15:0] o_mm_data_temp;

reg [`ADDR_SZ-1:0]  emib_rd_address;

reg o_rd_en_reg, read_en ,read_en_1clk;

wire  read_en_reg;
wire  rempty ;

reg [`RAM_WIDTH-1:0] mm_data_temp ;
parameter IDLE = 3'b0;
parameter READ_EMIB = 3'b01;
parameter READ_DONE = 3'b10;
parameter JUGE_ERR = 3'b11;
parameter READ_ERR = 3'b100;


assign o_mm_addr = i_base_addr + i_offset_addr + emib_rd_address ;

//always @(posedge i_clk )
//begin
//	emib_to_mm_data_temp1 <= i_emib_to_mm_data;
//	emib_to_mm_data_temp2 <= emib_to_mm_data_temp1 ;
//end 

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
		if( i_rd_en)
		Nextstate = JUGE_ERR;
		else
		Nextstate = IDLE;		
		end
	JUGE_ERR:                     //judge  the object is  error  or not
		begin	
		if(!i_error)
			Nextstate = READ_EMIB;
		else 
			Nextstate = READ_ERR;
		end
	READ_EMIB:                   //read the emib data
		begin
		if(ptr_read >= i_mm_data_len)
		Nextstate = READ_DONE;
		else
		Nextstate = READ_EMIB;		
		end		
	READ_DONE:                  //read finish
		Nextstate = IDLE;	
	READ_ERR:	
		Nextstate = IDLE;		
	default:
		Nextstate = IDLE;		
	endcase
end

//state3
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		o_rd_en <= 1'b0;
		emib_rd_address	<= `ADDR_SZ'b0;	
		o_read_error <= 1'b0 ;	
		o_read_done <= 1'b0 ;	
	end
	else
	case(Nextstate)	
	IDLE,JUGE_ERR:
		begin
		o_rd_en <= 1'b0;
		emib_rd_address	<= `ADDR_SZ'b0;	
		o_read_error <= 1'b0 ;	
		o_read_done <= 1'b0 ;
		o_mm_data_len <= i_mm_data_len;
		end
	READ_EMIB:
		begin
		o_rd_en <= 1'b1;
		emib_rd_address <= ptr_read ;
		o_read_error <= 1'b0 ;
		o_read_done <= 1'b0 ;
	   o_mm_data_len <= i_mm_data_len;	
		end		
	READ_DONE:
		begin
		o_rd_en <= 1'b0;
		emib_rd_address	<= `ADDR_SZ'b0;	
		o_read_error <= 1'b0 ;	
		o_read_done <= 1'b1 ;
		o_mm_data_len <= i_mm_data_len;
		end	
	READ_ERR:
		begin
		o_read_error <= 1'b1 ;
		o_rd_en <= 1'b0;
		emib_rd_address	<= `ADDR_SZ'b0;	
		o_read_done <= 1'b0 ;
		o_mm_data_len <= `ADDR_SZ'b0;
		end		
	default:
		begin
		o_rd_en <= 1'b0;
		o_read_error <= 1'b0 ;
		emib_rd_address	<= `ADDR_SZ'b0;
		o_read_done <= 1'b0 ;	
		o_mm_data_len <= `ADDR_SZ'b0;
		end	
	endcase
end


always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	mm_data_temp <= `RAM_WIDTH'b0; 
	o_rd_en_reg <= 1'b0;
	end
	else if(State_dly3 == READ_EMIB)
	begin
	mm_data_temp <= i_emib_to_mm_data;//
	o_rd_en_reg <= 1'b1;
	end
	else
	begin
	mm_data_temp <= `RAM_WIDTH'b0; 
	o_rd_en_reg <= 1'b0;
	end
end

/*****************generate read address******************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	ptr_read <= `ADDR_SZ'b0 ;
	end
	else if((Nextstate == READ_EMIB)&&(ptr_read < i_mm_data_len))
	begin
	ptr_read <= ptr_read + 1'b1;
	end
	else
	begin
	ptr_read <= `ADDR_SZ'b0 ;
	end
end
/*******************end*************************/
reg    [15:0]           fifo_emib_to_mm [255:0];
reg    [7:0]            wr_addr;
reg    [7:0]            rd_addr;
reg                     rd_en_reg_dly;
reg                     rd_rsp_en_dly;
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		wr_addr <= 8'b0;
	else if(o_rd_en_reg)
		wr_addr <= wr_addr + 1'b1;
	else ;
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		rd_en_reg_dly <= 1'b0;
	else 
		rd_en_reg_dly <= o_rd_en_reg;
end
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		rd_rsp_en_dly <= 1'b0;
	else
		rd_rsp_en_dly <= i_rd_rsp_en;
end
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		rd_addr <= 8'b0;
	else if(o_rd_en_reg && !rd_en_reg_dly)
		rd_addr <= wr_addr;
	else if(i_rd_rsp_en)
		rd_addr <= rd_addr + 1'b1;
	else if(!i_rd_rsp_en && rd_rsp_en_dly)
		rd_addr <= rd_addr - 1'b1;
	else ;
end
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		o_mm_data_temp <= 16'b0;
	else
	begin
		fifo_emib_to_mm[wr_addr] <= mm_data_temp;
		o_mm_data_temp           <= fifo_emib_to_mm[rd_addr];
	end
end

///***********fifo to cache the read data**********/
//fifo_ram    fifo_read_data(
//	.clock(i_clk),
//	.data(mm_data_temp),
//	.rdreq(i_rd_rsp_en),
//	.wrreq(o_rd_en_reg),
//	.empty(rempty), 
//	.q(o_mm_data_temp));
///*****************end************************/
assign o_mm_data = i_rd_rsp_en ? o_mm_data_temp :16'h0;

endmodule 
