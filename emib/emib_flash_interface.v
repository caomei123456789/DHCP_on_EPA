/*******************************************************************
File name   			:	emib_flash_interface.v
Function    			:	1.generate the drive signal to flash interface module
 
Version maintenance	:	zourenbo
Version     			:	V1.0
data        			:	2010-12-13
*******************************************************************/

/***************************   modify record   *********************

**************************************************************************
**************************************************************************/
`include "../master_rtl/define/define.v"
module  emib_flash_interface(
		input wire   i_clk,
		input wire   i_rst_n,
		
		input wire   i_device_state, //system work state
				
		output reg  o_flash_rd_irq,//write flash request signal 
		input wire   i_flash_rd_en,	//write flash enable signal 

		input wire i_flash_wr_en, //read flash enable signal 
		output reg o_flash_wr_irq,//read flash request signal 
		
		input wire i_write_done,  //write ram finish signal
		input wire i_read_flash_done, //read ram finish signal
		
		input wire [`ADDR_SZ-1:0] i_emib_wr_address, //write emib address
		input wire [`ADDR_SZ-1:0]	i_offset_len,     //write emib data length
		
		output reg [`ADDR_SZ-1:0] o_flash_addr_offset, //write flash offset address
		output reg [`ADDR_SZ-1:0] o_flash_data_len     //write data length

);


reg  flash_wr_en,flash_wr_en_reg;
wire  flash_wr_irq;
 
 reg rst_n_1clk;

/**************generate the read flash request signal*****************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	o_flash_wr_irq <= 1'b0;
	else if(flash_wr_irq )
	o_flash_wr_irq <= 1'b1;
	else if(i_flash_rd_en /*i_flash_wr_en*/)  //Modified by SYF 2014.5.20
	o_flash_wr_irq <= 1'b0;	
	else
	o_flash_wr_irq <= o_flash_wr_irq;
end
/*************************end*************************/



always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	rst_n_1clk <= 1'b0;
	else
	begin
	rst_n_1clk <= i_rst_n;
	end	
end


/**************generate the write flash request signal*****************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	o_flash_rd_irq <= 1'b0;
	else if(i_rst_n && (!rst_n_1clk))
	begin
	o_flash_rd_irq <= 1'b1;
	end	
	else if(i_read_flash_done)
	begin
	o_flash_rd_irq <= 1'b0;	
	end
end
/*************************end*************************/

/**************generate the write flash address signal*****************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_flash_addr_offset <= `ADDR_SZ'h0ff ;
	o_flash_data_len <= `ADDR_SZ'h0 ;
	end
	else if(flash_wr_irq)
	begin
	o_flash_addr_offset <= `ADDR_SZ'h0 ;
	o_flash_data_len <= `ADDR_SZ'hb00 ;    //`ADDR_SZ'h3ff ;    //Modified by SYF 2014.5.20
	end	
	else 
	begin
	o_flash_addr_offset <= o_flash_addr_offset ;
	o_flash_data_len <= o_flash_data_len ;
	end
end
/*************************end*************************/


always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	flash_wr_en <= 1'b0;
	end
	else if(i_device_state)
	begin
	flash_wr_en <= 1'b1;
	end
	else
	begin
	flash_wr_en <= 1'b0;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	flash_wr_en_reg <= 1'b0;
	end
	else
	begin
	flash_wr_en_reg <= flash_wr_en;
	end
end

assign flash_wr_irq = flash_wr_en & (!flash_wr_en_reg);


endmodule 