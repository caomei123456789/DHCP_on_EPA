`include "../master_rtl/define/define.v"
module flash_interface
(/*** common pin***/
 input wire i_clk,//the system clock
 input wire i_rst_n, // the reset signal , low effective
/***connect with EMIB***/
 input wire i_wr_irq,// write interrupt,high effective
 input wire [15:0] i_flash_data,//data for writing into flash
 input wire [`ADDR_SZ-1:0] i_flash_addr_offset,   //Modified by SYF 2014.5.20
 input wire [`ADDR_SZ-1:0] i_flash_data_len,      //Modified by SYF 2014.5.20
 input wire i_rd_irq,
 output wire o_flash_wr_en,
 output wire [`ADDR_SZ-1:0] o_flash_waddr,        //Modified by SYF 2014.5.20
 output wire o_wr_dn,
 output wire [15:0] o_flash_data,
 output wire o_flash_rd_en,
 output wire [`ADDR_SZ-1:0] o_flash_raddr,        //Modified by SYF 2014.5.20
 output wire o_flash_read_done,
/*** connect with flash***/
 output wire o_scl,
 inout wire b_sda
);

parameter IDLE = 2'b00;
parameter WR_STATE = 2'b01;
parameter RD_STATE = 2'b11;

wire scl_w;
wire scl_r;
reg wr_irq;
reg rd_irq;
reg [1:0] fsm_cs;
reg [1:0] fsm_ns;
assign o_scl = scl_w || scl_r;



always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
	begin
		fsm_cs <= IDLE;
	end
	else 
	begin
		fsm_cs <= fsm_ns;
	end
end

always @ (*)
begin
	if (!i_rst_n)
	begin
		fsm_ns = IDLE;
	end
	else
	case(fsm_cs)
	IDLE:
	begin
	    if (i_wr_irq)
		 begin
		     fsm_ns = WR_STATE;
		 end
		 else if (i_rd_irq)
		 begin
		     fsm_ns = RD_STATE;
		 end
		 else
	    begin
		     fsm_ns = IDLE;
	    end	
	end
	WR_STATE:
	begin
	    if (o_wr_dn)
	    begin
		     fsm_ns = IDLE;
	    end
       else
		 begin
		     fsm_ns = WR_STATE;
		 end
   end
	RD_STATE:
	begin
	    if (o_flash_read_done)
	    begin
		     fsm_ns = IDLE;
	    end
       else
		 begin
		     fsm_ns = RD_STATE;
		 end
   end	
   endcase
end

always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
   begin
	    wr_irq <= 1'b0;
		 rd_irq <= 1'b0;
	end
	else 
	case (fsm_ns)
	IDLE:
	begin
	    wr_irq <= 1'b0;
		 rd_irq <= 1'b0;
	end
	WR_STATE:
	begin
	    wr_irq <= 1'b1;
		 rd_irq <= 1'b0;
	end
	RD_STATE:
	begin
	    wr_irq <= 1'b0;
		 rd_irq <= 1'b1;
	end
   endcase
end
	
write_flash write_flash
(
 .i_clk(i_clk),
 .i_rst_n(i_rst_n), 
 .i_wr_irq(wr_irq),
 .i_flash_data(i_flash_data),
 .i_flash_addr_offset(i_flash_addr_offset),
 .i_flash_data_len(i_flash_data_len),
 .o_flash_wr_en(o_flash_wr_en),
 .o_flash_waddr(o_flash_waddr),
 .o_wr_dn(o_wr_dn),
 .b_sda(b_sda),
 .o_scl(scl_w)
);

read_flash read_flash
(
 .i_clk(i_clk),
 .i_rst_n(i_rst_n), 
 .i_rd_irq(rd_irq),
 .b_sda(b_sda),
 .o_flash_data(o_flash_data),
 .o_flash_rd_en(o_flash_rd_en),
 .o_flash_raddr(o_flash_raddr),
 .o_flash_read_done(o_flash_read_done),
 .o_scl(scl_r)
);
endmodule
