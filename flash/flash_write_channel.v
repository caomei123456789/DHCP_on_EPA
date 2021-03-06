`include "../master_rtl/define/define.v"
module flash_write_channel
(		/*** common pin***/
input wire i_clk,//the system clock
input wire i_rst_n, 
		/*****emib***************/
input wire i_emib_irq,
input wire [15:0] i_emib_data,//data for writing into flash
input wire [`ADDR_SZ-1:0] i_emib_addr_offset,    //Modified by SYF 2014.5.20
input wire [`ADDR_SZ-1:0] i_emib_data_len,       //Modified by SYF 2014.5.20
output reg o_emib_wr_en,
output reg [`ADDR_SZ-1:0] o_emib_waddr,          //Modified by SYF 2014.5.20
		/*********dpram*****************/
input wire i_dpram_irq,
input wire [15:0] i_dpram_data,//data for writing into flash
input wire [`ADDR_SZ-1:0] i_dpram_addr_offset,   //Modified by SYF 2014.5.20
input wire [`ADDR_SZ-1:0] i_dpram_data_len,      //Modified by SYF 2014.5.20
output reg o_dpram_wr_en,
output reg [`ADDR_SZ-1:0] o_dpram_waddr,         //Modified by SYF 2014.5.20
		/********flash****************************/		
input wire i_flash_wr_en,
input wire [`ADDR_SZ-1:0] i_flash_waddr,         //Modified by SYF 2014.5.20
input wire i_wr_dn,
output reg o_flash_irq,// write interrupt,high effective
output reg [15:0] o_flash_data,//data for writing into flash
output reg [`ADDR_SZ-1:0] o_flash_addr_offset,   //Modified by SYF 2014.5.20
output reg [`ADDR_SZ-1:0] o_flash_data_len       //Modified by SYF 2014.5.20
);
 reg emib_wr;
 reg dpram_wr;
 
always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
	begin
		 emib_wr <= 1'b0;
	    dpram_wr <= 1'b0;
   end
	else if (i_wr_dn)
	begin
		 emib_wr <= 1'b0;
	    dpram_wr <= 1'b0;
   end
	else if (i_emib_irq)
	begin
	    emib_wr <= 1'b1;
	end
	else if (i_dpram_irq)
	begin
	    dpram_wr <= 1'b1;
	end 
end

always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
	begin
	    o_flash_irq <= 1'b0;
   end
	else if (i_emib_irq)
	begin
	    o_flash_irq <= 1'b1;
	end
	else if (i_dpram_irq)
	begin
	    o_flash_irq <= 1'b1;
	end
	else 
	begin
	    o_flash_irq <= 1'b0;
   end
end

always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
	begin
	    o_flash_addr_offset <= `ADDR_SZ'h0;    //Modified by SYF 2014.5.20
	end
	else if (emib_wr)
	begin
	    o_flash_addr_offset <= i_emib_addr_offset;
	end
	else if (dpram_wr)
	begin
	    o_flash_addr_offset <= i_dpram_addr_offset;
	end	
	else 
	begin
	    o_flash_addr_offset <= `ADDR_SZ'h0;    //Modified by SYF 2014.5.20
	end
end	
	
always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
	begin
	    o_flash_data_len <= `ADDR_SZ'h0;       //Modified by SYF 2014.5.20
	end
	else if (emib_wr)
	begin
	    o_flash_data_len <= i_emib_data_len;
	end
	else if (dpram_wr)
	begin
	    o_flash_data_len <= i_dpram_data_len;
	end	
	else 
	begin
	    o_flash_data_len <= `ADDR_SZ'h0;       //Modified by SYF 2014.5.20
	end
end

always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
	begin
	    o_flash_data <= 16'h0;
	end
	else if (emib_wr)
	begin
	    o_flash_data <= i_emib_data;
	end
	else if (dpram_wr)
	begin
	    o_flash_data <= i_dpram_data;
	end	
	else 
	begin
	    o_flash_data <= 16'h0;
	end
end	

always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
	begin
	    o_emib_wr_en <= 1'b0;
		 o_dpram_wr_en <= 1'b0;
	end
	else if (emib_wr)
	begin
	    o_emib_wr_en <= i_flash_wr_en;
	end
	else if (dpram_wr)
	begin
	    o_dpram_wr_en <= i_flash_wr_en;
	end	
	else 
	begin
	    o_emib_wr_en <= 1'b0;
		 o_dpram_wr_en <= 1'b0;
	end
end

always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
	begin
	    o_emib_waddr <= `ADDR_SZ'h0;     //Modified by SYF 2014.5.20
		 o_dpram_waddr <= `ADDR_SZ'h0;
	end
	else if (emib_wr)
	begin
	    o_emib_waddr <= i_flash_waddr;
	end
	else if (dpram_wr)
	begin
	    o_dpram_waddr <= i_flash_waddr;
	end	
	else 
	begin
	    o_emib_waddr <= `ADDR_SZ'h0;     //Modified by SYF 2014.5.20
		 o_dpram_waddr <= `ADDR_SZ'h0;
	end
end

endmodule
