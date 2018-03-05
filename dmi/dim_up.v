module dim_up(
		i_clk,
		i_rst_n,
		i_main_clock_state_up,
		i_macrocycle_b_up,
		i_local_node_mac,

		i_sendtrig_A,
		i_sendtrig_B,
		i_sendtrig_C,

		//port A
		//recv
		i_Rx_dv_A,
		i_recv_data_A,
		//send
		i_Rx_dv_host_A,
		i_recv_data_host_A,
      o_Tx_en_A,
		o_send_data_A,
		
		//port B
		//recv
		i_Rx_dv_B,
		i_recv_data_B,
		//send
		i_Rx_dv_host_B,
		i_recv_data_host_B,
		o_Tx_en_B,
		o_send_data_B,

		//port C
		//recv
		i_Rx_dv_C,
		i_recv_data_C,
		//send
		i_Rx_dv_host_C,
		i_recv_data_host_C,
      o_Tx_en_C,
		o_send_data_C,

		//time stamp -- port A
		o_get_time_en_frt0_s_A,
		o_get_time_en_sync_s_A,  // slave
		o_send_recvn_s_A,	       // 1 -- send;  0 -- recv
		o_get_time_en_frt0_m_A,  // master
		o_get_time_en_sync_m_A,
		o_send_recvn_m_A,
		
		//time stamp -- port B
		o_get_time_en_frt0_s_B,
		o_get_time_en_sync_s_B,  // slave
		o_send_recvn_s_B,	       // 1 -- send;  0 -- recv
		o_get_time_en_frt0_m_B,  // master
		o_get_time_en_sync_m_B,
		o_send_recvn_m_B,
		
		//time stamp -- port C
		o_get_time_en_frt0_s_C,
		o_get_time_en_sync_s_C,  // slave
		o_send_recvn_s_C,	       // 1 -- send;  0 -- recv
		o_get_time_en_frt0_m_C,  // master
		o_get_time_en_sync_m_C,
		o_send_recvn_m_C,
		
		//port connection state
		i_link_valid_A,
		i_link_valid_B,
		i_link_valid_C
);



		input            i_clk;
		input            i_rst_n;
		input            i_main_clock_state_up;
		input            i_macrocycle_b_up;
		input    [47:0]  i_local_node_mac;

		input            i_sendtrig_A;
		input            i_sendtrig_B;
		input            i_sendtrig_C;

		input            i_Rx_dv_A;
		input    [3:0]   i_recv_data_A;
		input            i_Rx_dv_host_A;
		input    [3:0]   i_recv_data_host_A;
		output           o_Tx_en_A;
		output   [3:0]   o_send_data_A;
		
		input            i_Rx_dv_B;
		input    [3:0]   i_recv_data_B;
		input            i_Rx_dv_host_B;
		input    [3:0]   i_recv_data_host_B;
		output           o_Tx_en_B;
		output   [3:0]   o_send_data_B;

		input            i_Rx_dv_C;
		input    [3:0]   i_recv_data_C;
		input            i_Rx_dv_host_C;
		input    [3:0]   i_recv_data_host_C;
		output           o_Tx_en_C;
		output   [3:0]   o_send_data_C;

		output           o_get_time_en_frt0_s_A;  // frt0 time stamp
		output           o_get_time_en_sync_s_A;  // sync time stamp
		output           o_send_recvn_s_A;		   //receive or send
		output           o_get_time_en_frt0_m_A;  // frt0 time stamp
		output           o_get_time_en_sync_m_A;  // sync time stamp
		output           o_send_recvn_m_A;		   //receive or send

		output           o_get_time_en_frt0_s_B;  // frt0 time stamp
		output           o_get_time_en_sync_s_B;  // sync time stamp
		output           o_send_recvn_s_B;		   //receive or send
		output           o_get_time_en_frt0_m_B;  // frt0 time stamp
		output           o_get_time_en_sync_m_B;  // sync time stamp
		output           o_send_recvn_m_B;		   //receive or send

		output           o_get_time_en_frt0_s_C;  // frt0 time stamp
		output           o_get_time_en_sync_s_C;  // sync time stamp
		output           o_send_recvn_s_C;		   //receive or send
		output           o_get_time_en_frt0_m_C;  // frt0 time stamp
		output           o_get_time_en_sync_m_C;  // sync time stamp
		output           o_send_recvn_m_C;		   //receive or send
		
		input            i_link_valid_A;
		input            i_link_valid_B;
		input            i_link_valid_C;





		

		reg              o_Tx_en_A;
		reg      [3:0]   o_send_data_A;

		reg              o_Tx_en_B;
		reg      [3:0]   o_send_data_B;

		reg              o_Tx_en_C;
		reg      [3:0]   o_send_data_C;
		
		reg              o_get_time_en_frt0_s_A;
		reg              o_get_time_en_sync_s_A;
		reg              o_send_recvn_s_A;
		reg              o_get_time_en_frt0_m_A;
		reg              o_get_time_en_sync_m_A;
		reg              o_send_recvn_m_A;

		reg              o_get_time_en_frt0_s_B;
		reg              o_get_time_en_sync_s_B;
		reg              o_send_recvn_s_B;
		reg              o_get_time_en_frt0_m_B;
		reg              o_get_time_en_sync_m_B;
		reg              o_send_recvn_m_B;
		
		reg              o_get_time_en_frt0_s_C;
		reg              o_get_time_en_sync_s_C;
		reg              o_send_recvn_s_C;
		reg              o_get_time_en_frt0_m_C;
		reg              o_get_time_en_sync_m_C;
		reg              o_send_recvn_m_C;

		



//output of transmit check
wire        rd_en_A;
wire        rd_en_B;
wire        rd_en_C;
wire        Rx_dv_A_legal;
wire        Rx_dv_B_legal;
wire        Rx_dv_C_legal;


//cache all the data received on every port, and then determine whether to transmit it
//ram
reg  [3:0]  cache_port_A[63:0];
reg  [3:0]  cache_port_B[63:0];
reg  [3:0]  cache_port_C[63:0];
//output
reg  [3:0]  o_cache_out_A;
reg  [3:0]  o_cache_out_B;
reg  [3:0]  o_cache_out_C;
//parameters to read/write ram
reg  [7:0]  wraddress_A;
reg  [7:0]  rdaddress_A;
reg  [7:0]  wraddress_B;
reg  [7:0]  rdaddress_B;
reg  [7:0]  wraddress_C;
reg  [7:0]  rdaddress_C;

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		wraddress_A <= 8'b0;
	end
	else if(i_Rx_dv_A)
	begin
		if(wraddress_A == 8'd63)
			wraddress_A <= 1'b1;
		else
			wraddress_A <= wraddress_A + 1'b1;
	end
	else
	begin
		wraddress_A <= 8'b0;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		wraddress_B <= 8'b0;
	end
	else if(i_Rx_dv_B)
	begin
		if(wraddress_B == 8'd63)
			wraddress_B <= 1'b1;
		else
			wraddress_B <= wraddress_B + 1'b1;
	end
	else
	begin
		wraddress_B <= 8'b0;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		wraddress_C <= 8'b0;
	end
	else if(i_Rx_dv_C)
	begin
		if(wraddress_C == 8'd63)
			wraddress_C <= 1'b1;
		else
			wraddress_C <= wraddress_C + 1'b1;
	end
	else
	begin
		wraddress_C <= 8'b0;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		rdaddress_A <= 8'b0;
	end
	else if(rd_en_A)
	begin
		if(rdaddress_A == 8'd63)
			rdaddress_A <= 1'b1;
		else
			rdaddress_A <= rdaddress_A + 1'b1;
	end
	else
	begin
		rdaddress_A <= 8'b0;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		rdaddress_B <= 8'b0;
	end
	else if(rd_en_B)
	begin
		if(rdaddress_B == 8'd63)
			rdaddress_B <= 1'b1;
		else
			rdaddress_B <= rdaddress_B + 1'b1;
	end
	else
	begin
		rdaddress_B <= 8'b0;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		rdaddress_C <= 8'b0;
	end
	else if(rd_en_C)
	begin
		if(rdaddress_C == 8'd63)
			rdaddress_C <= 1'b1;
		else
			rdaddress_C <= rdaddress_C + 1'b1;
	end
	else
	begin
		rdaddress_C <= 8'b0;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		o_cache_out_A <= 4'b0;
		o_cache_out_B <= 4'b0;
		o_cache_out_C <= 4'b0;
	end
	else
	begin
		cache_port_A[wraddress_A] <= i_recv_data_A;
		cache_port_B[wraddress_B] <= i_recv_data_B;
		cache_port_C[wraddress_C] <= i_recv_data_C;
		o_cache_out_A <= cache_port_A[rdaddress_A];
		o_cache_out_B <= cache_port_B[rdaddress_B];
		o_cache_out_C <= cache_port_C[rdaddress_C];
	end
end
//transmit part finish


//dest_mac, pky_type, recv_addr, frt_type outputed from PDU_analysis, in order to make timestamp trig signal
wire  [47:0]  dest_mac_A,  dest_mac_B,  dest_mac_host_A,  dest_mac_host_B;
wire  [15:0]  pkg_type_A,  pkg_type_B,  pkg_type_host_A,  pkg_type_host_B;
wire  [15:0] recv_addr_A, recv_addr_B, recv_addr_host_A, recv_addr_host_B;
wire  [7:0]   frt_type_A,  frt_type_B,  frt_type_host_A,  frt_type_host_B;
wire  [47:0]  dest_mac_C,  dest_mac_host_C;
wire  [15:0]  pkg_type_C,  pkg_type_host_C;
wire  [15:0] recv_addr_C,  recv_addr_host_C;
wire  [7:0]   frt_type_C,  frt_type_host_C;
wire  [3:0]   recv_status_A, recv_status_B, recv_status_C;
//parameter statement finish


//generate timestamp trig signal
reg           get_time_en_frt0_s_A, get_time_en_sync_s_A;
reg           get_time_en_frt0_s_B, get_time_en_sync_s_B;
reg           get_time_en_frt0_s_C, get_time_en_sync_s_C;

reg           get_time_en_frt0_m_A, get_time_en_sync_m_A;
reg           get_time_en_frt0_m_B, get_time_en_sync_m_B;
reg           get_time_en_frt0_m_C, get_time_en_sync_m_C;

//port A
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		get_time_en_sync_s_A <= 1'b0;
		get_time_en_frt0_s_A <= 1'b0;
		o_send_recvn_s_A     <= 1'b0;
	end
	else if((pkg_type_A == 16'h8907) && (frt_type_A == 8'h21) && (dest_mac_A == 48'h01005e000182))
	begin
		get_time_en_sync_s_A <= 1'b1;
		get_time_en_frt0_s_A <= 1'b0;
		o_send_recvn_s_A     <= 1'b0;
	end
	else if((pkg_type_host_A == 16'h8907) && (frt_type_host_A == 8'h20) && (dest_mac_host_A == 48'h01005e000181))
	begin
		get_time_en_sync_s_A <= 1'b1;
		get_time_en_frt0_s_A <= 1'b0;
		o_send_recvn_s_A     <= 1'b1;	
	end
	else if((pkg_type_A == 16'h8907) && (frt_type_A == 8'h10) && (dest_mac_A == 48'hffffffffffff) && (recv_status_A == 4'b1))
	begin
		get_time_en_frt0_s_A <= 1'b1;
		get_time_en_sync_s_A <= 1'b0;
		o_send_recvn_s_A     <= 1'b0;
	end
	else
	begin
		get_time_en_sync_s_A <= 1'b0;
		get_time_en_frt0_s_A <= 1'b0;
		o_send_recvn_s_A     <= 1'b0;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		get_time_en_sync_m_A <= 1'b0;
		get_time_en_frt0_m_A <= 1'b0;
		o_send_recvn_m_A     <= 1'b0;
	end	
	else if((pkg_type_A == 16'h8907) && (frt_type_A == 8'h20) && (dest_mac_A == 48'h01005e000181))
	begin
		get_time_en_sync_m_A <= 1'b1;
		get_time_en_frt0_m_A <= 1'b0;
		o_send_recvn_m_A     <= 1'b0;
	end
	//host is for send
	else if((pkg_type_host_A == 16'h8907) && (frt_type_host_A == 8'h10) && (dest_mac_host_A == 48'hffffffffffff))
	begin
		get_time_en_frt0_m_A <= 1'b1;
		get_time_en_sync_m_A <= 1'b0;
		o_send_recvn_m_A     <= 1'b1;
	end
	else if((pkg_type_host_A == 16'h8907) && (frt_type_host_A == 8'h21) && (dest_mac_host_A == 48'h01005e000182))
	begin
		get_time_en_sync_m_A <= 1'b1;
		get_time_en_frt0_m_A <= 1'b0;
		o_send_recvn_m_A     <= 1'b1;
	end	
	else
	begin
		get_time_en_sync_m_A <= 1'b0;
		get_time_en_frt0_m_A <= 1'b0;
		o_send_recvn_m_A     <= 1'b0;
	end
end

//port B
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		get_time_en_sync_s_B <= 1'b0;
		get_time_en_frt0_s_B <= 1'b0;
		o_send_recvn_s_B     <= 1'b0;
	end
	else if((pkg_type_B == 16'h8907) && (frt_type_B == 8'h21) && (dest_mac_B == 48'h01005e000182))
	begin
		get_time_en_sync_s_B <= 1'b1;
		get_time_en_frt0_s_B <= 1'b0;
		o_send_recvn_s_B     <= 1'b0;
	end
	else if((pkg_type_host_B == 16'h8907) && (frt_type_host_B == 8'h20) && (dest_mac_host_B == 48'h01005e000181))
	begin
		get_time_en_sync_s_B <= 1'b1;
		get_time_en_frt0_s_B <= 1'b0;
		o_send_recvn_s_B     <= 1'b1;	
	end	
	else if((pkg_type_B == 16'h8907) && (frt_type_B == 8'h10) && (dest_mac_B == 48'hffffffffffff) && (recv_status_B == 4'b1))
	begin
		get_time_en_frt0_s_B <= 1'b1;
		get_time_en_sync_s_B <= 1'b0;
		o_send_recvn_s_B     <= 1'b0;
	end	
	else
	begin
		get_time_en_sync_s_B <= 1'b0;
		get_time_en_frt0_s_B <= 1'b0;
		o_send_recvn_s_B     <= 1'b0;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		get_time_en_sync_m_B <= 1'b0;
		get_time_en_frt0_m_B <= 1'b0;
		o_send_recvn_m_B     <= 1'b0;
	end
	else if((pkg_type_B == 16'h8907) && (frt_type_B == 8'h20) && (dest_mac_B == 48'h01005e000181))
	begin
		get_time_en_sync_m_B <= 1'b1;
		get_time_en_frt0_m_B <= 1'b0;
		o_send_recvn_m_B     <= 1'b0;
	end	
	//host is for send
	else if((pkg_type_host_B == 16'h8907) && (frt_type_host_B == 8'h10) && (dest_mac_host_B == 48'hffffffffffff))
	begin
		get_time_en_frt0_m_B <= 1'b1;
		get_time_en_sync_m_B <= 1'b0;
		o_send_recvn_m_B     <= 1'b1;
	end	
	else if((pkg_type_host_B == 16'h8907) && (frt_type_host_B == 8'h21) && (dest_mac_host_B == 48'h01005e000182))
	begin
		get_time_en_sync_m_B <= 1'b1;
		get_time_en_frt0_m_B <= 1'b0;
		o_send_recvn_m_B     <= 1'b1;
	end		
	else
	begin
		get_time_en_sync_m_B <= 1'b0;
		get_time_en_frt0_m_B <= 1'b0;
		o_send_recvn_m_B     <= 1'b0;
	end
end

//port C
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		get_time_en_sync_s_C <= 1'b0;
		get_time_en_frt0_s_C <= 1'b0;
		o_send_recvn_s_C     <= 1'b0;
	end
	else if((pkg_type_C == 16'h8907) && (frt_type_C == 8'h21) && (dest_mac_C == 48'h01005e000182))
	begin
		get_time_en_sync_s_C <= 1'b1;
		get_time_en_frt0_s_C <= 1'b0;
		o_send_recvn_s_C     <= 1'b0;
	end
	else if((pkg_type_host_C == 16'h8907) && (frt_type_host_C == 8'h20) && (dest_mac_host_C == 48'h01005e000181))
	begin
		get_time_en_sync_s_C <= 1'b1;
		get_time_en_frt0_s_C <= 1'b0;
		o_send_recvn_s_C     <= 1'b1;	
	end	
	else if((pkg_type_C == 16'h8907) && (frt_type_C == 8'h10) && (dest_mac_C == 48'hffffffffffff) && (recv_status_C == 4'b1))
	begin
		get_time_en_frt0_s_C <= 1'b1;
		get_time_en_sync_s_C <= 1'b0;
		o_send_recvn_s_C     <= 1'b0;
	end	
	else
	begin
		get_time_en_sync_s_C <= 1'b0;
		get_time_en_frt0_s_C <= 1'b0;
		o_send_recvn_s_C     <= 1'b0;
	end
end

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		get_time_en_sync_m_C <= 1'b0;
		get_time_en_frt0_m_C <= 1'b0;
		o_send_recvn_m_C     <= 1'b0;
	end
	else if((pkg_type_C == 16'h8907) && (frt_type_C == 8'h20) && (dest_mac_C == 48'h01005e000181))
	begin
		get_time_en_sync_m_C <= 1'b1;
		get_time_en_frt0_m_C <= 1'b0;
		o_send_recvn_m_C     <= 1'b0;
	end	
	//host is for send
	else if((pkg_type_host_C == 16'h8907) && (frt_type_host_C == 8'h10) && (dest_mac_host_C == 48'hffffffffffff))
	begin
		get_time_en_frt0_m_C <= 1'b1;
		get_time_en_sync_m_C <= 1'b0;
		o_send_recvn_m_C     <= 1'b1;
	end	
	else if((pkg_type_host_C == 16'h8907) && (frt_type_host_C == 8'h21) && (dest_mac_host_C == 48'h01005e000182))
	begin
		get_time_en_sync_m_C <= 1'b1;
		get_time_en_frt0_m_C <= 1'b0;
		o_send_recvn_m_C     <= 1'b1;
	end		
	else
	begin
		get_time_en_sync_m_C <= 1'b0;
		get_time_en_frt0_m_C <= 1'b0;
		o_send_recvn_m_C     <= 1'b0;
	end
end
//generate timestamp trig signal accomplished


//acquire posedge edge, generate trig signal
reg           get_time_en_sync_1clk_s_A, get_time_en_frt0_1clk_s_A;
reg           get_time_en_sync_1clk_s_B, get_time_en_frt0_1clk_s_B;
reg           get_time_en_sync_1clk_s_C, get_time_en_frt0_1clk_s_C;

reg           get_time_en_sync_1clk_m_A, get_time_en_frt0_1clk_m_A;
reg           get_time_en_sync_1clk_m_B, get_time_en_frt0_1clk_m_B;
reg           get_time_en_sync_1clk_m_C, get_time_en_frt0_1clk_m_C;

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		get_time_en_sync_1clk_s_A <= 1'b0;
		get_time_en_frt0_1clk_s_A <= 1'b0;
		get_time_en_sync_1clk_m_A <= 1'b0;
		get_time_en_frt0_1clk_m_A <= 1'b0;
		get_time_en_sync_1clk_s_B <= 1'b0;
		get_time_en_frt0_1clk_s_B <= 1'b0;
		get_time_en_sync_1clk_m_B <= 1'b0;
		get_time_en_frt0_1clk_m_B <= 1'b0;
		get_time_en_sync_1clk_s_C <= 1'b0;
		get_time_en_frt0_1clk_s_C <= 1'b0;
		get_time_en_sync_1clk_m_C <= 1'b0;
		get_time_en_frt0_1clk_m_C <= 1'b0;
	end
	else
	begin
		get_time_en_sync_1clk_s_A <= get_time_en_sync_s_A;
		get_time_en_frt0_1clk_s_A <= get_time_en_frt0_s_A;
		get_time_en_sync_1clk_m_A <= get_time_en_sync_m_A;
		get_time_en_frt0_1clk_m_A <= get_time_en_frt0_m_A;
		get_time_en_sync_1clk_s_B <= get_time_en_sync_s_B;
		get_time_en_frt0_1clk_s_B <= get_time_en_frt0_s_B;
		get_time_en_sync_1clk_m_B <= get_time_en_sync_m_B;
		get_time_en_frt0_1clk_m_B <= get_time_en_frt0_m_B;
		get_time_en_sync_1clk_s_C <= get_time_en_sync_s_C;
		get_time_en_frt0_1clk_s_C <= get_time_en_frt0_s_C;
		get_time_en_sync_1clk_m_C <= get_time_en_sync_m_C;
		get_time_en_frt0_1clk_m_C <= get_time_en_frt0_m_C;
	end
end
//port A
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		o_get_time_en_sync_s_A <= 1'b0;
	else if((!get_time_en_sync_1clk_s_A) && get_time_en_sync_s_A)
		o_get_time_en_sync_s_A <= 1'b1;
	else
		o_get_time_en_sync_s_A <= 1'b0;
end
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		o_get_time_en_frt0_s_A <= 1'b0;
	else if((!get_time_en_frt0_1clk_s_A) && get_time_en_frt0_s_A)
		o_get_time_en_frt0_s_A <= 1'b1;
	else
		o_get_time_en_frt0_s_A <= 1'b0;
end
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		o_get_time_en_sync_m_A <= 1'b0;
	else if((!get_time_en_sync_1clk_m_A) && get_time_en_sync_m_A)
		o_get_time_en_sync_m_A <= 1'b1;
	else
		o_get_time_en_sync_m_A <= 1'b0;
end
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		o_get_time_en_frt0_m_A <= 1'b0;
	else if((!get_time_en_frt0_1clk_m_A) && get_time_en_frt0_m_A)
		o_get_time_en_frt0_m_A <= 1'b1;
	else
		o_get_time_en_frt0_m_A <= 1'b0;
end
//port B
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		o_get_time_en_sync_s_B <= 1'b0;
	else if((!get_time_en_sync_1clk_s_B) && get_time_en_sync_s_B)
		o_get_time_en_sync_s_B <= 1'b1;
	else
		o_get_time_en_sync_s_B <= 1'b0;
end
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		o_get_time_en_frt0_s_B <= 1'b0;
	else if((!get_time_en_frt0_1clk_s_B) && get_time_en_frt0_s_B)
		o_get_time_en_frt0_s_B <= 1'b1;
	else
		o_get_time_en_frt0_s_B <= 1'b0;
end
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		o_get_time_en_sync_m_B <= 1'b0;
	else if((!get_time_en_sync_1clk_m_B) && get_time_en_sync_m_B)
		o_get_time_en_sync_m_B <= 1'b1;
	else
		o_get_time_en_sync_m_B <= 1'b0;
end
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		o_get_time_en_frt0_m_B <= 1'b0;
	else if((!get_time_en_frt0_1clk_m_B) && get_time_en_frt0_m_B)
		o_get_time_en_frt0_m_B <= 1'b1;
	else
		o_get_time_en_frt0_m_B <= 1'b0;
end
//port C
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		o_get_time_en_sync_s_C <= 1'b0;
	else if((!get_time_en_sync_1clk_s_C) && get_time_en_sync_s_C)
		o_get_time_en_sync_s_C <= 1'b1;
	else
		o_get_time_en_sync_s_C <= 1'b0;
end
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		o_get_time_en_frt0_s_C <= 1'b0;
	else if((!get_time_en_frt0_1clk_s_C) && get_time_en_frt0_s_C)
		o_get_time_en_frt0_s_C <= 1'b1;
	else
		o_get_time_en_frt0_s_C <= 1'b0;
end
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		o_get_time_en_sync_m_C <= 1'b0;
	else if((!get_time_en_sync_1clk_m_C) && get_time_en_sync_m_C)
		o_get_time_en_sync_m_C <= 1'b1;
	else
		o_get_time_en_sync_m_C <= 1'b0;
end
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		o_get_time_en_frt0_m_C <= 1'b0;
	else if((!get_time_en_frt0_1clk_m_C) && get_time_en_frt0_m_C)
		o_get_time_en_frt0_m_C <= 1'b1;
	else
		o_get_time_en_frt0_m_C <= 1'b0;
end






reg i_sendtrig_A_dly;
reg i_sendtrig_B_dly;
reg i_sendtrig_C_dly;
reg i_Rx_dv_host_A_dly;
reg i_Rx_dv_host_B_dly;
reg i_Rx_dv_host_C_dly;
reg Rx_dv_A_legal_dly;
reg Rx_dv_B_legal_dly;
reg Rx_dv_C_legal_dly;
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		i_sendtrig_A_dly   <= 1'b0;
		i_sendtrig_B_dly   <= 1'b0;
		i_sendtrig_C_dly   <= 1'b0;
		i_Rx_dv_host_A_dly <= 1'b0;
		i_Rx_dv_host_B_dly <= 1'b0;
		i_Rx_dv_host_C_dly <= 1'b0;
		Rx_dv_A_legal_dly  <= 1'b0;
		Rx_dv_B_legal_dly  <= 1'b0;
		Rx_dv_C_legal_dly  <= 1'b0;
	end
	else
	begin
		i_sendtrig_A_dly   <= i_sendtrig_A;
		i_sendtrig_B_dly   <= i_sendtrig_B;
		i_sendtrig_C_dly   <= i_sendtrig_C;
		i_Rx_dv_host_A_dly <= i_Rx_dv_host_A;
		i_Rx_dv_host_B_dly <= i_Rx_dv_host_B;
		i_Rx_dv_host_C_dly <= i_Rx_dv_host_C;
		Rx_dv_A_legal_dly  <= Rx_dv_A_legal;
		Rx_dv_B_legal_dly  <= Rx_dv_B_legal;
		Rx_dv_C_legal_dly  <= Rx_dv_C_legal;
	end
end

parameter PORT_A_IDLE       = 3'b000;
parameter PORT_A_SEND_SELF  = 3'b001;
parameter PORT_A_TRANSMIT_B = 3'b011;
parameter PORT_A_TRANSMIT_C = 3'b010;
reg       [2:0]  fsm_cs_A;
reg       [2:0]  fsm_ns_A;
//1st fsm	
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n) 
		fsm_cs_A <= PORT_A_IDLE;
	else
		fsm_cs_A <= fsm_ns_A;
end
// 2rd fsm
always @(*)
begin
	if(!i_rst_n)
		fsm_ns_A = PORT_A_IDLE;
	else
	begin
		case(fsm_cs_A)
		PORT_A_IDLE:
			if(i_sendtrig_A && !i_sendtrig_A_dly)
				fsm_ns_A = PORT_A_SEND_SELF;
			else if(Rx_dv_B_legal && !Rx_dv_B_legal_dly && !i_Rx_dv_A)
				fsm_ns_A = PORT_A_TRANSMIT_B;
			else if(Rx_dv_C_legal && !Rx_dv_C_legal_dly && !i_Rx_dv_A && !i_Rx_dv_B)
				fsm_ns_A = PORT_A_TRANSMIT_C;
			else
				fsm_ns_A = PORT_A_IDLE;
		PORT_A_SEND_SELF:
			if(i_Rx_dv_host_A_dly && !i_Rx_dv_host_A)
				fsm_ns_A = PORT_A_IDLE;
			else
				fsm_ns_A = PORT_A_SEND_SELF;
		PORT_A_TRANSMIT_B:
			if(Rx_dv_B_legal_dly && !Rx_dv_B_legal)
				fsm_ns_A = PORT_A_IDLE;
			else if(i_sendtrig_A && !i_sendtrig_A_dly)
				fsm_ns_A = PORT_A_SEND_SELF;
			else
				fsm_ns_A = PORT_A_TRANSMIT_B;
		PORT_A_TRANSMIT_C:
			if(Rx_dv_C_legal_dly && !Rx_dv_C_legal)
				fsm_ns_A = PORT_A_IDLE;
			else if(i_sendtrig_A && !i_sendtrig_A_dly)
				fsm_ns_A = PORT_A_SEND_SELF;
			else
				fsm_ns_A = PORT_A_TRANSMIT_C;
		default:
			fsm_ns_A = PORT_A_IDLE;
		endcase
	end
end
// 3rd fsm
always @ (posedge i_clk, negedge i_rst_n)
begin
    if(!i_rst_n)
    begin
        o_Tx_en_A     <= 1'b0;
        o_send_data_A <= 4'b0;
    end
    else
    case (fsm_ns_A)
    PORT_A_IDLE:
    begin
        o_Tx_en_A     <= 1'b0;
        o_send_data_A <= 4'b0;
    end
    PORT_A_SEND_SELF:
    begin
        o_Tx_en_A     <= i_Rx_dv_host_A;
        o_send_data_A <= i_recv_data_host_A;
    end
    PORT_A_TRANSMIT_B:
    begin
        o_Tx_en_A     <= Rx_dv_B_legal;
        o_send_data_A <= o_cache_out_B;
    end
    PORT_A_TRANSMIT_C:
    begin
        o_Tx_en_A     <= Rx_dv_C_legal;
        o_send_data_A <= o_cache_out_C;
    end
    default:
    begin
        o_Tx_en_A     <= 1'b0;
        o_send_data_A <= 4'b0;
    end
    endcase
end

parameter PORT_B_IDLE       = 3'b000;
parameter PORT_B_SEND_SELF  = 3'b001;
parameter PORT_B_TRANSMIT_A = 3'b011;
parameter PORT_B_TRANSMIT_C = 3'b010;
reg       [2:0]  fsm_cs_B;
reg       [2:0]  fsm_ns_B;
//1st fsm	
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n) 
		fsm_cs_B <= PORT_B_IDLE;
	else
		fsm_cs_B <= fsm_ns_B;
end
// 2rd fsm
always @(*)
begin
	if(!i_rst_n)
		fsm_ns_B = PORT_B_IDLE;
	else
	begin
		case(fsm_cs_B)
		PORT_B_IDLE:
			if(i_sendtrig_B && !i_sendtrig_B_dly)
				fsm_ns_B = PORT_B_SEND_SELF;
			else if(Rx_dv_A_legal && !Rx_dv_A_legal_dly)
				fsm_ns_B = PORT_B_TRANSMIT_A;
			else if(Rx_dv_C_legal && !Rx_dv_C_legal_dly && !i_Rx_dv_A && !i_Rx_dv_B)
				fsm_ns_B = PORT_B_TRANSMIT_C;
			else
				fsm_ns_B = PORT_B_IDLE;
		PORT_B_SEND_SELF:
			if(i_Rx_dv_host_B_dly && !i_Rx_dv_host_B)
				fsm_ns_B = PORT_B_IDLE;
			else
				fsm_ns_B = PORT_B_SEND_SELF;
		PORT_B_TRANSMIT_A:
			if(Rx_dv_A_legal_dly && !Rx_dv_A_legal)
				fsm_ns_B = PORT_B_IDLE;
			else if(i_sendtrig_B && !i_sendtrig_B_dly)
				fsm_ns_B = PORT_B_SEND_SELF;
			else
				fsm_ns_B = PORT_B_TRANSMIT_A;
		PORT_B_TRANSMIT_C:
			if(Rx_dv_C_legal_dly && !Rx_dv_C_legal)
				fsm_ns_B = PORT_B_IDLE;
			else if(i_sendtrig_B && !i_sendtrig_B_dly)
				fsm_ns_B = PORT_B_SEND_SELF;
			else
				fsm_ns_B = PORT_B_TRANSMIT_C;
		default:
			fsm_ns_B = PORT_B_IDLE;
		endcase
	end
end
// 3rd fsm
always @ (posedge i_clk, negedge i_rst_n)
begin
    if(!i_rst_n)
    begin
        o_Tx_en_B     <= 1'b0;
        o_send_data_B <= 4'b0;
    end
    else
    case (fsm_ns_B)
    PORT_B_IDLE:
    begin
        o_Tx_en_B     <= 1'b0;
        o_send_data_B <= 4'b0;
    end
    PORT_B_SEND_SELF:
    begin
        o_Tx_en_B     <= i_Rx_dv_host_B;
        o_send_data_B <= i_recv_data_host_B;
    end
    PORT_B_TRANSMIT_A:
    begin
        o_Tx_en_B     <= Rx_dv_A_legal;
        o_send_data_B <= o_cache_out_A;
    end
    PORT_B_TRANSMIT_C:
    begin
        o_Tx_en_B     <= Rx_dv_C_legal;
        o_send_data_B <= o_cache_out_C;
    end
    default:
    begin
        o_Tx_en_B     <= 1'b0;
        o_send_data_B <= 4'b0;
    end
    endcase
end

parameter PORT_C_IDLE       = 3'b000;
parameter PORT_C_SEND_SELF  = 3'b001;
parameter PORT_C_TRANSMIT_A = 3'b011;
parameter PORT_C_TRANSMIT_B = 3'b010;
reg       [2:0]  fsm_cs_C;
reg       [2:0]  fsm_ns_C;
//1st fsm	
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n) 
		fsm_cs_C <= PORT_C_IDLE;
	else
		fsm_cs_C <= fsm_ns_C;
end
// 2rd fsm
always @(*)
begin
	if(!i_rst_n)
		fsm_ns_C = PORT_C_IDLE;
	else
	begin
		case(fsm_cs_C)
		PORT_C_IDLE:
			if(i_sendtrig_C && !i_sendtrig_C_dly)
				fsm_ns_C = PORT_C_SEND_SELF;
			else if(Rx_dv_A_legal && !Rx_dv_A_legal_dly)
				fsm_ns_C = PORT_C_TRANSMIT_A;
			else if(Rx_dv_B_legal && !Rx_dv_B_legal_dly && !i_Rx_dv_A)
				fsm_ns_C = PORT_C_TRANSMIT_B;
			else
				fsm_ns_C = PORT_C_IDLE;
		PORT_C_SEND_SELF:
			if(i_Rx_dv_host_C_dly && !i_Rx_dv_host_C)
				fsm_ns_C = PORT_C_IDLE;
			else
				fsm_ns_C = PORT_C_SEND_SELF;
		PORT_C_TRANSMIT_A:
			if(Rx_dv_A_legal_dly && !Rx_dv_A_legal)
				fsm_ns_C = PORT_C_IDLE;
			else if(i_sendtrig_C && !i_sendtrig_C_dly)
				fsm_ns_C = PORT_C_SEND_SELF;
			else
				fsm_ns_C = PORT_C_TRANSMIT_A;
		PORT_C_TRANSMIT_B:
			if(Rx_dv_B_legal_dly && !Rx_dv_B_legal)
				fsm_ns_C = PORT_C_IDLE;
			else if(i_sendtrig_C && !i_sendtrig_C_dly)
				fsm_ns_C = PORT_C_SEND_SELF;
			else
				fsm_ns_C = PORT_C_TRANSMIT_B;
		default:
			fsm_ns_C = PORT_C_IDLE;
		endcase
	end
end
// 3rd fsm
always @ (posedge i_clk, negedge i_rst_n)
begin
    if(!i_rst_n)
    begin
        o_Tx_en_C     <= 1'b0;
        o_send_data_C <= 4'b0;
    end
    else
    case (fsm_ns_C)
    PORT_C_IDLE:
    begin
        o_Tx_en_C     <= 1'b0;
        o_send_data_C <= 4'b0;
    end
    PORT_C_SEND_SELF:
    begin
        o_Tx_en_C     <= i_Rx_dv_host_C;
        o_send_data_C <= i_recv_data_host_C;
    end
    PORT_C_TRANSMIT_A:
    begin
        o_Tx_en_C     <= Rx_dv_A_legal;
        o_send_data_C <= o_cache_out_A;
    end
    PORT_C_TRANSMIT_B:
    begin
        o_Tx_en_C     <= Rx_dv_B_legal;
        o_send_data_C <= o_cache_out_B;
    end
    default:
    begin
        o_Tx_en_C     <= 1'b0;
        o_send_data_C <= 4'b0;
    end
    endcase
end



reg        macrocycle_b_dly;
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		macrocycle_b_dly <= 1'b0;
	else
		macrocycle_b_dly <= i_macrocycle_b_up;
end

wire       macro_start_trig;
assign     macro_start_trig = i_macrocycle_b_up && !macrocycle_b_dly;

reg  [63:0] current_macrocycle_frt_sent;
reg  [63:0] current_macrocycle_mcc_sent;
reg  [63:0] current_macrocycle_syncreq_sent;
reg  [63:0] current_macrocycle_syncrsp_sent;
//reg  [63:0] current_macrocycle_syncreq_sent_A;
//reg  [63:0] current_macrocycle_syncreq_sent_B;
//reg  [63:0] current_macrocycle_syncreq_sent_C;
//reg  [63:0] current_macrocycle_syncrsp_sent_A;
//reg  [63:0] current_macrocycle_syncrsp_sent_B;
//reg  [63:0] current_macrocycle_syncrsp_sent_C;
wire [5:0]  src_mac_A, src_mac_B, src_mac_C;
wire [1:0]  id_A,      id_B,      id_C;

always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		current_macrocycle_frt_sent <= 64'b0;
	else if(macro_start_trig)
		current_macrocycle_frt_sent <= 64'b0;
//	else if((recv_addr_A == 16'd30) && (pkg_type_A == 16'h8907) && (frt_type_A == 8'h10))
	else if((recv_addr_A == 16'd33) && (pkg_type_A == 16'h8907) && (frt_type_A == 8'h10))
		current_macrocycle_frt_sent[src_mac_A] <= 1'b1;
	else if((recv_addr_B == 16'd33) && (pkg_type_B == 16'h8907) && (frt_type_B == 8'h10) && !i_Rx_dv_A)
		current_macrocycle_frt_sent[src_mac_B] <= 1'b1;
	else if((recv_addr_C == 16'd33) && (pkg_type_C == 16'h8907) && (frt_type_C == 8'h10) && !i_Rx_dv_A && !i_Rx_dv_B)
		current_macrocycle_frt_sent[src_mac_C] <= 1'b1;
	else
		current_macrocycle_frt_sent <= current_macrocycle_frt_sent;
end
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		current_macrocycle_mcc_sent <= 64'b0;
	else if(macro_start_trig)
		current_macrocycle_mcc_sent <= 64'b0;
	else if((recv_addr_A == 16'd33) && (pkg_type_A == 16'h8907) && (frt_type_A[7:4] == 4'h9))
		current_macrocycle_mcc_sent[src_mac_A] <= 1'b1;
	else if((recv_addr_B == 16'd33) && (pkg_type_B == 16'h8907) && (frt_type_B[7:4] == 4'h9) && !i_Rx_dv_A)
		current_macrocycle_mcc_sent[src_mac_B] <= 1'b1;
	else if((recv_addr_C == 16'd33) && (pkg_type_C == 16'h8907) && (frt_type_C[7:4] == 4'h9) && !i_Rx_dv_A && !i_Rx_dv_B)
		current_macrocycle_mcc_sent[src_mac_C] <= 1'b1;
	else
		current_macrocycle_mcc_sent <= current_macrocycle_mcc_sent;
end
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		current_macrocycle_syncreq_sent <= 64'b0;
	else if(macro_start_trig)
		current_macrocycle_syncreq_sent <= 64'b0;
	else if((recv_addr_A == 16'd33) && (pkg_type_A == 16'h8907) && (frt_type_A == 8'h20))
		current_macrocycle_syncreq_sent[src_mac_A] <= 1'b1;
	else if((recv_addr_B == 16'd33) && (pkg_type_B == 16'h8907) && (frt_type_B == 8'h20) && !i_Rx_dv_A)
		current_macrocycle_syncreq_sent[src_mac_B] <= 1'b1;
	else if((recv_addr_C == 16'd33) && (pkg_type_C == 16'h8907) && (frt_type_C == 8'h20) && !i_Rx_dv_A && !i_Rx_dv_B)
		current_macrocycle_syncreq_sent[src_mac_C] <= 1'b1;
	else
		current_macrocycle_syncreq_sent <= current_macrocycle_syncreq_sent;
end
always @(posedge i_clk or negedge i_rst_n)
begin
	if(!i_rst_n)
		current_macrocycle_syncrsp_sent <= 64'b0;
	else if(macro_start_trig)
		current_macrocycle_syncrsp_sent <= 64'b0;
	else if((recv_addr_A == 16'd33) && (pkg_type_A == 16'h8907) && (frt_type_A == 8'h21))
		current_macrocycle_syncrsp_sent[src_mac_A] <= 1'b1;
	else if((recv_addr_B == 16'd33) && (pkg_type_B == 16'h8907) && (frt_type_B == 8'h21) && !i_Rx_dv_A)
		current_macrocycle_syncrsp_sent[src_mac_B] <= 1'b1;
	else if((recv_addr_C == 16'd33) && (pkg_type_C == 16'h8907) && (frt_type_C == 8'h21) && !i_Rx_dv_A && !i_Rx_dv_B)
		current_macrocycle_syncrsp_sent[src_mac_C] <= 1'b1;
	else
		current_macrocycle_syncrsp_sent <= current_macrocycle_syncrsp_sent;
end
//always @(posedge i_clk or negedge i_rst_n)
//begin
//	if(!i_rst_n)
//	begin
//		current_macrocycle_syncreq_sent_A <= 64'b0;
//		current_macrocycle_syncreq_sent_B <= 64'b0;
//		current_macrocycle_syncreq_sent_C <= 64'b0;
//	end
//	else if(macro_start_trig)
//	begin
//		current_macrocycle_syncreq_sent_A <= 64'b0;
//		current_macrocycle_syncreq_sent_B <= 64'b0;
//		current_macrocycle_syncreq_sent_C <= 64'b0;
//	end
//	else if((recv_addr_A == 16'd33) && (pkg_type_A == 16'h8907) && (frt_type_A == 8'h20))
//	begin
//		if(id_A == 2'b00)
//			current_macrocycle_syncreq_sent_A[src_mac_A] <= 1'b1;
//		else if(id_A == 2'b01)
//			current_macrocycle_syncreq_sent_B[src_mac_A] <= 1'b1;
//		else if(id_A == 2'b10)
//			current_macrocycle_syncreq_sent_C[src_mac_A] <= 1'b1;
//	end
//	else if((recv_addr_B == 16'd33) && (pkg_type_B == 16'h8907) && (frt_type_B == 8'h20) && !i_Rx_dv_A)
//	begin
//		if(id_B == 2'b00)
//			current_macrocycle_syncreq_sent_A[src_mac_B] <= 1'b1;
//		else if(id_B == 2'b01)
//			current_macrocycle_syncreq_sent_B[src_mac_B] <= 1'b1;
//		else if(id_B == 2'b10)
//			current_macrocycle_syncreq_sent_C[src_mac_B] <= 1'b1;
//	end
//	else if((recv_addr_C == 16'd33) && (pkg_type_C == 16'h8907) && (frt_type_C == 8'h20) && !i_Rx_dv_A && !i_Rx_dv_B)
//	begin
//		if(id_C == 2'b00)
//			current_macrocycle_syncreq_sent_A[src_mac_C] <= 1'b1;
//		else if(id_C == 2'b01)
//			current_macrocycle_syncreq_sent_B[src_mac_C] <= 1'b1;
//		else if(id_C == 2'b10)
//			current_macrocycle_syncreq_sent_C[src_mac_C] <= 1'b1;
//	end
//	else
//	begin
//		current_macrocycle_syncreq_sent_A <= current_macrocycle_syncreq_sent_A;
//		current_macrocycle_syncreq_sent_B <= current_macrocycle_syncreq_sent_B;
//		current_macrocycle_syncreq_sent_C <= current_macrocycle_syncreq_sent_C;
//	end
//end
//always @(posedge i_clk or negedge i_rst_n)
//begin
//	if(!i_rst_n)
//	begin
//		current_macrocycle_syncrsp_sent_A <= 64'b0;
//		current_macrocycle_syncrsp_sent_B <= 64'b0;
//		current_macrocycle_syncrsp_sent_C <= 64'b0;
//	end
//	else if(macro_start_trig)
//	begin
//		current_macrocycle_syncrsp_sent_A <= 64'b0;
//		current_macrocycle_syncrsp_sent_B <= 64'b0;
//		current_macrocycle_syncrsp_sent_C <= 64'b0;
//	end
//	else if((recv_addr_A == 16'd33) && (pkg_type_A == 16'h8907) && (frt_type_A == 8'h21))
//	begin
//		if(id_A == 2'b00)
//			current_macrocycle_syncrsp_sent_A[src_mac_A] <= 1'b1;
//		else if(id_A == 2'b01)
//			current_macrocycle_syncrsp_sent_B[src_mac_A] <= 1'b1;
//		else if(id_A == 2'b10)
//			current_macrocycle_syncrsp_sent_C[src_mac_A] <= 1'b1;
//	end
//	else if((recv_addr_B == 16'd33) && (pkg_type_B == 16'h8907) && (frt_type_B == 8'h21) && !i_Rx_dv_A)
//	begin
//		if(id_B == 2'b00)
//			current_macrocycle_syncrsp_sent_A[src_mac_B] <= 1'b1;
//		else if(id_B == 2'b01)
//			current_macrocycle_syncrsp_sent_B[src_mac_B] <= 1'b1;
//		else if(id_B == 2'b10)
//			current_macrocycle_syncrsp_sent_C[src_mac_B] <= 1'b1;
//	end
//	else if((recv_addr_C == 16'd33) && (pkg_type_C == 16'h8907) && (frt_type_C == 8'h21) && !i_Rx_dv_A && !i_Rx_dv_B)
//	begin
//		if(id_C == 2'b00)
//			current_macrocycle_syncrsp_sent_A[src_mac_C] <= 1'b1;
//		else if(id_C == 2'b01)
//			current_macrocycle_syncrsp_sent_B[src_mac_C] <= 1'b1;
//		else if(id_C == 2'b10)
//			current_macrocycle_syncrsp_sent_C[src_mac_C] <= 1'b1;
//	end
//	else
//	begin
//		current_macrocycle_syncrsp_sent_A <= current_macrocycle_syncrsp_sent_A;
//		current_macrocycle_syncrsp_sent_B <= current_macrocycle_syncrsp_sent_B;
//		current_macrocycle_syncrsp_sent_C <= current_macrocycle_syncrsp_sent_C;
//	end
//end


/*********************analysis the receive data from A port********************/
PDU_analysis_up   PDU_analysis_A2host(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_Rx_dv(i_Rx_dv_A),
		.i_recv_data(i_recv_data_A),

		.i_macro_start_trig(macro_start_trig),
		.i_frt_sent(current_macrocycle_frt_sent),
		.i_mcc_sent(current_macrocycle_mcc_sent),
		.i_syncreq_sent(current_macrocycle_syncreq_sent),
		.i_syncrsp_sent(current_macrocycle_syncrsp_sent),
//		.i_syncreq_sent_A(current_macrocycle_syncreq_sent_A),
//		.i_syncreq_sent_B(current_macrocycle_syncreq_sent_B),
//		.i_syncreq_sent_C(current_macrocycle_syncreq_sent_C),
//		.i_syncrsp_sent_A(current_macrocycle_syncrsp_sent_A),
//		.i_syncrsp_sent_B(current_macrocycle_syncrsp_sent_B),
//		.i_syncrsp_sent_C(current_macrocycle_syncrsp_sent_C),

		.o_src_mac_low(src_mac_A),
		.o_dest_mac(dest_mac_A),
		.o_pkg_type(pkg_type_A),
		.o_frt_type(frt_type_A),
		.o_id(id_A),
		.recv_addr(recv_addr_A),
		.o_recv_status(recv_status_A),

		.i_local_node_mac(i_local_node_mac),
		.o_recv_data_legal(Rx_dv_A_legal),
		.o_rd_en(rd_en_A)
);

/*********************analysis the receive data from B port********************/
PDU_analysis_up   PDU_analysis_B2host(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_Rx_dv(i_Rx_dv_B),
		.i_recv_data(i_recv_data_B),

		.i_macro_start_trig(macro_start_trig),
		.i_frt_sent(current_macrocycle_frt_sent),
		.i_mcc_sent(current_macrocycle_mcc_sent),
		.i_syncreq_sent(current_macrocycle_syncreq_sent),
		.i_syncrsp_sent(current_macrocycle_syncrsp_sent),
//		.i_syncreq_sent_A(current_macrocycle_syncreq_sent_A),
//		.i_syncreq_sent_B(current_macrocycle_syncreq_sent_B),
//		.i_syncreq_sent_C(current_macrocycle_syncreq_sent_C),
//		.i_syncrsp_sent_A(current_macrocycle_syncrsp_sent_A),
//		.i_syncrsp_sent_B(current_macrocycle_syncrsp_sent_B),
//		.i_syncrsp_sent_C(current_macrocycle_syncrsp_sent_C),

		.o_src_mac_low(src_mac_B),
		.o_dest_mac(dest_mac_B),
		.o_pkg_type(pkg_type_B),
		.o_frt_type(frt_type_B),
		.o_id(id_B),
		.recv_addr(recv_addr_B),
		.o_recv_status(recv_status_B),

		.i_local_node_mac(i_local_node_mac),
		.o_recv_data_legal(Rx_dv_B_legal),
		.o_rd_en(rd_en_B)	
);

/*********************analysis the receive data from C port********************/
PDU_analysis_up   PDU_analysis_C2host(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_Rx_dv(i_Rx_dv_C),
		.i_recv_data(i_recv_data_C),

		.i_macro_start_trig(macro_start_trig),
		.i_frt_sent(current_macrocycle_frt_sent),
		.i_mcc_sent(current_macrocycle_mcc_sent),
		.i_syncreq_sent(current_macrocycle_syncreq_sent),
		.i_syncrsp_sent(current_macrocycle_syncrsp_sent),
//		.i_syncreq_sent_A(current_macrocycle_syncreq_sent_A),
//		.i_syncreq_sent_B(current_macrocycle_syncreq_sent_B),
//		.i_syncreq_sent_C(current_macrocycle_syncreq_sent_C),
//		.i_syncrsp_sent_A(current_macrocycle_syncrsp_sent_A),
//		.i_syncrsp_sent_B(current_macrocycle_syncrsp_sent_B),
//		.i_syncrsp_sent_C(current_macrocycle_syncrsp_sent_C),

		.o_src_mac_low(src_mac_C),
		.o_dest_mac(dest_mac_C),
		.o_pkg_type(pkg_type_C),
		.o_frt_type(frt_type_C),
		.o_id(id_C),
		.recv_addr(recv_addr_C),
		.o_recv_status(recv_status_C),

		.i_local_node_mac(i_local_node_mac),
		.o_recv_data_legal(Rx_dv_C_legal),
		.o_rd_en(rd_en_C)
);



/*********************analysis the receive data from host port********************/
PDU_analysis_up   PDU_analysis_host2A(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		
		.i_Rx_dv(i_Rx_dv_host_A),
		.i_recv_data(i_recv_data_host_A),
		
		.o_dest_mac(dest_mac_host_A),
		.o_pkg_type(pkg_type_host_A),
		.o_frt_type(frt_type_host_A),
		.recv_addr(recv_addr_host_A)
);

PDU_analysis_up   PDU_analysis_host2B(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		
		.i_Rx_dv(i_Rx_dv_host_B),
		.i_recv_data(i_recv_data_host_B),
		
		.o_dest_mac(dest_mac_host_B),
		.o_pkg_type(pkg_type_host_B),
		.o_frt_type(frt_type_host_B),
		.recv_addr(recv_addr_host_B)
);

PDU_analysis_up   PDU_analysis_host2C(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		
		.i_Rx_dv(i_Rx_dv_host_C),
		.i_recv_data(i_recv_data_host_C),
		
		.o_dest_mac(dest_mac_host_C),
		.o_pkg_type(pkg_type_host_C),
		.o_frt_type(frt_type_host_C),
		.recv_addr(recv_addr_host_C)
);
endmodule 