
/*******************************************************************
File name   			:	master_csme.v
Function    			:	seng conmunication;
 
Version maintenance	:	caogang
Version     			:	V1.0
data        			:	2011-02-13
*******************************************************************/

/***************************   modify record   *********************

**************************************************************************
**************************************************************************/
module  master_csme(
			input wire i_clk,
			input wire i_rst_n,
			//
			input wire i_macrocycle_b,
			input wire [31:0]i_local_ip,
			input wire [31:0]i_frt_sendtime,
			//frt
			output reg [31:0]o_ind,
			output wire o_frt_trig,
			input wire [31:0]i_src_ip,
			input wire [7:0]i_pri,
			input wire i_rec_dn,
			//mm
			input wire i_csme_en,
			input wire i_mm_status,
			output reg o_mm_trig,
			//ptp
			output reg o_SyncReq_trig,
			output wire o_opc_trig,
			//evt
			input wire i_evt_status,
			output reg o_evt_trig,
			output reg o_write_dpram_trig,
			output reg o_read_dpram_trig,
			//config
			output reg o_config_trig,
			input wire i_config_status,
			
		   input wire i_main_clock_state,
			//nfrt read/write trig
			output reg o_nfrt_rd_dpram_trig,
			output reg o_nfrt_wr_dpram_trig
					);
					
reg macrocycle_b_dly;
reg [31:0]send_cnt, ac_send_cnt;
reg [7:0]hi_pri;
reg [7:0]local_hi_pri;			
					

reg pkg_trig, pkg_trig_reg, frt_trig, frt_trig_1clk;
					
always @(posedge i_clk or negedge i_rst_n)			
begin
	if(!i_rst_n)
		macrocycle_b_dly <= 1'b0;
	else
		macrocycle_b_dly <= i_macrocycle_b;
end		
//
always @(posedge i_clk or negedge i_rst_n)			
begin
	if(!i_rst_n)
		send_cnt <= 32'b0;
	else if(i_macrocycle_b )
		send_cnt <= send_cnt + 32'd40;
	else if(!i_macrocycle_b)
		send_cnt <= 32'b0;
end

always @(posedge i_clk or negedge i_rst_n)			
begin
	if(!i_rst_n)
		ac_send_cnt <= 32'b0;
	else if(!i_macrocycle_b )
		ac_send_cnt <= ac_send_cnt + 32'd40;
	else if(i_macrocycle_b)
		ac_send_cnt <= 32'b0;
end		
//
always @(posedge i_clk or negedge i_rst_n)			
begin
	if(!i_rst_n)
		frt_trig <= 1'b0;
	else if(send_cnt >= i_frt_sendtime && i_macrocycle_b && i_csme_en)
		frt_trig <= 1'b1;
	else 
		frt_trig <= 1'b0;
end	


always @(posedge i_clk or negedge i_rst_n)			
begin
	if(!i_rst_n)
		frt_trig_1clk <= 1'b0;
	else 
		frt_trig_1clk <= frt_trig;
end	

assign o_frt_trig = !frt_trig_1clk && frt_trig;

always @(posedge i_clk or negedge i_rst_n)			
begin
	if(!i_rst_n)
		pkg_trig <= 1'b0;
	else if((send_cnt >= i_frt_sendtime + 32'h2710) && i_macrocycle_b && i_csme_en)
		pkg_trig <= 1'b1;
	else 
		pkg_trig <= 1'b0;
end	


//data out_dpram trig
always @(posedge i_clk or negedge i_rst_n)			
begin
	if(!i_rst_n)
		o_read_dpram_trig <= 1'b0;
	//else if(ac_send_cnt == 32'd4000 && i_csme_en)
	else if(ac_send_cnt == 32'd50000 && i_csme_en)
		o_read_dpram_trig <= 1'b1;
	else 
		o_read_dpram_trig <= 1'b0;
end

//data in_dpram trig
always @(posedge i_clk or negedge i_rst_n)			
begin
	if(!i_rst_n)
		o_write_dpram_trig <= 1'b0;
	//else if(ac_send_cnt == 32'd20000 && i_csme_en)
	else if(ac_send_cnt == 32'd10000 && i_csme_en)
		o_write_dpram_trig <= 1'b1;
	else 
		o_write_dpram_trig <= 1'b0;
end

//nfrt read dpram data
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		o_nfrt_rd_dpram_trig <= 1'b0;
	else if(ac_send_cnt == 32'd36000 && i_csme_en)
		o_nfrt_rd_dpram_trig <= 1'b1;
	else
		o_nfrt_rd_dpram_trig <= 1'b0;
end

//nfrt write dpram data
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		o_nfrt_wr_dpram_trig <= 1'b0;
	else if(ac_send_cnt == 32'd40000 && i_csme_en)
		o_nfrt_wr_dpram_trig <= 1'b1;
	else
		o_nfrt_wr_dpram_trig <= 1'b0;
end

always @(posedge i_clk or negedge i_rst_n)			
begin
	if(!i_rst_n)
		pkg_trig_reg <= 1'b0;
	else 
		pkg_trig_reg <= pkg_trig;
end	

assign o_opc_trig = !pkg_trig_reg & pkg_trig;

//calculate the pri in frt frame 
always @(posedge i_clk or negedge i_rst_n)			
begin
	if(!i_rst_n)
		local_hi_pri <= 8'hff;
	else if(i_evt_status)
		local_hi_pri <= 8'h1;
	else if(i_mm_status)
		local_hi_pri <= 8'h21;
	else
		local_hi_pri <= 8'hff;		
end	


//calculate the o_ind in frt frame (for master )
/*always @(posedge i_clk or negedge i_rst_n)			
begin
	if(!i_rst_n)
	begin
		o_ind <= 32'hffffffff;
		hi_pri <= 8'hff;
	end
	else if(i_macrocycle_b && !macrocycle_b_dly)
	begin
		o_ind <= i_local_ip;
		hi_pri <= local_hi_pri;
	end	
	else if(i_rec_dn && ( (i_pri < hi_pri) ||  (i_pri == hi_pri && i_src_ip < o_ind  ) ) )
	begin
		o_ind <= i_src_ip;
		hi_pri <= i_pri;
	end
	else 
	begin
		o_ind <= o_ind;
		hi_pri <= hi_pri;	
	end
end*/

reg o_SyncReq_trig_interim;

always @(posedge i_clk or negedge i_rst_n)			
begin
	if(!i_rst_n)
	begin
		o_evt_trig <= 1'b0;
		o_mm_trig  <= 1'b0;
		o_SyncReq_trig <= 1'b0;
		o_config_trig <= 1'b0;
		o_SyncReq_trig_interim <= 1'b0; //sjj Nov_19th
	end
	else if(/*o_ind == i_local_ip &&*/ !i_macrocycle_b && macrocycle_b_dly && i_config_status )
		begin
			o_evt_trig <= 1'b0;
			o_mm_trig  <= 1'b0;
			o_SyncReq_trig <= 1'b0;
			o_config_trig <= 1'b1;
		end	
	else if(/*o_ind == i_local_ip &&*/ !i_macrocycle_b && macrocycle_b_dly && i_mm_status )
		begin
			o_evt_trig <= 1'b0;
			o_mm_trig  <= 1'b1;
			o_SyncReq_trig <= 1'b0;
			o_config_trig <= 1'b0;
		end
	else if(o_ind == i_local_ip && !i_macrocycle_b && macrocycle_b_dly && i_evt_status)
		begin
			o_evt_trig <= 1'b1;
			o_mm_trig  <= 1'b0;
			o_SyncReq_trig <= 1'b0;
			o_config_trig <= 1'b0;
		end	
   /****** sjj Nov_19th*******/
	else if(i_csme_en && i_main_clock_state && !i_macrocycle_b && macrocycle_b_dly && o_SyncReq_trig_interim)
		begin
			o_evt_trig <= 1'b0;
			o_mm_trig  <= 1'b0;		
			o_SyncReq_trig <= 1'b1;
			o_config_trig <= 1'b0;
			o_SyncReq_trig_interim <= 1'b1;
		end
	/****** sjj Nov_19th*******/		

	else if(i_csme_en /*&& o_ind == i_local_ip*/ && i_main_clock_state && !i_macrocycle_b && macrocycle_b_dly)
		begin
			o_evt_trig <= 1'b0;
			o_mm_trig  <= 1'b0;		
//			o_SyncReq_trig <= 1'b1;			
			o_SyncReq_trig_interim <= 1'b1;   //sjj Nov_19th
			o_config_trig <= 1'b0;
		end	

	else
	begin
		o_evt_trig <= 1'b0;
		o_mm_trig  <= 1'b0;
		o_SyncReq_trig <= 1'b0;
		o_config_trig <= 1'b0;
		o_SyncReq_trig_interim <= o_SyncReq_trig_interim;    //sjj Nov_19th
	end	
end	

endmodule
