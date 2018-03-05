`include "../master_rtl/define/define.v"
module write_flash
(
 input wire i_clk,
 input wire i_rst_n, 
 input wire i_wr_irq,
 input wire [15:0] i_flash_data,
 input wire [`ADDR_SZ-1:0] i_flash_addr_offset,       //Modified by SYF 2014.5.20
 input wire [`ADDR_SZ-1:0] i_flash_data_len,          //Modified by SYF 2014.5.20
 output reg o_flash_wr_en,
 output reg [`ADDR_SZ-1:0] o_flash_waddr,             //Modified by SYF 2014.5.20
 output reg o_wr_dn,
 inout wire b_sda,
 output reg o_scl
);

parameter IDLE_FLASH = 5'b00000;
parameter I2C_INIT = 5'b00001; 
parameter I2C_START = 5'b00011;
parameter FLASH_ADDR_READY = 5'b00010;
parameter FLASH_ADDR = 5'b00110;
parameter START_ADDRH = 5'b00111;
parameter START_ADDRL = 5'b00101;
parameter SEND_DATAH = 5'b00100;
parameter SEND_DATAL = 5'b01100;
parameter READY_STOP = 5'b01101;
parameter STOP_SIGNAL = 5'b01111;
parameter WRITE_DONE = 5'b01110; 
parameter JUDGE = 5'b01010;
parameter BUF_WAIT = 5'b01011;

parameter frequency = 8'hf9;

reg sda_send;

reg [4:0] fsm_FLASH_cs;
reg [4:0] fsm_FLASH_ns/*synthesis noprune*/;
reg scl_en;
wire [7:0] flash_addr;
reg [7:0] start_next_addrh;
reg [7:0] start_next_addrl;
wire [15:0] start_addr;
reg ov;
reg [7:0] freq_cn;
reg [3:0] bit_cn;
reg [5:0] page_word_cn;
reg [`ADDR_SZ-1:0] total_word_cn;   //Modified by SYF 2014.5.20

wire [7:0] datah;
wire [7:0] datal;

reg [7:0] clk_cn;
reg jump_en;
reg scl_dly1;
reg [27:0] tbuf;
reg scl;
reg first_pkg;
assign b_sda = sda_send;
assign flash_addr = 8'b10100000;//bit 3~1 is based on hardware
//assign start_addrh = 8'h00;//{6'h0,i_flash_addr_offset[9:8]};
//assign start_addrl = 8'h00;//i_flash_addr_offset[7:0];
assign start_addr = (i_flash_addr_offset == `ADDR_SZ'h0) ? 16'h0 :(({4'h0,i_flash_addr_offset}-1'b1)<<1'b1);   //Modified by SYF 2014.5.20
assign datah = i_flash_data[15:8];
assign datal = i_flash_data[7:0];

always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
	begin
	    scl_dly1 <= 1'b0;
	end
	else
	begin
	   scl_dly1 <= scl;
	end
end 

always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
	begin
	    clk_cn <= 8'h0;
	end
	else if (fsm_FLASH_cs != fsm_FLASH_ns)
	begin
	    clk_cn <= 8'h0;
	end
	else
	begin
	   clk_cn <= clk_cn + 1'b1;
	end
end 
always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
	begin
	    jump_en <= 1'b0;
	end
	else if (fsm_FLASH_cs != fsm_FLASH_ns)
	begin
	    jump_en <= 1'b0;
	end
	else if (clk_cn == 8'h80)
	begin
	    jump_en <= 1'b1;
	end
	else
	begin
	    jump_en <= 1'b0;
	end
end

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
	     tbuf <= 28'h0;
	 end
	 else if (fsm_FLASH_cs != fsm_FLASH_ns)
    begin
        tbuf <= 28'h0;
	 end
    else if((fsm_FLASH_cs == WRITE_DONE)||(fsm_FLASH_cs == BUF_WAIT))	    
    begin
       tbuf <= tbuf + 28'h1;
    end
  	 else 
    begin
        tbuf <= 28'h0;
	 end
end

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
        first_pkg <= 1'b0;
	 end
	 else if (fsm_FLASH_cs == SEND_DATAH)
	 begin
	      first_pkg <= 1'b1;
	 end
	 else if (fsm_FLASH_cs == IDLE_FLASH)
	 begin
        first_pkg <= 1'b0;
	 end
end

always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
	begin
		fsm_FLASH_cs <= IDLE_FLASH;
	end
	else 
	begin
		fsm_FLASH_cs <= fsm_FLASH_ns;
	end
end

always @ (*)
begin
	if (!i_rst_n)
	begin
		fsm_FLASH_ns = IDLE_FLASH;
	end
	else
	case(fsm_FLASH_cs)
	IDLE_FLASH:
	begin
		if (i_wr_irq)
		begin
			fsm_FLASH_ns = I2C_INIT;
		end
		else
		begin
			fsm_FLASH_ns = IDLE_FLASH;
		end
	end
	I2C_INIT:
	begin
	   if (jump_en)
		    fsm_FLASH_ns = I2C_START;
		else
		    fsm_FLASH_ns = I2C_INIT;
	end
	I2C_START:
	begin
		if (jump_en)
		begin
		    fsm_FLASH_ns = FLASH_ADDR_READY;
		end
		else
		begin
			fsm_FLASH_ns = I2C_START;
		end
	end
	FLASH_ADDR_READY:
	begin
	     fsm_FLASH_ns = FLASH_ADDR;
	end
	FLASH_ADDR:
	begin
		if ((bit_cn == 4'b0000)&&(freq_cn == frequency))
	  	begin
			fsm_FLASH_ns = START_ADDRH;
		end
		else 
		begin
			fsm_FLASH_ns = FLASH_ADDR;
		end
	end
	START_ADDRH:
	begin
		if ((bit_cn == 4'b0000)&&(freq_cn == frequency))
		begin
			fsm_FLASH_ns = START_ADDRL;
		end
		else 
		begin
			fsm_FLASH_ns = START_ADDRH;
		end
	end
	START_ADDRL:
	begin
		if ((bit_cn == 4'b0000)&&(freq_cn == frequency))
		begin
		    fsm_FLASH_ns = SEND_DATAH;
		end
		else
		begin
		    fsm_FLASH_ns = START_ADDRL;
		end
	end
	SEND_DATAH:
	begin
		if ((bit_cn == 4'b0000)&&(freq_cn == frequency))
		begin
			 fsm_FLASH_ns = SEND_DATAL;
		end
		else
		begin
		    fsm_FLASH_ns = SEND_DATAH;
		end
	end
	SEND_DATAL:
	begin
	    if (((bit_cn == 4'b0000)&&(freq_cn == frequency)) && (page_word_cn < 6'h10) && (total_word_cn < i_flash_data_len ))
	    begin
	        fsm_FLASH_ns = SEND_DATAH;
	    end
	    else if ((bit_cn == 4'b0000)&&(page_word_cn == 6'h10)&&(freq_cn == frequency) && (total_word_cn < i_flash_data_len ))
	    begin
			fsm_FLASH_ns = READY_STOP;
		end
		else if ((bit_cn == 4'b0000)&&(total_word_cn == i_flash_data_len)&& (freq_cn == frequency))
		begin
		    fsm_FLASH_ns = READY_STOP;
		end
		else
		begin
			 fsm_FLASH_ns = SEND_DATAL;
		end
	end
   READY_STOP:
	begin
	    if (jump_en)
	    begin
	        fsm_FLASH_ns = STOP_SIGNAL;
	    end
	    else
	    begin
	        fsm_FLASH_ns = READY_STOP;
	    end
    end
	STOP_SIGNAL:
	begin
	    if (jump_en)
	    begin
	        fsm_FLASH_ns = WRITE_DONE;
	    end
	    else
	    begin
	        fsm_FLASH_ns = STOP_SIGNAL;
	    end
    end
	WRITE_DONE:
	begin
	    if (tbuf == 28'h80)
		 begin
	        fsm_FLASH_ns = JUDGE;
		 end
		 else 
		 begin
	        fsm_FLASH_ns = WRITE_DONE;
	    end
    end
	 JUDGE:
	 begin
	     if (total_word_cn < i_flash_data_len )
		  begin
		      fsm_FLASH_ns = BUF_WAIT;
		  end
		  else 
		  begin
		      fsm_FLASH_ns = IDLE_FLASH;
		  end
	 end
	 BUF_WAIT:
	 begin
	     if (tbuf == 28'h1e848)
		  begin
		      fsm_FLASH_ns = I2C_INIT;
		  end
		  else 
		  begin
		      fsm_FLASH_ns = BUF_WAIT;
		  end
    end		  
    endcase
end

always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
    begin
		page_word_cn <= 6'h0;
	end
	else if ((fsm_FLASH_ns == SEND_DATAL)&&(bit_cn == 4'b0001)&& scl && !scl_dly1)
	begin
		page_word_cn <= page_word_cn + 6'h1;
	end
	else if (fsm_FLASH_ns == STOP_SIGNAL)
    begin
		page_word_cn <= 6'h0;
	end
end	

always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
    begin
		total_word_cn <= `ADDR_SZ'h0;
	end
	else if ((fsm_FLASH_ns == SEND_DATAL)&&(bit_cn == 4'b0001)&& scl && !scl_dly1)
	begin
		total_word_cn <= total_word_cn + `ADDR_SZ'h1;
	end
	else if (fsm_FLASH_ns == IDLE_FLASH)
    begin
		total_word_cn <= `ADDR_SZ'h0;
	end
end	

/*bit counter and the last bit is ack*/    
always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
   begin
		bit_cn <= 4'b1000;
	end
	else if (fsm_FLASH_ns != fsm_FLASH_cs)
	begin
		bit_cn <= 4'b1000;
	end
	else if (freq_cn == frequency)
	begin
		bit_cn <= bit_cn - 1'b1;
	end
end

always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
    begin
		freq_cn <= 8'h0;
	end
	else if ((fsm_FLASH_ns != fsm_FLASH_cs) || (freq_cn == frequency)) 
	begin
		freq_cn <= 8'h0;
	end
	else if ((fsm_FLASH_ns == FLASH_ADDR) 
	          || (fsm_FLASH_ns == START_ADDRH)
	          || (fsm_FLASH_ns == START_ADDRL)
	          || (fsm_FLASH_ns == SEND_DATAH)
	          || (fsm_FLASH_ns == SEND_DATAL)
             )
	begin
		freq_cn <= freq_cn + 1'b1;
	end
end
	

always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
    begin
		scl_en <= 1'b0;
	end
	else if (freq_cn == 8'h80)
	begin
        scl_en <= 1'b1;
    end
    else if (freq_cn == 8'hF0)
    begin
		scl_en <= 1'b0;
	end
end

always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
    begin
		o_scl <= 1'b1;
		scl <= 1'b1;
	end
	else if (   (fsm_FLASH_ns == I2C_INIT) 
	         || (fsm_FLASH_ns == I2C_START) 
	         || (fsm_FLASH_ns == STOP_SIGNAL)
	         || (fsm_FLASH_ns == WRITE_DONE)	
	         || scl_en)
	begin
		o_scl <= 1'b1;
		scl <= 1'b1;
	end
	else 
	begin
		o_scl <= 1'b0;
		scl <= 1'b0;
	end
end

always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
   begin
		start_next_addrl <= 8'hff;
	end
	else if ((fsm_FLASH_cs == STOP_SIGNAL) && jump_en)
	begin
		start_next_addrl <= start_next_addrl + 8'h20;
	end
	else if ((fsm_FLASH_ns == I2C_INIT) && !first_pkg )
   begin
		start_next_addrl <= start_addr[7:0];
	end	
	else if ((fsm_FLASH_ns == IDLE_FLASH))
   begin
		start_next_addrl <= 8'h0;
	end
end
	
always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
    begin
		ov <= 1'b0;
	end
	else if (start_next_addrl == 8'he0)
	begin
		ov <= 1'b1;
	end
	else
	begin
		ov <= 1'b0;
	end 
end

always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
    begin
		start_next_addrh <= 8'h0;
	end
	else if (ov && (start_next_addrl == 8'h0))
	begin
		start_next_addrh <= start_next_addrh + 8'h1;
	end
	else if ((fsm_FLASH_ns == I2C_INIT) && !first_pkg )
   begin
		start_next_addrh <= start_addr[15:8];//8'h0;
	end
	else if (fsm_FLASH_ns == IDLE_FLASH)
   begin
		start_next_addrh <= 8'h0;
	end
end	

always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
    begin	
		o_flash_wr_en <= 1'b0;
	end
	else if ((((fsm_FLASH_ns == START_ADDRL)&& !first_pkg)|| (fsm_FLASH_ns == SEND_DATAL)) && (bit_cn == 4'b0000)&& !scl && scl_dly1) 
	begin
		o_flash_wr_en <= 1'b1;              
	end                                  
	else
	begin
		o_flash_wr_en <= 1'b0;
	end
end


always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
    begin	
		o_flash_waddr <= `ADDR_SZ'h0;   //Modified by SYF 2014.5.20
	end
	else if ((/*((fsm_FLASH_ns == START_ADDRL)&& !first_pkg)|| */(fsm_FLASH_ns == SEND_DATAL)) && (bit_cn == 4'b0000)&&!scl && scl_dly1)   //modified by SYF 2013.10.24
	begin
		o_flash_waddr <= o_flash_waddr + `ADDR_SZ'h1;        //Modified by SYF 2014.5.20       
	end                                   
	else if (fsm_FLASH_ns == IDLE_FLASH)
	begin
		o_flash_waddr <= `ADDR_SZ'h0;   //Modified by SYF 2014.5.20
	end
end	

always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
    begin	
        o_wr_dn <= 1'b0;
	 end
	 else if ((fsm_FLASH_ns == JUDGE) && (total_word_cn >= i_flash_data_len))
	 begin
	     o_wr_dn <= 1'b1;
	 end
	 else
    begin	
        o_wr_dn <= 1'b0;
	 end
end
	 
always @ (posedge i_clk,negedge i_rst_n)
begin
	if (!i_rst_n)
    begin
		sda_send <= 1'bz;
	end
	else 
	case (fsm_FLASH_ns)
	IDLE_FLASH,JUDGE,BUF_WAIT:
	begin
		sda_send <= 1'bz;//1'b1 to z
	end
    I2C_INIT,WRITE_DONE:
	begin
		sda_send <= 1'b1;
	end
	I2C_START,FLASH_ADDR_READY,STOP_SIGNAL,READY_STOP:		
	begin
		sda_send <= 1'b0;
	end	
	FLASH_ADDR:
	begin
	    if (bit_cn != 4'h0)
	    begin
			sda_send <= flash_addr [bit_cn-1];//to ensure the bit count is sync with flash-addr 
		end
		else
		begin
			sda_send <= 1'bz;
		end
	end
	START_ADDRH:
	begin
	    if (bit_cn != 4'h0)
	    begin
			sda_send <= start_next_addrh [bit_cn-1];//to ensure the bit count is sync with flash-addr 
		end
		else
		begin
			sda_send <= 1'bz;
		end
	end
	START_ADDRL:
	begin
	    if (bit_cn != 4'h0)
	    begin
			sda_send <= start_next_addrl [bit_cn-1];//to ensure the bit count is sync with flash-addr 
		end
		else
		begin
			sda_send <= 1'bz;
		end
	end	
	SEND_DATAH:
	begin
	    if (bit_cn != 4'h0)
	    begin
			sda_send <= datah [bit_cn-1];//to ensure the bit count is sync with flash-addr 
		end
		else
		begin
			sda_send <= 1'bz;
		end
	end		
	SEND_DATAL:
	begin
	    if (bit_cn != 4'h0)
	    begin
			sda_send <= datal [bit_cn-1];//to ensure the bit count is sync with flash-addr 
		end
		else
		begin
			sda_send <= 1'bz;
		end
	end	
	default:
	begin
		sda_send <= 1'bz;
	end
	endcase
end



endmodule
