/*******************************************************************
File name   		:DHCP.v
Function    		:1
Version maintenance:wangkai0351
*******************************************************************/
/***************************   modify record   ****************************F
*star形主网,EPA设备逐一连接在AB上层网络情况下的DHCP服务20170704
*line形主网,EPA设备逐一连接在AB上层网络情况下的DHCP服务20170711
*star形主网,EPA设备逐一连接在ABC网络情况下的DHCP服务201707
*if DHCP_server out of network 20170720
*two_dhcp sver network link 20170725
**************************************************************************
**************************************************************************/
module DHCP
(
		//BUSCONVERT
		output reg [15:0]	 o_send_DHCP_data,
		output 	  [9:0]   o_send_DHCP_len,
		output reg         o_send_DHCP_irq,
		input wire  [9:0]   i_send_DHCP_addr,//bus_convert_up输出
		input wire          i_DHCP_nxt_pkg,//bus_convert_up输出
		
		input wire [31:0]  i_MacroCycle_time_uplayer,
		input wire [47:0]	    i_local_mac,
		output reg         o_DHCP_end_en,
		
		input wire  [15:0] i_recv_data_A,
		input wire  [15:0] i_recv_data_B,
		input wire  [15:0] i_recv_data_C,
		
		input wire  [3:0]  i_recv_data_4_A,
		input wire  [3:0]  i_recv_data_4_B,
		input wire  [3:0]  i_recv_data_4_C,
		
		input  wire  [9:0] i_recv_addr_A,
		input  wire  [9:0] i_recv_addr_B,
		input  wire  [9:0] i_recv_addr_C,
		
		input	 wire		    i_Rx_dv_A,
		input  wire        i_Rx_dv_B,
		input  wire        i_Rx_dv_C,
		
		input  wire        i_data_valid_A,
		input  wire        i_data_valid_B,
		input  wire        i_data_valid_C,
		
		input  wire        i_main_clock_state,
		input  wire        i_macrocycle_b,
		input  wire        i_device_type,
		input  wire        i_clk,
		input  wire        i_rst_n,
		input  wire        i_link_valid_A,
		input  wire        i_link_valid_B,
		input  wire        i_link_valid_C,
		input  wire        i_link_valid_D,
		input  wire [31:0] i_main_clock_ip_up,//
		output  reg [31:0] o_local_node_ip_DHCP,
		input  wire        i_main_clock_compete_end,
		//for transmit
		output wire        o_Tx_en_A,
		output wire [3:0]  o_send_data_A,
		output wire        o_Tx_en_B,
		output wire [3:0]  o_send_data_B

);

		//wire    [9:0]   o_send_DHCP_len;
		assign o_send_DHCP_len = 10'd31;
		
		assign i_link_valid=i_link_valid_A || i_link_valid_B || i_link_valid_C || i_link_valid_D;
      reg [31:0] local_node_ip_DHCP;
		reg DHCP_end_en;
//DHCP_end_en
always @(posedge i_clk, negedge i_rst_n)
begin
if(!i_rst_n)
	DHCP_end_en <= 1'b0;
	else if(DHCP_server_en && local_node_ip_DHCP!=32'b0 && (DHCP_clt_online_msg_recv_num <= DHCP_offer_msg_send_num) && DHCP_clt_online_msg_recv_num!=10'h000)
		DHCP_end_en <= 1'b1;
	else if(!DHCP_server_en && local_node_ip_DHCP!=32'b0)
		DHCP_end_en <= 1'b1;
	else
		DHCP_end_en <= DHCP_end_en;
end

//如果两个设备连接，那么发送两者的DHCP_MAC(文,//MAC小的设备会成为DHCP服务器
wire [15:0] DHCP_MAC [0:30];
assign DHCP_MAC[0]  = 16'hffff;
assign DHCP_MAC[1]  = 16'hffff;
assign DHCP_MAC[2]  = 16'hffff;
assign DHCP_MAC[3]  = 16'hffff;
assign DHCP_MAC[4]  = 16'hd0c0;//DHCP massege flag
assign DHCP_MAC[5]  = 16'h0001;//DHCP_MAC_msg flag
assign DHCP_MAC[6]  = DHCP_MAC_msg_server_en;
assign DHCP_MAC[7]  = 16'h0000;
assign DHCP_MAC[8]  = 16'h0000;
assign DHCP_MAC[9]  = i_local_mac[47:32];
assign DHCP_MAC[10]  = i_local_mac[31:16];
assign DHCP_MAC[11]  = i_local_mac[15:0];
assign DHCP_MAC[12]  = 16'h0000;
assign DHCP_MAC[13]  = 16'h0000;
assign DHCP_MAC[14]  = 16'h0000;
assign DHCP_MAC[15]  = 16'h0000;
assign DHCP_MAC[16]  = 16'h0000;
assign DHCP_MAC[17]  = 16'h0000;
assign DHCP_MAC[18]  = 16'h0000;
assign DHCP_MAC[19]  = 16'h0000;
assign DHCP_MAC[20]  = 16'h0000;
assign DHCP_MAC[21]  = 16'h0000;
assign DHCP_MAC[22]  = 16'h0000;
assign DHCP_MAC[23]  = 16'h0000;
assign DHCP_MAC[24]  = 16'h0000;
assign DHCP_MAC[25]  = 16'h0000;
assign DHCP_MAC[26]  = 16'h0000;
assign DHCP_MAC[27]  = 16'h0000;
assign DHCP_MAC[28]  = 16'h0000;
assign DHCP_MAC[29]  = 16'h0000;
assign DHCP_MAC[30]  = 16'h0001;//DHCP_MAC_msg end flag
//server device compete start
reg [15:0] DHCP_MAC_msg;
reg DHCP_MAC_msg_irq;
reg [9:0] DHCP_MAC_send_num;//high->done
reg [9:0] DHCP_MAC_msg_addr;
//irq
always @(posedge i_clk, negedge i_rst_n)
begin
if(!i_rst_n)
   o_send_DHCP_irq <= 1'b0;
	else if((i_link_valid && !recv_node_mac_less_than_me && DHCP_MAC_msg_rise && DHCP_MAC_msg_cnt>=32'h0000002b) || i_send_DHCP_addr >= 16'd32)
		o_send_DHCP_irq <= 1'b0;
	else if((i_link_valid&&!recv_node_mac_less_than_me&&DHCP_MAC_msg_rise) || (DHCP_MAC_msg_rise&&DHCP_server_en)|| DHCP_clt_online_msg_send_condition || DHCP_clt_req_ip_msg_send_condition || DHCP_offer_msg_send_condition)
		o_send_DHCP_irq <= 1'b1;
	else
		o_send_DHCP_irq <= 1'b0;
end

//DHCP_MAC_msg_cnt
reg [31:0] DHCP_MAC_msg_cnt;
always @(posedge i_clk, negedge i_rst_n)
begin
if(!i_rst_n)
		DHCP_MAC_msg_cnt <= 10'h000;
	else if(DHCP_MAC_msg_cnt < i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer)//10*i_MacroCycle_time_uplayer
	begin
		DHCP_MAC_msg_cnt <= DHCP_MAC_msg_cnt+1'b1;
	end
	else if(DHCP_MAC_msg_cnt == i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer)//10*i_MacroCycle_time_uplayer
	begin
		DHCP_MAC_msg_cnt <= 10'h000;
	end
	else
		DHCP_MAC_msg_cnt <= 10'h000;
end
reg DHCP_MAC_msg_rise;
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		DHCP_MAC_msg_rise <= 1'b0;
	else if(DHCP_MAC_msg_cnt <= 32'd35)
		DHCP_MAC_msg_rise <= 1'b1;
	else
		DHCP_MAC_msg_rise <= 1'b0;
end
//DHCP_MAC_msg
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		o_send_DHCP_data<=16'h0;
	else if(i_link_valid && !recv_node_mac_less_than_me && DHCP_MAC_msg_rise)//server and client send
		begin
			o_send_DHCP_data <= DHCP_MAC[i_send_DHCP_addr];
		end
	else if(DHCP_clt_online_msg_send_condition)
		begin
			o_send_DHCP_data <= DHCP_clt_online_msg[i_send_DHCP_addr];
		end	
	else if(DHCP_clt_req_ip_msg_send_condition)//client send
		begin
			o_send_DHCP_data <= DHCP_clt_req_ip_msg[i_send_DHCP_addr];
		end
	else if(DHCP_offer_msg_send_condition)
		begin
		   o_send_DHCP_data <= DHCP_offer_msg[i_send_DHCP_addr];
		end
//	else	if(!two_network_link_trig&&get_other_node_ip_in_ptp_done&&DHCP_MAC_msg_rise && DHCP_server_en)
//		begin
//		   o_send_DHCP_data <= DHCP_MAC[i_send_DHCP_addr];
//		end
	else if(DHCP_MAC_msg_rise && DHCP_server_en)//two dhcp network link
		begin
		   o_send_DHCP_data <= DHCP_MAC[i_send_DHCP_addr];
		end			
	else
			o_send_DHCP_data <=16'h0;				
end

//DHCP_MAC_send_num
always @(posedge i_clk, negedge i_rst_n)
begin
if(!i_rst_n)
   DHCP_MAC_send_num <= 10'b0;
	else if(i_send_DHCP_addr==10'h006 && o_send_DHCP_data==16'h0001)
		DHCP_MAC_send_num <= DHCP_MAC_send_num+10'b1;
	else
		DHCP_MAC_send_num <= DHCP_MAC_send_num;
end


//receive DHCP_MAC_msg报文，然后对比报文中的MAC和i_local_mac
reg [9:0] DHCP_MAC_recv_num;//high -> received DHCP_MAC_msg
reg [47:0] recv_node_mac;
always @(posedge i_clk, negedge i_rst_n)
begin
if(!i_rst_n)
   DHCP_MAC_recv_num <= 10'h0;
	else if((i_recv_addr_A==10'h006 && i_recv_data_A==16'h0001) || (i_recv_addr_B==10'h006 && i_recv_data_B==16'h0001))//for B
		DHCP_MAC_recv_num <= DHCP_MAC_recv_num + 1'b1;
	else
	DHCP_MAC_recv_num <= DHCP_MAC_recv_num;
end
reg recv_node_mac_end;
always @(posedge i_clk, negedge i_rst_n)
begin
if(!i_rst_n)
	recv_node_mac <= 48'b0;
	else if(DHCP_MAC_recv_num == 10'b0 && !server_device_compete_end)
	begin
		recv_node_mac <= 48'hffffffffffff;
		recv_node_mac_end <= 1'b0;
	end
	else if((DHCP_MAC_recv_num != 10'b0) && i_recv_addr_A==10'h00A && !server_device_compete_end)
		recv_node_mac[47:32] <= i_recv_data_A;
	else if((DHCP_MAC_recv_num != 10'b0) && i_recv_addr_A==10'h00B && !server_device_compete_end)
		recv_node_mac[31:16] <= i_recv_data_A;
	else if((DHCP_MAC_recv_num != 10'b0) && i_recv_addr_A==10'h00C && !server_device_compete_end)
	begin
		recv_node_mac[15:0]  <= i_recv_data_A;
		recv_node_mac_end <= 1'b1;
	end
	
	else if((DHCP_MAC_recv_num != 10'b0) && i_recv_addr_B==10'h00A && !server_device_compete_end)
		recv_node_mac[47:32] <= i_recv_data_B;
	else if((DHCP_MAC_recv_num != 10'b0) && i_recv_addr_B==10'h00B && !server_device_compete_end)
		recv_node_mac[31:16] <= i_recv_data_B;
	else if((DHCP_MAC_recv_num != 10'b0) && i_recv_addr_B==10'h00C && !server_device_compete_end)
	begin
		recv_node_mac[15:0]  <= i_recv_data_B;
		recv_node_mac_end <= 1'b1;
	end

	else
		begin
		recv_node_mac <= recv_node_mac;
		recv_node_mac_end <= recv_node_mac_end;
		end
end

reg recv_server_MAC_msg;
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		recv_server_MAC_msg <= 1'b0;
	else if(!DHCP_server_judge_end && DHCP_MAC_recv_num > 10'h00a && (i_recv_addr_A==10'h007&&i_recv_data_A==16'h000f)||(i_recv_addr_B==10'h007&&i_recv_data_B==16'h000f))
		recv_server_MAC_msg <= 1'b1;
	else
		recv_server_MAC_msg <= recv_server_MAC_msg;
end

reg DHCP_server_en;//DHCP服务器/客户端标志位
reg [3:0] DHCP_MAC_msg_server_en;
reg recv_node_mac_less_than_me;
reg DHCP_server_judge_end;
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		recv_node_mac_less_than_me <= 1'b0;
	else if(!DHCP_server_judge_end && i_local_mac>recv_node_mac && (recv_node_mac != 48'hffffffffffff) && recv_node_mac_end)
		recv_node_mac_less_than_me <= 1'b1;
	else
		recv_node_mac_less_than_me <= recv_node_mac_less_than_me;
end

always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			DHCP_server_en <= 1'b0;
			DHCP_MAC_msg_server_en <= 4'b0000;
		end
	else if(get_other_node_ip_in_ptp_done && i_main_clock_state)//server out of	network
		begin
			DHCP_server_en <= 1'b1;
			DHCP_MAC_msg_server_en <= 4'b1111;
		end
	else if(two_dhcp_sver_compete_end && !i_main_clock_state)//two dhcp network link
		begin
			DHCP_server_en <= 1'b0;
			DHCP_MAC_msg_server_en <= 4'b0000;
		end
	else if(!DHCP_server_judge_end && recv_node_mac_less_than_me)
		begin
			DHCP_server_en <= 1'b0;
			DHCP_MAC_msg_server_en <= 4'b0000;
		end
	else if(!DHCP_server_judge_end && DHCP_MAC_send_num>10'd10 && !recv_node_mac_less_than_me)	
		begin
			DHCP_server_en <= 1'b1;
			DHCP_MAC_msg_server_en <= 4'b1111;
		end
	else
		begin
			DHCP_server_en <= DHCP_server_en;
			DHCP_MAC_msg_server_en <= DHCP_MAC_msg_server_en;
		end
end

always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			DHCP_server_judge_end <= 1'b0;
		end
	else if(DHCP_server_en)
		begin
			DHCP_server_judge_end <= 1'b1;
		end
	else if(!DHCP_server_en &&((i_recv_addr_A==10'd7&&i_recv_data_A==16'h000f) || (i_recv_addr_B==10'd7&&i_recv_data_B==16'h000f)))
		begin
			DHCP_server_judge_end <= 1'b1;
		end
	else
			DHCP_server_judge_end <= DHCP_server_judge_end;
end

//FSM-from DHCP_MAC_msg get server_node_mac;
reg [47:0] server_node_MAC_A;
reg [2:0] get_server_node_mac_state_A;
parameter [2:0] get_server_node_mac_S0_A=3'b000;
parameter [2:0] get_server_node_mac_S1_A=3'b001;
parameter [2:0] get_server_node_mac_S2_A=3'b010;
parameter [2:0] get_server_node_mac_S3_A=3'b011;
parameter [2:0] get_server_node_mac_S4_A=3'b100;
parameter [2:0] get_server_node_mac_S5_A=3'b101;
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		get_server_node_mac_state_A <= 2'b00;
	else if(!DHCP_server_en)
		case(get_server_node_mac_state_A)
			get_server_node_mac_S0_A:
				if(i_recv_addr_A==10'd5&&i_recv_data_A==16'hd0c0)
					begin
						get_server_node_mac_state_A <= get_server_node_mac_S1_A;
					end
			get_server_node_mac_S1_A:
				if(i_recv_addr_A==10'd6&&i_recv_data_A==16'h0001)
					begin
						get_server_node_mac_state_A <= get_server_node_mac_S2_A;
					end
			get_server_node_mac_S2_A:
				if(i_recv_addr_A==10'd7&&i_recv_data_A==16'h000f)
					begin
						get_server_node_mac_state_A <= get_server_node_mac_S3_A;
					end
			get_server_node_mac_S3_A:
				if(i_recv_addr_A==10'd10)
					begin
						get_server_node_mac_state_A <= get_server_node_mac_S4_A;
						server_node_MAC_A[47:32] <= i_recv_data_A;
					end
			get_server_node_mac_S4_A:
				if(i_recv_addr_A==10'd11)
					begin
						get_server_node_mac_state_A <= get_server_node_mac_S5_A;
						server_node_MAC_A[31:16] <= i_recv_data_A;
					end
			get_server_node_mac_S5_A:
				if(i_recv_addr_A==10'd12)
						server_node_MAC_A[15:0] <= i_recv_data_A;
		endcase
		else
			server_node_MAC_A <= server_node_MAC_A;
end

reg [47:0] server_node_MAC_B;
reg [2:0] get_server_node_mac_state_B;
parameter [2:0] get_server_node_mac_S0_B=3'b000;
parameter [2:0] get_server_node_mac_S1_B=3'b001;
parameter [2:0] get_server_node_mac_S2_B=3'b010;
parameter [2:0] get_server_node_mac_S3_B=3'b011;
parameter [2:0] get_server_node_mac_S4_B=3'b100;
parameter [2:0] get_server_node_mac_S5_B=3'b101;
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		get_server_node_mac_state_B <= 2'b00;
	else if(!DHCP_server_en)
		case(get_server_node_mac_state_B)
			get_server_node_mac_S0_B:
				if(i_recv_addr_B==10'd5&&i_recv_data_B==16'hd0c0)
					begin
						get_server_node_mac_state_B <= get_server_node_mac_S1_B;
					end
			get_server_node_mac_S1_B:
				if(i_recv_addr_B==10'd6&&i_recv_data_B==16'h0001)
					begin
						get_server_node_mac_state_B <= get_server_node_mac_S2_B;
					end
			get_server_node_mac_S2_B:
				if(i_recv_addr_B==10'd7&&i_recv_data_B==16'h000f)
					begin
						get_server_node_mac_state_B <= get_server_node_mac_S3_B;
					end
			get_server_node_mac_S3_B:
				if(i_recv_addr_B==10'd10)
					begin
						server_node_MAC_B[47:32] <= i_recv_data_B;
						get_server_node_mac_state_B <= get_server_node_mac_S4_B;
					end
			get_server_node_mac_S4_B:
				if(i_recv_addr_B==10'd11)
					begin
						server_node_MAC_B[31:16] <= i_recv_data_B;
						get_server_node_mac_state_B <= get_server_node_mac_S5_B;
					end
			get_server_node_mac_S5_B:
				if(i_recv_addr_B==10'd12)
						server_node_MAC_B[15:0] <= i_recv_data_B;
		endcase
		else
			server_node_MAC_B <= server_node_MAC_B;
end

reg server_device_compete_end_clt;//for client high->end
reg server_device_compete_end_sver;// for server high->end
//reg server_device_compete_end;
assign server_device_compete_end = server_device_compete_end_clt || server_device_compete_end_sver;
reg [47:0] server_device_mac;
always @(posedge i_clk, negedge i_rst_n)
begin
if(!i_rst_n)
	begin
		server_device_mac <= 48'h000000000000;
		server_device_compete_end_clt <= 1'b0;
		server_device_compete_end_sver <= 1'b0;
	end
	
	else if((DHCP_MAC_send_num>16'd10||DHCP_MAC_recv_num>16'd10) && DHCP_server_en == 1'b1 &&DHCP_server_judge_end)
	begin
		server_device_mac <= i_local_mac;
		server_device_compete_end_sver <= 1'b1;
		server_device_compete_end_clt <= 1'b0;
	end
	else if((DHCP_MAC_send_num>16'd10||DHCP_MAC_recv_num>16'd10) && DHCP_server_en == 1'b0 &&DHCP_server_judge_end)
	begin
		server_device_mac <= recv_node_mac;
		server_device_compete_end_clt <= 1'b1;
		server_device_compete_end_sver <= 1'b0;
	end
	else
	begin
		server_device_mac <= 48'h000000000000;
		server_device_compete_end_clt <= 1'b0;
		server_device_compete_end_sver <= 1'b0;
	end

end
//DHCP_clt_online_msg
wire [15:0] DHCP_clt_online_msg[0:30];
assign DHCP_clt_online_msg[0]=16'hffff;
assign DHCP_clt_online_msg[1]=16'hffff;
assign DHCP_clt_online_msg[2]=16'hffff;
assign DHCP_clt_online_msg[3]=16'hffff;
assign DHCP_clt_online_msg[4]=16'hd0c0;//DHCP massege flag
assign DHCP_clt_online_msg[5]=16'h1010;//DHCP_clt_online_msg flag
assign DHCP_clt_online_msg[6]=16'h0000;
assign DHCP_clt_online_msg[7]=16'h0000;
assign DHCP_clt_online_msg[8]=16'h0000;
assign DHCP_clt_online_msg[9]=i_local_mac[47:32];
assign DHCP_clt_online_msg[10]=i_local_mac[31:16];
assign DHCP_clt_online_msg[11]=i_local_mac[15:0];
assign DHCP_clt_online_msg[12]=16'h0000;
assign DHCP_clt_online_msg[13]=16'h0000;
assign DHCP_clt_online_msg[14]=16'h0000;
assign DHCP_clt_online_msg[15]=16'h0000;
assign DHCP_clt_online_msg[16]=16'h0000;
assign DHCP_clt_online_msg[17]=16'h0000;
assign DHCP_clt_online_msg[18]=16'h0000;
assign DHCP_clt_online_msg[19]=16'h0000;
assign DHCP_clt_online_msg[20]=16'h0000;
assign DHCP_clt_online_msg[21]=16'h0000;
assign DHCP_clt_online_msg[22]=16'h0000;
assign DHCP_clt_online_msg[23]=16'h0000;
assign DHCP_clt_online_msg[24]=16'h0000;
assign DHCP_clt_online_msg[25]=16'h0000;
assign DHCP_clt_online_msg[26]=16'h0000;
assign DHCP_clt_online_msg[27]=16'h0000;
assign DHCP_clt_online_msg[28]=16'h0000;
assign DHCP_clt_online_msg[29]=16'h0000;
assign DHCP_clt_online_msg[30]=16'h1010;//DHCP_clt_online_msg flag

reg [32:0] server_device_compete_end_clt_dly;
always @(posedge i_clk, negedge i_rst_n)
begin	
	if(!i_rst_n)
		server_device_compete_end_clt_dly <= 32'b0;
	else if(server_device_compete_end_clt && server_device_compete_end_clt_dly<32'hffffff)
		server_device_compete_end_clt_dly <= server_device_compete_end_clt_dly+32'h00000001;
	else
		server_device_compete_end_clt_dly <= server_device_compete_end_clt_dly;
end

reg DHCP_clt_online_msg_send_condition;
reg DHCP_clt_online_msg_send_done;
reg [9:0] DHCP_clt_online_msg_send_num;
always @(posedge i_clk, negedge i_rst_n)
begin	
	if(!i_rst_n)
		begin
		DHCP_clt_online_msg_send_condition<=1'b0;
		DHCP_clt_online_msg_send_done <= 1'b0;
		end
	else if(server_device_compete_end_clt_dly>=32'hfffffe && !DHCP_clt_online_msg_send_condition && !DHCP_clt_online_msg_send_done && !DHCP_server_en)
		DHCP_clt_online_msg_send_condition<=1'b1;
	else if(DHCP_clt_online_msg_send_condition && i_send_DHCP_addr==10'd31 && o_send_DHCP_data==16'h1010)
		DHCP_clt_online_msg_send_done <= 1'b1;
	else if(!DHCP_clt_online_msg_send_done && DHCP_clt_online_msg_send_condition && i_send_DHCP_addr<=10'd30)
		DHCP_clt_online_msg_send_condition<=1'b1;
	else
		begin
		DHCP_clt_online_msg_send_condition<=1'b0;
		DHCP_clt_online_msg_send_done <= DHCP_clt_online_msg_send_done;
		end
end

reg [9:0] DHCP_clt_online_msg_recv_num;
always @(posedge i_clk, negedge i_rst_n)
begin	
	if(!i_rst_n)
		DHCP_clt_online_msg_recv_num <= 10'b0;
	else if((DHCP_server_en && i_recv_addr_A==10'd6 && i_recv_data_A==16'h1010) || (DHCP_server_en && i_recv_addr_B==10'd6 && i_recv_data_B==16'h1010))
		DHCP_clt_online_msg_recv_num <= DHCP_clt_online_msg_recv_num+10'h001;
	else
		DHCP_clt_online_msg_recv_num <= DHCP_clt_online_msg_recv_num;
end

//server device compete end
//Client request mac address msg
wire [15:0] DHCP_clt_req_ip_msg[0:30];
assign DHCP_clt_req_ip_msg[0]=16'hffff;
assign DHCP_clt_req_ip_msg[1]=16'hffff;
assign DHCP_clt_req_ip_msg[2]=16'hffff;
assign DHCP_clt_req_ip_msg[3]=16'hffff;
assign DHCP_clt_req_ip_msg[4]=16'hd0c0;//DHCP massege flag
assign DHCP_clt_req_ip_msg[5]=16'h0011;//DHCP_MAC_msg flag
assign DHCP_clt_req_ip_msg[6]=16'h0000;
assign DHCP_clt_req_ip_msg[7]=16'h0000;
assign DHCP_clt_req_ip_msg[8]=16'h0000;
assign DHCP_clt_req_ip_msg[9]=i_local_mac[47:32];
assign DHCP_clt_req_ip_msg[10]=i_local_mac[31:16];
assign DHCP_clt_req_ip_msg[11]=i_local_mac[15:0];
assign DHCP_clt_req_ip_msg[12]=16'h0000;
assign DHCP_clt_req_ip_msg[13]=16'h0000;
assign DHCP_clt_req_ip_msg[14]=16'h0000;
assign DHCP_clt_req_ip_msg[15]=16'h0000;
assign DHCP_clt_req_ip_msg[16]=16'h0000;
assign DHCP_clt_req_ip_msg[17]=16'h0000;
assign DHCP_clt_req_ip_msg[18]=16'h0000;
assign DHCP_clt_req_ip_msg[19]=16'h0000;
assign DHCP_clt_req_ip_msg[20]=16'h0000;
assign DHCP_clt_req_ip_msg[21]=16'h0000;
assign DHCP_clt_req_ip_msg[22]=16'h0000;
assign DHCP_clt_req_ip_msg[23]=16'h0000;
assign DHCP_clt_req_ip_msg[24]=16'h0000;
assign DHCP_clt_req_ip_msg[25]=16'h0000;
assign DHCP_clt_req_ip_msg[26]=16'h0000;
assign DHCP_clt_req_ip_msg[27]=16'h0000;
assign DHCP_clt_req_ip_msg[28]=16'h0000;
assign DHCP_clt_req_ip_msg[29]=16'h0000;
assign DHCP_clt_req_ip_msg[30]=16'h0011;

reg DHCP_clt_req_ip_msg_send_done;
always @(posedge i_clk, negedge i_rst_n)
begin	
	if(!i_rst_n)
		DHCP_clt_req_ip_msg_send_done <= 1'b0;
	else if(DHCP_server_en==1'b0 && server_device_compete_end_clt ==1'b1 && i_send_DHCP_addr==10'h01f && o_send_DHCP_data==16'h0011 & server_device_compete_end_sver==1'b0)
		DHCP_clt_req_ip_msg_send_done <= 1'b1;
	else
		DHCP_clt_req_ip_msg_send_done <= DHCP_clt_req_ip_msg_send_done;
end

reg [31:0] DHCP_clt_req_ip_msg_send_condition_dly;
always @(posedge i_clk, negedge i_rst_n)
begin	
	if(!i_rst_n)
		DHCP_clt_req_ip_msg_send_condition_dly <= 32'b0;
	else if(DHCP_clt_online_msg_send_done && DHCP_clt_req_ip_msg_send_condition_dly<32'hfffffe)
		DHCP_clt_req_ip_msg_send_condition_dly <= DHCP_clt_req_ip_msg_send_condition_dly+32'h1;
	else
		DHCP_clt_req_ip_msg_send_condition_dly <= DHCP_clt_req_ip_msg_send_condition_dly;
end
		
reg DHCP_clt_req_ip_msg_send_condition;
always @(posedge i_clk, negedge i_rst_n)
begin	
	if(!i_rst_n)
		DHCP_clt_req_ip_msg_send_condition <= 1'b0;
	else if(DHCP_clt_req_ip_msg_send_condition_dly>=32'hfffffd && DHCP_server_en==1'b0 && server_device_compete_end_clt ==1'b1 && !DHCP_clt_req_ip_msg_send_done)
		DHCP_clt_req_ip_msg_send_condition <= 1'b1;
	else if(DHCP_clt_req_ip_msg_send_irq)
		DHCP_clt_req_ip_msg_send_condition <= 1'b1;
	else if(DHCP_clt_req_ip_msg_send_condition && DHCP_offer_msg_wait_cnt<32'd31)
		DHCP_clt_req_ip_msg_send_condition <= 1'b1;
	else
		DHCP_clt_req_ip_msg_send_condition <= 1'b0;
end
reg [31:0] DHCP_clt_req_ip_msg_send_num;
reg [31:0] DHCP_offer_msg_wait_cnt;
reg DHCP_clt_req_ip_msg_send_irq;
always @(posedge i_clk, negedge i_rst_n)
begin	
	if(!i_rst_n)
	begin
		DHCP_offer_msg_wait_cnt <= 32'h00000000;
		DHCP_clt_req_ip_msg_send_irq <= 1'b0;
	end
	else if(!DHCP_offer_msg_recv_done && DHCP_clt_req_ip_msg_send_done && (DHCP_offer_msg_wait_cnt<(i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer)))
		begin
		DHCP_clt_req_ip_msg_send_irq <=1'b0;
		DHCP_offer_msg_wait_cnt <= DHCP_offer_msg_wait_cnt + 32'h00000001;
		end
	else if(DHCP_offer_msg_wait_cnt == i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer)
		begin
		DHCP_clt_req_ip_msg_send_irq <=1'b1;
		DHCP_offer_msg_wait_cnt <= 32'h00000000;
		DHCP_clt_req_ip_msg_send_num <= DHCP_clt_req_ip_msg_send_num+32'b1;
		end
	else if(DHCP_clt_req_ip_msg_send_num)//for test
		begin
		DHCP_clt_req_ip_msg_send_irq <=1'b0;
		DHCP_clt_req_ip_msg_send_num <= DHCP_clt_req_ip_msg_send_num;
		end
	else
		begin
		DHCP_clt_req_ip_msg_send_irq <=1'b0;
		DHCP_clt_req_ip_msg_send_num <= DHCP_clt_req_ip_msg_send_num;
		end
end

		
//ip_resource total=30
wire [31:0] ip_resource [0:20];
assign ip_resource[0] =32'b11000000101010000000000000000010;
assign ip_resource[1] =32'b11000000101010000000000000000011;
assign ip_resource[2] =32'b11000000101010000000000000000100;
assign ip_resource[3] =32'b11000000101010000000000000000101;
assign ip_resource[4] =32'b11000000101010000000000000000110;
assign ip_resource[5] =32'b11000000101010000000000000000111;
assign ip_resource[6] =32'b11000000101010000000000000001000;
assign ip_resource[7] =32'b11000000101010000000000000001001;
assign ip_resource[8] =32'b11000000101010000000000000001010;
assign ip_resource[9] =32'b11000000101010000000000000001011;
assign ip_resource[10] =32'b11000000101010000000000000001100;
assign ip_resource[11] =32'b11000000101010000000000000001101;
assign ip_resource[12] =32'b11000000101010000000000000001110;
assign ip_resource[13] =32'b11000000101010000000000000001111;
assign ip_resource[14] =32'b11000000101010000000000000010000;
assign ip_resource[15] =32'b11000000101010000000000000010001;
assign ip_resource[16] =32'b11000000101010000000000000010010;
assign ip_resource[17] =32'b11000000101010000000000000010011;
assign ip_resource[18] =32'b11000000101010000000000000010100;
assign ip_resource[19] =32'b11000000101010000000000000010101;
assign ip_resource[20] =32'b11000000101010000000000000010110;
//
reg ip_send_already [0:16];
reg ip_allot_already [0:16];
reg [7:0] ip_resource_idx;//ip resource sorting index
reg [9:0] DHCP_clt_req_ip_msg_recv_num;//for server
reg DHCP_clt_req_ip_msg_recv_done;

always @(posedge i_clk, negedge i_rst_n)
begin	
	if(!i_rst_n)
			DHCP_clt_req_ip_msg_recv_num <= 10'b0;
	else if((DHCP_server_en && server_device_compete_end && i_recv_addr_A == 10'h006 && i_recv_data_A == 16'h0011)||(DHCP_server_en && server_device_compete_end && i_recv_addr_B == 10'h006 && i_recv_data_B == 16'h0011))
		begin	
			DHCP_clt_req_ip_msg_recv_num <= DHCP_clt_req_ip_msg_recv_num+10'b1;
			DHCP_clt_req_ip_msg_recv_done <= 1'b1;
		end
//	else if((DHCP_server_en && server_device_compete_end && i_recv_addr_A!=10'h000)||(DHCP_server_en && server_device_compete_end && i_recv_addr_B!=10'h000))
//			DHCP_clt_req_ip_msg_recv_done <= 1'b1;
	else if((DHCP_clt_req_ip_msg_recv_done && i_recv_addr_A<10'h30 && i_recv_addr_A!=10'h000)||(DHCP_clt_req_ip_msg_recv_done && i_recv_addr_B<10'h30&&i_recv_addr_B!=10'h000))
			DHCP_clt_req_ip_msg_recv_done <= 1'b1;
	else
		begin
			DHCP_clt_req_ip_msg_recv_num <= DHCP_clt_req_ip_msg_recv_num;
			DHCP_clt_req_ip_msg_recv_done <= 1'b0;
		end
end

//DHCP_offer_msg
always @(posedge i_clk, negedge i_rst_n)
begin	
	if(!i_rst_n)
	;
	else
		   DHCP_offer_msg[0] <= 16'hffff;
			DHCP_offer_msg[1] <= 16'hffff;
			DHCP_offer_msg[2] <= 16'hffff;
			DHCP_offer_msg[3] <= 16'hffff;
			DHCP_offer_msg[4]<=16'hd0c0;//DHCP massege flag
			DHCP_offer_msg[5]<=16'h0100;//DHCP_offer_msg flag
			DHCP_offer_msg[6]<=16'h0000;
			DHCP_offer_msg[7]<=16'h0000;
			DHCP_offer_msg[8]<=16'h0000;
			DHCP_offer_msg[12]<=16'h0000;
			DHCP_offer_msg[13]<=16'h0000;
			DHCP_offer_msg[19]<=16'h0000;
			DHCP_offer_msg[20]<=16'h0000;
			DHCP_offer_msg[21]<=16'h0000;
			DHCP_offer_msg[22]<=16'h0000;
			DHCP_offer_msg[23]<=16'h0000;
			DHCP_offer_msg[24]<=16'h0000;
			DHCP_offer_msg[25]<=16'h0000;
			DHCP_offer_msg[26]<=16'h0000;
			DHCP_offer_msg[27]<=16'h0000;
			DHCP_offer_msg[28]<=16'h0000;
			DHCP_offer_msg[29]<=16'h0000;
			DHCP_offer_msg[30]<=16'h0100;
end
reg [15:0] DHCP_offer_msg [30:0];
reg DHCP_offer_msg_send_pre_done;
always @(posedge i_clk, negedge i_rst_n)
begin	
	if(!i_rst_n)
	begin
		DHCP_offer_msg[9] <= 16'h0000;
		DHCP_offer_msg[10] <= 16'h0000;
		DHCP_offer_msg[11] <= 16'h0000;
		DHCP_offer_msg_send_pre_done <= 1'b0;
	end
	
	else if(DHCP_clt_req_ip_msg_recv_done && DHCP_server_en && server_device_compete_end && i_recv_addr_A==10'h00A)//DHCP_clt_req_ip_msg_recv_done
		DHCP_offer_msg[14] <= i_recv_data_A;
	else if(DHCP_clt_req_ip_msg_recv_done && DHCP_server_en && server_device_compete_end && i_recv_addr_A==10'h00B)
		DHCP_offer_msg[15] <= i_recv_data_A;
	else if(DHCP_clt_req_ip_msg_recv_done && DHCP_server_en && server_device_compete_end && i_recv_addr_A==10'h00C)
		begin
			DHCP_offer_msg[16] <= i_recv_data_A;
			DHCP_offer_msg[9]<=i_local_mac[47:32];
			DHCP_offer_msg[10]<=i_local_mac[41:16];
			DHCP_offer_msg[11]<=i_local_mac[15:0];
			if(local_node_ip_DHCP == 32'b11000000101010000000000000000001)
				begin
					DHCP_offer_msg[17] <= ip_resource[DHCP_offer_msg_send_num][31:16];
					DHCP_offer_msg[18] <= ip_resource[DHCP_offer_msg_send_num][15:0];
					DHCP_offer_msg_send_num <= DHCP_offer_msg_send_num + 10'b1;
					DHCP_offer_msg_send_pre_done <= 1'd1;
				end
			else if(local_node_ip_DHCP!=32'b11000000101010000000000000000001)
				begin
					DHCP_offer_msg_send_num <= DHCP_offer_msg_send_num + 10'b1;
					DHCP_offer_msg[17] <= other_node_ip_in_ptp[31:16];
					DHCP_offer_msg[18] <= other_node_ip_in_ptp[15:0]+DHCP_offer_msg_send_num;
					DHCP_offer_msg_send_pre_done <= 1'd1;
				end
		end
		//for B
	else if(DHCP_clt_req_ip_msg_recv_done && DHCP_server_en && server_device_compete_end && i_recv_addr_B==10'h00A)//DHCP_clt_req_ip_msg_recv_done
		DHCP_offer_msg[14] <= i_recv_data_B;
	else if(DHCP_clt_req_ip_msg_recv_done && DHCP_server_en && server_device_compete_end && i_recv_addr_B==10'h00B)
		DHCP_offer_msg[15] <= i_recv_data_B;
	else if(DHCP_clt_req_ip_msg_recv_done && DHCP_server_en && server_device_compete_end && i_recv_addr_B==10'h00C)
		begin
			DHCP_offer_msg[16] <= i_recv_data_B;
			DHCP_offer_msg[9]<=i_local_mac[47:32];
			DHCP_offer_msg[10]<=i_local_mac[41:16];
			DHCP_offer_msg[11]<=i_local_mac[15:0];
			if(local_node_ip_DHCP == 32'b11000000101010000000000000000001)
				begin
					DHCP_offer_msg[17] <= ip_resource[DHCP_offer_msg_send_num][31:16];
					DHCP_offer_msg[18] <= ip_resource[DHCP_offer_msg_send_num][15:0];
					DHCP_offer_msg_send_num <= DHCP_offer_msg_send_num + 10'b1;
					DHCP_offer_msg_send_pre_done <= 1'd1;
				end
			else if(local_node_ip_DHCP != 32'b11000000101010000000000000000001)
				begin
					DHCP_offer_msg_send_num <= DHCP_offer_msg_send_num + 10'b1;
					DHCP_offer_msg[17] <= other_node_ip_in_ptp[31:16];
					DHCP_offer_msg[18] <= other_node_ip_in_ptp[15:0]+DHCP_offer_msg_send_num;
					DHCP_offer_msg_send_pre_done <= 1'd1;
				end
		end
		//for B
		else
			begin
			DHCP_offer_msg[9] <= DHCP_offer_msg[9];
			DHCP_offer_msg[10] <= DHCP_offer_msg[10];
			DHCP_offer_msg[11] <= DHCP_offer_msg[11];
			DHCP_offer_msg[14] <= DHCP_offer_msg[14];
			DHCP_offer_msg[15] <= DHCP_offer_msg[15];
			DHCP_offer_msg[16] <= DHCP_offer_msg[16];
			DHCP_offer_msg[17] <= DHCP_offer_msg[17];
			DHCP_offer_msg[18] <= DHCP_offer_msg[18];
			DHCP_offer_msg_send_num <= DHCP_offer_msg_send_num;
			DHCP_offer_msg_send_pre_done <= 1'd0;
			end
end

reg DHCP_offer_msg_send_condition;
reg [9:0] DHCP_offer_msg_send_num;
always @(posedge i_clk, negedge i_rst_n)
begin	
	if(!i_rst_n)
		DHCP_offer_msg_send_condition <= 1'b0;
	else if(DHCP_clt_online_msg_recv_num!=10'h000 && DHCP_clt_req_ip_msg_recv_num!=10'h000 && server_device_compete_end && DHCP_offer_msg_send_pre_done && !DHCP_offer_msg_send_done)
		DHCP_offer_msg_send_condition <= 1'b1;
	else if(DHCP_offer_msg_send_condition && DHCP_clt_req_ip_msg_recv_num!=10'h000 && server_device_compete_end && i_send_DHCP_addr<=10'h01b  && !DHCP_offer_msg_send_done)
		DHCP_offer_msg_send_condition <= 1'b1;
	else if(DHCP_offer_msg_send_done)
		DHCP_offer_msg_send_condition <= 1'b0;
	else
		DHCP_offer_msg_send_condition <= 1'b0;
end

reg DHCP_offer_msg_send_done;
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		DHCP_offer_msg_send_done <= 1'b0;
	else if(DHCP_server_en && server_device_compete_end && i_send_DHCP_addr==10'h01f && o_send_DHCP_data==16'h0100 & server_device_compete_end_clt==1'b0)
		DHCP_offer_msg_send_done <= 1'b1;
	else
		DHCP_offer_msg_send_done <= 1'b0;
end

//reg DHCP_offer_msg_recv_done_1;
//reg DHCP_offer_msg_recv_done_2;
//reg DHCP_offer_msg_recv_done_3;
//reg DHCP_offer_msg_recv_done_4;
//always @(posedge i_clk, negedge i_rst_n)
//begin	
//	if(!i_rst_n)
//		begin
//			DHCP_offer_msg_recv_done_1 <= 1'b0;
//			DHCP_offer_msg_recv_done_2 <= 1'b0;
//			DHCP_offer_msg_recv_done_3 <= 1'b0;
//			DHCP_offer_msg_recv_done_4 <= 1'b0;
//		end
//	else if(DHCP_clt_req_ip_msg_send_done && DHCP_server_en == 1'b0 && i_recv_addr_A == 10'd6 && i_recv_data_A == 16'h0100)
//		DHCP_offer_msg_recv_done_1 <= 1'b1;
//	else if(DHCP_clt_req_ip_msg_send_done && DHCP_server_en == 1'b0 && i_recv_addr_A == 10'hf && i_recv_data_A == i_local_mac[47:32])
//		DHCP_offer_msg_recv_done_2 <= 1'b1;
//	else if(DHCP_clt_req_ip_msg_send_done && DHCP_server_en == 1'b0 && i_recv_addr_A == 10'h10 && i_recv_data_A == i_local_mac[31:16])
//		DHCP_offer_msg_recv_done_3 <= 1'b1;
//	else if(DHCP_clt_req_ip_msg_send_done && i_recv_addr_A == 10'h11 && i_recv_data_A == i_local_mac[15:0])
//		DHCP_offer_msg_recv_done_4 <= 1'b1;
//		
//	//for B
//	else if(DHCP_clt_req_ip_msg_send_done && DHCP_server_en == 1'b0 && i_recv_addr_B == 10'd6 && i_recv_data_B == 16'h0100)
//		DHCP_offer_msg_recv_done_1 <= 1'b1;
//	else if(DHCP_clt_req_ip_msg_send_done && DHCP_server_en == 1'b0 && i_recv_addr_B == 10'hf && i_recv_data_B == i_local_mac[47:32])
//		DHCP_offer_msg_recv_done_2 <= 1'b1;
//	else if(DHCP_clt_req_ip_msg_send_done && DHCP_server_en == 1'b0 && i_recv_addr_B == 10'h10 && i_recv_data_B == i_local_mac[31:16])
//		DHCP_offer_msg_recv_done_3 <= 1'b1;
//	else if(DHCP_clt_req_ip_msg_send_done && i_recv_addr_B == 10'h11 && i_recv_data_B == i_local_mac[15:0])
//		DHCP_offer_msg_recv_done_4 <= 1'b1;
//	//for B
//	
//	else
//		begin
//			DHCP_offer_msg_recv_done_1 <= DHCP_offer_msg_recv_done_1;
//			DHCP_offer_msg_recv_done_2 <= DHCP_offer_msg_recv_done_2;
//			DHCP_offer_msg_recv_done_3 <= DHCP_offer_msg_recv_done_3;
//			DHCP_offer_msg_recv_done_4 <= DHCP_offer_msg_recv_done_4;
//		end
//end
//reg DHCP_offer_msg_recv_done;
//always @(posedge i_clk, negedge i_rst_n)
//begin	
//	if(!i_rst_n)
//		begin
//		local_node_ip_DHCP <= 32'b0;
//		DHCP_offer_msg_recv_done <= 1'b0;
//		end
//	else if(local_node_ip_DHCP==32'h00000000 && DHCP_server_en==1'b1 && server_device_compete_end)   //如果本设备连接网络且是主设备，那么初始化IP为192.168.0.1
//		begin
//			local_node_ip_DHCP <= 32'b11000000101010000000000000000001;    //192.168.0.1
//		end
//	else if(!DHCP_offer_msg_recv_done && DHCP_server_en == 1'b0 && DHCP_offer_msg_recv_done_1 && DHCP_offer_msg_recv_done_2 && DHCP_offer_msg_recv_done_3 && DHCP_offer_msg_recv_done_4)
//		begin
//			if(i_recv_addr_A==10'd18)
//				local_node_ip_DHCP[31:16] <= i_recv_data_A;
//			else if(i_recv_addr_A==10'd19)
//			begin
//				local_node_ip_DHCP[15:0]  <= i_recv_data_A;
//				DHCP_offer_msg_recv_done <= 1'b1;
//			end
//			//for B/////////////////////////////////////
//			if(i_recv_addr_B==10'd18)
//				local_node_ip_DHCP[31:16] <= i_recv_data_B;
//			else if(i_recv_addr_B==10'd19)
//			begin
//				local_node_ip_DHCP[15:0]  <= i_recv_data_B;
//				DHCP_offer_msg_recv_done <= 1'b1;
//			end
//			//for B////////////////////////////////////
//		end
//	else
//		local_node_ip_DHCP <= local_node_ip_DHCP;
//end
reg DHCP_offer_msg_recv_done;
reg [2:0] get_ip_from_offer_state;
parameter [2:0] get_ip_from_offer_S0=3'b000;
parameter [2:0] get_ip_from_offer_S1=3'b001;
parameter [2:0] get_ip_from_offer_S2=3'b010;
parameter [2:0] get_ip_from_offer_S3=3'b011;
parameter [2:0] get_ip_from_offer_S4=3'b100;
parameter [2:0] get_ip_from_offer_S5=3'b101;

always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			get_ip_from_offer_state <= 3'b000;
			DHCP_offer_msg_recv_done <= 1'b0;
		end
	else if(local_node_ip_DHCP==32'h00000000 && DHCP_server_en==1'b1 && server_device_compete_end)   //如果本设备连接网络且是主设备，那么初始化IP为192.168.0.1
			local_node_ip_DHCP <= 32'b11000000101010000000000000000001;    //192.168.0.1
	else if(!DHCP_offer_msg_recv_done && !DHCP_server_en && DHCP_clt_req_ip_msg_send_done)
		case(get_ip_from_offer_state)
			get_ip_from_offer_S0:		
				if((i_recv_addr_A == 10'd6 && i_recv_data_A == 16'h0100)||(i_recv_addr_B == 10'd6 && i_recv_data_B == 16'h0100))
					get_ip_from_offer_state <= get_ip_from_offer_S1;
				else
					get_ip_from_offer_state <= get_ip_from_offer_S0;
			get_ip_from_offer_S1:		
				if((i_recv_addr_A == 10'hf && i_recv_data_A == i_local_mac[47:32])||(i_recv_addr_B == 10'hf && i_recv_data_B == i_local_mac[47:32]))
					get_ip_from_offer_state <= get_ip_from_offer_S2;
				else
					get_ip_from_offer_state <= get_ip_from_offer_S1;
			get_ip_from_offer_S2:
				if((i_recv_addr_A == 10'h10 && i_recv_data_A == i_local_mac[31:16])||(i_recv_addr_B == 10'h10 && i_recv_data_B == i_local_mac[31:16]))
					get_ip_from_offer_state <= get_ip_from_offer_S3;
				else
					get_ip_from_offer_state <= get_ip_from_offer_S1;
			get_ip_from_offer_S3:		
				if((i_recv_addr_A == 10'h11 && i_recv_data_A == i_local_mac[15:0])||(i_recv_addr_B == 10'h11 && i_recv_data_B == i_local_mac[15:0]))
					get_ip_from_offer_state <= get_ip_from_offer_S4;
				else
					get_ip_from_offer_state <= get_ip_from_offer_S1;
			get_ip_from_offer_S4:
				if(i_recv_addr_A==10'd18)
					begin
						local_node_ip_DHCP[31:16] <= i_recv_data_A;
						get_ip_from_offer_state <= get_ip_from_offer_S4;
					end
				else if(i_recv_addr_A==10'd19)
					begin
						local_node_ip_DHCP[15:0]  <= i_recv_data_A;
						DHCP_offer_msg_recv_done <= 1'b1;
					end
				else if(i_recv_addr_B==10'd18)
					begin
						local_node_ip_DHCP[31:16] <= i_recv_data_B;
						get_ip_from_offer_state <= get_ip_from_offer_S4;
					end
				else if(i_recv_addr_B==10'd19)
					begin
						local_node_ip_DHCP[15:0]  <= i_recv_data_B;
						DHCP_offer_msg_recv_done <= 1'b1;
					end
		endcase
	end
assign DHCP_end=DHCP_offer_msg_recv_done || server_device_compete_end_sver;
////////////////////////server out of network/////////////////////////////////////
reg [31:0] other_node_ip_in_ptp_A;
reg [9:0] other_node_ip_in_ptp_cnt_A;
reg [9:0] get_other_node_ip_in_ptp_cnt_A;
reg get_other_node_ip_in_ptp_done_A;
reg [31:0] other_node_ip_in_ptp_A_temp;
reg [2:0] get_other_node_ip_in_ptp_state_A;
parameter [2:0] get_other_node_ip_in_ptp_S0_A=3'b000;
parameter [2:0] get_other_node_ip_in_ptp_S1_A=3'b001;
parameter [2:0] get_other_node_ip_in_ptp_S2_A=3'b010;
parameter [2:0] get_other_node_ip_in_ptp_S3_A=3'b011;
parameter [2:0] get_other_node_ip_in_ptp_S4_A=3'b100;
parameter [2:0] get_other_node_ip_in_ptp_S5_A=3'b101;
parameter [2:0] get_other_node_ip_in_ptp_S6_A=3'b110;
parameter [2:0] get_other_node_ip_in_ptp_S7_A=3'b111;
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			get_other_node_ip_in_ptp_state_A <= 3'b000;
			get_other_node_ip_in_ptp_done_A <= 1'b0;
		end
	else if(i_main_clock_ip_up!=32'b0 && DHCP_server_judge_end && !DHCP_server_en && i_main_clock_state && !get_other_node_ip_in_ptp_done_A && i_macrocycle_b)//macrocycle?
		case(get_other_node_ip_in_ptp_state_A)
			get_other_node_ip_in_ptp_S0_A:
				if(i_recv_addr_A==10'd1 && i_recv_data_A==16'hffff)
					get_other_node_ip_in_ptp_state_A <= get_other_node_ip_in_ptp_S1_A;
			get_other_node_ip_in_ptp_S1_A:
				if(i_recv_addr_A==10'd2 && i_recv_data_A==16'hffff)
					get_other_node_ip_in_ptp_state_A <= get_other_node_ip_in_ptp_S2_A;				
			get_other_node_ip_in_ptp_S2_A:
				if(i_recv_addr_A==10'd3 && i_recv_data_A==16'hffff)
					get_other_node_ip_in_ptp_state_A <= get_other_node_ip_in_ptp_S3_A;
			get_other_node_ip_in_ptp_S3_A:
				if(i_recv_addr_A==10'd7 && i_recv_data_A==16'h8907)
					get_other_node_ip_in_ptp_state_A <= get_other_node_ip_in_ptp_S4_A;
			get_other_node_ip_in_ptp_S4_A:
				if(i_recv_addr_A==10'd9)
					begin
						other_node_ip_in_ptp_A_temp[31:16] <= i_recv_data_A;
						get_other_node_ip_in_ptp_state_A <= get_other_node_ip_in_ptp_S5_A;
					end
			get_other_node_ip_in_ptp_S5_A:
				if(i_recv_addr_A==10'd10)
					begin
						other_node_ip_in_ptp_A_temp[15:0] <= i_recv_data_A;
						get_other_node_ip_in_ptp_state_A <= get_other_node_ip_in_ptp_S6_A;
					end
			get_other_node_ip_in_ptp_S6_A:
				if(i_recv_addr_A==10'd11 && i_recv_data_A[3:0]==4'h0)
					begin
						other_node_ip_in_ptp_A <= (other_node_ip_in_ptp_A_temp | other_node_ip_in_ptp_A | local_node_ip_DHCP);
						//other_node_ip_in_ptp_cnt_A <= other_node_ip_in_ptp_cnt_A+10'h001;
						get_other_node_ip_in_ptp_state_A <= get_other_node_ip_in_ptp_S7_A;
					end
				else
					begin
						other_node_ip_in_ptp_A <= 32'b0;
						get_other_node_ip_in_ptp_state_A <= get_other_node_ip_in_ptp_S0_A;
					end
			get_other_node_ip_in_ptp_S7_A:
					if(i_macrocycle_b)
					begin
						get_other_node_ip_in_ptp_state_A <= get_other_node_ip_in_ptp_S0_A;
						get_other_node_ip_in_ptp_cnt_A <= get_other_node_ip_in_ptp_cnt_A+10'h001;
					end
		endcase
		else if(!i_macrocycle_b)
			begin
				if(get_other_node_ip_in_ptp_cnt_A >= 10'h060)
					get_other_node_ip_in_ptp_done_A <= 1'b1;
				else if(get_other_node_ip_in_ptp_done_B && get_other_node_ip_in_ptp_cnt_A == 10'h000)
					get_other_node_ip_in_ptp_done_A <= 1'b1;
			end
		else if(!i_link_valid)
			get_other_node_ip_in_ptp_done_A <= 1'b0;
end

reg [9:0] get_other_node_ip_in_ptp_cnt_B;
reg [31:0] other_node_ip_in_ptp_B;
reg [9:0] other_node_ip_in_ptp_cnt_B;
reg get_other_node_ip_in_ptp_done_B;
reg [31:0] other_node_ip_in_ptp_B_temp;
reg [2:0] get_other_node_ip_in_ptp_state_B;
parameter [2:0] get_other_node_ip_in_ptp_S0_B=3'b000;
parameter [2:0] get_other_node_ip_in_ptp_S1_B=3'b001;
parameter [2:0] get_other_node_ip_in_ptp_S2_B=3'b010;
parameter [2:0] get_other_node_ip_in_ptp_S3_B=3'b011;
parameter [2:0] get_other_node_ip_in_ptp_S4_B=3'b100;
parameter [2:0] get_other_node_ip_in_ptp_S5_B=3'b101;
parameter [2:0] get_other_node_ip_in_ptp_S6_B=3'b110;
parameter [2:0] get_other_node_ip_in_ptp_S7_B=3'b111;
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			get_other_node_ip_in_ptp_state_B <= 3'b000;
			get_other_node_ip_in_ptp_done_B <= 1'b0;
		end
	else if(i_main_clock_ip_up!=32'b0 && DHCP_server_judge_end && server_out_of_network && !get_other_node_ip_in_ptp_done_B && i_macrocycle_b)
		case(get_other_node_ip_in_ptp_state_B)
			get_other_node_ip_in_ptp_S0_B:
				if(!i_macrocycle_b)
						get_other_node_ip_in_ptp_done_B <= 1'b1;
				else if(i_recv_addr_B==10'd1 && i_recv_data_B==16'hffff)
					get_other_node_ip_in_ptp_state_B <= get_other_node_ip_in_ptp_S1_B;
			get_other_node_ip_in_ptp_S1_B:
				if(!i_macrocycle_b)
						get_other_node_ip_in_ptp_done_B <= 1'b1;
				else if(i_recv_addr_B==10'd2 && i_recv_data_B==16'hffff)
					get_other_node_ip_in_ptp_state_B <= get_other_node_ip_in_ptp_S2_B;			
			get_other_node_ip_in_ptp_S2_B:
				if(!i_macrocycle_b)
						get_other_node_ip_in_ptp_done_B <= 1'b1;
				else if(i_recv_addr_B==10'd3 && i_recv_data_B==16'hffff)
					get_other_node_ip_in_ptp_state_B <= get_other_node_ip_in_ptp_S3_B;
			get_other_node_ip_in_ptp_S3_B:
				if(!i_macrocycle_b)
						get_other_node_ip_in_ptp_done_B <= 1'b1;
				else if(i_recv_addr_B==10'd7 && i_recv_data_B==16'h8907)
					get_other_node_ip_in_ptp_state_B <= get_other_node_ip_in_ptp_S4_B;
			get_other_node_ip_in_ptp_S4_B:
				if(!i_macrocycle_b)
						get_other_node_ip_in_ptp_done_B <= 1'b1;
				else if(i_recv_addr_B==10'd9)
					begin
						other_node_ip_in_ptp_B_temp[31:16] <= i_recv_data_B;
						get_other_node_ip_in_ptp_state_B <= get_other_node_ip_in_ptp_S5_B;
					end
			get_other_node_ip_in_ptp_S5_B:
				if(!i_macrocycle_b)
						get_other_node_ip_in_ptp_done_B <= 1'b1;
				else if(i_recv_addr_B==10'd10)
					begin
						other_node_ip_in_ptp_B_temp[15:0] <= i_recv_data_B;
						get_other_node_ip_in_ptp_state_B <= get_other_node_ip_in_ptp_S6_B;
					end
			get_other_node_ip_in_ptp_S6_B:
				if(!i_macrocycle_b)
						get_other_node_ip_in_ptp_done_B <= 1'b1;
				else if(i_recv_addr_B==10'd11 && i_recv_data_B[3:0]==4'h0)
					begin
						other_node_ip_in_ptp_B <= (other_node_ip_in_ptp_B_temp | other_node_ip_in_ptp_B | local_node_ip_DHCP);
						//other_node_ip_in_ptp_cnt_B <= other_node_ip_in_ptp_cnt_B+10'h001;
						get_other_node_ip_in_ptp_state_B <= get_other_node_ip_in_ptp_S7_B;
					end
				else
					begin
						other_node_ip_in_ptp_B <= 32'b0;
						get_other_node_ip_in_ptp_state_B <= get_other_node_ip_in_ptp_S0_B;
					end
			get_other_node_ip_in_ptp_S7_B:
				if(!i_macrocycle_b)
						get_other_node_ip_in_ptp_done_B <= 1'b1;
				else if(i_macrocycle_b)
					begin
						get_other_node_ip_in_ptp_state_B <= get_other_node_ip_in_ptp_S0_B;
						get_other_node_ip_in_ptp_cnt_B <= get_other_node_ip_in_ptp_cnt_B+10'h001;
					end
		endcase
		else if(!i_macrocycle_b)
			begin
				if(get_other_node_ip_in_ptp_cnt_B >= 10'h060)
					get_other_node_ip_in_ptp_done_B <= 1'b1;
				else if(get_other_node_ip_in_ptp_done_A && get_other_node_ip_in_ptp_cnt_B == 10'h000)
					get_other_node_ip_in_ptp_done_B <= 1'b1;
			end
		else if(!server_out_of_network)
			get_other_node_ip_in_ptp_done_B <= 1'b0;			
		else if(!i_link_valid)
			get_other_node_ip_in_ptp_done_B <= 1'b0;					
end
assign get_other_node_ip_in_ptp_done=get_other_node_ip_in_ptp_done_A & get_other_node_ip_in_ptp_done_B;
assign other_node_ip_in_ptp = (other_node_ip_in_ptp_A | other_node_ip_in_ptp_B | other_node_ip_in_ptp_two_A | other_node_ip_in_ptp_two_B);
wire [31:0] other_node_ip_in_ptp;
reg server_out_of_network;
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			server_out_of_network <= 1'b0;
			//other_node_ip_in_ptp <= 32'b0;
		end
	else if(!DHCP_server_en && i_main_clock_state && i_main_clock_compete_end)
		begin
			server_out_of_network <= 1'b1;
		end
	else if(get_other_node_ip_in_ptp_done)
			server_out_of_network <= 1'b0;
	else
		begin
			server_out_of_network <= 1'b0;
			//other_node_ip_in_ptp <= other_node_ip_in_ptp;
		end
end
////////////////////////server out of network/////////////////////////////////////

///////////////////////two have dhcp_server_en network link///////////////////////
reg two_network_link_trig;//two dhcp network linking signal
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		two_network_link_trig <= 1'b0;
	else if(DHCP_server_en && ((i_recv_addr_A==10'd7 && i_recv_data_A==16'h000f) ||(i_recv_addr_B==10'd7 && i_recv_data_B==16'h000f)))
		two_network_link_trig <= 1'b1;
	else if(get_other_node_ip_in_ptp_two_done)
		two_network_link_trig <= 1'b0;
	else
		two_network_link_trig <= two_network_link_trig;
end

reg two_dhcp_sver_compete_end;
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		two_dhcp_sver_compete_end <= 1'b0;
	else if(two_network_link_trig && i_main_clock_compete_end)
		two_dhcp_sver_compete_end <= 1'b1;
	else
		two_dhcp_sver_compete_end <= 1'b0;
end

reg [9:0] get_other_node_ip_in_ptp_two_cnt_A;
reg [31:0] other_node_ip_in_ptp_two_A;
reg get_other_node_ip_in_ptp_two_done_A;
assign get_other_node_ip_in_ptp_two_done=get_other_node_ip_in_ptp_two_done_A|get_other_node_ip_in_ptp_two_done_B;
reg [31:0] other_node_ip_in_ptp_two_A_temp;

reg [2:0] get_other_node_ip_in_ptp_two_state_A;
parameter [2:0] get_other_node_ip_in_ptp_two_S0_A=3'b000;
parameter [2:0] get_other_node_ip_in_ptp_two_S1_A=3'b001;
parameter [2:0] get_other_node_ip_in_ptp_two_S2_A=3'b010;
parameter [2:0] get_other_node_ip_in_ptp_two_S3_A=3'b011;
parameter [2:0] get_other_node_ip_in_ptp_two_S4_A=3'b100;
parameter [2:0] get_other_node_ip_in_ptp_two_S5_A=3'b101;
parameter [2:0] get_other_node_ip_in_ptp_two_S6_A=3'b110;
parameter [2:0] get_other_node_ip_in_ptp_two_S7_A=3'b111;
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			get_other_node_ip_in_ptp_two_state_A <= 3'b000;
			get_other_node_ip_in_ptp_two_done_A <= 1'b0;
		end
	else if(i_main_clock_ip_up!=32'b0 && DHCP_server_judge_end && DHCP_server_en && two_dhcp_sver_compete_end && i_main_clock_state && !get_other_node_ip_in_ptp_two_done_A && i_macrocycle_b)//macrocycle?
		case(get_other_node_ip_in_ptp_two_state_A)
			get_other_node_ip_in_ptp_two_S0_A:
				if(i_recv_addr_A==10'd1 && i_recv_data_A==16'hffff)
					get_other_node_ip_in_ptp_two_state_A <= get_other_node_ip_in_ptp_two_S1_A;
			get_other_node_ip_in_ptp_two_S1_A:
				if(i_recv_addr_A==10'd2 && i_recv_data_A==16'hffff)
					get_other_node_ip_in_ptp_two_state_A <= get_other_node_ip_in_ptp_two_S2_A;				
			get_other_node_ip_in_ptp_two_S2_A:
				if(i_recv_addr_A==10'd3 && i_recv_data_A==16'hffff)
					get_other_node_ip_in_ptp_two_state_A <= get_other_node_ip_in_ptp_two_S3_A;
			get_other_node_ip_in_ptp_two_S3_A:
				if(i_recv_addr_A==10'd7 && i_recv_data_A==16'h8907)
					get_other_node_ip_in_ptp_two_state_A <= get_other_node_ip_in_ptp_two_S4_A;
			get_other_node_ip_in_ptp_two_S4_A:
				if(i_recv_addr_A==10'd9)
					begin
						other_node_ip_in_ptp_two_A_temp[31:16] <= i_recv_data_A;
						get_other_node_ip_in_ptp_two_state_A <= get_other_node_ip_in_ptp_two_S5_A;
					end
			get_other_node_ip_in_ptp_two_S5_A:
				if(i_recv_addr_A==10'd10)
					begin
						other_node_ip_in_ptp_two_A_temp[15:0] <= i_recv_data_A;
						get_other_node_ip_in_ptp_two_state_A <= get_other_node_ip_in_ptp_two_S6_A;
					end
			get_other_node_ip_in_ptp_two_S6_A:
				if(i_recv_addr_A==10'd11 && i_recv_data_A[3:0]==4'h0)
					begin
						other_node_ip_in_ptp_two_A <= (other_node_ip_in_ptp_two_A_temp | other_node_ip_in_ptp_two_A | local_node_ip_DHCP);
						//other_node_ip_in_ptp_two_cnt_A <= other_node_ip_in_ptp_two_cnt_A+10'h001;
						get_other_node_ip_in_ptp_two_state_A <= get_other_node_ip_in_ptp_two_S7_A;
					end
				else
					begin
						other_node_ip_in_ptp_two_A <= 32'b0;
						get_other_node_ip_in_ptp_two_state_A <= get_other_node_ip_in_ptp_two_S0_A;
					end
			get_other_node_ip_in_ptp_two_S7_A:
					if(i_macrocycle_b)
					begin
						get_other_node_ip_in_ptp_two_state_A <= get_other_node_ip_in_ptp_two_S0_A;
						get_other_node_ip_in_ptp_two_cnt_A <= get_other_node_ip_in_ptp_two_cnt_A+10'h001;
					end
		endcase
		else if(!i_macrocycle_b)
			begin
				if(get_other_node_ip_in_ptp_two_cnt_A >= 10'h060)
					get_other_node_ip_in_ptp_two_done_A <= 1'b1;
				else if(get_other_node_ip_in_ptp_two_done_B&& get_other_node_ip_in_ptp_two_cnt_A == 10'h000)
					get_other_node_ip_in_ptp_two_done_A <= 1'b1;
			end
		else if(!two_dhcp_sver_compete_end)
			get_other_node_ip_in_ptp_two_done_A <= 1'b0;
		else if(!i_link_valid)
			get_other_node_ip_in_ptp_two_done_A <= 1'b0;
end


reg [9:0] get_other_node_ip_in_ptp_two_cnt_B;
reg [31:0] other_node_ip_in_ptp_two_B;
reg get_other_node_ip_in_ptp_two_done_B;
reg [31:0] other_node_ip_in_ptp_two_B_temp;

reg [2:0] get_other_node_ip_in_ptp_two_state_B;
parameter [2:0] get_other_node_ip_in_ptp_two_S0_B=3'b000;
parameter [2:0] get_other_node_ip_in_ptp_two_S1_B=3'b001;
parameter [2:0] get_other_node_ip_in_ptp_two_S2_B=3'b010;
parameter [2:0] get_other_node_ip_in_ptp_two_S3_B=3'b011;
parameter [2:0] get_other_node_ip_in_ptp_two_S4_B=3'b100;
parameter [2:0] get_other_node_ip_in_ptp_two_S5_B=3'b101;
parameter [2:0] get_other_node_ip_in_ptp_two_S6_B=3'b110;
parameter [2:0] get_other_node_ip_in_ptp_two_S7_B=3'b111;
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			get_other_node_ip_in_ptp_two_state_B <= 3'b000;
			get_other_node_ip_in_ptp_two_done_B <= 1'b0;
		end
	else if(i_main_clock_ip_up!=32'b0 && DHCP_server_judge_end && DHCP_server_en && two_dhcp_sver_compete_end && i_main_clock_state && !get_other_node_ip_in_ptp_two_done_B && i_macrocycle_b)
		case(get_other_node_ip_in_ptp_two_state_B)
			get_other_node_ip_in_ptp_two_S0_B:
				if(i_recv_addr_B==10'd1 && i_recv_data_B==16'hffff)
					get_other_node_ip_in_ptp_two_state_B <= get_other_node_ip_in_ptp_two_S1_B;
			get_other_node_ip_in_ptp_two_S1_B:
				if(i_recv_addr_B==10'd2 && i_recv_data_B==16'hffff)
					get_other_node_ip_in_ptp_two_state_B <= get_other_node_ip_in_ptp_two_S2_B;				
			get_other_node_ip_in_ptp_two_S2_B:
				if(i_recv_addr_B==10'd3 && i_recv_data_B==16'hffff)
					get_other_node_ip_in_ptp_two_state_B <= get_other_node_ip_in_ptp_two_S3_B;
			get_other_node_ip_in_ptp_two_S3_B:
				if(i_recv_addr_B==10'd7 && i_recv_data_B==16'h8907)
					get_other_node_ip_in_ptp_two_state_B <= get_other_node_ip_in_ptp_two_S4_B;
			get_other_node_ip_in_ptp_two_S4_B:
				if(i_recv_addr_B==10'd9)
					begin
						other_node_ip_in_ptp_two_B_temp[31:16] <= i_recv_data_B;
						get_other_node_ip_in_ptp_two_state_B <= get_other_node_ip_in_ptp_two_S5_B;
					end
			get_other_node_ip_in_ptp_two_S5_B:
				if(i_recv_addr_B==10'd10)
					begin
						other_node_ip_in_ptp_two_B_temp[15:0] <= i_recv_data_B;
						get_other_node_ip_in_ptp_two_state_B <= get_other_node_ip_in_ptp_two_S6_B;
					end
			get_other_node_ip_in_ptp_two_S6_B:
				if(i_recv_addr_B==10'd11 && i_recv_data_B[3:0]==4'h0)
					begin
						other_node_ip_in_ptp_two_B <= (other_node_ip_in_ptp_two_B_temp | other_node_ip_in_ptp_two_B | local_node_ip_DHCP);
						//other_node_ip_in_ptp_two_cnt_B <= other_node_ip_in_ptp_two_cnt_B+10'h001;
						get_other_node_ip_in_ptp_two_state_B <= get_other_node_ip_in_ptp_two_S7_B;
					end
				else
					begin
						other_node_ip_in_ptp_two_B <= 32'b0;
						get_other_node_ip_in_ptp_two_state_B <= get_other_node_ip_in_ptp_two_S0_B;
					end
			get_other_node_ip_in_ptp_two_S7_B:
					if(i_macrocycle_b)
					begin
						get_other_node_ip_in_ptp_two_state_B <= get_other_node_ip_in_ptp_two_S0_B;
						get_other_node_ip_in_ptp_two_cnt_B <= get_other_node_ip_in_ptp_two_cnt_B+10'h001;
					end
		endcase
		else if(!i_macrocycle_b)
			begin
				if(get_other_node_ip_in_ptp_two_cnt_B >= 10'h060)
					get_other_node_ip_in_ptp_two_done_B <= 1'b1;
				else if(get_other_node_ip_in_ptp_two_done_A&& get_other_node_ip_in_ptp_two_cnt_B == 10'h000)
					get_other_node_ip_in_ptp_two_done_B <= 1'b1;
			end
		else if(!two_dhcp_sver_compete_end)
			get_other_node_ip_in_ptp_two_done_B <= 1'b0;
		else if(!i_link_valid)
			get_other_node_ip_in_ptp_two_done_B <= 1'b0;
end
///////////////////////two have dhcp_server_en network link///////////////////////
reg [15:0] wr_cache_data_A;
reg [9:0] rd_cache_addr_A;
reg [9:0] wr_cache_addr_A;
reg wr_cache_en_A;
wire [15:0] rd_cache_data_A;

always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n) 
	begin
		wr_cache_en_A <= 1'b0;
		wr_cache_addr_A <= 10'b0; 	
		wr_cache_data_A <= 16'b0; 
	end
	else if(i_Rx_dv_A)
	begin
		wr_cache_en_A <= 1'b1;
		wr_cache_addr_A <= wr_cache_addr_A + 1'b1; 
		wr_cache_data_A <= i_recv_data_4_A;
	end
	else if(!i_Rx_dv_A)
	begin
		wr_cache_en_A <= 1'b0;
		wr_cache_addr_A <= 10'b0;  	
		wr_cache_data_A <= 16'b0; 
	end			
	else
	begin
		wr_cache_en_A <= wr_cache_en_A;
		wr_cache_addr_A <= wr_cache_addr_A; 	
		wr_cache_data_A <= wr_cache_data_A; 
	end
end

reg [15:0] msg_flag_d0c0_A;
//msg_flag_d0c0_B
always @ (posedge i_clk, negedge i_rst_n)
begin
	if (!i_rst_n)
		msg_flag_d0c0_A <= 16'b0;
	else if(wr_cache_addr_A == 10'd34)
		msg_flag_d0c0_A[15:12] <= wr_cache_data_A[3:0];
	else if(wr_cache_addr_A == 10'd33)
		msg_flag_d0c0_A[11:8] <= wr_cache_data_A[3:0];
	else if(wr_cache_addr_A == 10'd36)
		msg_flag_d0c0_A[7:4] <= wr_cache_data_A[3:0];
	else if(wr_cache_addr_A == 10'd35)
		msg_flag_d0c0_A[3:0] <= wr_cache_data_A[3:0];
	else if(cache_data_send_down_A)
		msg_flag_d0c0_A <= 16'b0;
	else
		msg_flag_d0c0_A <= msg_flag_d0c0_A;
end

reg [15:0] DHCP_msg_flag_A;
always @ (posedge i_clk, negedge i_rst_n)
begin
	if (!i_rst_n)
		DHCP_msg_flag_A <= 4'b0000;
	else if(wr_cache_addr_A == 10'd38)
		DHCP_msg_flag_A[15:12] <= wr_cache_data_A[3:0];
	else if(wr_cache_addr_A == 10'd37)
		DHCP_msg_flag_A[11:8] <= wr_cache_data_A[3:0];
	else if(wr_cache_addr_A == 10'd40)
		DHCP_msg_flag_A[7:4] <= wr_cache_data_A[3:0];
	else if(wr_cache_addr_A == 10'd39)
		DHCP_msg_flag_A[3:0] <= wr_cache_data_A[3:0];
	else if(cache_data_send_down_A)
		DHCP_msg_flag_A <= 16'b0;
	else
		DHCP_msg_flag_A <= DHCP_msg_flag_A;
end

reg [47:0] des_MAC_A;
always @ (posedge i_clk, negedge i_rst_n)
begin
	if (!i_rst_n)
		des_MAC_A <= 48'h0;
	else if(DHCP_msg_flag_A==16'h0100&&wr_cache_addr_A == 10'd74)
		des_MAC_A[47:44] <= wr_cache_data_A[3:0];
	else if(DHCP_msg_flag_A==16'h0100&&wr_cache_addr_A == 10'd73)
		des_MAC_A[43:40] <= wr_cache_data_A[3:0];
	else if(DHCP_msg_flag_A==16'h0100&&wr_cache_addr_A == 10'd76)
		des_MAC_A[39:36] <= wr_cache_data_A[3:0];
	else if(DHCP_msg_flag_A==16'h0100&&wr_cache_addr_A == 10'd75)	
		des_MAC_A[35:32] <= wr_cache_data_A[3:0];
	else if(DHCP_msg_flag_A==16'h0100&&wr_cache_addr_A == 10'd78)
		des_MAC_A[31:28] <= wr_cache_data_A[3:0];
	else if(DHCP_msg_flag_A==16'h0100&&wr_cache_addr_A == 10'd77)
		des_MAC_A[27:24] <= wr_cache_data_A[3:0];
	else if(DHCP_msg_flag_A==16'h0100&&wr_cache_addr_A == 10'd80)
		des_MAC_A[23:20] <= wr_cache_data_A[3:0];
	else if(DHCP_msg_flag_A==16'h0100&&wr_cache_addr_A == 10'd79)
		des_MAC_A[19:16] <= wr_cache_data_A[3:0];
	else if(DHCP_msg_flag_A==16'h0100&&wr_cache_addr_A == 10'd82)
		des_MAC_A[15:12] <= wr_cache_data_A[3:0];
	else if(DHCP_msg_flag_A==16'h0100&&wr_cache_addr_A == 10'd81)
		des_MAC_A[11:8] <= wr_cache_data_A[3:0];
	else if(DHCP_msg_flag_A==16'h0100&&wr_cache_addr_A == 10'd84)
		des_MAC_A[7:4] <= wr_cache_data_A[3:0];
	else if(DHCP_msg_flag_A==16'h0100&&wr_cache_addr_A == 10'd83)
		des_MAC_A[3:0] <= wr_cache_data_A[3:0];
	else if(cache_data_send_down_A)
		des_MAC_A <= 48'b0;
	else
		des_MAC_A <= des_MAC_A;
end

always @ (posedge i_clk, negedge i_rst_n)
begin
	if (!i_rst_n)
	;
end

reg [47:0] src_MAC_A;
reg src_MAC_A_rise;
always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		src_MAC_A <= 48'b0;
		src_MAC_A_rise <= 1'b0;
	 end
	 else if(wr_cache_addr_A == 10'h034)               
	 begin
		src_MAC_A[47:44] <= wr_cache_data_A[3:0];	     
	 end
	 else if(wr_cache_addr_A == 10'h035)               
	 begin
		src_MAC_A[43:40] <= wr_cache_data_A[3:0];	     
	 end
	 else if(wr_cache_addr_A == 10'h36)               
	 begin
		src_MAC_A[39:36] <= wr_cache_data_A[3:0];	     
	 end
	 else if(wr_cache_addr_A == 10'h37)               
	 begin
		src_MAC_A[35:32] <= wr_cache_data_A[3:0];	     
	 end
	 else if(wr_cache_addr_A == 10'h38)               
	 begin
		src_MAC_A[31:28] <= wr_cache_data_A[3:0];	     
	 end
	 else if(wr_cache_addr_A == 10'h39)               
	 begin
		src_MAC_A[27:24] <= wr_cache_data_A[3:0];	     
	 end
	 else if(wr_cache_addr_A == 10'h3a)               
	 begin
		src_MAC_A[23:20] <= wr_cache_data_A[3:0];	     
	 end	 
	 else if(wr_cache_addr_A == 10'h3b)               
	 begin
		src_MAC_A[19:16] <= wr_cache_data_A[3:0];	     
	 end		 
	 else if(wr_cache_addr_A == 10'h3c)               
	 begin
		src_MAC_A[15:12] <= wr_cache_data_A[3:0];	     
	 end	 
	 else if(wr_cache_addr_A == 10'h3d)               
	 begin
		src_MAC_A[11:8] <= wr_cache_data_A[3:0];	     
	 end	 
	 else if(wr_cache_addr_A == 10'h3e)               
	 begin
		src_MAC_A[7:4] <= wr_cache_data_A[3:0];	     
	 end		 
	 else if(wr_cache_addr_A == 10'h3f)               
	 begin
		src_MAC_A[3:0] <= wr_cache_data_A[3:0];
		src_MAC_A_rise <= 1'b1;
	 end	 
	 else if(cache_data_send_down_A)                  
	 begin
		src_MAC_A <= 48'b0;	 
	 end
	 else
	 begin
		src_MAC_A <= src_MAC_A;
		src_MAC_A_rise <= 1'b0;
	 end
end

reg [4:0] Nextstate_A;                  
reg [4:0] State_A;                      
parameter IDLE_A                  = 5'd0;
parameter WAIT_IFG_A              = 5'd1;
parameter SEND_START_A            = 5'd2;
parameter SEND_1DATA_A            = 5'd3;
parameter SEND_OVER_A             = 5'd4;

parameter IDLE_B                  = 5'd0;
parameter WAIT_IFG_B              = 5'd1;
parameter SEND_START_B            = 5'd2;
parameter SEND_1DATA_B            = 5'd3;
parameter SEND_OVER_B             = 5'd4;

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       cache_data_send_flag_A <= 1'd0;                      
    end
    else if (rd_cache_addr_A ==  10'd3)                     
    begin
        cache_data_send_flag_A <= 1'd1;                     
    end
    else if (Nextstate_A == SEND_OVER_A)                    
    begin
        cache_data_send_flag_A <= 1'd0;                     
    end
    else
    begin
        cache_data_send_flag_A <= cache_data_send_flag_A;   
    end
end


/*************************************************
  1st always block, sequential state transition 
**************************************************/
always @ (posedge i_clk , negedge i_rst_n)
begin
    if (!i_rst_n)
    begin
        State_A <= IDLE_A;              
    end
    else 
    begin
        State_A  <= Nextstate_A;        
    end
end


/****************************************************
  2nd always block, combinational condition judgment
*****************************************************/
always @ (posedge i_clk , negedge i_rst_n)
begin 	
    case (State_A)
    IDLE_A:
	 begin
		  if((wr_cache_addr_A >= 10'h30) && (src_MAC_A != i_local_mac) && (src_MAC_A != 48'd0) && (des_MAC_A!=i_local_mac) && (!DHCP_server_en||DHCP_msg_flag_A!=16'h0011)&&msg_flag_d0c0_A==16'hd0c0)//important judgement for transmit
		  begin	
				Nextstate_A = SEND_START_A;		  
		  end
		  else
		  begin
				Nextstate_A = IDLE_A;		  
		  end
	 end
	 WAIT_IFG_A:
    begin
        if(ifg_num_A >= 8'd23)
		  begin
				Nextstate_A = SEND_START_A;
		  end
        else
		  begin 
				Nextstate_A = WAIT_IFG_A;
		  end
    end	
    SEND_START_A:
	 begin
        Nextstate_A = SEND_1DATA_A;   // sjj Nov_12nd
	 end
    SEND_1DATA_A:
	 begin
			if(rd_cache_addr_A > 10'h094+ 2'd2)  //sjj Nov_15th		
			begin
				 Nextstate_A = SEND_OVER_A;
			end
			else
			begin
				 Nextstate_A = SEND_1DATA_A;			
			end
	 end
    SEND_OVER_A:
	 begin
        Nextstate_A = IDLE_A;
	 end
    default:
        Nextstate_A = IDLE_A;
    endcase
end

reg [7:0] ifg_num_A;
reg [3:0] dmi_buffer_data_A;
always @(posedge i_clk ,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		rd_cache_addr_A <= 10'b0;
		ifg_num_A <= 8'd0;
	end
	else
	case(Nextstate_A)
	IDLE_A:
		begin
			rd_cache_addr_A <= 10'b0;
			ifg_num_A <= 8'd0;	
		end
	 WAIT_IFG_A:
    begin
        ifg_num_A <= ifg_num_A + 1'b1;
    end	
   SEND_START_A:
		begin
			rd_cache_addr_A <= 10'd1;
		end	
	SEND_1DATA_A:
		begin
			dmi_buffer_data_A <= rd_cache_data_A[3:0];
			rd_cache_addr_A <= rd_cache_addr_A + 1'b1;
		end		
	SEND_OVER_A:
		begin
			rd_cache_addr_A <= 10'b0;
			ifg_num_A <= 8'd0;
		end	
	default:
	begin
		rd_cache_addr_A <= 10'b0;
   end		
	endcase
end

assign o_Tx_en_A = cache_data_send_flag_B;
assign o_send_data_A = dmi_buffer_data_B;

assign o_Tx_en_B = cache_data_send_flag_A;
assign o_send_data_B = dmi_buffer_data_A;


always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n) 
	begin
		wr_cache_en_B <= 1'b0;
		wr_cache_addr_B <= 10'b0; 	
		wr_cache_data_B <= 16'b0; 
	end
	else if(i_Rx_dv_B)
	begin
		wr_cache_en_B <= 1'b1;
		wr_cache_addr_B <= wr_cache_addr_B + 1'b1; 
		wr_cache_data_B <= i_recv_data_4_B;
	end				
	else if(!i_Rx_dv_B)
	begin
		wr_cache_en_B <= 1'b0;
		wr_cache_addr_B <= 10'b0;  	
		wr_cache_data_B <= 16'b0; 
	end			
	else
	begin
		wr_cache_en_B <= wr_cache_en_B;
		wr_cache_addr_B <= wr_cache_addr_B; 	
		wr_cache_data_B <= wr_cache_data_B; 
	end
end

reg [15:0] msg_flag_d0c0_B;
//msg_flag_d0c0_B
always @ (posedge i_clk, negedge i_rst_n)
begin
	if (!i_rst_n)
		msg_flag_d0c0_B <= 16'b0;
	else if(wr_cache_addr_B == 10'd34)
		msg_flag_d0c0_B[15:12] <= wr_cache_data_B[3:0];
	else if(wr_cache_addr_B == 10'd33)
		msg_flag_d0c0_B[11:8] <= wr_cache_data_B[3:0];
	else if(wr_cache_addr_B == 10'd36)
		msg_flag_d0c0_B[7:4] <= wr_cache_data_B[3:0];
	else if(wr_cache_addr_B == 10'd35)
		msg_flag_d0c0_B[3:0] <= wr_cache_data_B[3:0];
	else if(cache_data_send_down_B)
		msg_flag_d0c0_B <= 16'b0;
	else
		msg_flag_d0c0_B <= msg_flag_d0c0_B;
end

reg [15:0] DHCP_msg_flag_B;
always @ (posedge i_clk, negedge i_rst_n)
begin
	if (!i_rst_n)
		DHCP_msg_flag_B <= 4'b0000;
	else if(wr_cache_addr_B == 10'd38)
		DHCP_msg_flag_B[15:12] <= wr_cache_data_B[3:0];
	else if(wr_cache_addr_B == 10'd37)
		DHCP_msg_flag_B[11:8] <= wr_cache_data_B[3:0];
	else if(wr_cache_addr_B == 10'd40)
		DHCP_msg_flag_B[7:4] <= wr_cache_data_B[3:0];
	else if(wr_cache_addr_B == 10'd39)
		DHCP_msg_flag_B[3:0] <= wr_cache_data_B[3:0];
	else if(cache_data_send_down_B)
		DHCP_msg_flag_B <= 16'b0;
	else
		DHCP_msg_flag_B <= DHCP_msg_flag_B;
end

reg [47:0] des_MAC_B;
always @ (posedge i_clk, negedge i_rst_n)
begin
	if (!i_rst_n)
		des_MAC_B <= 48'h0;
	else if(DHCP_msg_flag_B==16'h0100&&wr_cache_addr_B == 10'd74)
		des_MAC_B[47:44] <= wr_cache_data_B[3:0];
	else if(DHCP_msg_flag_B==16'h0100&&wr_cache_addr_B == 10'd73)
		des_MAC_B[43:40] <= wr_cache_data_B[3:0];
	else if(DHCP_msg_flag_B==16'h0100&&wr_cache_addr_B == 10'd76)
		des_MAC_B[39:36] <= wr_cache_data_B[3:0];
	else if(DHCP_msg_flag_B==16'h0100&&wr_cache_addr_B == 10'd75)	
		des_MAC_B[35:32] <= wr_cache_data_B[3:0];
	else if(DHCP_msg_flag_B==16'h0100&&wr_cache_addr_B == 10'd78)
		des_MAC_B[31:28] <= wr_cache_data_B[3:0];
	else if(DHCP_msg_flag_B==16'h0100&&wr_cache_addr_B == 10'd77)
		des_MAC_B[27:24] <= wr_cache_data_B[3:0];
	else if(DHCP_msg_flag_B==16'h0100&&wr_cache_addr_B == 10'd80)
		des_MAC_B[23:20] <= wr_cache_data_B[3:0];
	else if(DHCP_msg_flag_B==16'h0100&&wr_cache_addr_B == 10'd79)
		des_MAC_B[19:16] <= wr_cache_data_B[3:0];
	else if(DHCP_msg_flag_B==16'h0100&&wr_cache_addr_B == 10'd82)
		des_MAC_B[15:12] <= wr_cache_data_B[3:0];
	else if(DHCP_msg_flag_B==16'h0100&&wr_cache_addr_B == 10'd81)
		des_MAC_B[11:8] <= wr_cache_data_B[3:0];
	else if(DHCP_msg_flag_B==16'h0100&&wr_cache_addr_B == 10'd84)
		des_MAC_B[7:4] <= wr_cache_data_B[3:0];
	else if(DHCP_msg_flag_B==16'h0100&&wr_cache_addr_B == 10'd83)
		des_MAC_B[3:0] <= wr_cache_data_B[3:0];
	else if(cache_data_send_down_B)
		des_MAC_B <= 48'b0;
	else
		des_MAC_B <= des_MAC_B;
end

reg [47:0] src_MAC_B;
reg src_MAC_B_rise;
always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		src_MAC_B <= 48'b0;
		src_MAC_B_rise <= 1'b0;
	 end
	 else if(wr_cache_addr_B == 10'h034)               
	 begin
		src_MAC_B[47:44] <= wr_cache_data_B[3:0];	     
	 end
	 else if(wr_cache_addr_B == 10'h035)               
	 begin
		src_MAC_B[43:40] <= wr_cache_data_B[3:0];	     
	 end
	 else if(wr_cache_addr_B == 10'h36)               
	 begin
		src_MAC_B[39:36] <= wr_cache_data_B[3:0];	     
	 end
	 else if(wr_cache_addr_B == 10'h37)               
	 begin
		src_MAC_B[35:32] <= wr_cache_data_B[3:0];	     
	 end
	 else if(wr_cache_addr_B == 10'h38)               
	 begin
		src_MAC_B[31:28] <= wr_cache_data_B[3:0];	     
	 end
	 else if(wr_cache_addr_B == 10'h39)               
	 begin
		src_MAC_B[27:24] <= wr_cache_data_B[3:0];	     
	 end
	 else if(wr_cache_addr_B == 10'h3a)               
	 begin
		src_MAC_B[23:20] <= wr_cache_data_B[3:0];	     
	 end	 
	 else if(wr_cache_addr_B == 10'h3b)               
	 begin
		src_MAC_B[19:16] <= wr_cache_data_B[3:0];	     
	 end		 
	 else if(wr_cache_addr_B == 10'h3c)               
	 begin
		src_MAC_B[15:12] <= wr_cache_data_B[3:0];	     
	 end	 
	 else if(wr_cache_addr_B == 10'h3d)               
	 begin
		src_MAC_B[11:8] <= wr_cache_data_B[3:0];	     
	 end	 
	 else if(wr_cache_addr_B == 10'h3e)               
	 begin
		src_MAC_B[7:4] <= wr_cache_data_B[3:0];	     
	 end		 
	 else if(wr_cache_addr_B == 10'h3f)               
	 begin
		src_MAC_B[3:0] <= wr_cache_data_B[3:0];
		src_MAC_B_rise <= 1'b1;
	 end	 
	 else if(cache_data_send_down_B)                  
	 begin
		src_MAC_B <= 48'b0;	 
	 end
	 else
	 begin
		src_MAC_B <= src_MAC_B;
		src_MAC_B_rise <= 1'b0;
	 end
end

reg [4:0] Nextstate_B;                  
reg [4:0] State_B;                      

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       cache_data_send_flag_B <= 1'd0;                      
    end
    else if (rd_cache_addr_B ==  10'd3)                     
    begin
        cache_data_send_flag_B <= 1'd1;                     
    end
    else if (Nextstate_B == SEND_OVER_B)                    
    begin
        cache_data_send_flag_B <= 1'd0;                     
    end
    else
    begin
        cache_data_send_flag_B <= cache_data_send_flag_B;   
    end
end


/*************************************************
  1st always block, sequential state transition 
**************************************************/
always @ (posedge i_clk , negedge i_rst_n)
begin
    if (!i_rst_n)
    begin
        State_B <= IDLE_B;              
    end
    else 
    begin
        State_B  <= Nextstate_B;        
    end
end


/****************************************************
  2nd always block, combinational condition judgment
*****************************************************/
always @ (posedge i_clk , negedge i_rst_n)
begin 	
    case (State_B)
    IDLE_B:
	 begin
		  if((wr_cache_addr_B >= 10'h30) && (src_MAC_B != i_local_mac) && (src_MAC_B != 48'd0) && (des_MAC_B!=i_local_mac) && (!DHCP_server_en||DHCP_msg_flag_B!=16'h0011)&&msg_flag_d0c0_B==16'hd0c0)//important judgement for transmit
		  begin	
				Nextstate_B = SEND_START_B;		  
		  end
		  else
		  begin
				Nextstate_B = IDLE_B;		  
		  end
	 end
	 WAIT_IFG_B:
    begin
        if(ifg_num_B >= 8'd23)
		  begin
				Nextstate_B = SEND_START_B;
		  end
        else
		  begin 
				Nextstate_B = WAIT_IFG_B;
		  end
    end	
    SEND_START_B:
	 begin
        Nextstate_B = SEND_1DATA_B;   // sjj Nov_12nd
	 end
    SEND_1DATA_B:
	 begin
			if(rd_cache_addr_B > 10'h094+ 2'd2)  //sjj Nov_15th		
			begin
				 Nextstate_B = SEND_OVER_B;
			end
			else
			begin
				 Nextstate_B = SEND_1DATA_B;			
			end
	 end
    SEND_OVER_B:
	 begin
        Nextstate_B = IDLE_B;
	 end
    default:
        Nextstate_B = IDLE_B;
    endcase
end

reg [7:0] ifg_num_B;
reg [3:0] dmi_buffer_data_B;
always @(posedge i_clk ,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		rd_cache_addr_B <= 10'b0;
		ifg_num_B <= 8'd0;
	end
	else
	case(Nextstate_B)
	IDLE_B:
		begin
			rd_cache_addr_B <= 10'b0;
			ifg_num_B <= 8'd0;	
		end
	 WAIT_IFG_B:
    begin
        ifg_num_B <= ifg_num_B + 1'b1;
    end	
   SEND_START_B:
		begin
			rd_cache_addr_B <= 10'd1;
		end	
	SEND_1DATA_B:
		begin
			dmi_buffer_data_B <= rd_cache_data_B[3:0];
			rd_cache_addr_B <= rd_cache_addr_B + 1'b1;
		end		
	SEND_OVER_B:
		begin
			rd_cache_addr_B <= 10'b0;
			ifg_num_B <= 8'd0;
		end	
	default:
	begin
		rd_cache_addr_B <= 10'b0;
   end		
	endcase
end
/////////////////////////////////////////////////////////////////////////////////////////
reg valid_1clk, valid_2clk;
reg [9:0] rd_cache_addr_1clk, rd_cache_addr_2clk;
reg cache_data_send_flag_A, cache_data_send_flag_A_1clk;     //Modified by SYF 2014.5.28
reg cache_data_send_flag_B, cache_data_send_flag_B_1clk;
reg cache_data_send_flag_C, cache_data_send_flag_C_1clk;     //Modified by SYF 2014.5.28
reg cache_data_send_flag_D, cache_data_send_flag_D_1clk;     //Modified by SYF 2014.5.28

reg cache_data_send_irq, cache_data_send_down_A;      //Modified by SYF 2014.5.28
reg cache_data_send_down_B; 
reg cache_data_send_down_C;           //Modified by SYF 2014.5.28
reg cache_data_send_down_D;           //Modified by SYF 2014.5.28

reg  SendIrq_1clk, SendIrq_2clk;

always @(posedge i_clk, negedge i_rst_n)
begin
    if(!i_rst_n)
	begin
		cache_data_send_flag_A_1clk <= 1'd0;              //Modified by SYF 2014.5.28
		cache_data_send_flag_B_1clk <= 1'd0;
		cache_data_send_flag_C_1clk <= 1'd0;              //Modified by SYF 2014.5.28
		cache_data_send_flag_D_1clk <= 1'd0;              //Modified by SYF 2014.5.28
	end
	else
	begin
		cache_data_send_flag_A_1clk <= cache_data_send_flag_A;           //Modified by SYF 2014.5.28
		cache_data_send_flag_B_1clk <= cache_data_send_flag_B;
		cache_data_send_flag_C_1clk <= cache_data_send_flag_C;           //Modified by SYF 2014.5.28
		cache_data_send_flag_D_1clk <= cache_data_send_flag_D;           //Modified by SYF 2014.5.28
	end
end


//cache_data_send_down_A
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		cache_data_send_down_A <= 1'b0;        //Modified by SYF 2014.5.28
	end
	else if (cache_data_send_flag_A_1clk && !cache_data_send_flag_A)   //Modified by SYF 2014.5.28
	begin
		cache_data_send_down_A <= 1'b1;        //Modified by SYF 2014.5.28
	end
	else 
	begin
		cache_data_send_down_A <= 1'b0;        //Modified by SYF 2014.5.28
	end
end

//cache_data_send_down_B
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		cache_data_send_down_B <= 1'b0;
	end
	else if (cache_data_send_flag_B_1clk && !cache_data_send_flag_B)
	begin
		cache_data_send_down_B <= 1'b1;
	end
	else 
	begin
		cache_data_send_down_B <= 1'b0;
	end
end


transmit_cache  transmit_cache__DHCP_A(
	.data(wr_cache_data_A),
	.rdaddress(rd_cache_addr_A),
	.rdclock(i_clk),
	.wraddress(wr_cache_addr_A),
	.wrclock(i_clk),
	.wren(wr_cache_en_A),
	.q(rd_cache_data_A)
	);
	
reg [15:0] wr_cache_data_B;
reg [9:0] rd_cache_addr_B;
reg [9:0] wr_cache_addr_B;
reg wr_cache_en_B;
wire [15:0] rd_cache_data_B;

transmit_cache  transmit_cache__DHCP_B(
	.data(wr_cache_data_B),
	.rdaddress(rd_cache_addr_B),
	.rdclock(i_clk),
	.wraddress(wr_cache_addr_B),
	.wrclock(i_clk),
	.wren(wr_cache_en_B),
	.q(rd_cache_data_B)
	);
	
//////////////////////////////////////////////////////////////
//output
always @(posedge i_clk, negedge i_rst_n)
begin
if(!i_rst_n)
	o_local_node_ip_DHCP <= 1'b0;
	else
  o_local_node_ip_DHCP <= local_node_ip_DHCP;
end

reg DHCP_end_en_dly;
reg [31:0] DHCP_end_en_dly_cnt;
always @(posedge i_clk, negedge i_rst_n)
begin
if(!i_rst_n)
	DHCP_end_en_dly_cnt <= 32'b0;
	else if(DHCP_end_en==1'b1 && DHCP_end_en_dly_cnt<i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer)//10*i_MacroCycle_time_uplayer
		DHCP_end_en_dly_cnt <= DHCP_end_en_dly_cnt+32'b1;
	else
		DHCP_end_en_dly_cnt <= DHCP_end_en_dly_cnt;
end
always @(posedge i_clk, negedge i_rst_n)
begin
if(!i_rst_n)
	DHCP_end_en_dly <= 1'b0;
	else if(DHCP_end_en_dly_cnt==i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer+i_MacroCycle_time_uplayer)//10*i_MacroCycle_time_uplayer
		DHCP_end_en_dly <= 1'b1;
	else
		DHCP_end_en_dly <= DHCP_end_en_dly;
end

always @(posedge i_clk, negedge i_rst_n)
begin
if(!i_rst_n)
	o_DHCP_end_en <= 1'b0;
	else if(DHCP_server_en)
		o_DHCP_end_en <= DHCP_end_en;
	else if(!DHCP_server_en)
		o_DHCP_end_en <= DHCP_end_en_dly;
end
/////////////////////////////////////////////////////////////////

endmodule
