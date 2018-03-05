
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

module  PDU_analysis(
		input wire  i_clk,
		input wire  i_rst_n,
		input wire  i_macrocycle_b,
		
		input wire  i_Rx_dv,
		input wire  [3:0] i_recv_data,
		
		input wire  i_device_type,                    //Modified by SYF 2014.6.18
		
		output reg  [47:0] o_dest_mac,
		output reg  [15:0] o_pkg_type,
		output reg  [7:0]  o_frt_type,
		output reg  [7:0]  o_msgid,
		output reg  [15:0] recv_addr,
		output reg  [3:0]  o_recv_status,
		
		/*******************************/
		input wire [15:0] i_len_master_clock,           //Modified by SYF 2014.5.23
      /*******************************/
		//for time check
		output reg  o_rd_en_property,							//modified by guhao 20131220
		output reg  [7:0]  o_rd_addr,							//modified by guhao 20131220
		input  wire [95:0] i_devicepro,						//Modified by SYF 2014.5.22
		input  wire i_query_plantinfo_dn,					//modified by guhao 20131223
		input  wire i_csme_en,									//modified by guhao 20131223
		input  wire [99:0] i_is_device,						//modified by guhao 20131227
		//for time check

		input  wire [31:0] i_ptptime_second,
		input  wire [31:0] i_ptptime_nanosecond,
		input  wire [31:0] i_macro_start_time_s,
		input  wire [31:0] i_macro_start_time_ns,
		
		//20140213	//for package check
		output reg [191:0] o_alarm_data,
		output reg o_send_alarm_to_pdo,
		output wire o_pack_safe,
		
//		output wire o_send_alarm_to_pdo_1,
//		output wire o_pack_safe_1,
		//20140213
		
		//20140225, for package transmit
		output reg  o_recv_data_legal,
		output reg  o_rd_en,
		//20140225
		
		//test
		output reg  [31:0] o_time_shake,
		output reg  [3:0] o_dst_mac_type,
		output reg  [7:0] o_pack_type
		//test
);

//assign o_send_alarm_to_pdo_1 = 1'b0;
//assign o_pack_safe_1 = 1'b1;
reg pack_safe;                                                                //Modified by SYF 2014.6.18
assign o_pack_safe = !i_device_type ? 1'b1 : pack_safe;                       //Modified by SYF 2014.6.18

//test
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		o_time_shake <= 32'b0;
		o_dst_mac_type <= 4'b0;
		o_pack_type <= 8'b0;
	end
	else
	begin
		o_time_shake <= time_shaking;
		o_dst_mac_type <= dst_mac_type;
		o_pack_type <= pack_type;
	end
end
//test

reg [3:0] Nextstate, State;
reg pkg_flag;

parameter  IDLE = 4'b0000;
parameter  RECV_PRENUM = 4'b0001;
parameter  RECV_DATA = 4'b0010;
parameter  RECV_DONE = 4'b0011;

//20140213
reg [47:0] src_mac;							/* modified by guhao 20131210 for line-bus security test */
reg [31:0] packB17_20;						/*modified by guhao 20131230, DstIP if sync, SrcIP if FRT*/
reg [31:0] packB21_24;						/*modified by guhao 20131230, SrcIP if sync, M/S & Len if FRT*/
reg [3:0]  dst_mac_type;					/* modified by guhao 20131210 for line-bus security test */
reg [7:0]  pack_type;						/* modified by guhao 20131211 for line-bus security test */

reg [31:0] pack_received_s;				//for alarm time data and time security check
reg [31:0] pack_received_ns;
reg [31:0] send_offset;						//caculate the time offset
reg [31:0] time_shaking;

reg macrocycle_b_dly;
reg [99:0] is_active;
reg [99:0] is_active_rsp;
reg [99:0] curmacrofrt_sent;
reg [99:0] curmacrosyncreq_sent;
reg [99:0] curmacrosyncrsp_sent;
reg [99:0] curmacromcc_sent;

reg frt_illegalsid;
reg frt_illegaltype;
reg frt_illegalmsgid;
reg frt_unmatchip;
reg frt_illegalclockstate;
reg frt_illegallength;

reg syncreq_illegalsid;
reg syncreq_illegaltype;
reg syncreq_illegaldstip;
reg syncreq_illegalsrcip;

reg syncrsp_illegalsid;
reg syncrsp_illegaltype;
reg syncrsp_illegaldstip;
reg syncrsp_illegalsrcip;

reg mm_illegalsid;
reg mm_illegaltype;
reg mm_illegalsrcip;
reg mm_illegaldstip;

reg mcc_illegalsid;
reg mcc_illegaltype;
reg mcc_illegalmsgid;
reg mcc_unmatchip;
reg mcc_wrongdata;

reg frt_abnormal_packlen;
reg mcc_abnormal_packlen;
reg syncreq_abnormal_packlen;
reg syncrsp_abnormal_packlen;

//illegal detected from transmit
reg frt_floodattack;
reg frt_illegaltimeoffset;
reg syncreq_floodattack;
reg syncrsp_floodattack;
reg mcc_floodattack;

reg summrize_security_check;

reg [31:0] o_frt_error_type;
reg [31:0] o_mm_error_type;
reg [31:0] o_mcc_error_type;
reg [31:0] o_syncreq_error_type;
reg [31:0] o_syncrsp_error_type;
reg [31:0] o_pack_error_type;

reg arrange_alarm_to_pdo;
reg alarmdata_send_done;
//20140213

reg [7:0] compensation_cnt;	//20140225




/**************analysis the receive data************************/
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
		begin
			Nextstate <= RECV_PRENUM;
			pack_received_s  <= i_ptptime_second;
			pack_received_ns <= i_ptptime_nanosecond;		
		end
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
	RECV_DONE:      //receive done
	begin
		Nextstate <= IDLE;
		pack_received_s  <= 32'b0;
		pack_received_ns <= 32'b0;
	end
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
		recv_addr <= 16'd0 ;
	end
	else 
	case(Nextstate)
	IDLE,RECV_PRENUM,RECV_DONE:
		begin
		recv_addr <= 16'd0 ;
		end		
	RECV_DATA:
		begin
		recv_addr <= recv_addr + 16'd1 ;
		end	
	default:
		begin
		recv_addr <= 16'd0 ;
		end	
	endcase	
end
/********************end**************************/


always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		pkg_flag <= 1'b0 ;
	end
	else if(Nextstate == RECV_DATA)
	begin
		pkg_flag <= 1'b1 ;
	end
	else if(Nextstate == RECV_DONE)
	begin
		pkg_flag <= 1'b0 ;	
	end
	else
	begin
		pkg_flag <= pkg_flag ;
	end	
end



/*******save the dest mac   of the  pdu********/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_dest_mac <= 48'b0 ;
	end
	else if(recv_addr == 16'd10) 
	begin
	o_dest_mac[3:0] <= i_recv_data ;    //  
	end
	else if(recv_addr == 16'd11) 
	begin
	o_dest_mac[7:4] <= i_recv_data ;    //  
	end
	else if(recv_addr == 16'd8) 
	begin
	o_dest_mac[11:8] <= i_recv_data ; 
	end	
	else if(recv_addr == 16'd9)
	begin
	o_dest_mac[15:12] <= i_recv_data ; 
	end
	else if(recv_addr == 16'd6) 
	begin
	o_dest_mac[19:16] <= i_recv_data ;    //  
	end
	else if(recv_addr == 16'd7) 
	begin
	o_dest_mac[23:20] <= i_recv_data ;    //  
	end
	else if(recv_addr == 16'd4) 
	begin
	o_dest_mac[27:24] <= i_recv_data ; 
	end	
	else if(recv_addr == 16'd5)
	begin
	o_dest_mac[31:28] <= i_recv_data ; 
	end
	else if(recv_addr == 16'd2)
	begin
	o_dest_mac[35:32] <= i_recv_data ; 
	end
	else if(recv_addr == 16'd3) 
	begin
	o_dest_mac[39:36] <= i_recv_data ;    //  
	end
	else if(recv_addr == 16'd0) 
	begin
	o_dest_mac[43:40] <= i_recv_data ;    //  
	end
	else if(recv_addr == 16'd1) 
	begin
	o_dest_mac[47:44] <= i_recv_data ; 
	end	
	else if(pkg_flag == 1'b0)
	begin
	o_dest_mac <= 48'b0 ;
	end
	else 
	begin
	o_dest_mac <= o_dest_mac;    //others
	end			
end
/*********************end*************************/



/*******save the type of the pdu,such as frt,arp ...********/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_pkg_type <= 16'b0 ;
	end
	else if(recv_addr == 16'd24) 
	begin
	o_pkg_type[11:8] <= i_recv_data ;    //  
	end
	else if(recv_addr == 16'd25) 
	begin
	o_pkg_type[15:12] <= i_recv_data ;    //  
	end
	else if(recv_addr == 16'd26) 
	begin
	o_pkg_type[3:0] <= i_recv_data ; 
	end	
	else if(recv_addr == 16'd27)
	begin
	o_pkg_type[7:4] <= i_recv_data ; 
	end
	else if(pkg_flag == 1'b0)
	begin
	o_pkg_type <= 16'h0;   
	end		
	else 
	begin
	o_pkg_type <= o_pkg_type;    //others
	end			
end
/*********************end*************************/

/*******save the type of the frt pdu,such as frt,ptp,mm...********/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_frt_type <= 8'b0 ;
	end
	else if(recv_addr == 16'd29) 
	begin
	o_frt_type[7:4] <= i_recv_data ;    //  
	end
	else if(recv_addr == 16'd28) 
	begin
	o_frt_type[3:0] <= i_recv_data ;    //  
	end
	else if(pkg_flag == 1'b0)
	begin
	o_frt_type <= 8'h0;   
	end
	else 
	begin
	o_frt_type <= o_frt_type;    //others
	end			
end
/*********************end*************************/


/*******save the message id  of the  pdu********/
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
	o_msgid <= 8'b0 ;
	end
	else if(recv_addr == 16'd30) 
	begin
	o_msgid[3:0] <= i_recv_data ;    //  
	end
	else if(recv_addr == 16'd31) 
	begin
	o_msgid[7:4] <= i_recv_data ;    //  
	end
	else if(pkg_flag == 1'b0)
	begin
	o_msgid <= 8'h0;   
	end
	else 
	begin
	o_msgid <= o_msgid;    //others
	end			
end
/*********************end*************************/



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




//20140221, add package check, gather package data
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		src_mac <= 48'b0 ;
	end
	else if(recv_addr == 16'd12) 
	begin
		src_mac[43:40] <= i_recv_data ;
	end
	else if(recv_addr == 16'd13) 
	begin
		src_mac[47:44] <= i_recv_data ; 
	end
	else if(recv_addr == 16'd14)
	begin
		src_mac[35:32] <= i_recv_data ; 
	end
	else if(recv_addr == 16'd15) 
	begin
		src_mac[39:36] <= i_recv_data ;
	end	
	else if(recv_addr == 16'd16) 
	begin
		src_mac[27:24] <= i_recv_data ; 
	end
	else if(recv_addr == 16'd17)
	begin
		src_mac[31:28] <= i_recv_data ; 
	end
	else if(recv_addr == 16'd18) 
	begin
		src_mac[19:16] <= i_recv_data ;
	end
	else if(recv_addr == 16'd19) 
	begin
		src_mac[23:20] <= i_recv_data ;
	end
	else if(recv_addr == 16'd20) 
	begin
		src_mac[11:8] <= i_recv_data ; 
	end
	else if(recv_addr == 16'd21)
	begin
		src_mac[15:12] <= i_recv_data ; 
	end
	else if(recv_addr == 16'd22) 
	begin
		src_mac[3:0] <= i_recv_data ;
	end
	else if(recv_addr == 16'd23) 
	begin
		src_mac[7:4] <= i_recv_data ;
	end
	else if(pkg_flag == 1'b0)
	begin
		src_mac <= 48'b0 ;
	end
end

//packB17_20, SrcIP for FRT/MM, DstIP for SYNC
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		packB17_20 <= 32'b0;
	end
	else if(recv_addr == 16'd32) 
	begin
		packB17_20[27:24] <= i_recv_data ; 
	end
	else if(recv_addr == 16'd33)
	begin
		packB17_20[31:28] <= i_recv_data ; 
	end
	else if(recv_addr == 16'd34) 
	begin
		packB17_20[19:16] <= i_recv_data ;
	end
	else if(recv_addr == 16'd35) 
	begin
		packB17_20[23:20] <= i_recv_data ;
	end
	else if(recv_addr == 16'd36) 
	begin
		packB17_20[11:8] <= i_recv_data ; 
	end
	else if(recv_addr == 16'd37)
	begin
		packB17_20[15:12] <= i_recv_data ; 
	end
	else if(recv_addr == 16'd38) 
	begin
		packB17_20[3:0] <= i_recv_data ;
	end
	else if(recv_addr == 16'd39) 
	begin
		packB17_20[7:4] <= i_recv_data ;
	end
	else if(pkg_flag == 1'b0)
	begin
		packB17_20 <= 32'b0 ;
	end
end

//pack 21_24, DstIP for MM, SrcIP for SYNC, M/S & Lenth for FRT
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		packB21_24 <= 32'b0;
	end
	else if(recv_addr == 16'd40) 
	begin
		packB21_24[27:24] <= i_recv_data ; 
	end
	else if(recv_addr == 16'd41)
	begin
		packB21_24[31:28] <= i_recv_data ; 
	end
	else if(recv_addr == 16'd42) 
	begin
		packB21_24[19:16] <= i_recv_data ;
	end
	else if(recv_addr == 16'd43) 
	begin
		packB21_24[23:20] <= i_recv_data ;
	end
	else if(recv_addr == 16'd44) 
	begin
		packB21_24[11:8] <= i_recv_data ; 
	end
	else if(recv_addr == 16'd45)
	begin
		packB21_24[15:12] <= i_recv_data ; 
	end
	else if(recv_addr == 16'd46) 
	begin
		packB21_24[3:0] <= i_recv_data ;
	end
	else if(recv_addr == 16'd47) 
	begin
		packB21_24[7:4] <= i_recv_data ;
	end
	else if(pkg_flag == 1'b0)
	begin
		packB21_24 <= 32'b0 ;
	end
end

//after dst_mac finished, judge dst_mac_type
always @(posedge i_clk ,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		dst_mac_type <= 4'b0;
	end
	else if(recv_addr == 16'd12)
	begin
		if((o_dest_mac[47:40] == 8'hff) && (o_dest_mac[39:32] == 8'hff) && (o_dest_mac[31:24] == 8'hff) && (o_dest_mac[23:16] == 8'hff) && (o_dest_mac[15:8] == 8'hff) && (o_dest_mac[7:0] == 8'hff))
			dst_mac_type <= 4'd1;	//FRT or MM request or MCC
		else if((o_dest_mac[47:40] == 8'h1) && (o_dest_mac[39:32] == 8'h0) && (o_dest_mac[31:24] == 8'h5e) && (o_dest_mac[23:16] == 8'h0) && (o_dest_mac[15:8] == 8'h1) && (o_dest_mac[7:0] == 8'h81))
			dst_mac_type <= 4'd2;	//SYNC_REQ MAC
		else if((o_dest_mac[47:40] == 8'h1) && (o_dest_mac[39:32] == 8'h0) && (o_dest_mac[31:24] == 8'h5e) && (o_dest_mac[23:16] == 8'h0) && (o_dest_mac[15:8] == 8'h1) && (o_dest_mac[7:0] == 8'h82))
			dst_mac_type <= 4'd3;	//SYNC_RSP MAC
		else if((o_dest_mac[47:40] == 8'h0) && (o_dest_mac[39:32] == 8'h1) && (o_dest_mac[31:24] == 8'h2 ) && (o_dest_mac[23:16] == 8'h3) && (o_dest_mac[15:8] == 8'h4) && (o_dest_mac[7:0] == 8'd200))
			dst_mac_type <= 4'd4;	//mm_rsp or config_rsp Host MAC is 00-01-02-03-04-200
		else
			dst_mac_type <= 4'd5;	//not system pack
	end
	else if(pkg_flag == 1'b0)
		dst_mac_type <= 4'd0;
end

always @(posedge i_clk ,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		pack_type <= 8'b0;
	end
	else if(recv_addr == 16'd24)
	begin
		if(dst_mac_type == 4'd1)//FF-FF-FF-FF-FF-FF
		begin
			if((src_mac[47:40] == 8'h0) && (src_mac[39:32] == 8'h1) && (src_mac[31:24] == 8'h2) && (src_mac[23:16] == 8'h3) /*&& (src_mac[15:8] == 8'h4)*/ && (src_mac[7:0] < 8'h65))
				pack_type <= 8'd2;	//device mac 00-01-02-03-04-(01~100), FRT or MCC
			else if((src_mac[47:40] == 8'h44) && (src_mac[39:32] == 8'h37) && (src_mac[31:24] == 8'he6) && (src_mac[23:16] == 8'h25) && (src_mac[15:8] == 8'h4f) && (src_mac[7:0] == 8'h22))
				pack_type <= 8'd4;	//device mac 00-01-02-03-04-200, MM request
			else
				pack_type <= 8'd5;	//illegal broadcasting package
		end
		else if(dst_mac_type == 4'd2)//01-00-5e-00-01-81
		begin
			if((src_mac[47:40] == 8'h0) && (src_mac[39:32] == 8'h1) && (src_mac[31:24] == 8'h2) && (src_mac[23:16] == 8'h3) /*&& (src_mac[15:8] == 8'h4)*/ && (src_mac[7:0] < 8'h65))
				pack_type <= 8'd7;	//device mac 00-01-02-03-04-(01~100), master device, sync_req
			else
				pack_type <= 8'd8;	//illegal device send sync_req
		end
		else if(dst_mac_type == 4'd3)//01-00-5e-00-01-82
		begin
			if((src_mac[47:40] == 8'h0) && (src_mac[39:32] == 8'h1) && (src_mac[31:24] == 8'h2) && (src_mac[23:16] == 8'h3) /*&& (src_mac[15:8] == 8'h4)*/ && (src_mac[7:0] < 8'h65))
				pack_type <= 8'd10;
			else
				pack_type <= 8'd11;	//illegal device send sync_rsp
		end
		else if(dst_mac_type == 4'd4)//00-01-02-03-04-200
		begin
			if((src_mac[47:40] == 8'h0) && (src_mac[39:32] == 8'h1) && (src_mac[31:24] == 8'h2) && (src_mac[23:16] == 8'h3) /*&& (src_mac[15:8] == 8'h4)*/ && (src_mac[7:0] < 8'hc8))
				pack_type <= 8'd13;
			else
				pack_type <= 8'd14;	//illegal device send mm response
		end
		else if(dst_mac_type == 4'd5)
		begin
			pack_type <= 8'd18;	//illegal dst_mac
		end
		else
		begin
			pack_type <= 8'd18;
		end
	end
	else if(recv_addr == 16'd28)//it needed to be 28 as 8907 received
	begin
		if(pack_type == 8'd2)
		begin
			if((o_pkg_type == 16'h8907) && i_is_device[src_mac[7:0] - 1'b1])//20140224, add EMIB info check
				pack_type <= 8'd1;
		end
		else if(pack_type == 8'd4)
		begin
			if(o_pkg_type == 16'h8907)//send by host, not EPA device
				pack_type <= 8'd3;
		end
		else if(pack_type == 8'd7)
		begin
			if((o_pkg_type == 16'h8907) && i_is_device[src_mac[7:0] - 1'b1])
				pack_type <= 8'd6;
		end
		else if(pack_type == 8'd10)
		begin
			if((o_pkg_type == 16'h8907) && i_is_device[src_mac[7:0] - 1'b1])
				pack_type <= 8'd9;
		end
		else if(pack_type == 8'd13)
		begin
			if((o_pkg_type == 16'h8907) && i_is_device[src_mac[7:0] - 1'b1])
				pack_type <= 8'd12;
		end
	end
	else if(recv_addr == 16'd30)//classify FRT and MCC
	begin
		if((pack_type == 8'd1) && (o_frt_type[7:4] == 4'h9))
		begin
			pack_type <= 8'd15;
		end
	end
	else if(pkg_flag == 1'b0)
	begin
		pack_type <= 8'b0;
	end
end



//start to check frt security, as pack_type == 8'd1
//o_frt_type gets its value when recv_addr == 16'd28&29
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		frt_illegalsid  <= 1'b0;
		frt_illegaltype <= 1'b0;
	end
	else if ((recv_addr == 16'd31) && (pack_type == 8'd1))//FRT
	begin
		if(o_frt_type[7:4] == 4'h1)//FRT
			frt_illegalsid <= 1'b0;
		else
			frt_illegalsid <= 1'b1;
	end
	else if ((recv_addr == 16'd32) && (pack_type == 8'd1))//FRT	
	begin
		if(o_frt_type[3:0] == 4'h0 || o_frt_type[3:0] == 4'h1)
			frt_illegaltype <= 1'b0;
		else
			frt_illegaltype <= 1'b1;
	end
	else if(pkg_flag == 1'b0)
	begin
		frt_illegalsid  <= 1'b0;
		frt_illegaltype <= 1'b0;
	end
end

//o_msgid gets its value when recv_addr == 16'd30&31
//msgid check is only meaningful for FRT when regular communication

//packB17_20, SrcIP for MCC/FRT, received when recv_addr == 16'd32~39
//when recv_addr == 16'd25 starts to read device_pro, so it's no problem
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		frt_unmatchip <= 1'b0;
	end
	else if((recv_addr == 16'd40) && (pack_type == 8'd1))//FRT
	begin
		if(packB17_20 == i_devicepro[95:64])      //Modified by SYF 2014.5.22   //i_devicepro[79:48]
			frt_unmatchip <= 1'b0;
		else
			frt_unmatchip <= 1'b1;
	end
	else if(pkg_flag == 1'b0)
	begin
		frt_unmatchip <= 1'b0;
	end
end

//pack21_24, M/S & Lenth for FRT, received when recv_addr == 16'd40~47
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		frt_illegalclockstate <= 1'b0;
		frt_illegallength <= 1'b0;
	end
	else if((recv_addr == 16'd48) && (pack_type == 8'd1))
	begin
		if(packB21_24[20:16] == 5'h0 || packB21_24[20:16] == 5'h1 || packB21_24[20:16] == 5'h11)
			frt_illegalclockstate <= 1'b0;
		else
			frt_illegalclockstate <= 1'b1;
	end
	else if((recv_addr == 16'd49) && (pack_type == 8'd1))
	begin
		if(packB21_24[15:0] == (i_devicepro[31:16] * 2))   //Modified by SYF 2014.5.22  //i_devicepro[15:0]
			frt_illegallength <= 1'b0;
		else
			frt_illegallength <= 1'b1;
	end
	else if(pkg_flag == 1'b0)
	begin
		frt_illegalclockstate <= 1'b0;
		frt_illegallength <= 1'b0;
	end
end
//codes for frt security check is finished except real package length

//start to check sync_req security, as pack_type == 8'd6
//o_frt_type gets its value when recv_addr == 16'd28&29
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		syncreq_illegalsid  <= 1'b0;
		syncreq_illegaltype <= 1'b0;
	end
	else if ((recv_addr == 16'd31) && (pack_type == 8'd6))//sync_req
	begin
		if(o_frt_type[7:4] == 4'h2)//sync_req
			syncreq_illegalsid <= 1'b0;
		else
			syncreq_illegalsid <= 1'b1;
	end
	else if ((recv_addr == 16'd32) && (pack_type == 8'd6))//sync_req
	begin
		if(o_frt_type[3:0] == 4'h0)
			syncreq_illegaltype <= 1'b0;
		else
			syncreq_illegaltype <= 1'b1;
	end
	else if(pkg_flag == 1'b0)
	begin
		syncreq_illegalsid  <= 1'b0;
		syncreq_illegaltype <= 1'b0;
	end
end

//packB17_20, DstIP for sync_req, received when recv_addr == 16'd32~39
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
		syncreq_illegaldstip <= 1'b0;
	//DstIP is 192.168.1.x
	else if ((recv_addr == 16'd48) && (pack_type == 8'd6))
	begin
		if ((packB17_20[31:24] == 8'd192) && (packB17_20[23:16] == 8'd168) /*&& (packB17_20[15:8] == 8'd1)*/)// &&(packB17_20[15:8] < 8'd100)?    //Modified by SYF 2014.6.10
			syncreq_illegaldstip <= 1'b0;
		else
			syncreq_illegaldstip <= 1'b1;
	end
	else if(pkg_flag == 1'b0)
		syncreq_illegaldstip <= 1'b0;
end

//packB21_24, SrcIP for sync_req, received when recv_addr == 16'd40~47
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		syncreq_illegalsrcip <= 1'b0;
	end
	else if((recv_addr == 16'd48) && (pack_type == 8'd6))//sync_req
	begin
		if((packB21_24[31:24] == 8'd192) && (packB21_24[23:16] == 8'd168) /*&& (packB21_24[15:8] == 8'd1)*/ && (packB21_24 == i_devicepro[95:64]))   //Modified by SYF 2014.5.22   //i_devicepro[79:48]
			syncreq_illegalsrcip <= 1'b0;
		else
			syncreq_illegalsrcip <= 1'b1;
	end
	else if(pkg_flag == 1'b0)
	begin
		syncreq_illegalsrcip <= 1'b0;
	end
end
//codes for frt security check is finished except real package length

//start to check sync_rsp security, as pack_type == 8'd9
//o_frt_type gets its value when recv_addr == 16'd28&29
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		syncrsp_illegalsid  <= 1'b0;
		syncrsp_illegaltype <= 1'b0;
	end
	else if ((recv_addr == 16'd31) && (pack_type == 8'd9))//sync_rsp
	begin
		if(o_frt_type[7:4] == 4'h2)//sync_req
			syncrsp_illegalsid <= 1'b0;
		else
			syncrsp_illegalsid <= 1'b1;
	end
	else if ((recv_addr == 16'd32) && (pack_type == 8'd9))//sync_rsp
	begin
		if(o_frt_type[3:0] == 4'h1)
			syncrsp_illegaltype <= 1'b0;
		else
			syncrsp_illegaltype <= 1'b1;
	end
	else if(pkg_flag == 1'b0)
	begin
		syncrsp_illegalsid  <= 1'b0;
		syncrsp_illegaltype <= 1'b0;
	end
end

//packB17_20, DstIP for sync_rsp, received when recv_addr == 16'd32~39
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
		syncrsp_illegaldstip <= 1'b0;
	//DstIP is 192.168.1.x
	else if ((recv_addr == 16'd48) && (pack_type == 8'd9))
	begin
		if ((packB17_20[31:24] == 8'd192) && (packB17_20[23:16] == 8'd168) /*&& (packB17_20[15:8] == 8'd1)*/)
			syncrsp_illegaldstip <= 1'b0;
		else
			syncrsp_illegaldstip <= 1'b1;
	end
	else if(pkg_flag == 1'b0)
		syncrsp_illegaldstip <= 1'b0;
end

//packB21_24, SrcIP for sync_rsp, received when recv_addr == 16'd40~47
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		syncrsp_illegalsrcip <= 1'b0;
	end
	else if((recv_addr == 16'd48) && (pack_type == 8'd9))//sync_rsp
	begin
		if(packB21_24 == i_devicepro[95:64])     //Modified by SYF 2014.5.22   //i_devicepro[79:48]
			syncrsp_illegalsrcip <= 1'b0;
		else
			syncrsp_illegalsrcip <= 1'b1;
	end
	else if(pkg_flag == 1'b0)
	begin
		syncrsp_illegalsrcip <= 1'b0;
	end
end
//codes for frt security check is finished except real package length

//start to check MM security, as pack_type == 8'd3
//o_frt_type gets its value when recv_addr == 16'd28&29
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		mm_illegalsid  <= 1'b0;
		mm_illegaltype <= 1'b0;
	end
	else if ((recv_addr == 16'd31) && (pack_type == 8'd3))//sync_rsp
	begin
		if(o_frt_type[7:4] == 4'h0)//sync_req
			mm_illegalsid <= 1'b0;
		else
			mm_illegalsid <= 1'b1;
	end
	else if ((recv_addr == 16'd32) && (pack_type == 8'd3))//sync_rsp
	begin
		if((o_frt_type[3:0] == 4'h0) || (o_frt_type[3:0] == 4'h3) || (o_frt_type[3:0] == 4'h6))
			mm_illegaltype <= 1'b0;
		else
			mm_illegaltype <= 1'b1;
	end
	else if(pkg_flag == 1'b0)
	begin
		mm_illegalsid  <= 1'b0;
		mm_illegaltype <= 1'b0;
	end
end

//packB17_20, SrcIP for MM, received when recv_addr == 16'd32~39
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		mm_illegalsrcip <= 1'b0;
	end
	else if((recv_addr == 16'd40) && (pack_type == 8'd3))//FRT
	begin
		if ((packB17_20[31:24] == 8'd192) && (packB17_20[23:16] == 8'd168) && (packB17_20[15:8] == 8'd1) && (packB17_20[7:0] == 8'd200))
			mm_illegalsrcip <= 1'b0;
		else
			mm_illegalsrcip <= 1'b1;
	end
	else if(pkg_flag == 1'b0)
	begin
		mm_illegalsrcip <= 1'b0;
	end
end

//packB21_24, DstIP for MM, received when recv_addr == 16'd32~39, needed to be 192.168.1.200
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
		mm_illegaldstip <= 1'b0;
	//DstIP is 192.168.1.x
	else if ((recv_addr == 16'd48) && (pack_type == 8'd6))
	begin
		//MM read request might be FF-FF-FF-FF
		//if ((packB21_24[31:24] == 8'd192) && (packB21_24[23:16] == 8'd168) && (packB21_24[15:8] == 8'd1))
		if(packB21_24 == 32'hFFFFFFFF)
			mm_illegaldstip <= 1'b0;
		else
			mm_illegaldstip <= 1'b1;
	end
	else if(pkg_flag == 1'b0)
		mm_illegaldstip <= 1'b0;
end
//codes for frt security check is finished except real package length

//start to check MCC security, as pack_type == 8'd15
//o_frt_type gets its value when recv_addr == 16'd28&29
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		mcc_illegalsid  <= 1'b0;
		mcc_illegaltype <= 1'b0;
	end
	else if ((recv_addr == 16'd31) && (pack_type == 8'd15))//MCC
	begin
		if(o_frt_type[7:4] == 4'h9)//MCC
			mcc_illegalsid <= 1'b0;
		else
			mcc_illegalsid <= 1'b1;
	end
	else if ((recv_addr == 16'd32) && (pack_type == 8'd15))//MCC
	begin
		if((o_frt_type[3:0] == 4'h0) || (o_frt_type[3:0] == 4'h1) || (o_frt_type[3:0] == 4'h2) || (o_frt_type[3:0] == 4'h3) || (o_frt_type[3:0] == 4'h4))   //Modified by SYF 2014.5.29
			mcc_illegaltype <= 1'b0;
		else
			mcc_illegaltype <= 1'b1;
	end
	else if(pkg_flag == 1'b0)
	begin
		mcc_illegalsid  <= 1'b0;
		mcc_illegaltype <= 1'b0;
	end
end

//o_msgid gets its value when recv_addr == 16'd30&31
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		mcc_illegalmsgid <= 1'b0;
	end
	else if ((recv_addr == 16'd32) && (pack_type == 8'd15))//MCC
	begin
		if((o_msgid == 8'h0))
			mcc_illegalmsgid <= 1'b0;
		else
			mcc_illegalmsgid <= 1'b1;
	end
	else if(pkg_flag == 1'b0)
	begin
		mcc_illegalmsgid <= 1'b0;
	end
end

//packB17_20, SrcIP for MCC, received when recv_addr == 16'd32~39
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		mcc_unmatchip <= 1'b0;
	end
	else if((recv_addr == 16'd40) && (pack_type == 8'd15))//MCC        //48       //Modified by SYF 2014.5.27       //recv_addr == 16'd40
	begin
		if(packB17_20 == i_devicepro[95:64])         //Modified by SYF 2014.5.30   //i_devicepro[79:48]   //packB17_20
			mcc_unmatchip <= 1'b0;
		else
			mcc_unmatchip <= 1'b1;
	end
	else if(pkg_flag == 1'b0)
	begin
		mcc_unmatchip <= 1'b0;
	end
end

//packB21_24 should be 0 for MCC, received when recv_addr == 16'd40~47
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		mcc_wrongdata <= 1'b0;
	end
	else if((recv_addr == 16'd48) && (pack_type == 8'd15))//MCC
	begin
		if(packB21_24 == 32'b0)
			mcc_wrongdata <= 1'b0;
		else
			mcc_wrongdata <= 1'b0;  //1'b1;
	end
	else if(pkg_flag == 1'b0)
	begin
		mcc_wrongdata <= 1'b0;
	end
end

//I guess this should be done after all the packages has received as the offset&len check hasn't been involved
//summarize all the illegal information
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		o_frt_error_type		<= 32'b0;
		o_mm_error_type		<= 32'b0;
		o_mcc_error_type		<= 32'b0;
		o_syncreq_error_type <= 32'b0;
		o_syncrsp_error_type <= 32'b0;
		o_pack_error_type		<= 32'b0;
		arrange_alarm_to_pdo <= 1'b0;
		pack_safe				<= 1'b0;                  //Modified by SYF 2014.6.18
		o_send_alarm_to_pdo	<= 1'b0;
		alarmdata_send_done  <= 1'b0;
		o_alarm_data			<= 192'b0;
	end
	else if(recv_addr == 16'd31)
	begin
		if((pack_type == 8'd1) || (pack_type == 8'd3) || (pack_type == 8'd6) || (pack_type == 8'd9) || (pack_type == 8'd15))
		begin
			o_pack_error_type <= 32'b0;
		end
		else
		begin
			o_pack_error_type[7:0] <= pack_type;
		end
	end
	else if(recv_addr == 16'd49)
	begin
		o_alarm_data[143:96] <= src_mac;
		o_alarm_data[63:32]  <= pack_received_s;
		o_alarm_data[31:0]   <= pack_received_ns;
		if((pack_type == 8'd6) || (pack_type == 8'd9))
			o_alarm_data[95:64] <= packB21_24;
		else
			o_alarm_data[95:64] <= packB17_20;
	end
	else if(summrize_security_check)
	begin
		arrange_alarm_to_pdo <= 1'b1;
		if(pack_type == 8'd1)
		begin
			o_frt_error_type[0] <= frt_illegalsid;
			o_frt_error_type[1] <= frt_illegaltype;
			o_frt_error_type[2] <= frt_illegalmsgid;
			o_frt_error_type[3] <= frt_unmatchip;
			o_frt_error_type[4] <= frt_illegalclockstate;
			o_frt_error_type[5] <= frt_illegallength;
			o_frt_error_type[6] <= frt_abnormal_packlen;
			o_frt_error_type[7] <= frt_floodattack;
			o_frt_error_type[8] <= frt_illegaltimeoffset;
		end
		else if(pack_type == 8'd3)
		begin
			o_mm_error_type[0] <= mm_illegalsid;
			o_mm_error_type[1] <= mm_illegaltype;
			o_mm_error_type[2] <= mm_illegalsrcip;
			o_mm_error_type[3] <= mm_illegaldstip;
		end
		else if(pack_type == 8'd6)
		begin
			o_syncreq_error_type[0] <= syncreq_illegalsid;
			o_syncreq_error_type[1] <= syncreq_illegaltype;
			o_syncreq_error_type[2] <= syncreq_illegaldstip;
			o_syncreq_error_type[3] <= syncreq_illegalsrcip;
			o_syncreq_error_type[4] <= syncreq_abnormal_packlen;
			o_syncreq_error_type[5] <= syncreq_floodattack;
		end
		else if(pack_type == 8'd9)
		begin
			o_syncrsp_error_type[0] <= syncrsp_illegalsid;
			o_syncrsp_error_type[1] <= syncrsp_illegaltype;
			o_syncrsp_error_type[2] <= syncrsp_illegaldstip;
			o_syncrsp_error_type[3] <= syncrsp_illegalsrcip;
			o_syncrsp_error_type[4] <= syncrsp_abnormal_packlen;
			o_syncrsp_error_type[5] <= syncrsp_floodattack;
		end
//		else if(pack_type == 8'd12)//mm_response
//		begin
//		
//		end
		else if(pack_type == 8'd15)
		begin
			o_mcc_error_type[0] <= mcc_illegalsid;
			o_mcc_error_type[1] <= mcc_illegaltype;
			o_mcc_error_type[2] <= mcc_illegalmsgid;
			o_mcc_error_type[3] <= mcc_unmatchip;
			o_mcc_error_type[4] <= mcc_wrongdata;
			o_mcc_error_type[5] <= mcc_abnormal_packlen;
			o_mcc_error_type[6] <= mcc_floodattack;
		end
	end
	else if(arrange_alarm_to_pdo)
	begin
		arrange_alarm_to_pdo <= 1'b0;
		if(o_mcc_error_type != 32'b0)
		begin
			o_send_alarm_to_pdo	 <= 1'b1;
			o_alarm_data[183:176] <= 8'd1;
			o_alarm_data[175:144] <= o_mcc_error_type;
		end
		else if(o_frt_error_type != 32'b0)
		begin
			o_send_alarm_to_pdo	 <= 1'b1;
			o_alarm_data[183:176] <= 8'd2;
			o_alarm_data[175:144] <= o_frt_error_type;
		end
		else if(o_mm_error_type != 32'b0)
		begin
			o_send_alarm_to_pdo	 <= 1'b1;
			o_alarm_data[183:176] <= 8'd3;
			o_alarm_data[175:144] <= o_mm_error_type;
		end
		else if(o_syncreq_error_type != 32'b0)
		begin
			o_send_alarm_to_pdo	 <= 1'b1;
			o_alarm_data[183:176] <= 8'd4;
			o_alarm_data[175:144] <= o_syncreq_error_type;
		end
		else if(o_syncrsp_error_type != 32'b0)
		begin
			o_send_alarm_to_pdo	 <= 1'b1;
			o_alarm_data[183:176] <= 8'd5;
			o_alarm_data[175:144] <= o_syncrsp_error_type;
		end
		else if(o_pack_error_type != 32'b0)
		begin
			o_send_alarm_to_pdo	 <= 1'b1;
			o_alarm_data[183:176] <= 8'd6;
			o_alarm_data[175:144] <= o_pack_error_type;
		end
		else
		begin
			o_send_alarm_to_pdo <= 1'b0;
			o_alarm_data		  <= 192'b0;
			pack_safe			  <= 1'b1;                         //Modified by SYF 2014.6.18
		end
	end
	else if(pack_safe)                                         //Modified by SYF 2014.6.18
	begin
		pack_safe <= 1'b0;                                      //Modified by SYF 2014.6.18
	end
	else if(o_send_alarm_to_pdo)
	begin
		o_send_alarm_to_pdo <= 1'b0;
		alarmdata_send_done <= 1'b1;
	end
	else if(alarmdata_send_done)
	begin
		o_frt_error_type		<= 32'b0;
		o_mm_error_type		<= 32'b0;
		o_mcc_error_type		<= 32'b0;
		o_syncreq_error_type <= 32'b0;
		o_syncrsp_error_type <= 32'b0;
		arrange_alarm_to_pdo <= 1'b0;
		o_send_alarm_to_pdo	<= 1'b0;
		alarmdata_send_done  <= 1'b0;
		o_alarm_data			<= 192'b0;
	end
end

//When package receiving finished, check the package lenth
//generate the 192 bit alarm information to send to pdo_data_send
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		frt_abnormal_packlen		 <= 1'b0;
		mcc_abnormal_packlen		 <= 1'b0;
		syncreq_abnormal_packlen <= 1'b0;
		syncrsp_abnormal_packlen <= 1'b0;
		summrize_security_check  <= 1'b0;
	end
	else if(Nextstate == RECV_DONE)
	begin
		if(pack_type == 8'd1)
		begin
			if(recv_addr == (((i_devicepro[31:16] * 2) + 32) * 2 + 9))   //Modified by SYF 2014.5.22  //i_devicepro[15:0]
				frt_abnormal_packlen <= 1'b0;
			else
				frt_abnormal_packlen <= 1'b1;
		end
		if(pack_type == 8'd6)//????????????
		begin
			//if(recv_addr == (((i_devicepro[15:0] * 2) + 32) * 2 + 9))				//20140217
			if(recv_addr == (((i_len_master_clock[15:0] * 2) + 32) * 2 + 9))
			//if(recv_addr == 16'd129)
				syncreq_abnormal_packlen <= 1'b0;
			else
				syncreq_abnormal_packlen <= 1'b1;
		end
		if(pack_type == 8'd9)//????????????
		begin
			//if(recv_addr == (((i_devicepro[31:16] * 2) + 32) * 2 + 9))				//Modiified by SYF 2014.5.22  //i_devicepro[15:0]
         if(recv_addr == (((i_len_master_clock[15:0] * 2) + 32) * 2 + 9))
//			if(recv_addr == 16'd129)
				syncrsp_abnormal_packlen <= 1'b0;
			else
				syncrsp_abnormal_packlen <= 1'b1;		//as sync_rsp may not be that length
//				syncrsp_abnormal_packlen <= 1'b0;
		end
		else if(pack_type == 8'd15)
		begin
			if(recv_addr == 16'd129)	//MCC package 60 Bytes
				mcc_abnormal_packlen <= 1'b0;
			else
				mcc_abnormal_packlen <= 1'b1;
		end
		summrize_security_check <= 1'b1;
	end
	else if(summrize_security_check)
		summrize_security_check <= 1'b0;
end
//20140221, add package check, gather package data




//20140226, transmit
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
end

//send rd_en to read device property from RAM
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		o_rd_en_property <= 1'b0;
		o_rd_addr        <= 8'b0;
	end
	else if(recv_addr == 16'd25)
	begin
		if((pack_type == 8'd2) || (pack_type == 8'd7) || (pack_type == 8'd10))
		begin
			o_rd_en_property <= 1'b1;
			o_rd_addr        <= (src_mac[7:0] - 1);
		end
		else
		begin
			o_rd_en_property <= 1'b0;
			o_rd_addr        <= 8'b0;
		end
	end
	else if(recv_addr == 16'd30)
	begin
		o_rd_en_property <= 1'b0;
		o_rd_addr        <= 8'b0;
	end
end
//send rd_en to read device property from RAM
//caculate the time offset of FRT package
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		send_offset  <= 32'b0;
		time_shaking <= 32'b0;
	end
	else if(recv_addr == 16'd25)
	begin
		if(pack_received_ns > i_macro_start_time_ns)
			send_offset <= (pack_received_ns - i_macro_start_time_ns);
		else
			send_offset <= ((pack_received_ns + 32'h3B9ACA00) - i_macro_start_time_ns);
	end
	else if(recv_addr == 16'd28)
	begin
		if(send_offset > i_devicepro[63:32])      //Modified by SYF 2014.5.22  //i_devicepro[47:16]
			time_shaking <= send_offset - i_devicepro[63:32];          //Modified by SYF 2014.5.22   //i_devicepro[47:16]
		else
			time_shaking <= i_devicepro[63:32] - send_offset;          //Modified by SYF 2014.5.22   //i_devicepro[47:16]
	end
	else if(pkg_flag == 1'b0)
	begin
		send_offset  <= 32'b0;
		time_shaking <= 32'b0;
	end
end

always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		macrocycle_b_dly <= 1'b0 ;
	else
		macrocycle_b_dly <= i_macrocycle_b;
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		o_rd_en           <= 1'b0;
		is_active         <= 100'b0;
		is_active_rsp         <= 100'b0;
		curmacromcc_sent  <= 100'b0;
		curmacrofrt_sent  <= 100'b0;
		curmacrosyncreq_sent <= 100'b0;
		curmacrosyncrsp_sent <= 100'b0;
//		o_sync_reqed		<= 1'b0;
//		o_sync_rsped      <= 1'b0;
		frt_floodattack <= 1'b0;
		syncreq_floodattack <= 1'b0;
		syncrsp_floodattack <= 1'b0;
		mcc_floodattack <= 1'b0;
	end
	else if(!macrocycle_b_dly && i_macrocycle_b)
	begin
		is_active         <= 100'b0;
		is_active_rsp         <= 100'b0;		
		curmacromcc_sent  <= 100'b0;
		curmacrofrt_sent  <= 100'b0;
		curmacrosyncreq_sent <= 100'b0;
		curmacrosyncrsp_sent <= 100'b0;
	end
	else if(recv_addr == 8'd31)
	begin
		if(((pack_type == 8'd1) || (pack_type == 8'd6) || (pack_type == 8'd9) || (pack_type == 8'd15)) && i_is_device[src_mac[7:0] - 1'b1])
		begin
			if(!i_csme_en)
			begin
				if(pack_type == 8'd1)
					begin
						if(!curmacrofrt_sent[src_mac[7:0] - 1'b1])
							begin
								o_rd_en <= 1'b1;
								curmacrofrt_sent[src_mac[7:0] - 1'b1] <= 1'b1;
							end
						else
							begin
								o_rd_en <= 1'b0;
								frt_floodattack <= 1'b1;
							end
					end
				else if(pack_type == 8'd6)
				begin
					if(curmacrosyncreq_sent[src_mac[7:0] - 1'b1] == 1'b0)
					begin
						o_rd_en <= 1'b1;
						curmacrosyncreq_sent[src_mac[7:0] - 1'b1] <= 1'b1;
//						o_sync_reqed <= 1'b1;
					end
					else
					begin
						o_rd_en <= 1'b0;
						syncreq_floodattack <= 1'b1;
					end
				end
				else if(pack_type == 8'd9)
				begin
					if(curmacrosyncrsp_sent[src_mac[7:0] - 1'b1] == 1'b0)
					begin
						o_rd_en <= 1'b1;
						curmacrosyncrsp_sent[src_mac[7:0] - 1'b1] <= 1'b1;
//						o_sync_reqed <= 1'b1;
					end
					else
					begin
						o_rd_en <= 1'b0;
						syncrsp_floodattack <= 1'b1;
					end
				end
//				else if(pack_type == 8'd9)
//				begin
//					if(i_sync_reqed == 1'b1)
//					begin
//						o_rd_en <= 1'b1;
//						o_sync_rsped <= 1'b1;
//					end
//					else
//						o_rd_en <= 1'b0;
//				end
				else if(pack_type == 8'd15)
				begin
					if(!curmacromcc_sent[src_mac[7:0] - 1'b1])
					begin
						o_rd_en <= 1'b1;
						curmacromcc_sent[src_mac[7:0] - 1'b1] <= 1'b1;
					end
					else
					begin
						o_rd_en <= 1'b0;
						mcc_floodattack <= 1'b1;
					end
				end
			end
			else	//under some cases, o_rd_en <= 1'b0
			begin
				if(pack_type == 8'd1)
				begin
//					if(!curmacrofrt_sent[src_mac[7:0] - 1'b1])
//					begin
//						if(src_mac[7:0] == 8'd3)
//						begin
//							if((time_shaking < 32'd3000) && (time_shaking > 32'd1500))
//							begin
//								o_rd_en <= 1'b1;
//								curmacrofrt_sent[src_mac[7:0] - 1'b1] <= 1'b1;
//								is_active[src_mac[7:0] - 1'b1] <= 1'b1;
//							end
//							else
//							begin
//								o_rd_en <= 1'b0;
//								frt_illegaltimeoffset <= 1'b1;
//							end
//						end
//						else
//						begin
//							o_rd_en <= 1'b1;
//							curmacrofrt_sent[src_mac[7:0] - 1'b1] <= 1'b1;
//							is_active[src_mac[7:0] - 1'b1] <= 1'b1;
//						end
//					end
//					else
//					begin
//						o_rd_en <= 1'b0;		//******************************************
//						frt_floodattack <= 1'b1;
//					end
//					if((time_shaking < 32'h6000) && !curmacrofrt_sent[src_mac[7:0] - 1'b1])
					if(!curmacrofrt_sent[src_mac[7:0] - 1'b1])
					begin
						o_rd_en <= 1'b1;
						curmacrofrt_sent[src_mac[7:0] - 1'b1] <= 1'b1;
						is_active[src_mac[7:0] - 1'b1] <= 1'b1;
					end
					else
					begin
						o_rd_en <= 1'b0;
						frt_floodattack <= 1'b1;
					end
				end
				else if(pack_type == 8'd6)//sync_req
				begin
					if((curmacrosyncreq_sent[src_mac[7:0] - 1'b1] == 1'b0) /*&& is_active[src_mac[7:0] - 1'b1] == 1'b0*/)
					begin
						o_rd_en <= 1'b1;
						curmacrosyncreq_sent[src_mac[7:0] - 1'b1] <= 1'b1;
//						o_sync_reqed <= 1'b1;
					end
					else
					begin
						o_rd_en <= 1'b0;
						syncreq_floodattack <= 1'b1;
					end
				end
							
    			else if(pack_type == 8'd9)//sync_rsp
				begin
//					if((curmacrosyncrsp_sent[src_mac[7:0] - 1'b1] == 1'b0) && is_active[src_mac[7:0] - 1'b1] == 1'b0)
					if((curmacrosyncrsp_sent[src_mac[7:0] - 1'b1] == 1'b0) && is_active_rsp[src_mac[7:0] - 1'b1] == 1'b0)
					begin
						o_rd_en <= 1'b1;
						curmacrosyncrsp_sent[src_mac[7:0] - 1'b1] <= 1'b1;
						is_active_rsp[src_mac[7:0] - 1'b1] <= 1'b1;
//						o_sync_reqed <= 1'b1;
					end
					else
					begin
						o_rd_en <= 1'b0;
						syncrsp_floodattack <= 1'b1;
					end
				end
//				begin
//					if(i_sync_reqed == 1'b1)
//					begin
//						o_rd_en <= 1'b1;
//						o_sync_rsped <= 1'b1;
//					end
//					else
//						o_rd_en <= 1'b0;
//				end
//				else if(pack_type == 8'd9)
//				begin
//					if((curmacrosyncrsp_sent[src_mac[7:0] - 1'b1] == 1'b0) && is_active[src_mac[7:0] - 1'b1] == 1'b0)
//					begin
//						o_rd_en <= 1'b1;
//						curmacrosyncrsp_sent[src_mac[7:0] - 1'b1] <= 1'b1;
////						o_sync_reqed <= 1'b1;
//					end
//					else
//					begin
//						o_rd_en <= 1'b0;
//						syncrsp_floodattack <= 1'b1;
//					end
//				end
				else if(pack_type == 8'd15)
				begin
					if(!curmacromcc_sent[src_mac[7:0] - 1'b1])
					begin
						o_rd_en <= 1'b1;
						curmacromcc_sent[src_mac[7:0] - 1'b1] <= 1'b1;
					end
					else
					begin
						o_rd_en <= 1'b0;
						mcc_floodattack <= 1'b1;
					end
				end
				else
					o_rd_en <= 1'b0;
			end
		end
		else
			o_rd_en <= 1'b0;
	end
//	else if(i_sync_rsped == 1'b1)
//		o_sync_reqed <= 1'b0;
//	else if(o_sync_rsped == 1'b1)
//		o_sync_rsped <= 1'b0;
	else if(alarmdata_send_done)
	begin
		frt_floodattack <= 1'b0;
		frt_illegaltimeoffset <= 1'b0;
		syncreq_floodattack <= 1'b0;
		syncrsp_floodattack <= 1'b0;
		mcc_floodattack <= 1'b0;
	end
//	else if(compensation_cnt > 8'd46)
	else if(compensation_cnt > 8'd48)    //2014_April_30th
	begin
		o_rd_en <= 1'b0;
	end
end




//always @(posedge i_clk or negedge i_rst_n)
//begin
//	if(!i_rst_n)
//	begin
//		o_rd_en <= 1'b0;
//	end
//	else if(recv_addr == 8'd31)
//	begin
//		o_rd_en <= 1'b1;
//	end
//	else if(compensation_cnt > 8'd46)
//	begin
//		o_rd_en <= 1'b0;
//	end
//end




always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		o_recv_data_legal <= 1'b0;
	end
	else if((recv_addr == 8'd33) && o_rd_en)
	//else if((recv_addr == 8'd3) && o_rd_en)
	begin
		o_recv_data_legal <= 1'b1;
	end
//	else if(compensation_cnt > 8'd48)
	else if(compensation_cnt > 8'd50)  // 2014_April_30th
	//else if(compensation_cnt > 8'd18)
	begin
		o_recv_data_legal <= 1'b0;
	end
end
















endmodule 