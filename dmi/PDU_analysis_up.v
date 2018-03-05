
/*******************************************************************
File name   			:	dmi_top.v
Function    			:	1.analysis the pdu ;
								2.provides pins connect with external module;
 
Version maintenance	:	zourenbo
Version     			:	V1.0
data        			:	2010-12-13
*******************************************************************/

/***************************   modify record   *********************

**************************************************************************
**************************************************************************/

module  PDU_analysis_up(
		i_clk,
		i_rst_n,

		i_Rx_dv,
		i_recv_data,

		i_macro_start_trig,
		i_frt_sent,
		i_mcc_sent,
		i_syncreq_sent,
		i_syncrsp_sent,
//		i_syncreq_sent_A,
//		i_syncreq_sent_B,
//		i_syncreq_sent_C,
//		i_syncrsp_sent_A,
//		i_syncrsp_sent_B,
//		i_syncrsp_sent_C,

		o_src_mac_low,
		o_dest_mac,
		o_pkg_type,
		o_frt_type,
		o_id,
		recv_addr,
		o_recv_status,

		i_local_node_mac,
		o_recv_data_legal,
		o_rd_en
);

		input           i_clk;
		input           i_rst_n;

		input           i_Rx_dv;
		input   [3:0]   i_recv_data;

		input           i_macro_start_trig;
		input   [63:0]  i_frt_sent;
		input   [63:0] i_mcc_sent;
		input   [63:0] i_syncreq_sent;
		input   [63:0] i_syncrsp_sent;
//		input   [63:0] i_syncreq_sent_A;
//		input   [63:0] i_syncreq_sent_B;
//		input   [63:0] i_syncreq_sent_C;
//		input   [63:0] i_syncrsp_sent_A;
//		input   [63:0] i_syncrsp_sent_B;
//		input   [63:0] i_syncrsp_sent_C;

		output  [5:0]   o_src_mac_low;
		output  [47:0]  o_dest_mac;
		output  [15:0]  o_pkg_type;
		output  [7:0]   o_frt_type;
		output  [1:0]   o_id;
		output  [15:0]  recv_addr;
		output  [3:0]   o_recv_status;
		
		input   [47:0]  i_local_node_mac;
		output          o_recv_data_legal;
		output          o_rd_en;




		wire    [5:0]   o_src_mac_low;
		reg     [47:0]  o_dest_mac;
		reg     [15:0]  o_pkg_type;
		reg     [7:0]   o_frt_type;
		reg     [1:0]   o_id;
		reg     [15:0]  recv_addr;
		reg     [3:0]   o_recv_status;
		
		reg             o_recv_data_legal;
		reg             o_rd_en;




assign o_src_mac_low = o_src_mac[5:0];




		reg             pkg_flag;
		reg     [47:0]  o_src_mac;
		reg     [7:0]   compensation_cnt;





reg [3:0]  Nextstate;
reg [3:0]  State;
parameter  IDLE        = 4'b0000;
parameter  RECV_PRENUM = 4'b0001;
parameter  RECV_DATA   = 4'b0010;
parameter  RECV_DONE   = 4'b0011;


always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		Nextstate <= IDLE;
	end
	else
	case(Nextstate)
	IDLE:
		if(i_Rx_dv)
			Nextstate <= RECV_PRENUM;
		else
			Nextstate <= IDLE;
	RECV_PRENUM:      //receive pre num
		if(!i_Rx_dv)
			Nextstate <= IDLE;
		else if(i_recv_data == 4'hd)
			Nextstate <= RECV_DATA;
		else 
			Nextstate <= RECV_PRENUM ;		
	RECV_DATA:        //receive the data
		if(!i_Rx_dv)
			Nextstate <= RECV_DONE;
		else
			Nextstate <= RECV_DATA;	
	RECV_DONE:        //receive done
		Nextstate <= IDLE;
	default:
		Nextstate <= IDLE;		
	endcase	
end
/********************end**************************/



/**************generate the receive address************************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		recv_addr <= 16'd0;
	end
	else 
	case(Nextstate)
	IDLE,RECV_PRENUM,RECV_DONE:
		begin
			recv_addr <= 16'd0;
		end		
	RECV_DATA:
		begin
			recv_addr <= recv_addr + 16'd1;
		end	
	default:
		begin
			recv_addr <= 16'd0;
		end	
	endcase	
end
/********************end**************************/


always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		pkg_flag <= 1'b0;
	end
	else if(Nextstate == RECV_DATA)
	begin
		pkg_flag <= 1'b1;
	end
	else if(Nextstate == RECV_DONE)
	begin
		pkg_flag <= 1'b0;	
	end
	else
	begin
		pkg_flag <= pkg_flag;
	end	
end



/*******save the dest mac   of the  pdu********/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		o_dest_mac <= 48'b0;
	end
	else if(recv_addr == 16'd10) 
	begin
		o_dest_mac[3:0] <= i_recv_data;
	end
	else if(recv_addr == 16'd11) 
	begin
		o_dest_mac[7:4] <= i_recv_data;
	end
	else if(recv_addr == 16'd8) 
	begin
		o_dest_mac[11:8] <= i_recv_data; 
	end	
	else if(recv_addr == 16'd9)
	begin
		o_dest_mac[15:12] <= i_recv_data; 
	end
	else if(recv_addr == 16'd6) 
	begin
		o_dest_mac[19:16] <= i_recv_data;
	end
	else if(recv_addr == 16'd7) 
	begin
		o_dest_mac[23:20] <= i_recv_data;
	end
	else if(recv_addr == 16'd4) 
	begin
		o_dest_mac[27:24] <= i_recv_data;
	end	
	else if(recv_addr == 16'd5)
	begin
		o_dest_mac[31:28] <= i_recv_data;
	end
	else if(recv_addr == 16'd2)
	begin
		o_dest_mac[35:32] <= i_recv_data;
	end
	else if(recv_addr == 16'd3) 
	begin
		o_dest_mac[39:36] <= i_recv_data;
	end
	else if(recv_addr == 16'd0) 
	begin
		o_dest_mac[43:40] <= i_recv_data;
	end
	else if(recv_addr == 16'd1) 
	begin
		o_dest_mac[47:44] <= i_recv_data;
	end	
	else if(pkg_flag == 1'b0)
	begin
		o_dest_mac <= 48'b0;
	end
	else 
	begin
		o_dest_mac <= o_dest_mac;    //others
	end			
end
/*********************end*************************/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		o_src_mac <= 48'b0;
	end
	else if(recv_addr == 16'd22) 
	begin
		o_src_mac[3:0] <= i_recv_data;
	end
	else if(recv_addr == 16'd23) 
	begin
		o_src_mac[7:4] <= i_recv_data;
	end
	else if(recv_addr == 16'd20) 
	begin
		o_src_mac[11:8] <= i_recv_data; 
	end	
	else if(recv_addr == 16'd21)
	begin
		o_src_mac[15:12] <= i_recv_data; 
	end
	else if(recv_addr == 16'd18) 
	begin
		o_src_mac[19:16] <= i_recv_data;
	end
	else if(recv_addr == 16'd19) 
	begin
		o_src_mac[23:20] <= i_recv_data;
	end
	else if(recv_addr == 16'd16) 
	begin
		o_src_mac[27:24] <= i_recv_data;
	end	
	else if(recv_addr == 16'd17)
	begin
		o_src_mac[31:28] <= i_recv_data;
	end
	else if(recv_addr == 16'd14)
	begin
		o_src_mac[35:32] <= i_recv_data;
	end
	else if(recv_addr == 16'd15) 
	begin
		o_src_mac[39:36] <= i_recv_data;
	end
	else if(recv_addr == 16'd12) 
	begin
		o_src_mac[43:40] <= i_recv_data;
	end
	else if(recv_addr == 16'd13) 
	begin
		o_src_mac[47:44] <= i_recv_data;
	end	
	else if(pkg_flag == 1'b0)
	begin
		o_src_mac <= 48'b0;
	end
	else 
	begin
		o_src_mac <= o_src_mac;    //others
	end
end



/*******save the type of the pdu,such as frt,arp ...********/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		o_pkg_type <= 16'b0;
	end
	else if(recv_addr == 16'd24) 
	begin
		o_pkg_type[11:8] <= i_recv_data;
	end
	else if(recv_addr == 16'd25) 
	begin
		o_pkg_type[15:12] <= i_recv_data;
	end
	else if(recv_addr == 16'd26) 
	begin
		o_pkg_type[3:0] <= i_recv_data;
	end	
	else if(recv_addr == 16'd27)
	begin
		o_pkg_type[7:4] <= i_recv_data;
	end
	else if(pkg_flag == 1'b0)
	begin
		o_pkg_type <= 16'h0;   
	end		
	else 
	begin
		o_pkg_type <= o_pkg_type;
	end			
end

/*******save the type of the frt pdu,such as frt,ptp,mm...********/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		o_frt_type <= 8'b0;
	end
	else if(recv_addr == 16'd29) 
	begin
		o_frt_type[7:4] <= i_recv_data;
	end
	else if(recv_addr == 16'd28) 
	begin
		o_frt_type[3:0] <= i_recv_data;
	end
	else if(pkg_flag == 1'b0)
	begin
		o_frt_type <= 8'h0;   
	end
	else 
	begin
		o_frt_type <= o_frt_type;
	end			
end
/*********************end*************************/

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		o_id <= 2'b0;
	end
//	else if(recv_addr == 16'd31) 
//	begin
//		o_id[7:4] <= i_recv_data;
//	end
//	else if(recv_addr == 16'd30) 
//	begin
//		o_id[3:0] <= i_recv_data;
//	end
	else if(recv_addr == 16'd31) 
	begin
		o_id <= i_recv_data[1:0];
	end
	else if(pkg_flag == 1'b0)
	begin
		o_id <= 2'h0;   
	end
	else 
	begin
		o_id <= o_id;
	end			
end

/****save the status****/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		o_recv_status <= 4'b0;
	end
	else if(recv_addr == 16'd42)
	begin
		o_recv_status <= i_recv_data;
	end
	else if(pkg_flag == 1'b0)
	begin
		o_recv_status <= 4'b0;
	end
	else
	begin
		o_recv_status <= o_recv_status;
	end
end



always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		compensation_cnt <= 8'b0;
	end
	else if(!i_Rx_dv)
	begin
		compensation_cnt <= compensation_cnt + 1'b1;
	end
	else if(i_Rx_dv)
	begin
		compensation_cnt <= 8'b0;
	end
	else
	begin
		compensation_cnt <= compensation_cnt;
	end
end



always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		o_rd_en <= 1'b0;
	end
//	else if(recv_addr == 8'd24)
	else if(recv_addr == 8'd31)
	begin
		o_rd_en <= 1'b1;
	end
//	else if(compensation_cnt > 8'd39)
	else if(compensation_cnt > 8'd46)
	begin
		o_rd_en <= 1'b0;
	end
	else
	begin
		o_rd_en <= o_rd_en;
	end
end


always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		o_recv_data_legal <= 1'b0;
	end
//	else if((recv_addr == 8'd25) && o_rd_en && (o_src_mac != i_local_node_mac))
	else if((recv_addr == 8'd32) && (o_pkg_type == 16'h8907) && (o_src_mac != i_local_node_mac))
	begin
		if((o_frt_type[7:4] == 4'h9) && !i_mcc_sent[o_src_mac_low])
			o_recv_data_legal <= 1'b1;
		else if((o_frt_type == 8'h10) && !i_frt_sent[o_src_mac_low])
			o_recv_data_legal <= 1'b1;
		else if((o_frt_type == 8'h20) && !i_syncreq_sent[o_src_mac_low])
			o_recv_data_legal <= 1'b1;
		else if((o_frt_type == 8'h21) && !i_syncrsp_sent[o_src_mac_low])
			o_recv_data_legal <= 1'b1;
//		else if((o_frt_type == 8'h20) && (o_id == 2'b00) && !i_syncreq_sent_A[o_src_mac_low])
//			o_recv_data_legal <= 1'b1;
//		else if((o_frt_type == 8'h20) && (o_id == 2'b01) && !i_syncreq_sent_B[o_src_mac_low])
//			o_recv_data_legal <= 1'b1;
//		else if((o_frt_type == 8'h20) && (o_id == 2'b10) && !i_syncreq_sent_C[o_src_mac_low])
//			o_recv_data_legal <= 1'b1;
//		else if((o_frt_type == 8'h21) && (o_id == 2'b00) && !i_syncrsp_sent_A[o_src_mac_low])
//			o_recv_data_legal <= 1'b1;
//		else if((o_frt_type == 8'h21) && (o_id == 2'b01) && !i_syncrsp_sent_B[o_src_mac_low])
//			o_recv_data_legal <= 1'b1;
//		else if((o_frt_type == 8'h21) && (o_id == 2'b10) && !i_syncrsp_sent_C[o_src_mac_low])
//			o_recv_data_legal <= 1'b1;
		else
			o_recv_data_legal <= o_recv_data_legal;
	end
//	else if(compensation_cnt > 8'd40)
	else if(compensation_cnt > 8'd47)
	begin
		o_recv_data_legal <= 1'b0;
	end
	else
	begin
		o_recv_data_legal <= o_recv_data_legal;
	end
end



endmodule 