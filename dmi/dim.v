module dim(
		input wire  i_clk,
		input wire  i_rst_n,
				
		input wire  i_Rx_dv_A,
		input wire [3:0] i_recv_data_A,
		
		output wire o_Tx_en_A,
		output wire [3:0] o_send_data_A,
		
		input wire  i_Rx_dv_B,
		input wire [3:0] i_recv_data_B,
		
		output wire o_Tx_en_B,
		output wire [3:0] o_send_data_B,
		
		input wire  i_Rx_dv_C,
		input wire [3:0] i_recv_data_C,
		
		output wire o_Tx_en_C,
		output wire [3:0] o_send_data_C,
		
		input wire  i_Rx_dv_D,               //Modified by SYF 2014.5.28
		input wire [3:0] i_recv_data_D,      //Modified by SYF 2014.5.28
		
		output wire o_Tx_en_D,               //Modified by SYF 2014.5.28
		output wire [3:0] o_send_data_D,     //Modified by SYF 2014.5.28

		input wire  i_Rx_dv_host_A,             //Modified by SYF 2014.5.28
		input wire [3:0] i_recv_data_host_A,    //Modified by SYF 2014.5.28
		
		input wire  i_Rx_dv_host_B,
		input wire [3:0] i_recv_data_host_B,		
		
		input wire  i_Rx_dv_host_C,             //Modified by SYF 2014.5.28
		input wire [3:0] i_recv_data_host_C,    //Modified by SYF 2014.5.28
	   
		input wire  i_Rx_dv_host_D,             //Modified by SYF 2014.5.28
		input wire [3:0] i_recv_data_host_D,    //Modified by SYF 2014.5.28
		
		output wire o_Tx_en_host_A,
		output wire [3:0] o_send_data_host_A,	
		
		output wire o_Tx_en_host_B,
		output wire [3:0] o_send_data_host_B,

		output wire o_Tx_en_host_C,            //Modified by SYF 2014.5.28
		output wire [3:0] o_send_data_host_C,	//Modified by SYF 2014.5.28
		
		output wire o_Tx_en_host_D,            //Modified by SYF 2014.5.28
		output wire [3:0] o_send_data_host_D,  //Modified by SYF 2014.5.28
	
      input wire  i_device_type,             //Modified by SYF 2014.6.18	
		
		output reg o_get_time_en_frt0_s_B,  // frt0 time stamp
		output reg o_get_time_en_sync_s_B, // sync time stamp
		
		output reg o_send_recvn_s_B,		//receive or send
		
		output reg o_get_time_en_frt0_m_B,  // frt0 time stamp
		output reg o_get_time_en_sync_m_B, // sync time stamp
		
		output reg o_send_recvn_m_B,		//receive or send		
		
		
		output reg o_get_time_en_frt0_s_A,  // frt0 time stamp
		output reg o_get_time_en_sync_s_A, // sync time stamp
		
		output reg o_send_recvn_s_A,		//receive or send
		
		output reg o_get_time_en_frt0_m_A,  // frt0 time stamp
		output reg o_get_time_en_sync_m_A, // sync time stamp
		
		output reg o_send_recvn_m_A,		//receive or send	

		output reg o_get_time_en_frt0_s_C,  //Modified by SYF 2014.5.28
		output reg o_get_time_en_sync_s_C,  //Modified by SYF 2014.5.28
		
		output reg o_send_recvn_s_C,		   //Modified by SYF 2014.5.28
		
		output reg o_get_time_en_frt0_m_C,  //Modified by SYF 2014.5.28
		output reg o_get_time_en_sync_m_C,  //Modified by SYF 2014.5.28
		
		output reg o_send_recvn_m_C,		   //Modified by SYF 2014.5.28


		output reg o_get_time_en_frt0_s_D,  //Modified by SYF 2014.5.28
		output reg o_get_time_en_sync_s_D,  //Modified by SYF 2014.5.28
		
		output reg o_send_recvn_s_D,		   //Modified by SYF 2014.5.28
		
		output reg o_get_time_en_frt0_m_D,  //Modified by SYF 2014.5.28
		output reg o_get_time_en_sync_m_D,  //Modified by SYF 2014.5.28
		
		output reg o_send_recvn_m_D,		   //Modified by SYF 2014.5.28		
		
		input wire i_main_clock_state_up,
		input wire i_main_clock_state_down,  //Modified by SYF 2014.5.28
		
/************** sjj Oct_30th******************/		
		//MM
		input wire i_csme_en_up,             //Modified by SYF 2014.5.28
		input wire i_csme_en_down,           //Modified by SYF 2014.5.28
		//MII
		input wire [15:0] i_recv_data,//data signal for receiving
		input wire i_data_valid,//data valid if high
		input wire [9:0] i_recv_addr,//receive addr when receiving
/************** sjj Oct_30th******************/	

/************** sjj Nov_1st******************/	
		input wire i_macrocycle_b_up,                //Modified by SYF 2014.5.28
		input wire i_macrocycle_b_down,              //Modified by SYF 2014.5.28
		input wire [47:0] i_local_node_mac,
/************** sjj Nov_1st******************/		
		
/*************** sjj Oct_23rd*******************/
		input wire [31:0] i_local_ip,
		input wire [31:0] i_src_ip,
/*************** sjj Oct_23rd*******************/	


/*************  sjj Nov_6th  *************/	
		input wire i_SendIrq,
		input wire [15:0] i_data_send,
		input wire [9:0]i_mac_rd_addr,
		input wire [9:0] i_lenth,
/*************  sjj Nov_6th  *************/	
		output reg [7:0] o_msgid,
/*************  sjj Nov_16th  *************/
      output reg mm_packet_trig,
/*************  sjj Nov_16th  *************/

/*************  sjj Nov_28th  *************/
		input wire i_link_valid_A,
		input wire i_link_valid_B,					
		input wire i_start_en_already,
		
		input wire i_link_valid_C,             //Modified by SYF 2014.5.28
		input wire i_link_valid_D,	            //Modified by SYF 2014.5.28
/*************  sjj Nov_28th  *************/
				
/*************  sjj Nov_19th  *************/
		input wire i_send_mcc_A,
		input wire i_send_mcc_B,
		input wire i_send_mcc_C,               //Modified by SYF 2014.5.28
		input wire i_send_mcc_D,               //Modified by SYF 2014.5.28
		
		input wire i_sending_frt_up,           //Modified by SYF 2014.5.28
		input wire i_sending_frt_down,         //Modified by SYF 2014.5.28
		
		input wire i_sending_mm,
		
		input wire i_sending_ptp_A,            //Modified by SYF 2014.5.27
		input wire i_sending_ptp_B,		
		input wire i_sending_ptp_C,            //Modified by SYF 2014.5.28
		input wire i_sending_ptp_D,            //Modified by SYF 2014.5.28
		
		input wire i_sending_mcc_up,           //Modified by SYF 2014.5.28
		input wire i_sending_mcc_down,         //Modified by SYF 2014.5.28
		
		input wire i_sending_config,
		input wire i_sending_arp,
/*************  sjj Nov_19th  *************/

		output reg recv_frt_main_from_A, 
		output reg recv_frt_main_from_B,
		
		output reg recv_MAC_data_from_A, 
		output reg recv_MAC_data_from_B,
		
      output reg recv_ptp_time_from_A, 
		output reg recv_ptp_time_from_B,
		
		output reg main_clock_compete_from_A,
		output reg main_clock_compete_from_B,
		
		input wire i_csme_en_A,
		input wire i_csme_en_B,
		
		output reg recv_frt_main_from_C,        //Modified by SYF 2014.5.28
		output reg recv_frt_main_from_D,        //Modified by SYF 2014.5.28
		
		output reg recv_MAC_data_from_C,        //Modified by SYF 2014.5.28
		output reg recv_MAC_data_from_D,        //Modified by SYF 2014.5.28
		
      output reg recv_ptp_time_from_C,        //Modified by SYF 2014.5.28
		output reg recv_ptp_time_from_D,        //Modified by SYF 2014.5.28
		
		output reg main_clock_compete_from_C,   //Modified by SYF 2014.5.28
		output reg main_clock_compete_from_D,   //Modified by SYF 2014.5.28
		
		input wire i_csme_en_C,                 //Modified by SYF 2014.5.28
		input wire i_csme_en_D,                 //Modified by SYF 2014.5.28
	
//		input wire i_stop_send_remcc,	
		input wire i_link_valid_up,             //Modified by SYF 2014.5.28
		input wire i_link_valid_down,           //Modified by SYF 2014.5.28
		
		output reg o_Rx_dv_A_macrocycle,
		output reg o_Rx_dv_B_macrocycle,
		input wire i_stop_send_remcc_up,        //Modified by SYF 2014.5.28
		input wire i_closing_csme_up,           //Modified by SYF 2014.5.28
		input wire i_stop_send_remcc2_down,     //Modified by SYF 2014.6.11
		
		output reg o_Rx_dv_C_macrocycle,        //Modified by SYF 2014.5.28
		output reg o_Rx_dv_D_macrocycle,        //Modified by SYF 2014.5.28
		input wire i_stop_send_remcc_down,      //Modified by SYF 2014.5.28
		input wire i_closing_csme_down,         //Modified by SYF 2014.5.28
		
		/********************************/
		input wire [15:0] i_len_master_clock_A,           //Modified by SYF 2014.5.23
		input wire [15:0] i_len_master_clock_B,           //Modified by SYF 2014.5.23
		input wire [15:0] i_len_master_clock_C,           //Modified by SYF 2014.5.28
		input wire [15:0] i_len_master_clock_D,           //Modified by SYF 2014.5.28
		/********************************/
		
		output reg frt_main_clock_status_A,     //Modified by SYF 2014.6.3
		output reg frt_main_clock_status_B,     //Modified by SYF 2014.6.3
		output reg frt_main_clock_status_C,     //Modified by SYF 2014.6.3
		output reg frt_main_clock_status_D,     //Modified by SYF 2014.6.3
		
////////////////////////////////////////////////////////////

		output reg  [47:0] o_plant_src_mac_up,				 //Modified by SYF 2014.5.28	
		input  wire [31:0] i_plant_ip_up,                //Modified by SYF 2014.5.28
		input  wire [31:0] i_plant_toffset_up,           //Modified by SYF 2014.5.28
		input  wire [15:0] i_plant_datalen_up,           //Modified by SYF 2014.5.28
		input  wire [15:0] i_plant_interval_up,          //Modified by SYF 2014.5.28
		output reg  o_plant_index_irq_up,                //Modified by SYF 2014.5.28
		input  wire i_plant_index_done_up,               //Modified by SYF 2014.5.28
		input  wire i_plant_index_error_up,              //Modified by SYF 2014.5.28
		
		output reg  [47:0] o_plant_src_mac_down,				 //Modified by SYF 2014.5.28	
		input  wire [31:0] i_plant_ip_down,                //Modified by SYF 2014.5.28
		input  wire [31:0] i_plant_toffset_down,           //Modified by SYF 2014.5.28
		input  wire [15:0] i_plant_datalen_down,           //Modified by SYF 2014.5.28
		input  wire [15:0] i_plant_interval_down,          //Modified by SYF 2014.5.28
		output reg  o_plant_index_irq_down,                //Modified by SYF 2014.5.28
		input  wire i_plant_index_done_down,               //Modified by SYF 2014.5.28
		input  wire i_plant_index_error_down,              //Modified by SYF 2014.5.28
		
		input  wire i_commen_data_rd_done,		 //Modified	by SYF 2014.5.22

		input  wire [31:0] i_ptptime_second_A,
		input  wire [31:0] i_ptptime_nanosecond_A,		
		
		input  wire [31:0] i_ptptime_second_B,
		input  wire [31:0] i_ptptime_nanosecond_B,

		input  wire [31:0] i_ptptime_second_C,          //Modified by SYF 2014.5.28
		input  wire [31:0] i_ptptime_nanosecond_C,		//Modified by SYF 2014.5.28
		 
		input  wire [31:0] i_ptptime_second_D,          //Modified by SYF 2014.5.28
		input  wire [31:0] i_ptptime_nanosecond_D,	   //Modified by SYF 2014.5.28		
		
		//20140221, attack alarm information
		output wire [191:0] o_alarm_data_A,
		output wire o_send_alarm_to_pdo_A,
		output wire o_pack_safe_A,		
		output wire [191:0] o_alarm_data_B,
		output wire o_send_alarm_to_pdo_B,
		output wire o_pack_safe_B,

		output wire [191:0] o_alarm_data_C,             //Modified by SYF 2014.5.28
		output wire o_send_alarm_to_pdo_C,              //Modified by SYF 2014.5.28
		output wire o_pack_safe_C,		                  //Modified by SYF 2014.5.28
		output wire [191:0] o_alarm_data_D,             //Modified by SYF 2014.5.28
		output wire o_send_alarm_to_pdo_D,              //Modified by SYF 2014.5.28
		output wire o_pack_safe_D			               //Modified by SYF 2014.5.28
				
);

wire  [47:0] dest_mac_A, dest_mac_B, dest_mac_C, dest_mac_D, dest_mac_host_A, dest_mac_host_B, dest_mac_host_C, dest_mac_host_D;            //Modified by SYF 2014.5.28
wire  [15:0] pkg_type_A, pkg_type_B, pkg_type_C, pkg_type_D, pkg_type_host_A, pkg_type_host_B, pkg_type_host_C, pkg_type_host_D;            //Modified by SYF 2014.5.28
wire  [7:0]  frt_type_A, frt_type_B, frt_type_C, frt_type_D, frt_type_host_A, frt_type_host_B, frt_type_host_C, frt_type_host_D, msgid_A, msgid_B, msgid_C, msgid_D, msgid_host_A, msgid_host_B, msgid_host_C, msgid_host_D;    //Modified by SYF 2014.5.28
wire  [15:0] recv_addr_A, recv_addr_B, recv_addr_C, recv_addr_D, recv_addr_host_A, recv_addr_host_B, recv_addr_host_C, recv_addr_host_D;    //Modified by SYF 2014.5.28

reg  get_time_en_frt0_s_A, get_time_en_sync_s_A;
reg  get_time_en_frt0_s_B, get_time_en_sync_s_B;

reg  get_time_en_frt0_s_C, get_time_en_sync_s_C;             //Modified by SYF 2014.5.28
reg  get_time_en_frt0_s_D, get_time_en_sync_s_D;             //Modified by SYF 2014.5.28

reg get_time_en_sync_1clk_s_A, get_time_en_frt0_1clk_s_A;
reg get_time_en_sync_1clk_s_B, get_time_en_frt0_1clk_s_B;

reg get_time_en_sync_1clk_s_C, get_time_en_frt0_1clk_s_C;    //Modified by SYF 2014.5.28
reg get_time_en_sync_1clk_s_D, get_time_en_frt0_1clk_s_D;    //Modified by SYF 2014.5.28

reg  get_time_en_frt0_m_A, get_time_en_sync_m_A;
reg  get_time_en_frt0_m_B, get_time_en_sync_m_B;

reg  get_time_en_frt0_m_C, get_time_en_sync_m_C;             //Modified by SYF 2014.5.28
reg  get_time_en_frt0_m_D, get_time_en_sync_m_D;             //Modified by SYF 2014.5.28

reg get_time_en_sync_1clk_m_A, get_time_en_frt0_1clk_m_A;
reg get_time_en_sync_1clk_m_B, get_time_en_frt0_1clk_m_B;

reg get_time_en_sync_1clk_m_C,get_time_en_frt0_1clk_m_C;     //Modified by SYF 2014.5.28
reg get_time_en_sync_1clk_m_D,get_time_en_frt0_1clk_m_D;     //Modified by SYF 2014.5.28


wire [3:0] recv_status_A, recv_status_B;
wire [3:0] recv_status_C, recv_status_D;                     //Modified by SYF 2014.5.28


/********* sjj Nov_19th************/

//Modified by SYF 2014.5.28	
//(alarm_num_A != 8'd10)		 
assign o_Tx_en_B = (Rx_dv_host2B && i_sending_mcc_up) ? 1'b1 :
							((Rx_dv_host2B && i_main_clock_state_up) ? 1'b1:
									((Rx_dv_host2B && !i_main_clock_state_up && 
									(i_sending_ptp_B || i_sending_mm || i_sending_config || i_sending_arp || (i_sending_frt_up &&(i_csme_en_A || i_csme_en_B)))) ? 1'b1 :   //Modified by SYF 2014.5.28 
										((cache_data_send_flag_A && !i_Rx_dv_host_B && !o_Rx_dv_A_macrocycle && !o_Rx_dv_B_macrocycle 
										&& !link_valid_up_dly && !i_closing_csme_up && i_link_valid_A && Rx_dv_A_legal && (!A_flood)) ? 1'b1 : 1'b0)));  //sjj 2014_April_29th						
												
assign o_send_data_B = (Rx_dv_host2B && i_sending_mcc_up) ? i_recv_data_host_B_dly :
								((Rx_dv_host2B && i_main_clock_state_up) ? i_recv_data_host_B_dly:
									((Rx_dv_host2B && !i_main_clock_state_up && 
									(i_sending_ptp_B || i_sending_mm || i_sending_config || i_sending_arp || (i_sending_frt_up &&(i_csme_en_A || i_csme_en_B)))) ? i_recv_data_host_B_dly :   //Modified by SYF 2014.5.28
											((cache_data_send_flag_A && !i_Rx_dv_host_B && !o_Rx_dv_A_macrocycle 
											&& !o_Rx_dv_B_macrocycle && !link_valid_up_dly && !i_closing_csme_up && i_link_valid_A && Rx_dv_A_legal && (!A_flood)) ? dmi_buffer_data_A : 4'b0)));  //sjj 2014_April_29th
							  		 
/********* sjj Nov_19th************/
			 
assign o_Tx_en_A = (Rx_dv_host2A && i_sending_mcc_up) ? 1'b1 :
								((Rx_dv_host2A && i_main_clock_state_up) ? 1'b1:
										((Rx_dv_host2A && !i_main_clock_state_up && 
										(i_sending_ptp_A || i_sending_mm || i_sending_config || i_sending_arp || (i_sending_frt_up && (i_csme_en_A || i_csme_en_B)))) ? 1'b1 :   //Modified by SYF 2014.5.28
											((cache_data_send_flag_B && !i_Rx_dv_host_A && !o_Rx_dv_A_macrocycle 
											&& !o_Rx_dv_B_macrocycle && !link_valid_up_dly && !i_closing_csme_up && i_link_valid_B && Rx_dv_B_legal && (!B_flood)) ? 1'b1 : 1'b0)));   //sjj 2014_April_29th
			 

assign o_send_data_A = (Rx_dv_host2A && i_sending_mcc_up) ? i_recv_data_host_A_dly :
								((Rx_dv_host2A && i_main_clock_state_up) ? i_recv_data_host_A_dly:
										((Rx_dv_host2A && !i_main_clock_state_up && 
										(i_sending_ptp_A || i_sending_mm || i_sending_config || i_sending_arp || (i_sending_frt_up && (i_csme_en_A || i_csme_en_B)))) ? i_recv_data_host_A_dly :   //Modified by SYF 2014.5.28
											((cache_data_send_flag_B && !i_Rx_dv_host_A && !o_Rx_dv_A_macrocycle 
											&& !o_Rx_dv_B_macrocycle && !link_valid_up_dly && !i_closing_csme_up && i_link_valid_B && Rx_dv_B_legal && (!B_flood)) ? dmi_buffer_data_B : 4'b0)));   //sjj 2014_April_29th

/********* sjj Nov_19th************/
//Modified by SYF 2014.6.18				 
assign o_Tx_en_D = !i_device_type ? i_Rx_dv_host_D : (Rx_dv_host2D && i_sending_mcc_down) ? 1'b1 :
							((Rx_dv_host2D && i_main_clock_state_down) ? 1'b1:
									((Rx_dv_host2D && !i_main_clock_state_down && 
									(i_sending_ptp_D || i_sending_mm || i_sending_config || i_sending_arp || (i_sending_frt_down && (i_csme_en_C || i_csme_en_D)))) ? 1'b1 :     //Modified by SYF 2014.5.29
										((cache_data_send_flag_C && !i_Rx_dv_host_D && i_stop_send_remcc2_down && !o_Rx_dv_C_macrocycle && !o_Rx_dv_D_macrocycle 
										&& !link_valid_down_dly && !i_closing_csme_down && i_link_valid_C && Rx_dv_C_legal && (alarm_num_C != 8'd10)) ? 1'b1 : 1'b0))); 
//Modified by SYF 2014.6.18										
assign o_send_data_D = !i_device_type ? i_recv_data_host_D : (Rx_dv_host2D && i_sending_mcc_down) ? i_recv_data_host_D_dly :
								((Rx_dv_host2D && i_main_clock_state_down) ? i_recv_data_host_D_dly:
									((Rx_dv_host2D && !i_main_clock_state_down && 
									(i_sending_ptp_D || i_sending_mm || i_sending_config || i_sending_arp || (i_sending_frt_down && (i_csme_en_C || i_csme_en_D)))) ? i_recv_data_host_D_dly :   //Modified by SYF 2014.5.29
											((cache_data_send_flag_C && !i_Rx_dv_host_D && i_stop_send_remcc2_down && !o_Rx_dv_C_macrocycle 
											&& !o_Rx_dv_D_macrocycle && !link_valid_down_dly && !i_closing_csme_down && i_link_valid_C && Rx_dv_C_legal && (alarm_num_C != 8'd10)) ? dmi_buffer_data_C : 4'b0)));  //sjj 2014_April_29th 
 
assign o_Tx_en_C = (Rx_dv_host2C && i_sending_mcc_down) ? 1'b1 :
								((Rx_dv_host2C && i_main_clock_state_down) ? 1'b1:
										((Rx_dv_host2C && !i_main_clock_state_down && 
										(i_sending_ptp_C || i_sending_mm || i_sending_config || i_sending_arp || (i_sending_frt_down && (i_csme_en_C || i_csme_en_D)))) ? 1'b1 :    //Modified by SYF 2014.5.29
											((cache_data_send_flag_D && !i_Rx_dv_host_C && i_stop_send_remcc2_down && !o_Rx_dv_C_macrocycle 
											&& !o_Rx_dv_D_macrocycle && !link_valid_down_dly && !i_closing_csme_down && i_link_valid_D && Rx_dv_D_legal && (alarm_num_D != 8'd10)) ? 1'b1 : 1'b0)));  
			 
assign o_send_data_C = (Rx_dv_host2C && i_sending_mcc_down) ? i_recv_data_host_C_dly :
								((Rx_dv_host2C && i_main_clock_state_down) ? i_recv_data_host_C_dly:
										((Rx_dv_host2C && !i_main_clock_state_down && 
										(i_sending_ptp_C || i_sending_mm || i_sending_config || i_sending_arp || (i_sending_frt_down && (i_csme_en_C || i_csme_en_D)))) ? i_recv_data_host_C_dly :   //Modified by SYF 2014.5.29
											((cache_data_send_flag_D && !i_Rx_dv_host_C && i_stop_send_remcc2_down && !o_Rx_dv_C_macrocycle 
											&& !o_Rx_dv_D_macrocycle && !link_valid_down_dly && !i_closing_csme_down && i_link_valid_D && Rx_dv_D_legal && (alarm_num_D != 8'd10)) ? dmi_buffer_data_D : 4'b0)));   
  
reg A_flood;
reg B_flood;

always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			A_flood <= 1'b0;
			B_flood <= 1'b0;
		end
	else if(alarm_num_A == 8'd10)
		A_flood <= 1'b1;
	else if(alarm_num_B == 8'd10)
		B_flood <= 1'b1;
	else
		begin
			A_flood <= 1'b0;
			B_flood <= 1'b0;
		end
end
assign o_Tx_en_host_A = A_flood ? 1'b0:i_Rx_dv_A;
assign o_send_data_host_A = A_flood ? 4'b0:i_recv_data_A; 

assign o_Tx_en_host_B = B_flood? 1'b0:i_Rx_dv_B;
assign o_send_data_host_B = B_flood? 4'b0:i_recv_data_B;

//assign o_Tx_en_host_A = i_Rx_dv_A;
//assign o_send_data_host_A = i_recv_data_A;
//
//assign o_Tx_en_host_B = i_Rx_dv_B;
//assign o_send_data_host_B = i_recv_data_B;

 

assign o_Tx_en_host_C = (alarm_num_C != 8'd10) ? i_Rx_dv_C : 1'b0;            //Modified by SYF 2014.5.28
assign o_send_data_host_C = (alarm_num_C != 8'd10) ? i_recv_data_C : 4'b0;    //Modified by SYF 2014.5.28

assign o_Tx_en_host_D = (alarm_num_D != 8'd10) ? i_Rx_dv_D : 1'b0;            //Modified by SYF 2014.5.28
assign o_send_data_host_D = (alarm_num_D != 8'd10) ? i_recv_data_D : 4'b0;    //Modified by SYF 2014.5.28

reg [15:0] count_macrocycle_up, count_macrocycle_down;                        //Modified by SYF 2014.5.28
reg pre_link_valid_A, pre_link_valid_B, pre_link_valid_C, pre_link_valid_D;   //Modified by SYF 2014.5.28
reg link_valid_up_dly, link_valid_down_dly;                                   //Modified by SYF 2014.5.28

reg macrocycle_b_up_dly, macrocycle_b_down_dly;      //Modified by SYF 2014.5.28


/////////////////////////April 22th////////////////////////////////
reg  query_plantinfo_dn_up, query_plantinfo_dn_down;	   //Modified by SYF 2014.5.28
reg  [7:0] rdaddress_A, wraddress_A, rdaddress_B, wraddress_B, rdaddress_C, wraddress_C, rdaddress_D, wraddress_D;    //Modified by SYF 2014.5.28
wire Rx_dv_A_legal, Rx_dv_B_legal, Rx_dv_C_legal, Rx_dv_D_legal;                                                      //Modified by SYF 2014.5.28                     
wire [3:0] recv_data_A_legal, recv_data_B_legal, recv_data_C_legal, recv_data_D_legal;                                //Modified by SYF 2014.5.28
wire rd_en_A, rd_en_B, rd_en_C, rd_en_D;                    //Modified by SYF 2014.5.28
/////////////////////////April 22th////////////////////////////////

reg [3:0] i_recv_data_host_A_dly;
reg [3:0] i_recv_data_host_B_dly;

reg [3:0] i_recv_data_host_C_dly;           //Modified by SYF 2014.5.28
reg [3:0] i_recv_data_host_D_dly;           //Modified by SYF 2014.5.28


//////////////////////April 23th/////////////////////////   //Modified by SYF 2014.5.28
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			i_recv_data_host_A_dly <= 4'd0;
		   i_recv_data_host_B_dly <= 4'd0;
			i_recv_data_host_C_dly <= 4'd0;
			i_recv_data_host_D_dly <= 4'd0;
		end
	else 
		begin
			i_recv_data_host_A_dly <= i_recv_data_host_A;
			i_recv_data_host_B_dly <= i_recv_data_host_B;
			i_recv_data_host_C_dly <= i_recv_data_host_C;
			i_recv_data_host_D_dly <= i_recv_data_host_D;
		end
end

//*************************************************
//Modified by SYF 2014.5.28
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
		count_macrocycle_up <= 16'b0;
	else if(!(i_link_valid_A || i_link_valid_B))
		count_macrocycle_up <= 16'b0;
	else if(count_macrocycle_up > 16'd1250)
		count_macrocycle_up <= count_macrocycle_up;
	else if(i_macrocycle_b_up && !macrocycle_b_up_dly && i_csme_en_up && (i_link_valid_A && i_link_valid_B))
		count_macrocycle_up <= count_macrocycle_up + 8'b1;
end

always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
		count_macrocycle_down <= 16'b0;
	else if(!(i_link_valid_C || i_link_valid_D))
		count_macrocycle_down <= 16'b0;
	else if(count_macrocycle_down > 16'd1250)
		count_macrocycle_down <= count_macrocycle_down;
	else if(i_macrocycle_b_down && !macrocycle_b_down_dly && i_csme_en_down && (i_link_valid_C && i_link_valid_D))
		count_macrocycle_down <= count_macrocycle_down + 8'b1;
end
//****************************************************

//*************************************************
//Modified by SYF 2014.5.28
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			pre_link_valid_A <= 1'b0;
			pre_link_valid_B <= 1'b0;
		end
	else if(i_link_valid_up && i_csme_en_up)
		begin
			pre_link_valid_A <= i_link_valid_A_2clk;
			pre_link_valid_B <= i_link_valid_B_2clk;
		end
	else 
		begin
			pre_link_valid_A <= 1'b0;
			pre_link_valid_B <= 1'b0;
		end
end

always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			pre_link_valid_C <= 1'b0;
			pre_link_valid_D <= 1'b0;
		end
	else if(i_link_valid_down && i_csme_en_down)
		begin
			pre_link_valid_C <= i_link_valid_C_2clk;
			pre_link_valid_D <= i_link_valid_D_2clk;
		end
	else 
		begin
			pre_link_valid_C <= 1'b0;
			pre_link_valid_D <= 1'b0;
		end
end
//****************************************************

//*************************************************
//Modified by SYF 2014.5.28
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		link_valid_up_dly <= 1'b0;
	else if(i_link_valid_up && i_csme_en_up)
		link_valid_up_dly <= 1'b1;
	else if(i_stop_send_remcc_up)
		link_valid_up_dly <= 1'b0;
	else if(!i_link_valid_A)
		link_valid_up_dly <= 1'b0;
	else if(!i_link_valid_B)
		link_valid_up_dly <= 1'b0;
	else 
		link_valid_up_dly <= link_valid_up_dly;
end

reg link_valid_up_dly1;
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		link_valid_up_dly1 <= 1'b0;
	else
		link_valid_up_dly1 <= i_link_valid_up;
end

always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		link_valid_down_dly <= 1'b0;
	else if(i_link_valid_down && i_csme_en_down)
		link_valid_down_dly <= 1'b1;
	else if(i_stop_send_remcc2_down)                //Modified by SYF 2014.8.19       //i_stop_send_remcc_down
		link_valid_down_dly <= 1'b0;
	else if(!i_link_valid_C)
		link_valid_down_dly <= 1'b0;
	else if(!i_link_valid_D)
		link_valid_down_dly <= 1'b0;
	else 
		link_valid_down_dly <= link_valid_down_dly;
end

reg link_valid_down_dly1;
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		link_valid_down_dly1 <= 1'b0;
	else
		link_valid_down_dly1 <= i_link_valid_down;
end
//****************************************************

//*************************************************
//Modified by SYF 2014.5.28
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			o_Rx_dv_A_macrocycle <= 1'b0;
			o_Rx_dv_B_macrocycle <= 1'b0;
		end
	else if(!pre_link_valid_A && link_valid_up_dly1 && i_link_valid_B && i_csme_en_up)   
		o_Rx_dv_A_macrocycle <= 1'b1;                      //A port get access to the net
	else if(!pre_link_valid_B && link_valid_up_dly1 && i_link_valid_A && i_csme_en_up)
		o_Rx_dv_B_macrocycle <= 1'b1;                      //B port get access to the net
	else if(i_link_valid_A == 1'b0)
		o_Rx_dv_A_macrocycle <= 1'b0;
	else if(i_link_valid_B == 1'b0)
		o_Rx_dv_B_macrocycle <= 1'b0;
 	else if(i_stop_send_remcc_up)
		begin
			o_Rx_dv_A_macrocycle <= 1'b0;
			o_Rx_dv_B_macrocycle <= 1'b0;
		end
end

reg Rx_dv_A_macrocycle_dly, Rx_dv_B_macrocycle_dly;
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			Rx_dv_A_macrocycle_dly <= 1'b0;
			Rx_dv_B_macrocycle_dly <= 1'b0;
		end
	else 
		begin
			Rx_dv_A_macrocycle_dly <= o_Rx_dv_A_macrocycle;
			Rx_dv_B_macrocycle_dly <= o_Rx_dv_B_macrocycle;
		end
end

always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			o_Rx_dv_C_macrocycle <= 1'b0;
			o_Rx_dv_D_macrocycle <= 1'b0;
		end
	else if(!pre_link_valid_C && link_valid_down_dly1 && i_link_valid_D && i_csme_en_down)   
		o_Rx_dv_C_macrocycle <= 1'b1;                      //A port get access to the net
	else if(!pre_link_valid_D && link_valid_down_dly1 && i_link_valid_C && i_csme_en_down)
		o_Rx_dv_D_macrocycle <= 1'b1;                      //B port get access to the net
	else if(i_link_valid_C == 1'b0)
		o_Rx_dv_C_macrocycle <= 1'b0;
	else if(i_link_valid_D == 1'b0)
		o_Rx_dv_D_macrocycle <= 1'b0;
 	else if(i_stop_send_remcc2_down)                      //Modified by SYF 2014.8.19       //i_stop_send_remcc_down
		begin
			o_Rx_dv_C_macrocycle <= 1'b0;
			o_Rx_dv_D_macrocycle <= 1'b0;
		end
end

reg Rx_dv_C_macrocycle_dly, Rx_dv_D_macrocycle_dly;
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			Rx_dv_C_macrocycle_dly <= 1'b0;
			Rx_dv_D_macrocycle_dly <= 1'b0;
		end
	else 
		begin
			Rx_dv_C_macrocycle_dly <= o_Rx_dv_C_macrocycle;
			Rx_dv_D_macrocycle_dly <= o_Rx_dv_D_macrocycle;
		end
end
//****************************************************


//*************************************************
//Modified by SYF 2014.5.28
reg mcc_force_to_slave_A, mcc_force_to_slave_B;
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			mcc_force_to_slave_A <= 1'b0;
			mcc_force_to_slave_B <= 1'b0;
		end
	else if(i_closing_csme_up && Rx_dv_A_macrocycle_dly)
		begin
			mcc_force_to_slave_A <= 1'b0;
			mcc_force_to_slave_B <= 1'b1;
		end
	else if(i_closing_csme_up && Rx_dv_B_macrocycle_dly)
		begin
			mcc_force_to_slave_A <= 1'b1;
			mcc_force_to_slave_B <= 1'b0;
		end
	else if(i_closing_csme_up == 1'b0)
		begin
			mcc_force_to_slave_A <= 1'b0;
			mcc_force_to_slave_B <= 1'b0;
		end
	else
		begin
			mcc_force_to_slave_A <= mcc_force_to_slave_A;
			mcc_force_to_slave_B <= mcc_force_to_slave_B;
		end
end

reg mcc_force_to_slave_C, mcc_force_to_slave_D;
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			mcc_force_to_slave_C <= 1'b0;
			mcc_force_to_slave_D <= 1'b0;
		end
	else if(i_closing_csme_down && Rx_dv_C_macrocycle_dly)
		begin
			mcc_force_to_slave_C <= 1'b0;
			mcc_force_to_slave_D <= 1'b1;
		end
	else if(i_closing_csme_down && Rx_dv_D_macrocycle_dly)
		begin
			mcc_force_to_slave_C <= 1'b1;
			mcc_force_to_slave_D <= 1'b0;
		end
	else if(i_closing_csme_down == 1'b0)
		begin
			mcc_force_to_slave_C <= 1'b0;
			mcc_force_to_slave_D <= 1'b0;
		end
	else
		begin
			mcc_force_to_slave_C <= mcc_force_to_slave_C;
			mcc_force_to_slave_D <= mcc_force_to_slave_D;
		end
end
//****************************************************


//*************************************************
//Modified by SYF 2014.5.28
reg Rx_dv_host2A, Rx_dv_host2B;
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		Rx_dv_host2A <= 1'b0;
	else if(i_macrocycle_b_up && o_Rx_dv_A_macrocycle)
		Rx_dv_host2A <= 1'b0;
	else if(i_macrocycle_b_up && o_Rx_dv_B_macrocycle)
		Rx_dv_host2A <= i_Rx_dv_host_A;                   //Modified by SYF 2014.5.28
	else if(!i_macrocycle_b_up && o_Rx_dv_A_macrocycle)
		Rx_dv_host2A <= i_Rx_dv_host_A;                   //Modified by SYF 2014.5.28
	else if(!i_macrocycle_b_up && o_Rx_dv_B_macrocycle)
		Rx_dv_host2A <= 1'b0;
		/////////////////
	else if(mcc_force_to_slave_B)
		Rx_dv_host2A <= 1'b0;
	else if(mcc_force_to_slave_A)
		Rx_dv_host2A <= i_Rx_dv_host_A;                   //Modified by SYF 2014.5.28
		////////////////// 
	else if(i_link_valid_A && !i_closing_csme_up)
		Rx_dv_host2A <= i_Rx_dv_host_A;                   //Modified by SYF 2014.5.28
	else 
		Rx_dv_host2A <= Rx_dv_host2A;
end

always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		Rx_dv_host2B <= 1'b0;
	else if(i_macrocycle_b_up && o_Rx_dv_A_macrocycle)
		Rx_dv_host2B <= i_Rx_dv_host_B;
	else if(i_macrocycle_b_up && o_Rx_dv_B_macrocycle)
		Rx_dv_host2B <= 1'b0;
	else if(!i_macrocycle_b_up && o_Rx_dv_A_macrocycle)
		Rx_dv_host2B <= 1'b0;
	else if(!i_macrocycle_b_up && o_Rx_dv_B_macrocycle)
		Rx_dv_host2B <= i_Rx_dv_host_B;
		////////////////
	else if(mcc_force_to_slave_B)
		Rx_dv_host2B <= i_Rx_dv_host_B;
	else if(mcc_force_to_slave_A)
		Rx_dv_host2B <= 1'b0;
		/////////////////
	else if(i_link_valid_B && !i_closing_csme_up)
		Rx_dv_host2B <= i_Rx_dv_host_B;
	else 
		Rx_dv_host2B <= Rx_dv_host2B;
end

reg Rx_dv_host2C, Rx_dv_host2D;

always @(posedge i_clk, negedge i_rst_n)    //Modified by SYF 2014.6.11
begin
	if(!i_rst_n)
		Rx_dv_host2C <= 1'b0;
	else if(!i_stop_send_remcc2_down && i_macrocycle_b_down && o_Rx_dv_C_macrocycle)           //Modified by SYF 2014.8.19
		Rx_dv_host2C <= 1'b0;
	else if(!i_stop_send_remcc2_down && !i_macrocycle_b_down && o_Rx_dv_C_macrocycle)          //Modified by SYF 2014.8.19
		Rx_dv_host2C <= i_Rx_dv_host_C;
	else if(i_stop_send_remcc2_down || (!o_Rx_dv_C_macrocycle && i_csme_en_C))
		Rx_dv_host2C <= i_Rx_dv_host_C;
	else 
		Rx_dv_host2C <= Rx_dv_host2C;
end

always @(posedge i_clk, negedge i_rst_n)     //Modified by SYF 2014.6.11
begin
	if(!i_rst_n)
		Rx_dv_host2D <= 1'b0;
	else if(!i_stop_send_remcc2_down && i_macrocycle_b_down && o_Rx_dv_D_macrocycle)            //Modified by SYF 2014.8.19
		Rx_dv_host2D <= 1'b0;
	else if(!i_stop_send_remcc2_down && !i_macrocycle_b_down && o_Rx_dv_D_macrocycle)           //Modified by SYF 2014.8.19
		Rx_dv_host2D <= i_Rx_dv_host_D;
	else if(i_stop_send_remcc2_down || (!o_Rx_dv_D_macrocycle && i_csme_en_D))
		Rx_dv_host2D <= i_Rx_dv_host_D;
	else 
		Rx_dv_host2D <= Rx_dv_host2D;
end

//always @(posedge i_clk, negedge i_rst_n)
//begin
//	if(!i_rst_n)
//		Rx_dv_host2C <= 1'b0;
//	else if(i_macrocycle_b_down && o_Rx_dv_C_macrocycle)
//		Rx_dv_host2C <= 1'b0;
//	else if(i_macrocycle_b_down && o_Rx_dv_D_macrocycle)
//		Rx_dv_host2C <= i_Rx_dv_host_C;                   //Modified by SYF 2014.5.28
//	else if(!i_macrocycle_b_down && o_Rx_dv_C_macrocycle)
//		Rx_dv_host2C <= i_Rx_dv_host_C;                   //Modified by SYF 2014.5.28
//	else if(!i_macrocycle_b_down && o_Rx_dv_D_macrocycle)
//		Rx_dv_host2C <= 1'b0;
//		/////////////////
//	else if(mcc_force_to_slave_D)
//		Rx_dv_host2C <= 1'b0;
//	else if(mcc_force_to_slave_C)
//		Rx_dv_host2C <= i_Rx_dv_host_C;                   //Modified by SYF 2014.5.28
//		////////////////// 
//	else if(i_link_valid_C && !i_closing_csme_down)
//		Rx_dv_host2C <= i_Rx_dv_host_C;                   //Modified by SYF 2014.5.28
//	else 
//		Rx_dv_host2C <= Rx_dv_host2C;
//end
//
//
//always @(posedge i_clk, negedge i_rst_n)
//begin
//	if(!i_rst_n)
//		Rx_dv_host2D <= 1'b0;
//	else if(i_macrocycle_b_down && o_Rx_dv_D_macrocycle)
//		Rx_dv_host2D <= 1'b0;
//	else if(i_macrocycle_b_down && o_Rx_dv_C_macrocycle)
//		Rx_dv_host2D <= i_Rx_dv_host_D;                   //Modified by SYF 2014.5.28
//	else if(!i_macrocycle_b_down && o_Rx_dv_D_macrocycle)
//		Rx_dv_host2D <= i_Rx_dv_host_D;                   //Modified by SYF 2014.5.28
//	else if(!i_macrocycle_b_down && o_Rx_dv_C_macrocycle)
//		Rx_dv_host2D <= 1'b0;
//		/////////////////
//	else if(mcc_force_to_slave_C)
//		Rx_dv_host2D <= 1'b0;
//	else if(mcc_force_to_slave_D)
//		Rx_dv_host2D <= i_Rx_dv_host_D;                   //Modified by SYF 2014.5.28
//		////////////////// 
//	else if(i_link_valid_D && !i_closing_csme_down)
//		Rx_dv_host2D <= i_Rx_dv_host_D;                   //Modified by SYF 2014.5.28
//	else 
//		Rx_dv_host2D <= Rx_dv_host2D;
//end

//****************************************************

//*************************************************
//Modified by SYF 2014.5.28
always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		get_time_en_sync_s_D <= 1'b0 ;
		get_time_en_frt0_s_D <= 1'b0;
		o_send_recvn_s_D <= 1'b0;
		end
		else if((pkg_type_D == 16'h8907)&&(frt_type_D == 8'h21)&&(dest_mac_D == 48'h01005e000182))
		begin
		get_time_en_sync_s_D <= 1'b1;
		get_time_en_frt0_s_D <= 1'b0;
		o_send_recvn_s_D <= 1'b0;
		end	
		//host is for send
		else if((pkg_type_host_D == 16'h8907)&&(frt_type_host_D == 8'h20)&&(dest_mac_host_D == 48'h01005e000181))
		begin
		get_time_en_sync_s_D <= 1'b1;
		get_time_en_frt0_s_D <= 1'b0;
		o_send_recvn_s_D <= 1'b1;	
		end	
		else if((pkg_type_D == 16'h8907)&&(frt_type_D == 8'h10)&&(dest_mac_D == 48'hffffffffffff) && (recv_status_D == 4'b1))
		begin
		get_time_en_frt0_s_D <= 1'b1 ;
		get_time_en_sync_s_D <= 1'b0 ;
		o_send_recvn_s_D <= 1'b0;
		end	
		else
		begin
		get_time_en_sync_s_D <= 1'b0 ;
		get_time_en_frt0_s_D <= 1'b0 ;
		o_send_recvn_s_D <= 1'b0;	
		end
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		get_time_en_sync_s_C <= 1'b0 ;
		get_time_en_frt0_s_C <= 1'b0;
		o_send_recvn_s_C <= 1'b0;
		end
		else if((pkg_type_C == 16'h8907)&&(frt_type_C == 8'h21)&&(dest_mac_C == 48'h01005e000182))
		begin
		get_time_en_sync_s_C <= 1'b1;
		get_time_en_frt0_s_C <= 1'b0;
		o_send_recvn_s_C <= 1'b0;
		end			
		//host is for send	
		else if((pkg_type_host_C == 16'h8907)&&(frt_type_host_C == 8'h20)&&(dest_mac_host_C == 48'h01005e000181))
		begin
		get_time_en_sync_s_C <= 1'b1;
		get_time_en_frt0_s_C <= 1'b0;
		o_send_recvn_s_C <= 1'b1;	
		end
		else if((pkg_type_C == 16'h8907)&&(frt_type_C == 8'h10)&&(dest_mac_C == 48'hffffffffffff) && (recv_status_C == 4'b1))
		begin
		get_time_en_frt0_s_C <= 1'b1 ;
		get_time_en_sync_s_C <= 1'b0 ;
		o_send_recvn_s_C <= 1'b0;
		end
		else
		begin
		get_time_en_sync_s_C <= 1'b0 ;
		get_time_en_frt0_s_C <= 1'b0 ;
		o_send_recvn_s_C <= 1'b0;			
		end
end

//o_send_recvn_s:send =1;receive=0
always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		get_time_en_sync_s_B <= 1'b0 ;
		get_time_en_frt0_s_B <= 1'b0;
		o_send_recvn_s_B <= 1'b0;
		end
		else if((pkg_type_B == 16'h8907)&&(frt_type_B == 8'h21)&&(dest_mac_B == 48'h01005e000182))
		begin
		get_time_en_sync_s_B <= 1'b1;
		get_time_en_frt0_s_B <= 1'b0;
		o_send_recvn_s_B <= 1'b0;
		end	
		//host is for send
		else if((pkg_type_host_B == 16'h8907)&&(frt_type_host_B == 8'h20)&&(dest_mac_host_B == 48'h01005e000181))
		begin
		get_time_en_sync_s_B <= 1'b1;
		get_time_en_frt0_s_B <= 1'b0;
		o_send_recvn_s_B <= 1'b1;	
		end	
		else if((pkg_type_host_B == 16'h8907)&&(frt_type_host_B == 8'h10)&&(dest_mac_host_B == 48'hffffffffffff))                //Modified by SYF 2014.5.28
		begin
		get_time_en_sync_s_B <= 1'b0;
		get_time_en_frt0_s_B <= 1'b1;
		o_send_recvn_s_B <= 1'b1;	
		end
		else if((pkg_type_B == 16'h8907)&&(frt_type_B == 8'h10)&&(dest_mac_B == 48'hffffffffffff) && (recv_status_B == 4'b1))
		begin
		get_time_en_frt0_s_B <= 1'b1 ;
		get_time_en_sync_s_B <= 1'b0 ;
		o_send_recvn_s_B <= 1'b0;
		end	
		else
		begin
		get_time_en_sync_s_B <= 1'b0 ;
		get_time_en_frt0_s_B <= 1'b0 ;
		o_send_recvn_s_B <= 1'b0;	
		end
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		get_time_en_sync_s_A <= 1'b0 ;
		get_time_en_frt0_s_A <= 1'b0;
		o_send_recvn_s_A <= 1'b0;
		end
		else if((pkg_type_A == 16'h8907)&&(frt_type_A == 8'h21)&&(dest_mac_A == 48'h01005e000182))
		begin
		get_time_en_sync_s_A <= 1'b1;
		get_time_en_frt0_s_A <= 1'b0;
		o_send_recvn_s_A <= 1'b0;
		end				
		//host is for send	
		else if((pkg_type_host_A == 16'h8907)&&(frt_type_host_A == 8'h20)&&(dest_mac_host_A == 48'h01005e000181))                //Modified by SYF 2014.5.28
		begin
		get_time_en_sync_s_A <= 1'b1;
		get_time_en_frt0_s_A <= 1'b0;
		o_send_recvn_s_A <= 1'b1;	
		end
		else if((pkg_type_host_A == 16'h8907)&&(frt_type_host_A == 8'h10)&&(dest_mac_host_A == 48'hffffffffffff))                //Modified by SYF 2014.5.28
		begin
		get_time_en_sync_s_A <= 1'b0;
		get_time_en_frt0_s_A <= 1'b1;
		o_send_recvn_s_A <= 1'b1;	
		end
		else if((pkg_type_A == 16'h8907)&&(frt_type_A == 8'h10)&&(dest_mac_A == 48'hffffffffffff) && (recv_status_A == 4'b1))
		begin
		get_time_en_frt0_s_A <= 1'b1 ;
		get_time_en_sync_s_A <= 1'b0 ;
		o_send_recvn_s_A <= 1'b0;
		end
		else
		begin
		get_time_en_sync_s_A <= 1'b0 ;
		get_time_en_frt0_s_A <= 1'b0 ;
		o_send_recvn_s_A <= 1'b0;			
		end
end
//****************************************************


//*************************************************
//Modified by SYF 2014.5.28
always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		get_time_en_sync_m_D <= 1'b0 ;
		get_time_en_frt0_m_D <= 1'b0;
		o_send_recvn_m_D <= 1'b0;
		end
		else if((pkg_type_D == 16'h8907)&&(frt_type_D == 8'h20)&&(dest_mac_D == 48'h01005e000181))
		begin
		get_time_en_sync_m_D <= 1'b1 ;
		get_time_en_frt0_m_D <= 1'b0 ;
		o_send_recvn_m_D <= 1'b0;
		end	
		//host is for send
		else if((pkg_type_host_D == 16'h8907)&&(frt_type_host_D == 8'h10)&&(dest_mac_host_D == 48'hffffffffffff))
		begin
		get_time_en_frt0_m_D <= 1'b1 ;
		get_time_en_sync_m_D <= 1'b0 ;
		o_send_recvn_m_D <= 1'b1;
		end	
		else if((pkg_type_host_D == 16'h8907)&&(frt_type_host_D == 8'h21)&&(dest_mac_host_D == 48'h01005e000182))
		begin
		get_time_en_sync_m_D <= 1'b1;
		get_time_en_frt0_m_D <= 1'b0;
		o_send_recvn_m_D <= 1'b1;
		end		
		else
		begin
		get_time_en_sync_m_D <= 1'b0 ;
		get_time_en_frt0_m_D <= 1'b0 ;
		o_send_recvn_m_D <= 1'b0;			
		end
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
	   get_time_en_sync_m_C <= 1'b0 ;
		get_time_en_frt0_m_C <= 1'b0;
		o_send_recvn_m_C <= 1'b0;
		end	
		else if((pkg_type_C == 16'h8907)&&(frt_type_C == 8'h20)&&(dest_mac_C == 48'h01005e000181))
		begin
		get_time_en_sync_m_C <= 1'b1 ;
		get_time_en_frt0_m_C <= 1'b0 ;
		o_send_recvn_m_C <= 1'b0;
		end
		//host is for send
		else if((pkg_type_host_C == 16'h8907)&&(frt_type_host_C == 8'h10)&&(dest_mac_host_C == 48'hffffffffffff))
		begin
		get_time_en_frt0_m_C <= 1'b1 ;
		get_time_en_sync_m_C <= 1'b0 ;
		o_send_recvn_m_C <= 1'b1;
		end
		else if((pkg_type_host_C == 16'h8907)&&(frt_type_host_C == 8'h21)&&(dest_mac_host_C == 48'h01005e000182))
		begin
		get_time_en_sync_m_C <= 1'b1;
		get_time_en_frt0_m_C <= 1'b0;
		o_send_recvn_m_C <= 1'b1;
		end	
		else
		begin
		get_time_en_sync_m_C <= 1'b0 ;
		get_time_en_frt0_m_C <= 1'b0 ;
		o_send_recvn_m_C <= 1'b0;		
		end
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		get_time_en_sync_m_B <= 1'b0 ;
		get_time_en_frt0_m_B <= 1'b0;
		o_send_recvn_m_B <= 1'b0;
		end
		else if((pkg_type_B == 16'h8907)&&(frt_type_B == 8'h20)&&(dest_mac_B == 48'h01005e000181))
		begin
		get_time_en_sync_m_B <= 1'b1 ;
		get_time_en_frt0_m_B <= 1'b0 ;
		o_send_recvn_m_B <= 1'b0;
		end	
		//host is for send
		else if((pkg_type_host_B == 16'h8907)&&(frt_type_host_B == 8'h10)&&(dest_mac_host_B == 48'hffffffffffff))
		begin
		get_time_en_frt0_m_B <= 1'b1 ;
		get_time_en_sync_m_B <= 1'b0 ;
		o_send_recvn_m_B <= 1'b1;
		end	
		else if((pkg_type_host_B == 16'h8907)&&(frt_type_host_B == 8'h21)&&(dest_mac_host_B == 48'h01005e000182))
		begin
		get_time_en_sync_m_B <= 1'b1;
		get_time_en_frt0_m_B <= 1'b0;
		o_send_recvn_m_B <= 1'b1;
		end		
		else
		begin
		get_time_en_sync_m_B <= 1'b0 ;
		get_time_en_frt0_m_B <= 1'b0 ;
		o_send_recvn_m_B <= 1'b0;			
		end
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
	   get_time_en_sync_m_A <= 1'b0 ;
		get_time_en_frt0_m_A <= 1'b0;
		o_send_recvn_m_A <= 1'b0;
		end	
		else if((pkg_type_A == 16'h8907)&&(frt_type_A == 8'h20)&&(dest_mac_A == 48'h01005e000181))
		begin
		get_time_en_sync_m_A <= 1'b1 ;
		get_time_en_frt0_m_A <= 1'b0 ;
		o_send_recvn_m_A <= 1'b0;
		end
		//host is for send
		else if((pkg_type_host_A == 16'h8907)&&(frt_type_host_A == 8'h10)&&(dest_mac_host_A == 48'hffffffffffff))        //Modified by SYF 2014.5.28
		begin
		get_time_en_frt0_m_A <= 1'b1 ;
		get_time_en_sync_m_A <= 1'b0 ;
		o_send_recvn_m_A <= 1'b1;
		end
		else if((pkg_type_host_A == 16'h8907)&&(frt_type_host_A == 8'h21)&&(dest_mac_host_A == 48'h01005e000182))        //Modified by SYF 2014.5.28
		begin
		get_time_en_sync_m_A <= 1'b1;
		get_time_en_frt0_m_A <= 1'b0;
		o_send_recvn_m_A <= 1'b1;
		end	
		else
		begin
		get_time_en_sync_m_A <= 1'b0 ;
		get_time_en_frt0_m_A <= 1'b0 ;
		o_send_recvn_m_A <= 1'b0;		
		end
end
//****************************************************

//*************************************************
//Modified by SYF 2014.5.28
always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		get_time_en_sync_1clk_s_B <= 1'b0;
		get_time_en_sync_1clk_s_A <= 1'b0;
		end
		else
		begin
		get_time_en_sync_1clk_s_B <= get_time_en_sync_s_B;
		get_time_en_sync_1clk_s_A <= get_time_en_sync_s_A;
		end
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		get_time_en_sync_1clk_s_D <= 1'b0;
		get_time_en_sync_1clk_s_C <= 1'b0;
		end
		else
		begin
		get_time_en_sync_1clk_s_D <= get_time_en_sync_s_D;
		get_time_en_sync_1clk_s_C <= get_time_en_sync_s_C;
		end
end
//****************************************************

//*************************************************
//Modified by SYF 2014.5.28
always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		get_time_en_frt0_1clk_s_B <= 1'b0;
		get_time_en_frt0_1clk_s_A <= 1'b0;
		end
		else
		begin
		get_time_en_frt0_1clk_s_B <= get_time_en_frt0_s_B;
		get_time_en_frt0_1clk_s_A <= get_time_en_frt0_s_A;
		end
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		get_time_en_frt0_1clk_s_D <= 1'b0;
		get_time_en_frt0_1clk_s_C <= 1'b0;
		end
		else
		begin
		get_time_en_frt0_1clk_s_D <= get_time_en_frt0_s_D;
		get_time_en_frt0_1clk_s_C <= get_time_en_frt0_s_C;
		end
end
//****************************************************

//*************************************************
//Modified by SYF 2014.5.28
always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		o_get_time_en_frt0_s_D <= 1'b0;
		end
		else if((!get_time_en_frt0_1clk_s_D) && get_time_en_frt0_s_D)
		begin
		o_get_time_en_frt0_s_D <= 1'b1;
		end
		else
		begin
		o_get_time_en_frt0_s_D <= 1'b0;
		end
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		o_get_time_en_frt0_s_C <= 1'b0;
		end
		else if((!get_time_en_frt0_1clk_s_C) && get_time_en_frt0_s_C)
		begin
		o_get_time_en_frt0_s_C <= 1'b1;
		end
		else
		begin
		o_get_time_en_frt0_s_C <= 1'b0;
		end
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		o_get_time_en_frt0_s_B <= 1'b0;
		end
		else if((!get_time_en_frt0_1clk_s_B) && get_time_en_frt0_s_B)
		begin
		o_get_time_en_frt0_s_B <= 1'b1;
		end
		else
		begin
		o_get_time_en_frt0_s_B <= 1'b0;
		end
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		o_get_time_en_frt0_s_A <= 1'b0;
		end
		else if((!get_time_en_frt0_1clk_s_A) && get_time_en_frt0_s_A)
		begin
		o_get_time_en_frt0_s_A <= 1'b1;
		end
		else
		begin
		o_get_time_en_frt0_s_A <= 1'b0;
		end
end
//****************************************************


/*************sync time tamp***********/
//*************************************************
//Modified by SYF 2014.5.28
always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		o_get_time_en_sync_s_D <= 1'b0;
		end
		else if((!get_time_en_sync_1clk_s_D) && get_time_en_sync_s_D)
		begin
		o_get_time_en_sync_s_D <= 1'b1;
		end
		else
		begin
		o_get_time_en_sync_s_D <= 1'b0;
		end		
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		o_get_time_en_sync_s_C <= 1'b0;
		end
		else if((!get_time_en_sync_1clk_s_C) && get_time_en_sync_s_C)
		begin
		o_get_time_en_sync_s_C <= 1'b1;
		end
		else
		begin
		o_get_time_en_sync_s_C <= 1'b0;
		end		
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		o_get_time_en_sync_s_B <= 1'b0;
		end
		else if((!get_time_en_sync_1clk_s_B) && get_time_en_sync_s_B)
		begin
		o_get_time_en_sync_s_B <= 1'b1;
		end
		else
		begin
		o_get_time_en_sync_s_B <= 1'b0;
		end		
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		o_get_time_en_sync_s_A <= 1'b0;
		end
		else if((!get_time_en_sync_1clk_s_A) && get_time_en_sync_s_A)
		begin
		o_get_time_en_sync_s_A <= 1'b1;
		end
		else
		begin
		o_get_time_en_sync_s_A <= 1'b0;
		end		
end
/****************************************************************/

//*************************************************
//Modified by SYF 2014.5.28
always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		get_time_en_sync_1clk_m_B <= 1'b0;
		get_time_en_sync_1clk_m_A <= 1'b0;
		end
		else
		begin
		get_time_en_sync_1clk_m_B <= get_time_en_sync_m_B;
		get_time_en_sync_1clk_m_A <= get_time_en_sync_m_A;
		end
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		get_time_en_frt0_1clk_m_B <= 1'b0;
		get_time_en_frt0_1clk_m_A <= 1'b0;
		end
		else
		begin
		get_time_en_frt0_1clk_m_B <= get_time_en_frt0_m_B;
		get_time_en_frt0_1clk_m_A <= get_time_en_frt0_m_A;
		end
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		get_time_en_sync_1clk_m_D <= 1'b0;
		get_time_en_sync_1clk_m_C <= 1'b0;
		end
		else
		begin
		get_time_en_sync_1clk_m_D <= get_time_en_sync_m_D;
		get_time_en_sync_1clk_m_C <= get_time_en_sync_m_C;
		end
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		get_time_en_frt0_1clk_m_D <= 1'b0;
		get_time_en_frt0_1clk_m_C <= 1'b0;
		end
		else
		begin
		get_time_en_frt0_1clk_m_D <= get_time_en_frt0_m_D;
		get_time_en_frt0_1clk_m_C <= get_time_en_frt0_m_C;
		end
end
/****************************************************************/

//*************************************************
//Modified by SYF 2014.5.28
always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		o_get_time_en_frt0_m_D <= 1'b0;
		end
		else if((!get_time_en_frt0_1clk_m_D) && get_time_en_frt0_m_D)
		begin
		o_get_time_en_frt0_m_D <= 1'b1;
		end
		else
		begin
		o_get_time_en_frt0_m_D <= 1'b0;
		end
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		o_get_time_en_frt0_m_C <= 1'b0;
		end
		else if((!get_time_en_frt0_1clk_m_C) && get_time_en_frt0_m_C)
		begin
		o_get_time_en_frt0_m_C <= 1'b1;
		end
		else
		begin
		o_get_time_en_frt0_m_C <= 1'b0;
		end
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		o_get_time_en_frt0_m_B <= 1'b0;
		end
		else if((!get_time_en_frt0_1clk_m_B) && get_time_en_frt0_m_B)
		begin
		o_get_time_en_frt0_m_B <= 1'b1;
		end
		else
		begin
		o_get_time_en_frt0_m_B <= 1'b0;
		end
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		o_get_time_en_frt0_m_A <= 1'b0;
		end
		else if((!get_time_en_frt0_1clk_m_A) && get_time_en_frt0_m_A)
		begin
		o_get_time_en_frt0_m_A <= 1'b1;
		end
		else
		begin
		o_get_time_en_frt0_m_A <= 1'b0;
		end
end
/****************************************************************/

/*************sync time tamp***********/
//*************************************************
//Modified by SYF 2014.5.28
always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		o_get_time_en_sync_m_D <= 1'b0;
		end
		else if((!get_time_en_sync_1clk_m_D) && get_time_en_sync_m_D)
		begin
		o_get_time_en_sync_m_D <= 1'b1;
		end
		else
		begin
		o_get_time_en_sync_m_D <= 1'b0;
		end		
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		o_get_time_en_sync_m_C <= 1'b0;
		end
		else if((!get_time_en_sync_1clk_m_C) && get_time_en_sync_m_C)
		begin
		o_get_time_en_sync_m_C <= 1'b1;
		end
		else
		begin
		o_get_time_en_sync_m_C <= 1'b0;
		end		
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		o_get_time_en_sync_m_B <= 1'b0;
		end
		else if((!get_time_en_sync_1clk_m_B) && get_time_en_sync_m_B)
		begin
		o_get_time_en_sync_m_B <= 1'b1;
		end
		else
		begin
		o_get_time_en_sync_m_B <= 1'b0;
		end		
end

always @(posedge i_clk or negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
		o_get_time_en_sync_m_A <= 1'b0;
		end
		else if((!get_time_en_sync_1clk_m_A) && get_time_en_sync_m_A)
		begin
		o_get_time_en_sync_m_A <= 1'b1;
		end
		else
		begin
		o_get_time_en_sync_m_A <= 1'b0;
		end		
end
/****************************************************************/

reg wr_cache_en_A, wr_cache_en_A_1clk;       //Modified by SYF 2014.5.28
reg wr_cache_en_B, wr_cache_en_B_1clk;
reg wr_cache_en_C, wr_cache_en_C_1clk;       //Modified by SYF 2014.5.28
reg wr_cache_en_D, wr_cache_en_D_1clk;       //Modified by SYF 2014.5.28

reg [15:0] wr_cache_data_A, wr_cache_data_A_1clk, wr_cache_data_A_2clk, wr_cache_data_A_3clk;        //Modified by SYF 2014.5.28
reg [15:0] wr_cache_data_B, wr_cache_data_B_1clk, wr_cache_data_B_2clk, wr_cache_data_B_3clk;
reg [15:0] wr_cache_data_C, wr_cache_data_C_1clk, wr_cache_data_C_2clk, wr_cache_data_C_3clk;        //Modified by SYF 2014.5.28
reg [15:0] wr_cache_data_D, wr_cache_data_D_1clk, wr_cache_data_D_2clk, wr_cache_data_D_3clk;        //Modified by SYF 2014.5.28

reg [9:0] wr_cache_addr_A, wr_cache_addr_A_1clk, rd_cache_addr_A;          //Modified by SYF 2014.5.28
reg [9:0] wr_cache_addr_B, wr_cache_addr_B_1clk, rd_cache_addr_B;
reg [9:0] wr_cache_addr_C, wr_cache_addr_C_1clk, rd_cache_addr_C;          //Modified by SYF 2014.5.28
reg [9:0] wr_cache_addr_D, wr_cache_addr_D_1clk, rd_cache_addr_D;          //Modified by SYF 2014.5.28

wire [15:0] rd_cache_data_A;        //Modified by SYF 2014.5.28
wire [15:0] rd_cache_data_B;
wire [15:0] rd_cache_data_C;        //Modified by SYF 2014.5.28
wire [15:0] rd_cache_data_D;        //Modified by SYF 2014.5.28

reg frt_type, pdo_type;
reg [31:0] src_ip;
reg [47:0] src_mac;
reg [15:0] data_length;

reg valid_1clk, valid_2clk;
reg [9:0] rd_cache_addr_1clk, rd_cache_addr_2clk;

//reg  macrocycle_b_dly;

reg cache_data_send_flag_A, cache_data_send_flag_A_1clk;     //Modified by SYF 2014.5.28
reg cache_data_send_flag_B, cache_data_send_flag_B_1clk;
reg cache_data_send_flag_C, cache_data_send_flag_C_1clk;     //Modified by SYF 2014.5.28
reg cache_data_send_flag_D, cache_data_send_flag_D_1clk;     //Modified by SYF 2014.5.28

reg cache_data_send_irq, cache_data_send_down_A;      //Modified by SYF 2014.5.28
reg cache_data_send_down_B; 
reg cache_data_send_down_C;           //Modified by SYF 2014.5.28
reg cache_data_send_down_D;           //Modified by SYF 2014.5.28

reg  SendIrq_1clk, SendIrq_2clk;

/********** sjj Nov_14th *************/
reg [4:0] count_pre_num;

always @(posedge i_clk, negedge i_rst_n)
begin
		if(!i_rst_n)
		begin
			count_pre_num <= 5'b1; //sjj Nov_15th
		end
		else if(i_Rx_dv_A_rise)  //sjj Nov_15th
		begin
			count_pre_num <= 5'd1;		
		end
		else if((wr_cache_data_A == 16'h5) && (wr_cache_addr_A <= 10'h12) && (count_pre_num <= 10'd20)) //Modified by SYF 2014.5.29
		begin
			count_pre_num <= count_pre_num + 1'b1;
		end
		else
		begin
			count_pre_num <= count_pre_num;		
		end
end
/********** sjj Nov_14th *************/

//********************************************
//Modified by SYF 2014.5.28
always @(posedge i_clk, negedge i_rst_n)
begin
		if(!i_rst_n) 
			macrocycle_b_up_dly <= 1'b0;
		else
			macrocycle_b_up_dly <= i_macrocycle_b_up;
end

always @(posedge i_clk, negedge i_rst_n)
begin
		if(!i_rst_n) 
			macrocycle_b_down_dly <= 1'b0;
		else
			macrocycle_b_down_dly <= i_macrocycle_b_down;
end
//***********************************************


always @(posedge i_clk, negedge i_rst_n)
begin
    if(!i_rst_n)
	begin
	   valid_1clk <= 1'b0;
	   valid_2clk <= 1'b0;
		rd_cache_addr_1clk <= 10'h0;
		rd_cache_addr_2clk <= 10'h0;
		cache_data_send_flag_A_1clk <= 1'd0;              //Modified by SYF 2014.5.28
		cache_data_send_flag_B_1clk <= 1'd0;
		cache_data_send_flag_C_1clk <= 1'd0;              //Modified by SYF 2014.5.28
		cache_data_send_flag_D_1clk <= 1'd0;              //Modified by SYF 2014.5.28
	end
	else
	begin
	   valid_1clk <= i_data_valid;
		rd_cache_addr_1clk <= rd_cache_addr_A;                           //Modified by SYF 2014.5.29
		rd_cache_addr_2clk <= rd_cache_addr_1clk;
		cache_data_send_flag_A_1clk <= cache_data_send_flag_A;           //Modified by SYF 2014.5.28
		cache_data_send_flag_B_1clk <= cache_data_send_flag_B;
		cache_data_send_flag_C_1clk <= cache_data_send_flag_C;           //Modified by SYF 2014.5.28
		cache_data_send_flag_D_1clk <= cache_data_send_flag_D;           //Modified by SYF 2014.5.28
	end
end

always @ (posedge i_clk, negedge i_rst_n)
 begin
    if (!i_rst_n)
	 begin
		SendIrq_1clk <= 1'b0;
		SendIrq_2clk <= 1'b0;	
	 end	
	else 
	begin
		SendIrq_1clk <= i_SendIrq;
		SendIrq_2clk <= SendIrq_1clk;
	end
end

assign   SendIrq_rise = !SendIrq_2clk && i_SendIrq;


always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		cache_data_send_irq <= 1'b0;
	end
	else if (!cache_data_send_flag_A_1clk && cache_data_send_flag_A)    //Modified by SYF 2014.5.28
	begin
		cache_data_send_irq <= 1'b1;
	end
	else 
	begin
		cache_data_send_irq <= 1'b0;
	end
end

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

//********************************************
//Modified by SYF 2014.5.28
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		cache_data_send_down_C <= 1'b0;
	end
	else if (cache_data_send_flag_C_1clk && !cache_data_send_flag_C)
	begin
		cache_data_send_down_C <= 1'b1;
	end
	else 
	begin
		cache_data_send_down_C <= 1'b0;
	end
end

always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		cache_data_send_down_D <= 1'b0;
	end
	else if (cache_data_send_flag_D_1clk && !cache_data_send_flag_D)
	begin
		cache_data_send_down_D <= 1'b1;
	end
	else 
	begin
		cache_data_send_down_D <= 1'b0;
	end
end
//*******************************************

always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		frt_type <= 1'b0;
	end
	else if ((i_recv_addr == 10'd7) && i_data_valid && (i_recv_data == `EPA_TYPE))
	begin
		frt_type <= 1'b1;
	end
	else if (i_recv_addr == 10'h0)
	begin
		frt_type <= 1'b0;
	end
end


always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		pdo_type <= 1'b0;
	end
	else if ((i_recv_addr == 10'd8) && i_data_valid && (i_recv_data[15:12] == 4'h1) && frt_type)
	begin
		pdo_type <= 1'b1;
	end
	else if (i_recv_addr == 10'h0)
	begin
		pdo_type <= 1'b0;
	end
end



always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		data_length <= 16'b0;
	end
	else if ((i_recv_addr == 10'd12) && i_data_valid && frt_type && pdo_type)
	begin
		data_length <= i_recv_data;
	end
	else if(i_macrocycle_b_up && !macrocycle_b_up_dly)           //Modified by SYF 2014.5.28
	begin
		data_length <= 16'b0;
	end
end

//**********************************************
//Modified by SYF 2014.5.28

always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n) 
	begin
		wr_cache_en_D <= 1'b0;
		wr_cache_addr_D <= 10'b0; 	
		wr_cache_data_D <= 16'b0;
	end	
	else if(i_Rx_dv_D)
	begin
		wr_cache_en_D <= 1'b1;
		wr_cache_addr_D <= wr_cache_addr_D + 1'b1; 
		wr_cache_data_D <= i_recv_data_D;
	end		
	else if(i_Rx_dv_D_down_2 == 1'b1)   //sjj Nov_16th
	begin
		wr_cache_addr_D <= 10'd0; 	
	end			
	else if(!i_Rx_dv_D)
	begin
		wr_cache_en_D <= 1'b0;
		wr_cache_addr_D <= wr_cache_addr_D; 	
		wr_cache_data_D <= 16'b0; 
	end		
	else
	begin
		wr_cache_en_D <= wr_cache_en_D;
		wr_cache_addr_D <= wr_cache_addr_D; 	
		wr_cache_data_D <= wr_cache_data_D; 
	end
end

always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n) 
	begin
		wr_cache_en_C <= 1'b0;
		wr_cache_addr_C <= 10'b0; 	
		wr_cache_data_C <= 16'b0; 
	end
	else if(i_Rx_dv_C)
	begin
		wr_cache_en_C <= 1'b1;
		wr_cache_addr_C <= wr_cache_addr_C + 1'b1; 
		wr_cache_data_C <= i_recv_data_C;
	end			
	else if(i_Rx_dv_C_down_2 == 1'b1)   //sjj Nov_16th
	begin
		wr_cache_addr_C <= 10'd0; 	
	end			
	else if(!i_Rx_dv_C)
	begin
		wr_cache_en_C <= 1'b0;
		wr_cache_addr_C <= wr_cache_addr_C; 	
		wr_cache_data_C <= 16'b0; 
	end			
	else
	begin
		wr_cache_en_C <= wr_cache_en_C;
		wr_cache_addr_C <= wr_cache_addr_C; 	
		wr_cache_data_C <= wr_cache_data_C; 
	end
end

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
		wr_cache_data_B <= i_recv_data_B;
	end		
	else if(i_Rx_dv_B_down_2 == 1'b1)   //sjj Nov_16th
	begin
		wr_cache_addr_B <= 10'd0; 	
	end			
	else if(!i_Rx_dv_B)
	begin
		wr_cache_en_B <= 1'b0;
		wr_cache_addr_B <= wr_cache_addr_B; 	
		wr_cache_data_B <= 16'b0; 
	end		
	else
	begin
		wr_cache_en_B <= wr_cache_en_B;
		wr_cache_addr_B <= wr_cache_addr_B; 	
		wr_cache_data_B <= wr_cache_data_B; 
	end
end

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
		wr_cache_data_A <= i_recv_data_A;
	end			
	else if(i_Rx_dv_A_down_2 == 1'b1)   //sjj Nov_16th
	begin
		wr_cache_addr_A <= 10'd0; 	
	end			
	else if(!i_Rx_dv_A)
	begin
		wr_cache_en_A <= 1'b0;
		wr_cache_addr_A <= wr_cache_addr_A; 	
		wr_cache_data_A <= 16'b0; 
	end			
	else
	begin
		wr_cache_en_A <= wr_cache_en_A;
		wr_cache_addr_A <= wr_cache_addr_A; 	
		wr_cache_data_A <= wr_cache_data_A; 
	end
end
//**********************************************

//generate i_link_valid_A & i_link_valid_B 's down edge
reg i_link_valid_A_clk, i_link_valid_B_clk, i_link_valid_C_clk, i_link_valid_D_clk;        //Modified by SYF 2014.5.28
reg i_link_valid_A_1clk, i_link_valid_B_1clk, i_link_valid_C_1clk, i_link_valid_D_1clk;    //Modified by SYF 2014.5.28

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_link_valid_A_clk <= 1'b0;
		i_link_valid_B_clk <= 1'b0;
		i_link_valid_C_clk <= 1'b0;       //Modified by SYF 2014.5.28
		i_link_valid_D_clk <= 1'b0;       //Modified by SYF 2014.5.28
	 end
	 else
	 begin
		i_link_valid_A_clk <= i_link_valid_A;
		i_link_valid_B_clk <= i_link_valid_B;
		i_link_valid_C_clk <= i_link_valid_C;   //Modified by SYF 2014.5.28
		i_link_valid_D_clk <= i_link_valid_D;	 //Modified by SYF 2014.5.28
	 end
end

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_link_valid_A_1clk <= 1'b0;
		i_link_valid_B_1clk <= 1'b0;
		i_link_valid_C_1clk <= 1'b0;         //Modified by SYF 2014.5.28
		i_link_valid_D_1clk <= 1'b0;	       //Modified by SYF 2014.5.28
	 end
	 else
	 begin
		i_link_valid_A_1clk <= i_link_valid_A_clk;
		i_link_valid_B_1clk <= i_link_valid_B_clk;
		i_link_valid_C_1clk <= i_link_valid_C_clk;         //Modified by SYF 2014.5.28
		i_link_valid_D_1clk <= i_link_valid_D_clk;         //Modified by SYF 2014.5.28
	 end
end

reg i_link_valid_A_2clk, i_link_valid_B_2clk, i_link_valid_C_2clk, i_link_valid_D_2clk;    //Modified by SYF 2014.5.28

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_link_valid_A_2clk <= 1'b0;
		i_link_valid_B_2clk <= 1'b0;
		i_link_valid_C_2clk <= 1'b0;                       //Modified by SYF 2014.5.28
		i_link_valid_D_2clk <= 1'b0;                       //Modified by SYF 2014.5.28
	 end
	 else
	 begin
		i_link_valid_A_2clk <= i_link_valid_A_1clk;
		i_link_valid_B_2clk <= i_link_valid_B_1clk;
		i_link_valid_C_2clk <= i_link_valid_C_1clk;        //Modified by SYF 2014.5.28
		i_link_valid_D_2clk <= i_link_valid_D_1clk;	      //Modified by SYF 2014.5.28
	 end
end

reg i_link_valid_A_down, i_link_valid_B_down, i_link_valid_C_down, i_link_valid_D_down;   //Modified by SYF 2014.5.28

always @ (posedge i_clk, negedge i_rst_n)       //Modified by SYF 2014.5.28
begin
    if (!i_rst_n)
	 begin
		i_link_valid_D_down <= 1'b0;
	 end
	 else if(!i_link_valid_D && i_link_valid_D_1clk)
	 begin
		i_link_valid_D_down <= 1'b1;
	 end
	 else
	 begin
		i_link_valid_D_down <= 1'b0;
	 end
end

always @ (posedge i_clk, negedge i_rst_n)       //Modified by SYF 2014.5.28
begin
    if (!i_rst_n)
	 begin
		i_link_valid_C_down <= 1'b0;
	 end
	 else if(!i_link_valid_C && i_link_valid_C_1clk)
	 begin
		i_link_valid_C_down <= 1'b1;
	 end
	 else
	 begin
		i_link_valid_C_down <= 1'b0;
	 end
end

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_link_valid_B_down <= 1'b0;
	 end
	 else if(!i_link_valid_B && i_link_valid_B_1clk)
	 begin
		i_link_valid_B_down <= 1'b1;
	 end
	 else
	 begin
		i_link_valid_B_down <= 1'b0;
	 end
end

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_link_valid_A_down <= 1'b0;
	 end
	 else if(!i_link_valid_A && i_link_valid_A_1clk)
	 begin
		i_link_valid_A_down <= 1'b1;
	 end
	 else
	 begin
		i_link_valid_A_down <= 1'b0;
	 end
end

//generate o_Tx_en_A & o_Tx_en_B 's down edge
reg o_Tx_en_A_1clk;

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		o_Tx_en_A_1clk <= 1'b0;
	 end
	 else
	 begin
		o_Tx_en_A_1clk <= o_Tx_en_A;
	 end
end

reg o_Tx_en_A_down;

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		o_Tx_en_A_down <= 1'b0;
	 end
	 else if(!o_Tx_en_A && o_Tx_en_A_1clk)
	 begin
		o_Tx_en_A_down <= 1'b1;
	 end
	 else
	 begin
		o_Tx_en_A_down <= 1'b0;	 
	 end
end

reg o_Tx_en_B_1clk;

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		o_Tx_en_B_1clk <= 1'b0;
	 end
	 else
	 begin
		o_Tx_en_B_1clk <= o_Tx_en_B;
	 end
end

reg o_Tx_en_B_down;

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		o_Tx_en_B_down <= 1'b0;
	 end
	 else if(!o_Tx_en_B && o_Tx_en_B_1clk)
	 begin
		o_Tx_en_B_down <= 1'b1;
	 end
	 else
	 begin
		o_Tx_en_B_down <= 1'b0;	 
	 end
end

reg o_Tx_en_C_1clk;                            //Modified by SYF 2014.5.28

always @ (posedge i_clk, negedge i_rst_n)       //Modified by SYF 2014.5.28
begin
    if (!i_rst_n)
	 begin
		o_Tx_en_C_1clk <= 1'b0;
	 end
	 else
	 begin
		o_Tx_en_C_1clk <= o_Tx_en_C;
	 end
end

reg o_Tx_en_C_down;                            //Modified by SYF 2014.5.28

always @ (posedge i_clk, negedge i_rst_n)       //Modified by SYF 2014.5.28
begin
    if (!i_rst_n)
	 begin
		o_Tx_en_C_down <= 1'b0;
	 end
	 else if(!o_Tx_en_C && o_Tx_en_C_1clk)
	 begin
		o_Tx_en_C_down <= 1'b1;
	 end
	 else
	 begin
		o_Tx_en_C_down <= 1'b0;	 
	 end
end

reg o_Tx_en_D_1clk;                            //Modified by SYF 2014.5.28

always @ (posedge i_clk, negedge i_rst_n)       //Modified by SYF 2014.5.28
begin
    if (!i_rst_n)
	 begin
		o_Tx_en_D_1clk <= 1'b0;
	 end
	 else
	 begin
		o_Tx_en_D_1clk <= o_Tx_en_D;
	 end
end

reg o_Tx_en_D_down;                            //Modified by SYF 2014.5.28

always @ (posedge i_clk, negedge i_rst_n)       //Modified by SYF 2014.5.28
begin
    if (!i_rst_n)
	 begin
		o_Tx_en_D_down <= 1'b0;
	 end
	 else if(!o_Tx_en_D && o_Tx_en_D_1clk)
	 begin
		o_Tx_en_D_down <= 1'b1;
	 end
	 else
	 begin
		o_Tx_en_D_down <= 1'b0;	 
	 end
end

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

//***************************************
//Modified by SYF 2014.5.28
parameter IDLE_C                  = 5'd0;
parameter WAIT_IFG_C              = 5'd1;
parameter SEND_START_C            = 5'd2;
parameter SEND_1DATA_C            = 5'd3;
parameter SEND_OVER_C             = 5'd4;

parameter IDLE_D                  = 5'd0;
parameter WAIT_IFG_D              = 5'd1;
parameter SEND_START_D            = 5'd2;
parameter SEND_1DATA_D            = 5'd3;
parameter SEND_OVER_D             = 5'd4;
//***************************************

reg [4:0] Nextstate_A;                  //Modified by SYF 2014.5.28
reg [4:0] State_A;                      //Modified by SYF 2014.5.28

reg [4:0] Nextstate_B;
reg [4:0] State_B;

//***************************************
//Modified by SYF 2014.5.28
reg [4:0] Nextstate_C;
reg [4:0] State_C;

reg [4:0] Nextstate_D;
reg [4:0] State_D;
//***************************************

reg [3:0] dmi_buffer_data_A;     //Modified by SYF 2014.5.28
reg [3:0] dmi_buffer_data_B;
reg [3:0] dmi_buffer_data_C;     //Modified by SYF 2014.5.28
reg [3:0] dmi_buffer_data_D;     //Modified by SYF 2014.5.28
 
reg [7:0] ifg_num_A;             //Modified by SYF 2014.5.28
reg [7:0] ifg_num_B;
reg [7:0] ifg_num_C;             //Modified by SYF 2014.5.28
reg [7:0] ifg_num_D;             //Modified by SYF 2014.5.28

reg [9:0] i_recv_addr_1clk, i_recv_addr_2clk;
reg i_recv_addr_rise;

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_recv_addr_1clk <= 1'b0;
		i_recv_addr_2clk <= 1'b0;
	 end
	 else
	 begin
		i_recv_addr_1clk <= i_recv_addr;	 
		i_recv_addr_2clk <= i_recv_addr_1clk;	 
	 end		
end

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_recv_addr_rise <= 1'b0;
	 end
	 else if((i_recv_addr == 10'd1) && (i_recv_addr_2clk == 10'd0))
	 begin
		i_recv_addr_rise <= 1'b1; 
	 end	
	 else if((i_recv_addr == 10'd2) && (i_recv_addr_2clk == 10'd0))
	 begin
		i_recv_addr_rise <= 1'b1; 
	 end	
	 else
	 begin
		i_recv_addr_rise <= 1'b0;		
	 end	
end


always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		wr_cache_en_A_1clk <= 1'b0;
	 end
	 else
	 begin
		wr_cache_en_A_1clk <= wr_cache_en_A;	 
	 end		
end

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		wr_cache_data_A_1clk <= 1'b0;
		wr_cache_data_A_2clk <= 1'b0;
		wr_cache_data_A_3clk <= 1'b0;
	 end
	 else
	 begin
		wr_cache_data_A_1clk <= wr_cache_data_A;	      //Modified by SYF 2014.5.29
		wr_cache_data_A_2clk <= wr_cache_data_A_1clk;
		wr_cache_data_A_3clk <= wr_cache_data_A_2clk;
	 end		
end

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		wr_cache_addr_A_1clk <= 1'b0;              //Modified by SYF 2014.5.29
	 end
	 else
	 begin
		wr_cache_addr_A_1clk <= wr_cache_addr_A;	 //Modified by SYF 2014.5.29
	 end		
end


//generate i_Rx_Dv_A_rise
reg i_Rx_dv_A_1clk, i_Rx_dv_A_2clk;
reg i_Rx_dv_A_rise;
reg i_Rx_dv_A_down, i_Rx_dv_A_down_2;
reg [9:0] recv_whole_package_length_A;    //Modified by SYF 2014.5.28
reg [9:0] recv_whole_package_length_B;
reg [9:0] recv_whole_package_length_C;    //Modified by SYF 2014.5.28
reg [9:0] recv_whole_package_length_D;    //Modified by SYF 2014.5.28

//generate i_Rx_Dv_B_rise
reg i_Rx_dv_B_1clk, i_Rx_dv_B_2clk;
reg i_Rx_dv_B_rise;
reg i_Rx_dv_B_down, i_Rx_dv_B_down_2;

//********************************************
//Modified by SYF 2014.5.28
//generate i_Rx_Dv_C_rise
reg i_Rx_dv_C_1clk, i_Rx_dv_C_2clk;
reg i_Rx_dv_C_rise;
reg i_Rx_dv_C_down, i_Rx_dv_C_down_2;

//generate i_Rx_Dv_D_rise
reg i_Rx_dv_D_1clk, i_Rx_dv_D_2clk;
reg i_Rx_dv_D_rise;
reg i_Rx_dv_D_down, i_Rx_dv_D_down_2;
//********************************************

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_Rx_dv_A_1clk <= 1'b0;
		i_Rx_dv_A_2clk <= 1'b0;
	 end
	 else
	 begin
		i_Rx_dv_A_1clk <= i_Rx_dv_A;
		i_Rx_dv_A_2clk <= i_Rx_dv_A_1clk;		
	 end		
end


always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_Rx_dv_B_1clk <= 1'b0;
		i_Rx_dv_B_2clk <= 1'b0;
	 end
	 else
	 begin
		i_Rx_dv_B_1clk <= i_Rx_dv_B;
		i_Rx_dv_B_2clk <= i_Rx_dv_B_1clk;		
	 end		
end

//************************************************
//Modified by SYF 2014.5.28
always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_Rx_dv_C_1clk <= 1'b0;
		i_Rx_dv_C_2clk <= 1'b0;
	 end
	 else
	 begin
		i_Rx_dv_C_1clk <= i_Rx_dv_C;
		i_Rx_dv_C_2clk <= i_Rx_dv_C_1clk;		
	 end		
end

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_Rx_dv_D_1clk <= 1'b0;
		i_Rx_dv_D_2clk <= 1'b0;
	 end
	 else
	 begin
		i_Rx_dv_D_1clk <= i_Rx_dv_D;
		i_Rx_dv_D_2clk <= i_Rx_dv_D_1clk;		
	 end		
end
//*******************************************

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_Rx_dv_A_rise <= 1'b0;
	 end
	 else if(i_Rx_dv_A && !i_Rx_dv_A_1clk)
	 begin
		i_Rx_dv_A_rise <= 1'b1;	 
	 end
	 else
	 begin
		i_Rx_dv_A_rise <= 1'b0;	 
	 end
end

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_Rx_dv_B_rise <= 1'b0;
	 end
	 else if(i_Rx_dv_B && !i_Rx_dv_B_1clk)
	 begin
		i_Rx_dv_B_rise <= 1'b1;	 
	 end
	 else
	 begin
		i_Rx_dv_B_rise <= 1'b0;	 
	 end
end

//**********************************************
//Modified by SYF 2014.5.28
always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_Rx_dv_C_rise <= 1'b0;
	 end
	 else if(i_Rx_dv_C && !i_Rx_dv_C_1clk)
	 begin
		i_Rx_dv_C_rise <= 1'b1;	 
	 end
	 else
	 begin
		i_Rx_dv_C_rise <= 1'b0;	 
	 end
end

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_Rx_dv_D_rise <= 1'b0;
	 end
	 else if(i_Rx_dv_D && !i_Rx_dv_D_1clk)
	 begin
		i_Rx_dv_D_rise <= 1'b1;	 
	 end
	 else
	 begin
		i_Rx_dv_D_rise <= 1'b0;	 
	 end
end
//****************************************

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_Rx_dv_A_down <= 1'b0;
	 end
	 else if(!i_Rx_dv_A && i_Rx_dv_A_1clk)
	 begin
		i_Rx_dv_A_down <= 1'b1;	 
	 end
	 else
	 begin
		i_Rx_dv_A_down <= 1'b0;	 
	 end
end

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_Rx_dv_B_down <= 1'b0;
	 end
	 else if(!i_Rx_dv_B && i_Rx_dv_B_1clk)
	 begin
		i_Rx_dv_B_down <= 1'b1;	 
	 end
	 else
	 begin
		i_Rx_dv_B_down <= 1'b0;	 
	 end
end

//***************************************
//Modified by SYF 2014.5.28
always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_Rx_dv_C_down <= 1'b0;
	 end
	 else if(!i_Rx_dv_C && i_Rx_dv_C_1clk)
	 begin
		i_Rx_dv_C_down <= 1'b1;	 
	 end
	 else
	 begin
		i_Rx_dv_C_down <= 1'b0;	 
	 end
end

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_Rx_dv_D_down <= 1'b0;
	 end
	 else if(!i_Rx_dv_D && i_Rx_dv_D_1clk)
	 begin
		i_Rx_dv_D_down <= 1'b1;	 
	 end
	 else
	 begin
		i_Rx_dv_D_down <= 1'b0;	 
	 end
end
//*****************************************

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_Rx_dv_A_down_2 <= 1'b0;
	 end
	 else if(!i_Rx_dv_A_1clk && i_Rx_dv_A_2clk)
	 begin
		i_Rx_dv_A_down_2 <= 1'b1;	 
	 end
	 else
	 begin
		i_Rx_dv_A_down_2 <= 1'b0;	 
	 end
end

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_Rx_dv_B_down_2 <= 1'b0;
	 end
	 else if(!i_Rx_dv_B_1clk && i_Rx_dv_B_2clk)
	 begin
		i_Rx_dv_B_down_2 <= 1'b1;	 
	 end
	 else
	 begin
		i_Rx_dv_B_down_2 <= 1'b0;	 
	 end
end

//***********************************************
//Modified by SYF 2014.5.28
always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_Rx_dv_C_down_2 <= 1'b0;
	 end
	 else if(!i_Rx_dv_C_1clk && i_Rx_dv_C_2clk)
	 begin
		i_Rx_dv_C_down_2 <= 1'b1;	 
	 end
	 else
	 begin
		i_Rx_dv_C_down_2 <= 1'b0;	 
	 end
end

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		i_Rx_dv_D_down_2 <= 1'b0;
	 end
	 else if(!i_Rx_dv_D_1clk && i_Rx_dv_D_2clk)
	 begin
		i_Rx_dv_D_down_2 <= 1'b1;	 
	 end
	 else
	 begin
		i_Rx_dv_D_down_2 <= 1'b0;	 
	 end
end
//*******************************************

//check the type of packet   sjj Nov_22nd

reg [15:0] packet_type_A;

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		packet_type_A <= 16'b0;
	 end
	 else if(wr_cache_addr_A == 10'h28)              //Modified by SYF 2014.5.28
	 begin
		packet_type_A[11:8] <= i_recv_data_A[3:0];	 
	 end
	 else if(wr_cache_addr_A == 10'h29)              //Modified by SYF 2014.5.28
	 begin
		packet_type_A[15:12] <= i_recv_data_A[3:0];	 
	 end
	 else if(wr_cache_addr_A == 10'h2a)              //Modified by SYF 2014.5.28
	 begin
		packet_type_A[3:0] <= i_recv_data_A[3:0];	 
	 end
	 else if(wr_cache_addr_A == 10'h2b)              //Modified by SYF 2014.5.28
	 begin
		packet_type_A[7:4] <= i_recv_data_A[3:0];	 
	 end
	 else if(i_Rx_dv_B_down || i_Rx_dv_A_down)
	 begin
		packet_type_A <= 16'b0;
	 end
	 else
	 begin
		packet_type_A <= packet_type_A;	 
	 end
end


reg [15:0] packet_type_B;

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		packet_type_B <= 16'b0;
	 end
	 else if(wr_cache_addr_B == 10'h28)
	 begin
		packet_type_B[11:8] <= i_recv_data_B[3:0];	 
	 end
	 else if(wr_cache_addr_B == 10'h29)
	 begin
		packet_type_B[15:12] <= i_recv_data_B[3:0];	 
	 end
	 else if(wr_cache_addr_B == 10'h2a)
	 begin
		packet_type_B[3:0] <= i_recv_data_B[3:0];	 
	 end
	 else if(wr_cache_addr_B == 10'h2b)
	 begin
		packet_type_B[7:4] <= i_recv_data_B[3:0];	 
	 end
	 else if(i_Rx_dv_B_down || i_Rx_dv_A_down)
	 begin
		packet_type_B <= 16'b0;
	 end
	 else
	 begin
		packet_type_B <= packet_type_B;	 
	 end
end

//***************************************************
//Modified by SYF 2014.5.28
reg [15:0] packet_type_C;

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		packet_type_C <= 16'b0;
	 end
	 else if(wr_cache_addr_C == 10'h28)
	 begin
		packet_type_C[11:8] <= i_recv_data_C[3:0];	 
	 end
	 else if(wr_cache_addr_C == 10'h29)
	 begin
		packet_type_C[15:12] <= i_recv_data_C[3:0];	 
	 end
	 else if(wr_cache_addr_C == 10'h2a)
	 begin
		packet_type_C[3:0] <= i_recv_data_C[3:0];	 
	 end
	 else if(wr_cache_addr_C == 10'h2b)
	 begin
		packet_type_C[7:4] <= i_recv_data_C[3:0];	 
	 end
	 else if(i_Rx_dv_D_down || i_Rx_dv_C_down)
	 begin
		packet_type_C <= 16'b0;
	 end
	 else
	 begin
		packet_type_C <= packet_type_C;	 
	 end
end


reg [15:0] packet_type_D;

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		packet_type_D <= 16'b0;
	 end
	 else if(wr_cache_addr_D == 10'h28)
	 begin
		packet_type_D[11:8] <= i_recv_data_D[3:0];	 
	 end
	 else if(wr_cache_addr_D == 10'h29)
	 begin
		packet_type_D[15:12] <= i_recv_data_D[3:0];	 
	 end
	 else if(wr_cache_addr_D == 10'h2a)
	 begin
		packet_type_D[3:0] <= i_recv_data_D[3:0];	 
	 end
	 else if(wr_cache_addr_D == 10'h2b)
	 begin
		packet_type_D[7:4] <= i_recv_data_D[3:0];	 
	 end
	 else if(i_Rx_dv_D_down || i_Rx_dv_C_down)
	 begin
		packet_type_D <= 16'b0;
	 end
	 else
	 begin
		packet_type_D <= packet_type_D;	 
	 end
end
//****************************************************

//distinguish recv_packet_from_A, recv_packet_from_B

reg recv_packet_from_A, recv_packet_from_B, recv_packet_from_C, recv_packet_from_D;   //Modified by SYF 2014.5.28
always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		recv_packet_from_A <= 1'b0;
		recv_packet_from_B <= 1'b0;
	 end
	 else if(i_Rx_dv_A && (packet_type_A == 16'h8907) && (src_MAC_A != i_local_node_mac))
	 begin
		recv_packet_from_A <= 1'b1; 
	 end
	 else if(i_Rx_dv_B && (packet_type_B == 16'h8907) && (src_MAC_B != i_local_node_mac))
	 begin
		recv_packet_from_B <= 1'b1; 
	 end
	 else if(src_MAC_A == i_local_node_mac)
	 begin
		recv_packet_from_A <= 1'b0;
		recv_packet_from_B <= 1'b0;  	 
	 end
	 else if(src_MAC_B == i_local_node_mac)             //Modified by SYF 2014.6.13
	 begin
		recv_packet_from_A <= 1'b0;
		recv_packet_from_B <= 1'b0;  	 
	 end
	 else if(cache_data_send_down_A && (src_MAC_A != i_local_node_mac))                       //Modified by SYF 2014.5.28
	 begin
		recv_packet_from_A <= 1'b0;
		recv_packet_from_B <= 1'b0;  
	 end
	 else if(cache_data_send_down_B && (src_MAC_B != i_local_node_mac))                       //Modified by SYF 2014.5.28
	 begin
		recv_packet_from_A <= 1'b0;
		recv_packet_from_B <= 1'b0;  
	 end
	 else
	 begin
		recv_packet_from_A <= recv_packet_from_A;	 
		recv_packet_from_B <= recv_packet_from_B;	
	 end
end

//********************************************
//Modified by SYF 2014.5.28
always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		recv_packet_from_C <= 1'b0;
		recv_packet_from_D <= 1'b0;		
	 end
	 else if(i_Rx_dv_C && (packet_type_C == 16'h8907) && (src_MAC_C != i_local_node_mac))
	 begin
		recv_packet_from_C <= 1'b1; 
	 end
	 else if(i_Rx_dv_D && (packet_type_D == 16'h8907) && (src_MAC_D != i_local_node_mac))
	 begin
		recv_packet_from_D <= 1'b1; 
	 end
	 else if(src_MAC_C == i_local_node_mac)
	 begin
		recv_packet_from_C <= 1'b0;
		recv_packet_from_D <= 1'b0;  	 
	 end
	 else if(cache_data_send_down_C && (src_MAC_C != i_local_node_mac)) //sjj Dec_1st
	 begin
		recv_packet_from_C <= 1'b0;
		recv_packet_from_D <= 1'b0;  
	 end
	 else if(cache_data_send_down_D && (src_MAC_D != i_local_node_mac)) //sjj Dec_1st
	 begin
		recv_packet_from_C <= 1'b0;
		recv_packet_from_D <= 1'b0;  
	 end	 
	 else
	 begin
		recv_packet_from_C <= recv_packet_from_C;	 
		recv_packet_from_D <= recv_packet_from_D;	
	 end
end
//********************************************

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		recv_whole_package_length_A <= 10'd1518;
	 end
	 else if(i_Rx_dv_A_rise)
	 begin
		recv_whole_package_length_A <= 10'd1518;
	 end
	 else if(i_Rx_dv_A_down == 1'b1)
	 begin
		recv_whole_package_length_A <= wr_cache_addr_A;	 
	 end
	 else
	 begin
		recv_whole_package_length_A <= recv_whole_package_length_A;	
	 end
end


always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
//		recv_whole_package_length_B <= 10'b0;
		recv_whole_package_length_B <= 10'd1518;
	 end
	 else if(i_Rx_dv_B_rise)
	 begin
		recv_whole_package_length_B <= 10'd1518;
	 end
	 else if(i_Rx_dv_B_down == 1'b1)
	 begin
		recv_whole_package_length_B <= wr_cache_addr_B;	 
	 end
	 else
	 begin
		recv_whole_package_length_B <= recv_whole_package_length_B;		
	 end
end

//***********************************************
//Modified by SYF 2014.5.28
always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
//		recv_whole_package_length <= 10'b0;
		recv_whole_package_length_C <= 10'd200;
	 end
	 else if(i_Rx_dv_C_rise)
	 begin
		recv_whole_package_length_C <= 10'd200;
	 end
	 else if(i_Rx_dv_C_down == 1'b1)
	 begin
		recv_whole_package_length_C <= wr_cache_addr_C;	 
	 end
	 else
	 begin
		recv_whole_package_length_C <= recv_whole_package_length_C;	
	 end
end

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
//		recv_whole_package_length_B <= 10'b0;
		recv_whole_package_length_D <= 10'd200;
	 end
	 else if(i_Rx_dv_D_rise)
	 begin
		recv_whole_package_length_D <= 10'd200;
	 end
	 else if(i_Rx_dv_D_down == 1'b1)
	 begin
		recv_whole_package_length_D <= wr_cache_addr_D;	 
	 end
	 else
	 begin
		recv_whole_package_length_D <= recv_whole_package_length_D;		
	 end
end
//***********************************************

//test_for_catching MM packet

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		mm_packet_trig <= 1'b0;
	 end
	 else if((wr_cache_addr_A == 10'h2d) && (wr_cache_data_A == 16'd6))     //Modified by SYF 2014.5.29
	 begin
		mm_packet_trig <= 1'b1;	 
	 end
	 else
	 begin
		mm_packet_trig <= 1'b0;	 
	 end
end


//get source MAC from port"A" or port"B"
//get src_MAC_A
reg [47:0] src_MAC_A;

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		src_MAC_A <= 48'b0;
	 end
	 else if(wr_cache_addr_A == 10'h1d)               //Modified by SYF 2014.5.28
	 begin
		src_MAC_A[43:40] <= wr_cache_data_A[3:0];	     //Modified by SYF 2014.5.28
	 end
	 else if(wr_cache_addr_A == 10'h1e)               //Modified by SYF 2014.5.28
	 begin
		src_MAC_A[47:44] <= wr_cache_data_A[3:0];	     //Modified by SYF 2014.5.28
	 end
	 else if(wr_cache_addr_A == 10'h1f)               //Modified by SYF 2014.5.28
	 begin
		src_MAC_A[35:32] <= wr_cache_data_A[3:0];	     //Modified by SYF 2014.5.28
	 end
	 else if(wr_cache_addr_A == 10'h20)               //Modified by SYF 2014.5.28
	 begin
		src_MAC_A[39:36] <= wr_cache_data_A[3:0];	     //Modified by SYF 2014.5.28
	 end
	 else if(wr_cache_addr_A == 10'h21)               //Modified by SYF 2014.5.28
	 begin
		src_MAC_A[27:24] <= wr_cache_data_A[3:0];	     //Modified by SYF 2014.5.28
	 end
	 else if(wr_cache_addr_A == 10'h22)               //Modified by SYF 2014.5.28
	 begin
		src_MAC_A[31:28] <= wr_cache_data_A[3:0];	     //Modified by SYF 2014.5.28
	 end
	 else if(wr_cache_addr_A == 10'h23)               //Modified by SYF 2014.5.28
	 begin
		src_MAC_A[19:16] <= wr_cache_data_A[3:0];	     //Modified by SYF 2014.5.28
	 end	 
	 else if(wr_cache_addr_A == 10'h24)               //Modified by SYF 2014.5.28
	 begin
		src_MAC_A[23:20] <= wr_cache_data_A[3:0];	     //Modified by SYF 2014.5.28
	 end		 
	 else if(wr_cache_addr_A == 10'h25)               //Modified by SYF 2014.5.28
	 begin
		src_MAC_A[11:8] <= wr_cache_data_A[3:0];	     //Modified by SYF 2014.5.28
	 end	 
	 else if(wr_cache_addr_A == 10'h26)               //Modified by SYF 2014.5.28
	 begin
		src_MAC_A[15:12] <= wr_cache_data_A[3:0];	     //Modified by SYF 2014.5.28
	 end	 
	 else if(wr_cache_addr_A == 10'h27)               //Modified by SYF 2014.5.28
	 begin
		src_MAC_A[3:0] <= wr_cache_data_A[3:0];	     //Modified by SYF 2014.5.28
	 end		 
	 else if(wr_cache_addr_A == 10'h28)               //Modified by SYF 2014.5.28
	 begin
		src_MAC_A[7:4] <= wr_cache_data_A[3:0];	     //Modified by SYF 2014.5.28
	 end	 
	 else if(cache_data_send_down_A)                  //Modified by SYF 2014.5.28
	 begin
		src_MAC_A <= 48'b0;	 
	 end
	 else
	 begin
		src_MAC_A <= src_MAC_A;	 
	 end
end

//src_MAC_B
reg [47:0] src_MAC_B;

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		src_MAC_B <= 48'b0;
	 end
	 else if(wr_cache_addr_B == 10'h1d)
	 begin
		src_MAC_B[43:40] <= wr_cache_data_B[3:0];	 
	 end
	 else if(wr_cache_addr_B == 10'h1e)
	 begin
		src_MAC_B[47:44] <= wr_cache_data_B[3:0];	 
	 end
	 else if(wr_cache_addr_B == 10'h1f)
	 begin
		src_MAC_B[35:32] <= wr_cache_data_B[3:0];	 
	 end
	 else if(wr_cache_addr_B == 10'h20)
	 begin
		src_MAC_B[39:36] <= wr_cache_data_B[3:0];	 
	 end
	 else if(wr_cache_addr_B == 10'h21)
	 begin
		src_MAC_B[27:24] <= wr_cache_data_B[3:0];	 
	 end
	 else if(wr_cache_addr_B == 10'h22)
	 begin
		src_MAC_B[31:28] <= wr_cache_data_B[3:0];	 
	 end
	 else if(wr_cache_addr_B == 10'h23)
	 begin
		src_MAC_B[19:16] <= wr_cache_data_B[3:0];	 
	 end	 
	 else if(wr_cache_addr_B == 10'h24)
	 begin
		src_MAC_B[23:20] <= wr_cache_data_B[3:0];	 
	 end		 
	 else if(wr_cache_addr_B == 10'h25)
	 begin
		src_MAC_B[11:8] <= wr_cache_data_B[3:0];	 
	 end	 
	 else if(wr_cache_addr_B == 10'h26)
	 begin
		src_MAC_B[15:12] <= wr_cache_data_B[3:0];	 
	 end	 
	 else if(wr_cache_addr_B == 10'h27)
	 begin
		src_MAC_B[3:0] <= wr_cache_data_B[3:0];	 
	 end		 
	 else if(wr_cache_addr_B == 10'h28)
	 begin
		src_MAC_B[7:4] <= wr_cache_data_B[3:0];	 
	 end	 
	 else if(cache_data_send_down_B)
	 begin
		src_MAC_B <= 48'b0;	 
	 end
	 else
	 begin
		src_MAC_B <= src_MAC_B;	 
	 end
end

//******************************************************
//Modified by SYF 2014.5.28
reg [47:0] src_MAC_C;

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		src_MAC_C <= 48'b0;
	 end
	 else if(wr_cache_addr_C == 10'h1d)
	 begin
		src_MAC_C[43:40] <= wr_cache_data_C[3:0];	 
	 end
	 else if(wr_cache_addr_C == 10'h1e)
	 begin
		src_MAC_C[47:44] <= wr_cache_data_C[3:0];	 
	 end
	 else if(wr_cache_addr_C == 10'h1f)
	 begin
		src_MAC_C[35:32] <= wr_cache_data_C[3:0];	 
	 end
	 else if(wr_cache_addr_C == 10'h20)
	 begin
		src_MAC_C[39:36] <= wr_cache_data_C[3:0];	 
	 end
	 else if(wr_cache_addr_C == 10'h21)
	 begin
		src_MAC_C[27:24] <= wr_cache_data_C[3:0];	 
	 end
	 else if(wr_cache_addr_C == 10'h22)
	 begin
		src_MAC_C[31:28] <= wr_cache_data_C[3:0];	 
	 end
	 else if(wr_cache_addr_C == 10'h23)
	 begin
		src_MAC_C[19:16] <= wr_cache_data_C[3:0];	 
	 end	 
	 else if(wr_cache_addr_C == 10'h24)
	 begin
		src_MAC_C[23:20] <= wr_cache_data_C[3:0];	 
	 end		 
	 else if(wr_cache_addr_C == 10'h25)
	 begin
		src_MAC_C[11:8] <= wr_cache_data_C[3:0];	 
	 end	 
	 else if(wr_cache_addr_C == 10'h26)
	 begin
		src_MAC_C[15:12] <= wr_cache_data_C[3:0];	 
	 end	 
	 else if(wr_cache_addr_C == 10'h27)
	 begin
		src_MAC_C[3:0] <= wr_cache_data_C[3:0];	 
	 end		 
	 else if(wr_cache_addr_C == 10'h28)
	 begin
		src_MAC_C[7:4] <= wr_cache_data_C[3:0];	 
	 end	 
	 else if(cache_data_send_down_C)
	 begin
		src_MAC_C <= 48'b0;	 
	 end
	 else
	 begin
		src_MAC_C <= src_MAC_C;	 
	 end
end

//src_MAC_B
reg [47:0] src_MAC_D;

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
	 begin
		src_MAC_D <= 48'b0;
	 end
	 else if(wr_cache_addr_D == 10'h1d)
	 begin
		src_MAC_D[43:40] <= wr_cache_data_D[3:0];	 
	 end
	 else if(wr_cache_addr_D == 10'h1e)
	 begin
		src_MAC_D[47:44] <= wr_cache_data_D[3:0];	 
	 end
	 else if(wr_cache_addr_D == 10'h1f)
	 begin
		src_MAC_D[35:32] <= wr_cache_data_D[3:0];	 
	 end
	 else if(wr_cache_addr_D == 10'h20)
	 begin
		src_MAC_D[39:36] <= wr_cache_data_D[3:0];	 
	 end
	 else if(wr_cache_addr_D == 10'h21)
	 begin
		src_MAC_D[27:24] <= wr_cache_data_D[3:0];	 
	 end
	 else if(wr_cache_addr_D == 10'h22)
	 begin
		src_MAC_D[31:28] <= wr_cache_data_D[3:0];	 
	 end
	 else if(wr_cache_addr_D == 10'h23)
	 begin
		src_MAC_D[19:16] <= wr_cache_data_D[3:0];	 
	 end	 
	 else if(wr_cache_addr_D == 10'h24)
	 begin
		src_MAC_D[23:20] <= wr_cache_data_D[3:0];	 
	 end		 
	 else if(wr_cache_addr_D == 10'h25)
	 begin
		src_MAC_D[11:8] <= wr_cache_data_D[3:0];	 
	 end	 
	 else if(wr_cache_addr_D == 10'h26)
	 begin
		src_MAC_D[15:12] <= wr_cache_data_D[3:0];	 
	 end	 
	 else if(wr_cache_addr_D == 10'h27)
	 begin
		src_MAC_D[3:0] <= wr_cache_data_D[3:0];	 
	 end		 
	 else if(wr_cache_addr_D == 10'h28)
	 begin
		src_MAC_D[7:4] <= wr_cache_data_D[3:0];	 
	 end	 
	 else if(cache_data_send_down_D)
	 begin
		src_MAC_D <= 48'b0;	 
	 end
	 else
	 begin
		src_MAC_D <= src_MAC_D;	 
	 end
end
//************************************************

reg [47:0] temp_src_MAC_up;                 //Modified by SYF 2014.5.28

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
    begin        
       temp_src_MAC_up <= 48'd0;            //Modified by SYF 2014.5.28
       recv_MAC_data_from_A <= 1'd0;
       recv_MAC_data_from_B <= 1'd0;
    end
	 else if(i_macrocycle_b_up && !macrocycle_b_up_dly)   //Modified by SYF 2014.6.10
	 begin
	    temp_src_MAC_up <= 48'b0;        
		 recv_MAC_data_from_A <= 1'd0;
       recv_MAC_data_from_B <= 1'd0;
	 end
	 else if((src_MAC_A != temp_src_MAC_up) && (temp_src_MAC_up == 48'd0) && (wr_cache_addr_A == 10'h29))   //Modified by SYF 2014.5.28
	 begin
       temp_src_MAC_up <= src_MAC_A;        //Modified by SYF 2014.5.28
		 recv_MAC_data_from_A <= 1'd1;
       recv_MAC_data_from_B <= 1'd0;		 
	 end
	 else if((src_MAC_B != temp_src_MAC_up) && (temp_src_MAC_up == 48'd0) && (wr_cache_addr_B == 10'h29))   //Modified by SYF 2014.5.28
	 begin
       temp_src_MAC_up <= src_MAC_B;        //Modified by SYF 2014.5.28
		 recv_MAC_data_from_B <= 1'd1;	
		 recv_MAC_data_from_A <= 1'd0;	 
	 end
	 else if((src_MAC_A == temp_src_MAC_up) && (src_MAC_A == 48'd0) && (wr_cache_addr_A == 10'h29))         //Modified by SYF 2014.5.28
	 begin
		 recv_MAC_data_from_A <= 1'd1;	 
		 recv_MAC_data_from_B <= 1'd0;
	 end	
	 else if((src_MAC_B == temp_src_MAC_up) && (src_MAC_B == 48'd0) && (wr_cache_addr_B == 10'h29))         //Modified by SYF 2014.5.28
	 begin
		 recv_MAC_data_from_B <= 1'd1;
		 recv_MAC_data_from_A <= 1'd0;
	 end		
	 else if((src_MAC_A == temp_src_MAC_up) && (temp_src_MAC_up != 48'd0) && (wr_cache_addr_A == 10'h29))   //Modified by SYF 2014.5.28
	 begin
		 recv_MAC_data_from_B <= recv_MAC_data_from_B;
		 recv_MAC_data_from_A <= recv_MAC_data_from_A;
	 end
	 else if((src_MAC_B == temp_src_MAC_up) && (temp_src_MAC_up != 48'd0) && (wr_cache_addr_B == 10'h29))   //Modified by SYF 2014.5.28
	 begin
		 recv_MAC_data_from_A <= recv_MAC_data_from_A;
       recv_MAC_data_from_B <= recv_MAC_data_from_B;
	 end
	 else if((src_MAC_A != temp_src_MAC_up) && (temp_src_MAC_up != 48'd0) && (wr_cache_addr_A == 10'h29))   //Modified by SYF 2014.5.28
	 begin
       temp_src_MAC_up <= src_MAC_A;         //Modified by SYF 2014.5.28
		 recv_MAC_data_from_A <= 1'd1;
       recv_MAC_data_from_B <= 1'd0;	 
	 end
	 else if((src_MAC_B != temp_src_MAC_up) && (temp_src_MAC_up != 48'd0) && (wr_cache_addr_B == 10'h29))   //Modified by SYF 2014.5.28
	 begin
       temp_src_MAC_up <= src_MAC_B;         //Modified by SYF 2014.5.28
		 recv_MAC_data_from_B <= 1'd1;
		 recv_MAC_data_from_A <= 1'd0;	 
	 end
end

//***********************************************
//Modified by SYF 2014.5.28
reg [47:0] temp_src_MAC_down;                

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       temp_src_MAC_down <= 48'd0;
       recv_MAC_data_from_C <= 1'd0;
       recv_MAC_data_from_D <= 1'd0;
    end
	 else if(i_macrocycle_b_down && !macrocycle_b_down_dly)   //Modified by SYF 2014.6.10
	 begin
	    temp_src_MAC_down <= 48'b0;        
		 recv_MAC_data_from_C <= 1'd0;
       recv_MAC_data_from_D <= 1'd0;
	 end
	 else if((src_MAC_C != temp_src_MAC_down) && (temp_src_MAC_down == 48'd0) && (wr_cache_addr_C == 10'h29))
	 begin
       temp_src_MAC_down <= src_MAC_C;
		 recv_MAC_data_from_C <= 1'd1;
       recv_MAC_data_from_D <= 1'd0;		 
	 end
	 else if((src_MAC_D != temp_src_MAC_down) && (temp_src_MAC_down == 48'd0) && (wr_cache_addr_D == 10'h29))
	 begin
       temp_src_MAC_down <= src_MAC_D;
		 recv_MAC_data_from_D <= 1'd1;	
		 recv_MAC_data_from_C <= 1'd0;	 
	 end
	 else if((src_MAC_C == temp_src_MAC_down) && (src_MAC_A == 48'd0) && (wr_cache_addr_C == 10'h29))
	 begin
		 recv_MAC_data_from_C <= 1'd1;	 
		 recv_MAC_data_from_D <= 1'd0;
	 end	
	 else if((src_MAC_D == temp_src_MAC_down) && (src_MAC_B == 48'd0) && (wr_cache_addr_D == 10'h29))
	 begin
		 recv_MAC_data_from_D <= 1'd1;
		 recv_MAC_data_from_C <= 1'd0;
	 end		
	 else if((src_MAC_C == temp_src_MAC_down) && (temp_src_MAC_down != 48'd0) && (wr_cache_addr_C == 10'h29))
	 begin
		 recv_MAC_data_from_D <= recv_MAC_data_from_D;
		 recv_MAC_data_from_C <= recv_MAC_data_from_C;
	 end
	 else if((src_MAC_D == temp_src_MAC_down) && (temp_src_MAC_down != 48'd0) && (wr_cache_addr_D == 10'h29))
	 begin
		 recv_MAC_data_from_C <= recv_MAC_data_from_C;
       recv_MAC_data_from_D <= recv_MAC_data_from_D;
	 end
	 else if((src_MAC_C != temp_src_MAC_down) && (temp_src_MAC_down != 48'd0) && (wr_cache_addr_C == 10'h29))
	 begin
       temp_src_MAC_down <= src_MAC_C;
		 recv_MAC_data_from_C <= 1'd1;
       recv_MAC_data_from_D <= 1'd0;	 
	 end
	 else if((src_MAC_D != temp_src_MAC_down) && (temp_src_MAC_down != 48'd0) && (wr_cache_addr_D == 10'h29))
	 begin
       temp_src_MAC_down <= src_MAC_D;
		 recv_MAC_data_from_D <= 1'd1;
		 recv_MAC_data_from_C <= 1'd0;	 
	 end
end
//******************************************

//******************************************
//Modified by SYF 2014.5.28
always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       main_clock_compete_from_A <= 1'd0;
       main_clock_compete_from_B <= 1'd0;
    end
	 else if((src_MAC_A != temp_src_MAC_up) && (temp_src_MAC_up == 48'd0) && (wr_cache_addr_A == 10'h29))
	 begin
       main_clock_compete_from_A <= 1'd1;
       main_clock_compete_from_B <= 1'd0;	 
	 end
	 else if((src_MAC_B != temp_src_MAC_up) && (temp_src_MAC_up == 48'd0) && (wr_cache_addr_B == 10'h29))
	 begin
       main_clock_compete_from_A <= 1'd0;
       main_clock_compete_from_B <= 1'd1;		 
	 end
	 else if(i_link_valid_A_down)
	 begin
       main_clock_compete_from_A <= 1'd0;
       main_clock_compete_from_B <= 1'd1;		 
	 end
	 else if(i_link_valid_B_down)
	 begin
       main_clock_compete_from_A <= 1'd1;
       main_clock_compete_from_B <= 1'd0;	 	 
	 end
	 else
	 begin
       main_clock_compete_from_A <= main_clock_compete_from_A;
       main_clock_compete_from_B <= main_clock_compete_from_B;		 
	 end	 
end

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       main_clock_compete_from_C <= 1'd0;
       main_clock_compete_from_D <= 1'd0;
    end
	 else if((src_MAC_C != temp_src_MAC_down) && (temp_src_MAC_down == 48'd0) && (wr_cache_addr_C == 10'h29))
	 begin
       main_clock_compete_from_C <= 1'd1;
       main_clock_compete_from_D <= 1'd0;	 
	 end
	 else if((src_MAC_D != temp_src_MAC_down) && (temp_src_MAC_down == 48'd0) && (wr_cache_addr_D == 10'h29))
	 begin
       main_clock_compete_from_C <= 1'd0;
       main_clock_compete_from_D <= 1'd1;		 
	 end
	 else if(i_link_valid_C_down)
	 begin
       main_clock_compete_from_C <= 1'd0;
       main_clock_compete_from_D <= 1'd1;		 
	 end
	 else if(i_link_valid_D_down)
	 begin
       main_clock_compete_from_C <= 1'd1;
       main_clock_compete_from_D <= 1'd0;	 	 
	 end
	 else
	 begin
       main_clock_compete_from_C <= main_clock_compete_from_C;
       main_clock_compete_from_D <= main_clock_compete_from_D;		 
	 end	 
end
//*******************************************

// get recv_frt_or_sync
reg [7:0] recv_req_or_rep_A, recv_req_or_rep_B, recv_req_or_rep_C, recv_req_or_rep_D;   //Modified by SYF 2014.5.28

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_req_or_rep_A <= 8'd0;                            //Modified by SYF 2014.5.28
    end
    else if (wr_cache_addr_A == 10'h2d)                      //Modified by SYF 2014.5.28
    begin
        recv_req_or_rep_A[3:0] <= wr_cache_data_A[3:0];      //Modified by SYF 2014.5.28
    end
    else if (wr_cache_addr_A ==  10'h2e)                     //Modified by SYF 2014.5.28
    begin
        recv_req_or_rep_A[7:4] <= wr_cache_data_A[3:0];      //Modified by SYF 2014.5.28
    end
	 else if(i_macrocycle_b_up && !macrocycle_b_up_dly)       //Modified by SYF 2014.5.28
	 begin
        recv_req_or_rep_A <= 8'd0;	                         //Modified by SYF 2014.5.28
	 end
    else
    begin
        recv_req_or_rep_A <= recv_req_or_rep_A;              //Modified by SYF 2014.5.28
    end
end

always @ (posedge i_clk, negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_req_or_rep_B <= 8'd0;
    end
    else if (wr_cache_addr_B == 10'h2d)
    begin
        recv_req_or_rep_B[3:0] <= wr_cache_data_B[3:0];
    end
    else if (wr_cache_addr_B ==  10'h2e)
    begin
        recv_req_or_rep_B[7:4] <= wr_cache_data_B[3:0];
    end
	 else if(i_macrocycle_b_up && !macrocycle_b_up_dly)      //Modified by SYF 2014.5.28
	 begin
        recv_req_or_rep_B <= 8'd0;	 
	 end
    else
    begin
        recv_req_or_rep_B <= recv_req_or_rep_B;
    end
end

//********************************************
//Modified by SYF 2014.5.28
always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_req_or_rep_C <= 8'd0;
    end
    else if (wr_cache_addr_C == 10'h2d)
    begin
        recv_req_or_rep_C[3:0] <= wr_cache_data_C[3:0];
    end
    else if (wr_cache_addr_C ==  10'h2e)
    begin
        recv_req_or_rep_C[7:4] <= wr_cache_data_C[3:0];
    end
	 else if(i_macrocycle_b_down && !macrocycle_b_down_dly) 
	 begin
        recv_req_or_rep_C <= 8'd0;	 
	 end
    else
    begin
        recv_req_or_rep_C <= recv_req_or_rep_C;
    end
end

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_req_or_rep_D <= 8'd0;
    end
    else if (wr_cache_addr_D == 10'h2d)
    begin
        recv_req_or_rep_D[3:0] <= wr_cache_data_D[3:0];
    end
    else if (wr_cache_addr_D ==  10'h2e)
    begin
        recv_req_or_rep_D[7:4] <= wr_cache_data_D[3:0];
    end
	 else if(i_macrocycle_b_down && !macrocycle_b_down_dly)
	 begin
        recv_req_or_rep_D <= 8'd0;	 
	 end
    else
    begin
        recv_req_or_rep_D <= recv_req_or_rep_D;
    end
end
//*******************************************

// get main_clock_status in frt
//reg frt_main_clock_status_A, frt_main_clock_status_B;        //Modified by SYF 2014.5.28
//reg frt_main_clock_status_C, frt_main_clock_status_D;        //Modified by SYF 2014.5.28

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       frt_main_clock_status_A <= 1'b0;
    end
    else if (wr_cache_addr_A ==  10'h3b)
//    else if (wr_cache_addr ==  10'h3a)
    begin
        frt_main_clock_status_A <= wr_cache_data_A[0];
    end
	 else if(i_macrocycle_b_up && !macrocycle_b_up_dly)        //Modified by SYF 2014.5.28
	 begin
        frt_main_clock_status_A <= 1'b0;	 
	 end
    else
    begin
        frt_main_clock_status_A <= frt_main_clock_status_A;
    end
end

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       frt_main_clock_status_B <= 1'b0;
    end
    else if (wr_cache_addr_B ==  10'h3b)
//    else if (wr_cache_addr_B ==  10'h3a)
    begin
        frt_main_clock_status_B <= wr_cache_data_B[0];
    end
	 else if(i_macrocycle_b_up && !macrocycle_b_up_dly)        //Modified by SYF 2014.5.28
	 begin
        frt_main_clock_status_B <= 1'b0;	 
	 end
    else
    begin
        frt_main_clock_status_B <= frt_main_clock_status_B;
    end
end

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       frt_main_clock_status_C <= 1'b0;
    end
    else if (wr_cache_addr_C ==  10'h3b)
//    else if (wr_cache_addr_B ==  10'h3a)
    begin
        frt_main_clock_status_C <= wr_cache_data_C[0];
    end
	 else if(i_macrocycle_b_down && !macrocycle_b_down_dly)        //Modified by SYF 2014.5.28
	 begin
        frt_main_clock_status_C <= 1'b0;	 
	 end
    else
    begin
        frt_main_clock_status_C <= frt_main_clock_status_C;
    end
end

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       frt_main_clock_status_D <= 1'b0;
    end
    else if (wr_cache_addr_D ==  10'h3b)
//    else if (wr_cache_addr_B ==  10'h3a)
    begin
        frt_main_clock_status_D <= wr_cache_data_D[0];
    end
	 else if(i_macrocycle_b_down && !macrocycle_b_down_dly)        //Modified by SYF 2014.5.28
	 begin
        frt_main_clock_status_D <= 1'b0;	 
	 end
    else
    begin
        frt_main_clock_status_D <= frt_main_clock_status_D;
    end
end

reg recv_req_from_A_1, recv_rep_from_A_1;
reg recv_req_from_B_1, recv_rep_from_B_1;
reg recv_req_from_C_1, recv_rep_from_C_1;     //Modified by SYF 2014.5.28
reg recv_req_from_D_1, recv_rep_from_D_1;     //Modified by SYF 2014.5.28

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_req_from_A_1 <= 1'd0;
       recv_rep_from_A_1 <= 1'd0;
       recv_req_from_B_1 <= 1'd0;
       recv_rep_from_B_1 <= 1'd0;
    end
/*************** sjj Nov_28th*****************/
	 else if(i_link_valid_A_down)
	 begin
       recv_req_from_A_1 <= 1'd0;	
       recv_rep_from_A_1 <= 1'd0; 
	 end
	 else if(i_link_valid_B_down)
	 begin
       recv_req_from_B_1 <= 1'd0;	
       recv_rep_from_B_1 <= 1'd0; 
	 end
/*************** sjj Nov_28th*****************/	 
    else if (i_Rx_dv_A && (recv_req_or_rep_A == 8'h20) && (wr_cache_addr_A ==  10'h2f))    //Modified by SYF 2014.5.28
    begin
       recv_req_from_A_1 <= 1'd1;
    end
    else if (i_Rx_dv_A && (recv_req_or_rep_A == 8'h21) && (wr_cache_addr_A ==  10'h2f))    //Modified by SYF 2014.5.28
    begin
       recv_rep_from_A_1 <= 1'd1;
    end
    else if (i_Rx_dv_B && (recv_req_or_rep_B == 8'h20) && (wr_cache_addr_B ==  10'h2f))    //Modified by SYF 2014.5.28
    begin
       recv_req_from_B_1 <= 1'd1;
    end
    else if (i_Rx_dv_B && (recv_req_or_rep_B == 8'h21) && (wr_cache_addr_B ==  10'h2f))    //Modified by SYF 2014.5.28
    begin
       recv_rep_from_B_1 <= 1'd1;
    end
	 else
    begin
       recv_req_from_A_1 <= recv_req_from_A_1;
       recv_rep_from_A_1 <= recv_rep_from_A_1;
       recv_req_from_B_1 <= recv_req_from_B_1;
       recv_rep_from_B_1 <= recv_rep_from_B_1;
    end
end

//Modfied by SYF 2014.5.28
always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_req_from_C_1 <= 1'd0;
       recv_rep_from_C_1 <= 1'd0;
       recv_req_from_D_1 <= 1'd0;
       recv_rep_from_D_1 <= 1'd0;
    end
/*************** sjj Nov_28th*****************/
	 else if(i_link_valid_C_down)
	 begin
       recv_req_from_C_1 <= 1'd0;	
       recv_rep_from_C_1 <= 1'd0; 
	 end
	 else if(i_link_valid_D_down)
	 begin
       recv_req_from_D_1 <= 1'd0;	
       recv_rep_from_D_1 <= 1'd0; 
	 end
/*************** sjj Nov_28th*****************/	 
    else if (i_Rx_dv_C && (recv_req_or_rep_C == 8'h20) && (wr_cache_addr_C ==  10'h2f)) // sjj Nov_21st
    begin
       recv_req_from_C_1 <= 1'd1;
    end
    else if (i_Rx_dv_C && (recv_req_or_rep_C == 8'h21) && (wr_cache_addr_C ==  10'h2f)) // sjj Nov_28th
    begin
       recv_rep_from_C_1 <= 1'd1;
    end
    else if (i_Rx_dv_D && (recv_req_or_rep_D == 8'h20) && (wr_cache_addr_D ==  10'h2f))   //sjj Nov_21st
    begin
       recv_req_from_D_1 <= 1'd1;
    end
    else if (i_Rx_dv_D && (recv_req_or_rep_D == 8'h21) && (wr_cache_addr_D ==  10'h2f)) //sjj Nov_28th
    begin
       recv_rep_from_D_1 <= 1'd1;
    end
	 else
    begin
       recv_req_from_C_1 <= recv_req_from_C_1;
       recv_rep_from_C_1 <= recv_rep_from_C_1;
       recv_req_from_D_1 <= recv_req_from_D_1;
       recv_rep_from_D_1 <= recv_rep_from_D_1;
    end
end


/*************** sjj Nov_30th*****************/
reg recv_frt_main_from_A_1, recv_frt_main_from_B_1, recv_frt_main_from_C_1, recv_frt_main_from_D_1;   //Modified by SYF 2014.5.28

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_frt_main_from_A_1 <= 1'd0;
    end
	 else if(i_link_valid_A_down)
	 begin
       recv_frt_main_from_A_1 <= 1'b0;
	 end
    else if (i_Rx_dv_A && (recv_req_or_rep_A == 8'h10) && frt_main_clock_status_A && (wr_cache_addr_A ==  10'h3d))    //Modified by SYF 2014.5.28
    begin
       recv_frt_main_from_A_1 <= 1'b1;
    end
	 else if(!i_macrocycle_b_up && macrocycle_b_up_dly)     //Modified by SYF 2014.5.28
	 begin
       recv_frt_main_from_A_1 <= 1'd0;	 
	 end
	 else
    begin
       recv_frt_main_from_A_1 <= recv_frt_main_from_A_1;
    end
end

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_frt_main_from_B_1 <= 1'd0;
    end
	 else if(i_link_valid_B_down)
	 begin
       recv_frt_main_from_B_1 <= 1'b0;
	 end
    else if (i_Rx_dv_B && (recv_req_or_rep_B == 8'h10) && frt_main_clock_status_B && (wr_cache_addr_B ==  10'h3d))
    begin
       recv_frt_main_from_B_1 <= 1'b1;
    end
	 else if(!i_macrocycle_b_up && macrocycle_b_up_dly)           //Modified by SYF 2014.5.28
	 begin
       recv_frt_main_from_B_1 <= 1'd0;	 
	 end
	 else
    begin
       recv_frt_main_from_B_1 <= recv_frt_main_from_B_1;
    end
end

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_frt_main_from_C_1 <= 1'd0;
    end
	 else if(i_link_valid_C_down)
	 begin
       recv_frt_main_from_C_1 <= 1'b0;
	 end
    else if (i_Rx_dv_C && (recv_req_or_rep_C == 8'h10) && frt_main_clock_status_C && (wr_cache_addr_C ==  10'h3d))
    begin
       recv_frt_main_from_C_1 <= 1'b1;
    end
	 else if(!i_macrocycle_b_down && macrocycle_b_down_dly)         //Modified by SYF 2014.5.28
	 begin
       recv_frt_main_from_C_1 <= 1'd0;	 
	 end
	 else
    begin
       recv_frt_main_from_C_1 <= recv_frt_main_from_C_1;
    end
end

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_frt_main_from_D_1 <= 1'd0;
    end
	 else if(i_link_valid_D_down)
	 begin
       recv_frt_main_from_D_1 <= 1'b0;
	 end
    else if (i_Rx_dv_D && (recv_req_or_rep_D == 8'h10) && frt_main_clock_status_D && (wr_cache_addr_D ==  10'h3d))
    begin
       recv_frt_main_from_D_1 <= 1'b1;
    end
	 else if(!i_macrocycle_b_down && macrocycle_b_down_dly)           //Modified by SYF 2014.5.28
	 begin
       recv_frt_main_from_D_1 <= 1'd0;	 
	 end
	 else
    begin
       recv_frt_main_from_D_1 <= recv_frt_main_from_D_1;
    end
end

/*************** sjj Nov_30th*****************/	 


//recv_req_from_A,B_2    sjj Nov_21st
reg recv_req_from_A_2, recv_req_from_B_2, recv_req_from_C_2, recv_req_from_D_2;   //Modified by SYF 2014.5.28
reg recv_rep_from_A_2, recv_rep_from_B_2, recv_rep_from_C_2, recv_rep_from_D_2;   //Modified by SYF 2014.5.28          

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_req_from_A_2 <= 1'd0;
       recv_req_from_B_2 <= 1'd0;
       recv_rep_from_A_2 <= 1'd0;
       recv_rep_from_B_2 <= 1'd0;
    end
/*************** sjj Nov_28th*****************/
	 else if(i_link_valid_A_down)
	 begin
       recv_req_from_A_2 <= 1'd0;	
       recv_rep_from_A_2 <= 1'd0; 
	 end
	 else if(i_link_valid_B_down)
	 begin
       recv_req_from_B_2 <= 1'd0;	
       recv_rep_from_B_2 <= 1'd0; 
	 end
/*************** sjj Nov_28th*****************/	
    else if (i_Rx_dv_A_rise && (wr_cache_addr_A ==  10'd1)) //Modified by SYF 2014.5.28
    begin
       recv_req_from_A_2 <= 1'd1;
       recv_rep_from_A_2 <= 1'd1;
    end
    else if (i_Rx_dv_B_rise && (wr_cache_addr_B ==  10'd1)) //Modified by SYF 2014.5.28
    begin
       recv_req_from_B_2 <= 1'd1;
       recv_rep_from_B_2 <= 1'd1;
    end
 
    else
    begin
       recv_req_from_A_2 <= recv_req_from_A_2;
       recv_req_from_B_2 <= recv_req_from_B_2;
       recv_rep_from_A_2 <= recv_rep_from_A_2;
       recv_rep_from_B_2 <= recv_rep_from_B_2;
    end
end

//Modified by SYF 2014.5.28
always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_req_from_C_2 <= 1'd0;
       recv_req_from_D_2 <= 1'd0;
       recv_rep_from_C_2 <= 1'd0;
       recv_rep_from_D_2 <= 1'd0;
    end
/*************** sjj Nov_28th*****************/
	 else if(i_link_valid_C_down)
	 begin
       recv_req_from_C_2 <= 1'd0;	
       recv_rep_from_C_2 <= 1'd0; 
	 end
	 else if(i_link_valid_D_down)
	 begin
       recv_req_from_D_2 <= 1'd0;	
       recv_rep_from_D_2 <= 1'd0; 
	 end
/*************** sjj Nov_28th*****************/	
    else if (i_Rx_dv_C_rise && (wr_cache_addr_C ==  10'd1)) // sjj Nov_21st
    begin
       recv_req_from_C_2 <= 1'd1;
       recv_rep_from_C_2 <= 1'd1;
    end
    else if (i_Rx_dv_D_rise && (wr_cache_addr_D ==  10'd1)) // sjj Nov_21st
    begin
       recv_req_from_D_2 <= 1'd1;
       recv_rep_from_D_2 <= 1'd1;
    end
 
    else
    begin
       recv_req_from_C_2 <= recv_req_from_C_2;
       recv_req_from_D_2 <= recv_req_from_D_2;
       recv_rep_from_C_2 <= recv_rep_from_C_2;
       recv_rep_from_D_2 <= recv_rep_from_D_2;
    end
end




/*************** sjj Nov_30th*****************/
reg recv_frt_main_from_A_2, recv_frt_main_from_B_2, recv_frt_main_from_C_2, recv_frt_main_from_D_2;     //Modified by SYF 2014.5.28

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_frt_main_from_A_2 <= 1'b0;
    end
	 else if(i_link_valid_A_down)
	 begin
       recv_frt_main_from_A_2 <= 1'b0;	
	 end
    else if (i_Rx_dv_A_rise && (wr_cache_addr_A ==  10'd1))      //Modified by SYF 2014.5.28
    begin
       recv_frt_main_from_A_2 <= 1'b1;
    end
	 else if(!i_macrocycle_b_up && macrocycle_b_up_dly)           //Modified by SYF 2014.5.28
	 begin
       recv_frt_main_from_A_2 <= 1'd0;	 
	 end
    else
    begin
       recv_frt_main_from_A_2 <= recv_frt_main_from_A_2;
    end
end

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_frt_main_from_B_2 <= 1'b0;
    end
	 else if(i_link_valid_B_down)
	 begin
       recv_frt_main_from_B_2 <= 1'b0;	
	 end
    else if (i_Rx_dv_B_rise && (wr_cache_addr_B ==  10'd1))
    begin
       recv_frt_main_from_B_2 <= 1'b1;
    end
	 else if(!i_macrocycle_b_up && macrocycle_b_up_dly)        //Modified by SYF 2014.5.28
	 begin
       recv_frt_main_from_B_2 <= 1'd0;	 
	 end
    else
    begin
       recv_frt_main_from_B_2 <= recv_frt_main_from_B_2;
    end
end

//Modified by SYF 2014.5.28
always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_frt_main_from_C_2 <= 1'b0;
    end
	 else if(i_link_valid_C_down)
	 begin
       recv_frt_main_from_C_2 <= 1'b0;	
	 end
    else if (i_Rx_dv_C_rise && (wr_cache_addr_C ==  10'd1))
    begin
       recv_frt_main_from_C_2 <= 1'b1;
    end
	 else if(!i_macrocycle_b_down && macrocycle_b_down_dly)
	 begin
       recv_frt_main_from_C_2 <= 1'd0;	 
	 end
    else
    begin
       recv_frt_main_from_C_2 <= recv_frt_main_from_C_2;
    end
end

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_frt_main_from_D_2 <= 1'b0;
    end
	 else if(i_link_valid_D_down)
	 begin
       recv_frt_main_from_D_2 <= 1'b0;	
	 end
    else if (i_Rx_dv_D_rise && (wr_cache_addr_D ==  10'd1))
    begin
       recv_frt_main_from_D_2 <= 1'b1;
    end
	 else if(!i_macrocycle_b_down && macrocycle_b_down_dly)
	 begin
       recv_frt_main_from_D_2 <= 1'd0;	 
	 end
    else
    begin
       recv_frt_main_from_D_2 <= recv_frt_main_from_D_2;
    end
end
//*********************************************


/*************** sjj Nov_30th*****************/	

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_frt_main_from_A <= 1'd0;
    end	 
	 else if(i_link_valid_A_down)
	 begin
       recv_frt_main_from_A <= 1'd0;	 
	 end
	 else if(!i_macrocycle_b_up && macrocycle_b_up_dly)        //Modified by SYF 2014.5.28
	 begin
       recv_frt_main_from_A <= 1'd0;	 
	 end
    else if (recv_frt_main_from_A_1 && recv_frt_main_from_A_2)
    begin
       recv_frt_main_from_A <= 1'd1;
    end
    else
    begin
       recv_rep_from_A <= recv_rep_from_A;
    end
end


always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_frt_main_from_B <= 1'd0;
    end	 
	 else if(i_link_valid_B_down)
	 begin
       recv_frt_main_from_B <= 1'd0;
	 end
	 else if(!i_macrocycle_b_up && macrocycle_b_up_dly)          //Modified by SYF 2014.5.28
	 begin
       recv_frt_main_from_B <= 1'd0;	 
	 end
    else if (recv_frt_main_from_B_1 && recv_frt_main_from_B_2)
    begin
       recv_frt_main_from_B <= 1'd1;
    end
    else
    begin
       recv_rep_from_B <= recv_rep_from_B;
    end
end

//Modified by SYF 2014.5.28
always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_frt_main_from_C <= 1'd0;
    end	 
	 else if(i_link_valid_C_down)
	 begin
       recv_frt_main_from_C <= 1'd0;	 
	 end
	 else if(!i_macrocycle_b_down && macrocycle_b_down_dly)
	 begin
       recv_frt_main_from_C <= 1'd0;	 
	 end
    else if (recv_frt_main_from_C_1 && recv_frt_main_from_C_2)
    begin
       recv_frt_main_from_C <= 1'd1;
    end
    else
    begin
       recv_rep_from_C <= recv_rep_from_C;
    end
end


always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_frt_main_from_D <= 1'd0;
    end	 
	 else if(i_link_valid_D_down)
	 begin
       recv_frt_main_from_D <= 1'd0;
	 end
	 else if(!i_macrocycle_b_down && macrocycle_b_down_dly)
	 begin
       recv_frt_main_from_D <= 1'd0;	 
	 end
    else if (recv_frt_main_from_D_1 && recv_frt_main_from_D_2)
    begin
       recv_frt_main_from_D <= 1'd1;
    end
    else
    begin
       recv_rep_from_D <= recv_rep_from_D;
    end
end
//*****************************************

reg recv_ptp_time_from_A_temp, recv_ptp_time_from_B_temp, recv_ptp_time_from_C_temp, recv_ptp_time_from_D_temp;   //Modified by SYF 2014..5.28

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_ptp_time_from_A_temp <= 1'd0;
       recv_ptp_time_from_B_temp <= 1'd0;
    end	 
	 else if(recv_frt_main_from_A && !recv_frt_main_from_B)
	 begin
       recv_ptp_time_from_A_temp <= 1'd1;
       recv_ptp_time_from_B_temp <= 1'd0;	 
	 end
	 else if(!recv_frt_main_from_A && recv_frt_main_from_B)
	 begin
       recv_ptp_time_from_A_temp <= 1'd0;
       recv_ptp_time_from_B_temp <= 1'd1;	 
	 end
    else
    begin
       recv_ptp_time_from_A_temp <= recv_ptp_time_from_A_temp;
       recv_ptp_time_from_B_temp <= recv_ptp_time_from_B_temp;	
    end
end

//Modified by SYF 2014.5.28
always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_ptp_time_from_C_temp <= 1'd0;
       recv_ptp_time_from_D_temp <= 1'd0;
    end	 
	 else if(recv_frt_main_from_C && !recv_frt_main_from_D)
	 begin
       recv_ptp_time_from_C_temp <= 1'd1;
       recv_ptp_time_from_D_temp <= 1'd0;	 
	 end
	 else if(!recv_frt_main_from_C && recv_frt_main_from_D)
	 begin
       recv_ptp_time_from_C_temp <= 1'd0;
       recv_ptp_time_from_D_temp <= 1'd1;	 
	 end
    else
    begin
       recv_ptp_time_from_C_temp <= recv_ptp_time_from_C_temp;
       recv_ptp_time_from_D_temp <= recv_ptp_time_from_D_temp;	
    end
end
//*************************************************

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin 
		 recv_ptp_time_from_A <= 1'd0;
		 recv_ptp_time_from_B <= 1'd0;		 
	 end
	 else if(recv_ptp_time_from_A_temp)
	 begin
		 recv_ptp_time_from_A <= 1'd1;	 
		 recv_ptp_time_from_B <= 1'd0;
	 end
	 else if(recv_ptp_time_from_B_temp)
	 begin
		 recv_ptp_time_from_A <= 1'd0;	 
		 recv_ptp_time_from_B <= 1'd1;
	 end
    else
    begin
       recv_ptp_time_from_A <= recv_ptp_time_from_A;
       recv_ptp_time_from_B <= recv_ptp_time_from_B;	
    end
end
//Modified by SYF 2014.5.28
always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin 
		 recv_ptp_time_from_C <= 1'd0;
		 recv_ptp_time_from_D <= 1'd0;		 
	 end
	 else if(recv_ptp_time_from_C_temp)
	 begin
		 recv_ptp_time_from_C <= 1'd1;	 
		 recv_ptp_time_from_D <= 1'd0;
	 end
	 else if(recv_ptp_time_from_D_temp)
	 begin
		 recv_ptp_time_from_C <= 1'd0;	 
		 recv_ptp_time_from_D <= 1'd1;
	 end
    else
    begin
       recv_ptp_time_from_C <= recv_ptp_time_from_C;
       recv_ptp_time_from_D <= recv_ptp_time_from_D;	
    end
end
//*********************************

/*************** sjj Nov_30th*****************/	

reg recv_req_from_A, recv_req_from_B, recv_req_from_C, recv_req_from_D;      //Modified by SYF 2014.5.28
       

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_req_from_A <= 1'd0;
       recv_req_from_B <= 1'd0;
    end
    else if (recv_req_from_A_1 && recv_req_from_A_2) // sjj Nov_21st
    begin
       recv_req_from_A <= 1'd1;
    end
    else if (recv_req_from_B_1 && recv_req_from_B_2) // sjj Nov_21st
    begin
       recv_req_from_B <= 1'd1;
    end
    else
    begin
       recv_req_from_A <= recv_req_from_A;
       recv_req_from_B <= recv_req_from_B;
    end
end

//Modified by SYF 2014.5.28
always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_req_from_C <= 1'd0;
       recv_req_from_D <= 1'd0;
    end
    else if (recv_req_from_C_1 && recv_req_from_C_2) // sjj Nov_21st
    begin
       recv_req_from_C <= 1'd1;
    end
    else if (recv_req_from_D_1 && recv_req_from_D_2) // sjj Nov_21st
    begin
       recv_req_from_D <= 1'd1;
    end
    else
    begin
       recv_req_from_C <= recv_req_from_C;
       recv_req_from_D <= recv_req_from_D;
    end
end
//*********************************


reg recv_rep_from_A, recv_rep_from_B, recv_rep_from_C, recv_rep_from_D;   //Modified by SYF 2014.5.28
       
always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_rep_from_A <= 1'd0;
       recv_rep_from_B <= 1'd0;
    end	 
	 else if(i_link_valid_A_down)
	 begin
       recv_rep_from_A <= 1'd0;	 
	 end
	 else if(i_link_valid_B_down)
	 begin
       recv_rep_from_B <= 1'd0;
	 end
    else if (recv_rep_from_A_1 && recv_rep_from_A_2) // sjj Nov_21st
    begin
       recv_rep_from_A <= 1'd1;
    end
    else if (recv_rep_from_B_1 && recv_rep_from_B_2) // sjj Nov_21st
    begin
       recv_rep_from_B <= 1'd1;
    end
    else
    begin
       recv_rep_from_A <= recv_rep_from_A;
       recv_rep_from_B <= recv_rep_from_B;
    end
end

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       recv_rep_from_C <= 1'd0;
       recv_rep_from_D <= 1'd0;
    end	 
	 else if(i_link_valid_C_down)
	 begin
       recv_rep_from_C <= 1'd0;	 
	 end
	 else if(i_link_valid_D_down)
	 begin
       recv_rep_from_D <= 1'd0;
	 end
    else if (recv_rep_from_C_1 && recv_rep_from_C_2) // sjj Nov_21st
    begin
       recv_rep_from_C <= 1'd1;
    end
    else if (recv_rep_from_D_1 && recv_rep_from_D_2) // sjj Nov_21st
    begin
       recv_rep_from_D <= 1'd1;
    end
    else
    begin
       recv_rep_from_C <= recv_rep_from_C;
       recv_rep_from_D <= recv_rep_from_D;
    end
end

// cache_data_send_flag
always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       cache_data_send_flag_A <= 1'd0;                      //Modified by SYF 2014.5.28
    end
    else if (rd_cache_addr_A ==  10'd3)                     //Modified by SYF 2014.5.28
    begin
        cache_data_send_flag_A <= 1'd1;                     //Modified by SYF 2014.5.28
    end
    else if (Nextstate_A == SEND_OVER_A)                    //Modified by SYF 2014.5.28
    begin
        cache_data_send_flag_A <= 1'd0;                     //Modified by SYF 2014.5.28
    end
    else
    begin
        cache_data_send_flag_A <= cache_data_send_flag_A;   //Modified by SYF 2014.5.28
    end
end


/*************************************************
  1st always block, sequential state transition 
**************************************************/
always @ (posedge i_clk , negedge i_rst_n)
begin
    if (!i_rst_n)
    begin
        State_A <= IDLE_A;              //Modified by SYF 2014.5.28
    end
    else 
    begin
        State_A  <= Nextstate_A;        //Modified by SYF 2014.5.28
    end
end


/****************************************************
  2nd always block, combinational condition judgment
*****************************************************/
always @ (*)
begin 	
    case (State_A)
    IDLE_A:
	 begin
		  if((wr_cache_addr_A >= 10'h30) && (src_MAC_A != i_local_node_mac) && (src_MAC_A != 48'd0) && rd_en_A)//important judgement for transmit
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
			if(rd_cache_addr_A > recv_whole_package_length_A + 2'd2)  //sjj Nov_15th		
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

// cache_data_send_flag_B
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
always @ (*)
begin 	
    case (State_B)
    IDLE_B:
	 begin
	  if((wr_cache_addr_B >= 10'h30) && (src_MAC_B != i_local_node_mac) && (src_MAC_B != 48'd0) && rd_en_B)
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
			if(rd_cache_addr_B > recv_whole_package_length_B + 2'd2)  //sjj Nov_15th		
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

always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       cache_data_send_flag_C <= 1'd0;
    end
    else if (rd_cache_addr_C ==  10'd3)
    begin
        cache_data_send_flag_C <= 1'd1;
    end
    else if (Nextstate_C == SEND_OVER_C)
    begin
        cache_data_send_flag_C <= 1'd0;
    end
    else
    begin
        cache_data_send_flag_C <= cache_data_send_flag_C;
    end
end


/*************************************************
  1st always block, sequential state transition 
**************************************************/
always @ (posedge i_clk , negedge i_rst_n)
begin
    if (!i_rst_n)
    begin
        State_C <= IDLE_C;
    end
    else 
    begin
        State_C  <= Nextstate_C;
    end
end


/****************************************************
  2nd always block, combinational condition judgment
*****************************************************/
always @ (*)
begin 	
    case (State_C)
    IDLE_C:
	 begin
		  if((wr_cache_addr_C >= 10'h30) && (src_MAC_C != i_local_node_mac) && (src_MAC_C != 48'd0) && rd_en_C)
		  begin
				Nextstate_C = SEND_START_C;		  
		  end
		  else
		  begin
				Nextstate_C = IDLE_C;		  
		  end
	 end
	 WAIT_IFG_C:
    begin
        if(ifg_num_C >= 8'd23)
		  begin
				Nextstate_C = SEND_START_C;
		  end
        else
		  begin 
				Nextstate_C = WAIT_IFG_C;
		  end
    end	
    SEND_START_C:
	 begin
        Nextstate_C = SEND_1DATA_C;   // sjj Nov_12nd
	 end
    SEND_1DATA_C:
	 begin
			if(rd_cache_addr_C > recv_whole_package_length_C + 2'd2)  //sjj Nov_15th		
			begin
				 Nextstate_C = SEND_OVER_C;
			end
			else
			begin
				 Nextstate_C = SEND_1DATA_C;			
			end
	 end
    SEND_OVER_C:
	 begin
        Nextstate_C = IDLE_C;
	 end
    default:
        Nextstate_C = IDLE_C;
    endcase
end


always @(posedge i_clk ,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		rd_cache_addr_C <= 10'b0;
		ifg_num_C <= 8'd0;
	end
	else
	case(Nextstate_C)
	IDLE_C:
		begin
			rd_cache_addr_C <= 10'b0;
			ifg_num_C <= 8'd0;	
		end
	 WAIT_IFG_C:
    begin
        ifg_num_C <= ifg_num_C + 1'b1;
    end	
   SEND_START_C:
		begin
			rd_cache_addr_C <= 10'd1;
		end	
	SEND_1DATA_C:
		begin
			dmi_buffer_data_C <= rd_cache_data_C[3:0];
			rd_cache_addr_C <= rd_cache_addr_C + 1'b1;
		end		
	SEND_OVER_C:
		begin
			rd_cache_addr_C <= 10'b0;
			ifg_num_C <= 8'd0;
		end	
	default:
	begin
		rd_cache_addr_C <= 10'b0;
   end		
	endcase
end

// cache_data_send_flag_D
always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
    begin       
       cache_data_send_flag_D <= 1'd0;
    end
    else if (rd_cache_addr_D ==  10'd3)
    begin
        cache_data_send_flag_D <= 1'd1;
    end
    else if (Nextstate_D == SEND_OVER_D)
    begin
        cache_data_send_flag_D <= 1'd0;
    end
    else
    begin
        cache_data_send_flag_D <= cache_data_send_flag_D;
    end
end


/*************************************************
  1st always block, sequential state transition 
**************************************************/
always @ (posedge i_clk , negedge i_rst_n)
begin
    if (!i_rst_n)
    begin
        State_D <= IDLE_D;
    end
    else 
    begin
        State_D  <= Nextstate_D;
    end
end


/****************************************************
  2nd always block, combinational condition judgment
*****************************************************/
always @ (*)
begin 	
    case (State_D)
    IDLE_D:
	 begin
		  if((wr_cache_addr_D >= 10'h30) && (src_MAC_D != i_local_node_mac) && (src_MAC_D != 48'd0) && rd_en_D)
		  begin
				Nextstate_D = SEND_START_D;		  
		  end
		  else
		  begin
				Nextstate_D = IDLE_D;		  
		  end
	 end
	 WAIT_IFG_D:
    begin
        if(ifg_num_D >= 8'd23)
		  begin
				Nextstate_D = SEND_START_D;
		  end
        else
		  begin 
				Nextstate_D = WAIT_IFG_D;
		  end
    end	
    SEND_START_D:
	 begin
        Nextstate_D = SEND_1DATA_D;   // sjj Nov_12nd
	 end
    SEND_1DATA_D:
	 begin
			if(rd_cache_addr_D > recv_whole_package_length_D + 2'd2)  //sjj Nov_15th		
			begin
				 Nextstate_D = SEND_OVER_D;
			end
			else
			begin
				 Nextstate_D = SEND_1DATA_D;			
			end
	 end
    SEND_OVER_D:
	 begin
        Nextstate_D = IDLE_D;
	 end
    default:
        Nextstate_D = IDLE_D;
    endcase
end


always @(posedge i_clk ,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		rd_cache_addr_D <= 10'b0;
		ifg_num_D <= 8'd0;
	end
	else
	case(Nextstate_D)
	IDLE_D:
		begin
			rd_cache_addr_D <= 10'b0;
			ifg_num_D <= 8'd0;	
		end
	 WAIT_IFG_D:
    begin
        ifg_num_D <= ifg_num_D + 1'b1;
    end	
   SEND_START_D:
		begin
			rd_cache_addr_D <= 10'd1;
		end	
	SEND_1DATA_D:
		begin
			dmi_buffer_data_D <= rd_cache_data_D[3:0];
			rd_cache_addr_D <= rd_cache_addr_D + 1'b1;
		end		
	SEND_OVER_D:
		begin
			rd_cache_addr_D <= 10'b0;
			ifg_num_D <= 8'd0;
		end	
	default:
	begin
		rd_cache_addr_D <= 10'b0;
   end		
	endcase
end


/////////////////////security detection 2014_April_21th/////////////////////////
////////////////////////////////////////////////////////////////////////////////
reg  [95:0] device_property_up;    //Modified by SYF 2014.5.28   //[79:0] device_property;   
reg  [7:0]  wraddr_devicepro_up;   //Modified by SYF 2014.5.28  
reg  wr_en_devicepro_up;           //Modified by SYF 2014.5.28  

reg  [95:0] device_property_down;    //Modified by SYF 2014.5.28   //[79:0] device_property;  
reg  [7:0]  wraddr_devicepro_down;   //Modified by SYF 2014.5.28  
reg  wr_en_devicepro_down;           //Modified by SYF 2014.5.28 

wire [95:0] devicepro_A, devicepro_B, devicepro_C, devicepro_D;            //Modified by SYF 2014.5.28
wire [7:0]  rdproperty_A, rdproperty_B, rdproperty_C, rdproperty_D;        //Modified by SYF 2014.5.28
wire rdproperty_en_A, rdproperty_en_B, rdproperty_en_C, rdproperty_en_D;   //Modified by SYF 2014.5.28

reg  [2:0]  query_plantinfo_up_cs;       //Modified by SYF 2014.5.28
reg  [2:0]  query_plantinfo_up_ns;       //Modified by SYF 2014.5.28

parameter QUERY_IDLE_up  = 3'b000;       //Modified by SYF 2014.5.28
parameter QUERY_START_up = 3'b001;       //Modified by SYF 2014.5.28
parameter QUERY_WAIT_up  = 3'b010;       //Modified by SYF 2014.5.28
parameter QUERY_DATA_up  = 3'b100;       //Modified by SYF 2014.5.28
parameter QUERY_DONE_up  = 3'b011;       //Modified by SYF 2014.5.28

reg [99:0] is_device_up;					//modified by guhao 20131227, judge whether this num has a device when read configuration to RAM

reg  [2:0]  query_plantinfo_down_cs;       //Modified by SYF 2014.5.28
reg  [2:0]  query_plantinfo_down_ns;       //Modified by SYF 2014.5.28

parameter QUERY_IDLE_down  = 3'b000;       //Modified by SYF 2014.5.28
parameter QUERY_START_down = 3'b001;       //Modified by SYF 2014.5.28
parameter QUERY_WAIT_down  = 3'b010;       //Modified by SYF 2014.5.28
parameter QUERY_DATA_down  = 3'b100;       //Modified by SYF 2014.5.28
parameter QUERY_DONE_down  = 3'b011;       //Modified by SYF 2014.5.28

reg [99:0] is_device_down;					//modified by guhao 20131227, judge whether this num has a device when read configuration to RAM

reg macrocycle_b_up_delay;              //Modified by SYF 2014.5.28
reg macrocycle_b_down_delay;            //Modified by SYF 2014.5.28

reg [31:0] macro_start_time_s_A;
reg [31:0] macro_start_time_ns_A;

reg [31:0] macro_start_time_s_B;
reg [31:0] macro_start_time_ns_B;

reg [31:0] macro_start_time_s_C;          //Modified by SYF 2014.5.28
reg [31:0] macro_start_time_ns_C;         //Modified by SYF 2014.5.28

reg [31:0] macro_start_time_s_D;          //Modified by SYF 2014.5.28
reg [31:0] macro_start_time_ns_D;         //Modified by SYF 2014.5.28


always @ (posedge i_clk  , negedge i_rst_n)
begin
	if (!i_rst_n)
		query_plantinfo_up_cs <= QUERY_IDLE_up;
	else 
		query_plantinfo_up_cs <= query_plantinfo_up_ns;
end

always @ (*)
begin 
    case (query_plantinfo_up_cs)
    QUERY_IDLE_up:
	 begin
		if((!query_plantinfo_dn_up) && i_commen_data_rd_done)							//modified by guhao 20131223
			query_plantinfo_up_ns = QUERY_START_up;
		else
			query_plantinfo_up_ns = QUERY_IDLE_up;
	 end
	 QUERY_START_up:
		query_plantinfo_up_ns = QUERY_WAIT_up;
    QUERY_WAIT_up:
    begin
		if(i_plant_index_done_up || i_plant_index_error_up)
			query_plantinfo_up_ns = QUERY_DATA_up;
      else 
			query_plantinfo_up_ns = QUERY_WAIT_up;
    end
	 QUERY_DATA_up:
	 begin
		if(o_plant_src_mac_up[7:0] < 8'd100)
			query_plantinfo_up_ns = QUERY_START_up;
		else
			query_plantinfo_up_ns = QUERY_DONE_up;
//		query_plantinfo_ns = QUERY_START;
	 end
	 QUERY_DONE_up:
		query_plantinfo_up_ns = QUERY_IDLE_up;
    default:
      query_plantinfo_up_ns = QUERY_IDLE_up;
    endcase
end

always @ (posedge i_clk  , negedge i_rst_n)
begin
	if (!i_rst_n)
		begin 
			device_property_up        <= 96'b0;    //Modified by SYF 2014.5.22   //80'b0;
			wraddr_devicepro_up       <= 8'b0;
			wr_en_devicepro_up        <= 1'b0;
			o_plant_src_mac_up[47:40] <= 8'h0;
			o_plant_src_mac_up[39:32] <= 8'h1;
			o_plant_src_mac_up[31:24] <= 8'h2;
			o_plant_src_mac_up[23:16] <= 8'h3;
			o_plant_src_mac_up[15:8]  <= 8'h4;
			o_plant_src_mac_up[7:0]   <= 8'h0;
			o_plant_index_irq_up      <= 1'b0;
			query_plantinfo_dn_up  	  <= 1'b0;
			is_device_up              <= 100'b0;
		end
   else 
   case (query_plantinfo_up_ns)
	QUERY_IDLE_up:
		begin
			device_property_up    	   <= 96'b0;    //Modified by SYF 2014.5.22   //80'b0;
			wraddr_devicepro_up  	   <= 8'b0;
			wr_en_devicepro_up   	   <= 1'b0;
			o_plant_index_irq_up    	<= 1'b0;
		end
	QUERY_START_up:
		begin
			device_property_up    	  <= 96'b0;     //Modified by SYF 2014.5.22   //80'b0;
			wr_en_devicepro_up    	  <= 1'b0;
			o_plant_index_irq_up  	  <= 1'b1;
			if((o_plant_src_mac_up[7:0] + 1'b1) < 8'd101)
				o_plant_src_mac_up[7:0] <= o_plant_src_mac_up[7:0] + 1'b1;
			else
				o_plant_src_mac_up[7:0] <= 8'd1;
		end
	QUERY_WAIT_up:
		begin
			wraddr_devicepro_up       <= 8'b0;
			o_plant_index_irq_up  	  <= 1'b0;
		end
	QUERY_DATA_up:
		begin
			device_property_up[95:64] <= i_plant_ip_up;         //Modified by SYF 2014.5.22
			device_property_up[63:32] <= i_plant_toffset_up;
			device_property_up[31:16] <= i_plant_datalen_up;
			device_property_up[15:0]  <= i_plant_interval_up;   //Modified by SYF 2014.5.22
			if((i_plant_ip_up[31:24] == 8'd192) && (i_plant_ip_up[23:16] == 8'd168) /*&& (i_plant_ip_up[15:8] == 8'd1)*/ && (i_plant_ip_up[7:0] == o_plant_src_mac_up[7:0]))   //Modified SYF 2014.6.11
				begin
					wr_en_devicepro_up        <= 1'b1;
					wraddr_devicepro_up    	  <= o_plant_src_mac_up[7:0] - 1'b1;
					is_device_up[o_plant_src_mac_up[7:0] - 1'b1] <= 1'b1;
				end
			else
				begin
					wr_en_devicepro_up        <= 1'b0;
				end
		end
	QUERY_DONE_up:
		begin
			device_property_up      <= 96'b0;     //Modified by SYF 2014.5.22    //80'b0;
			wraddr_devicepro_up     <= 8'b0;
			wr_en_devicepro_up      <= 1'b0;
			o_plant_index_irq_up    <= 1'b0;
			query_plantinfo_dn_up	<= 1'b1;
		end
	default:
		begin
			device_property_up      <= 96'b0;     //Modified by SYF 2014.5.22    //80'b0;
			wraddr_devicepro_up     <= 8'b0;
			wr_en_devicepro_up      <= 1'b0;
			o_plant_index_irq_up    <= 1'b0;
		 end
	endcase
end
//modified 20140220, add EMIB read, fetch device property

//********************************************************
//Modified  by SYF 2014.5.28

always @ (posedge i_clk  , negedge i_rst_n)
begin
	if (!i_rst_n)
		query_plantinfo_down_cs <= QUERY_IDLE_down;
	else 
		query_plantinfo_down_cs <= query_plantinfo_down_ns;
end

always @ (*)
begin 
    case (query_plantinfo_down_cs)
    QUERY_IDLE_down:
	 begin
		if((!query_plantinfo_dn_down) && i_commen_data_rd_done)							//modified by guhao 20131223
			query_plantinfo_down_ns = QUERY_START_down;
		else
			query_plantinfo_down_ns = QUERY_IDLE_down;
	 end
	 QUERY_START_down:
		query_plantinfo_down_ns = QUERY_WAIT_down;
    QUERY_WAIT_down:
    begin
		if(i_plant_index_done_down || i_plant_index_error_down)
			query_plantinfo_down_ns = QUERY_DATA_down;
      else 
			query_plantinfo_down_ns = QUERY_WAIT_down;
    end
	 QUERY_DATA_down:
	 begin
		if(o_plant_src_mac_down[7:0] < 8'd100)
			query_plantinfo_down_ns = QUERY_START_down;
		else
			query_plantinfo_down_ns = QUERY_DONE_down;
//		query_plantinfo_ns = QUERY_START;
	 end
	 QUERY_DONE_down:
		query_plantinfo_down_ns = QUERY_IDLE_down;
    default:
      query_plantinfo_down_ns = QUERY_IDLE_down;
    endcase
end

always @ (posedge i_clk  , negedge i_rst_n)
begin
	if (!i_rst_n)
		begin 
			device_property_down        <= 96'b0;    //Modified by SYF 2014.5.22   //80'b0;
			wraddr_devicepro_down       <= 8'b0;
			wr_en_devicepro_down        <= 1'b0;
			o_plant_src_mac_down[47:40] <= 8'h0;
			o_plant_src_mac_down[39:32] <= 8'h1;
			o_plant_src_mac_down[31:24] <= 8'h2;
			o_plant_src_mac_down[23:16] <= 8'h3;
			o_plant_src_mac_down[15:8]  <= 8'h5;
			o_plant_src_mac_down[7:0]   <= 8'h0;
			o_plant_index_irq_down      <= 1'b0;
			query_plantinfo_dn_down  	  <= 1'b0;
			is_device_down              <= 100'b0;
		end
   else 
   case (query_plantinfo_down_ns)
	QUERY_IDLE_down:
		begin
			device_property_down    	<= 96'b0;    //Modified by SYF 2014.5.22   //80'b0;
			wraddr_devicepro_down  	   <= 8'b0;
			wr_en_devicepro_down   	   <= 1'b0;
			o_plant_index_irq_down    	<= 1'b0;
		end
	QUERY_START_down:
		begin
			device_property_down    	  <= 96'b0;     //Modified by SYF 2014.5.22   //80'b0;
			wr_en_devicepro_down    	  <= 1'b0;
			o_plant_index_irq_down  	  <= 1'b1;
			if((o_plant_src_mac_down[7:0] + 1'b1) < 8'd101)
				o_plant_src_mac_down[7:0] <= o_plant_src_mac_down[7:0] + 1'b1;
			else
				o_plant_src_mac_down[7:0] <= 8'd1;
		end
	QUERY_WAIT_down:
		begin
			wraddr_devicepro_down       <= 8'b0;
			o_plant_index_irq_down  	  <= 1'b0;
		end
	QUERY_DATA_down:
		begin
			device_property_down[95:64] <= i_plant_ip_down;         //Modified by SYF 2014.5.22
			device_property_down[63:32] <= i_plant_toffset_down;
			device_property_down[31:16] <= i_plant_datalen_down;
			device_property_down[15:0]  <= i_plant_interval_down;   //Modified by SYF 2014.5.22
			if((i_plant_ip_down[31:24] == 8'd192) && (i_plant_ip_down[23:16] == 8'd168) /*&& (i_plant_ip_down[15:8] == 8'd1)*/ && (i_plant_ip_down[7:0] == o_plant_src_mac_down[7:0]))    //Modified by SYF 2014.6.10
				begin
					wr_en_devicepro_down        <= 1'b1;
					wraddr_devicepro_down    	  <= o_plant_src_mac_down[7:0] - 1'b1;
					is_device_down[o_plant_src_mac_down[7:0] - 1'b1] <= 1'b1;
				end
			else
				begin
					wr_en_devicepro_down        <= 1'b0;
				end
		end
	QUERY_DONE_down:
		begin
			device_property_down      <= 96'b0;     //Modified by SYF 2014.5.22    //80'b0;
			wraddr_devicepro_down     <= 8'b0;
			wr_en_devicepro_down      <= 1'b0;
			o_plant_index_irq_down    <= 1'b0;
			query_plantinfo_dn_down	<= 1'b1;
		end
	default:
		begin
			device_property_down      <= 96'b0;     //Modified by SYF 2014.5.22    //80'b0;
			wraddr_devicepro_down     <= 8'b0;
			wr_en_devicepro_down      <= 1'b0;
			o_plant_index_irq_down    <= 1'b0;
		 end
	endcase
end
//********************************************************


//acquire start time of macro
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		macrocycle_b_up_delay <= 1'b0 ;                 //Modified by SYF 2014.5.28
	else
		macrocycle_b_up_delay <= i_macrocycle_b_up;     //Modified by SYF 2014.5.28
end

always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		macrocycle_b_down_delay <= 1'b0 ;                 //Modified by SYF 2014.5.28
	else
		macrocycle_b_down_delay <= i_macrocycle_b_down;     //Modified by SYF 2014.5.28
end

always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			macro_start_time_s_A  <= 31'b0;
			macro_start_time_ns_A <= 31'b0;
		end
	else if(!macrocycle_b_up_delay && i_macrocycle_b_up)		 //Modified by SYF 2014.5.28
		begin
			macro_start_time_s_A  <= i_ptptime_second_A;
			macro_start_time_ns_A <= i_ptptime_nanosecond_A;
		end
end

always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			macro_start_time_s_B  <= 31'b0;
			macro_start_time_ns_B <= 31'b0;
		end
	else if(!macrocycle_b_up_delay && i_macrocycle_b_up)		 //Modified by SYF 2014.5.28
		begin
			macro_start_time_s_B  <= i_ptptime_second_B;
			macro_start_time_ns_B <= i_ptptime_nanosecond_B;
		end
end

//****************************************
//Modifeid by SYF 2014.5.28
always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			macro_start_time_s_C  <= 31'b0;
			macro_start_time_ns_C <= 31'b0;
		end
	else if(!macrocycle_b_down_delay && i_macrocycle_b_down)		
		begin
			macro_start_time_s_C  <= i_ptptime_second_C;
			macro_start_time_ns_C <= i_ptptime_nanosecond_C;
		end
end

always @(posedge i_clk, negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			macro_start_time_s_D  <= 31'b0;
			macro_start_time_ns_D <= 31'b0;
		end
	else if(!macrocycle_b_down_delay && i_macrocycle_b_down)		
		begin
			macro_start_time_s_D  <= i_ptptime_second_D;
			macro_start_time_ns_D <= i_ptptime_nanosecond_D;
		end
end
//***************************************

//acquire

//********************************************************************************//
reg send_alarm_to_pdo_A_dly;
reg send_alarm_to_pdo_B_dly;
reg send_alarm_to_pdo_C_dly;                  //Modified by SYF 2014.5.28
reg send_alarm_to_pdo_D_dly;                  //Modified by SYF 2014.5.28
reg [7:0]alarm_num_A;
reg [7:0]alarm_num_B;
reg [7:0]alarm_num_C;                         //Modified by SYF 2014.5.28
reg [7:0]alarm_num_D;                         //Modified by SYF 2014.5.28
reg [7:0]none_alarm_count_macrocycle_A;
reg [7:0]none_alarm_count_macrocycle_B;
reg [7:0]none_alarm_count_macrocycle_C;       //Modified by SYF 2014.5.28
reg [7:0]none_alarm_count_macrocycle_D;       //Modified by SYF 2014.5.28


always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			send_alarm_to_pdo_A_dly <= 1'b0;
			send_alarm_to_pdo_B_dly <= 1'b0;
		end
	else 
		begin
			send_alarm_to_pdo_A_dly <= o_send_alarm_to_pdo_A;
			send_alarm_to_pdo_B_dly <= o_send_alarm_to_pdo_B;
		end
end

//*********************************************************
//Modified by SYF 2014.5.28
always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			send_alarm_to_pdo_C_dly <= 1'b0;
			send_alarm_to_pdo_D_dly <= 1'b0;
		end
	else 
		begin
			send_alarm_to_pdo_C_dly <= o_send_alarm_to_pdo_C;
			send_alarm_to_pdo_D_dly <= o_send_alarm_to_pdo_D;
		end
end
//*********************************************************

always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			alarm_num_A <= 8'b0;
			alarm_num_B <= 8'b0;
			alarm_num_C <= 8'b0;
			alarm_num_D <= 8'b0;
		end
	else if(i_macrocycle_b_up && send_alarm_to_pdo_A_dly && !o_send_alarm_to_pdo_A)
		alarm_num_A <= alarm_num_A + 8'd1;
	else if(i_macrocycle_b_up && send_alarm_to_pdo_B_dly && !o_send_alarm_to_pdo_B)
		alarm_num_B <= alarm_num_B + 8'd1;
	else if(i_macrocycle_b_down && send_alarm_to_pdo_C_dly && !o_send_alarm_to_pdo_C)
		alarm_num_C <= alarm_num_C + 8'd1;
	else if(i_macrocycle_b_down && send_alarm_to_pdo_D_dly && !o_send_alarm_to_pdo_D)
		alarm_num_D <= alarm_num_D + 8'd1;
	else if(i_link_valid_A == 1'b0)
		alarm_num_A <= 8'd0;
	else if(i_link_valid_B == 1'b0)
		alarm_num_B <= 8'd0;
	else if(i_link_valid_C == 1'b0)
		alarm_num_C <= 8'd0;
	else if(i_link_valid_D == 1'b0)
		alarm_num_D <= 8'd0;

	else if(alarm_num_A == 8'd10 && none_alarm_count_macrocycle_A >= 8'd5)
		alarm_num_A <= 8'd0;
	else if(alarm_num_B == 8'd10 && none_alarm_count_macrocycle_B >= 8'd5)
		alarm_num_B <= 8'd0;
	else if(alarm_num_C == 8'd10 && none_alarm_count_macrocycle_C >= 8'd5)
		alarm_num_C <= 8'd0;
	else if(alarm_num_D == 8'd10 && none_alarm_count_macrocycle_D >= 8'd5)
		alarm_num_D <= 8'd0;
	else if(alarm_num_A >= 8'd10)
		alarm_num_A <= 8'd10;
	else if(alarm_num_B >= 8'd10)
		alarm_num_B <= 8'd10;
	else if(alarm_num_C >= 8'd10)
		alarm_num_C <= 8'd10;
	else if(alarm_num_D >= 8'd10)
		alarm_num_D <= 8'd10;
	else
		begin
			alarm_num_A <= alarm_num_A;
			alarm_num_B <= alarm_num_B;
			alarm_num_C <= alarm_num_C;
			alarm_num_D <= alarm_num_D;
		end
end
//Modified by SYF 2014.5.28
//always @(posedge i_clk,negedge i_rst_n)
//begin
//	if(!i_rst_n)
//		begin
//			alarm_num_C <= 8'b0;
//			alarm_num_D <= 8'b0;
//		end
//	else if(i_macrocycle_b_down && send_alarm_to_pdo_C_dly && !o_send_alarm_to_pdo_C)                  //Modified by SYF 2014.5.28
//		alarm_num_C <= alarm_num_C + 8'd1;
//	else if(i_macrocycle_b_down && send_alarm_to_pdo_B_dly && !o_send_alarm_to_pdo_D)                  //Modified by SYF 2014.5.28
//		alarm_num_D <= alarm_num_D + 8'd1;
//	else if(alarm_num_C >= 8'd10)
//		alarm_num_C <= 8'd10;
//	else if(alarm_num_D >= 8'd10)
//		alarm_num_D <= 8'd10;
//	else if(i_link_valid_C == 1'b0)
//		alarm_num_C <= 8'd0;
//	else if(i_link_valid_D == 1'b0)
//		alarm_num_D <= 8'd0;
//	else if(alarm_num_C == 8'd10 && none_alarm_count_macrocycle_C >= 8'd5)
//		alarm_num_C <= 8'd0;
//	else if(alarm_num_D == 8'd10 && none_alarm_count_macrocycle_D >= 8'd5)
//		alarm_num_D <= 8'd0;
//	else
//		begin
//			alarm_num_C <= alarm_num_C;
//			alarm_num_D <= alarm_num_D;
//		end
//end
//******************************


always @(posedge i_clk,negedge i_rst_n)
begin
	if(!i_rst_n)
		begin
			none_alarm_count_macrocycle_A <= 8'd0;
			none_alarm_count_macrocycle_B <= 8'd0;
			none_alarm_count_macrocycle_C <= 8'd0;
			none_alarm_count_macrocycle_D <= 8'd0;
		end
	else if(!i_macrocycle_b_up && macrocycle_b_up_dly && alarm_num_A == 8'd10)
		none_alarm_count_macrocycle_A <= none_alarm_count_macrocycle_A + 8'd1;
	else if(!i_macrocycle_b_up && macrocycle_b_up_dly && alarm_num_B == 8'd10)
		none_alarm_count_macrocycle_B <= none_alarm_count_macrocycle_B + 8'd1;	
		
	else if(!i_macrocycle_b_down && macrocycle_b_down_dly && alarm_num_C == 8'd10)
		none_alarm_count_macrocycle_C <= none_alarm_count_macrocycle_C + 8'd1;
	else if(!i_macrocycle_b_down && macrocycle_b_down_dly && alarm_num_D == 8'd10)
		none_alarm_count_macrocycle_D <= none_alarm_count_macrocycle_D + 8'd1;
		
	else if(i_macrocycle_b_up && o_send_alarm_to_pdo_A)
		none_alarm_count_macrocycle_A <= 8'd0;	
	else if(i_macrocycle_b_up && o_send_alarm_to_pdo_B)
		none_alarm_count_macrocycle_B <= 8'd0;
		
	else if(i_macrocycle_b_down && o_send_alarm_to_pdo_C)
		none_alarm_count_macrocycle_C <= 8'd0;	
	else if(i_macrocycle_b_down && o_send_alarm_to_pdo_D)
		none_alarm_count_macrocycle_D <= 8'd0;
	else 
		begin
			none_alarm_count_macrocycle_A <= none_alarm_count_macrocycle_A;
			none_alarm_count_macrocycle_B <= none_alarm_count_macrocycle_B;
			none_alarm_count_macrocycle_C <= none_alarm_count_macrocycle_C;
			none_alarm_count_macrocycle_D <= none_alarm_count_macrocycle_D;
		end
end

//Modified by SYF 2014.5.28
//always @(posedge i_clk,negedge i_rst_n)
//begin
//	if(!i_rst_n)
//		begin
//			none_alarm_count_macrocycle_C <= 8'd0;
//			none_alarm_count_macrocycle_D <= 8'd0;
//		end
//	else if(!i_macrocycle_b_down && macrocycle_b_down_dly && alarm_num_C == 8'd10)
//		none_alarm_count_macrocycle_C <= none_alarm_count_macrocycle_C + 8'd1;
//	else if(!i_macrocycle_b_down && macrocycle_b_down_dly && alarm_num_D == 8'd10)
//		none_alarm_count_macrocycle_D <= none_alarm_count_macrocycle_D + 8'd1;	
//	else if(i_macrocycle_b_down && o_send_alarm_to_pdo_C)
//		none_alarm_count_macrocycle_C <= 8'd0;	
//	else if(i_macrocycle_b_down && o_send_alarm_to_pdo_D)
//		none_alarm_count_macrocycle_D <= 8'd0;
//	else 
//		begin
//			none_alarm_count_macrocycle_C <= none_alarm_count_macrocycle_C;
//			none_alarm_count_macrocycle_D <= none_alarm_count_macrocycle_D;
//		end
//end
//*********************************************


/*********************analysis the receive data from A port********************/
PDU_analysis   PDU_analysis_A2host(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		
/***************     sjj Oct_19th   ***************/
		.i_Rx_dv(i_Rx_dv_A),
		.i_recv_data(i_recv_data_A),
		
		.i_device_type(1'b1),        //Modified by SYF 2014.6.18
/***************     sjj Oct_19th   ***************/
		
		.o_dest_mac(dest_mac_A) ,
		.o_pkg_type(pkg_type_A),
		.o_frt_type(frt_type_A) ,
		.o_msgid(msgid_A),
		.recv_addr(recv_addr_A),
		.o_recv_status(recv_status_A),
	
		.i_macrocycle_b(i_macrocycle_b_up),
		.o_rd_en_property(rdproperty_en_A),					//modified by guhao 20131220
		.o_rd_addr(rdproperty_A),								//modified by guhao 20131220
		.i_devicepro(devicepro_A),								//modified by guhao 20131220
		
		.i_query_plantinfo_dn(query_plantinfo_dn_up),		//modified by guhao 20131223
		.i_csme_en(i_csme_en_up),									//modified by guhao 20131223
		.i_is_device(is_device_up),								//modified by guhao 20131227

		.i_ptptime_second(i_ptptime_second_A),
		.i_ptptime_nanosecond(i_ptptime_nanosecond_A),
		.i_macro_start_time_s(macro_start_time_s_A),
		.i_macro_start_time_ns(macro_start_time_ns_A),
		
		/***********************************/
		.i_len_master_clock(i_len_master_clock_A),        //Modified by SYF 2014.5.23
		/***********************************/
		
		//20140213
		.o_alarm_data(o_alarm_data_A),
		.o_send_alarm_to_pdo(o_send_alarm_to_pdo_A),
		.o_pack_safe(o_pack_safe_A),
		//20140213
		
		//20140225, for transmit
		.o_recv_data_legal(Rx_dv_A_legal),
		.o_rd_en(rd_en_A)
	
);
/*******************************end*********************************************/

/*********************analysis the receive data from B port********************/

PDU_analysis   PDU_analysis_B2host(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		
		.i_Rx_dv(i_Rx_dv_B),
		.i_recv_data(i_recv_data_B),
		
		.i_device_type(1'b1),        //Modified by SYF 2014.6.18
		
		.o_dest_mac(dest_mac_B),
		.o_pkg_type(pkg_type_B),
		.o_frt_type(frt_type_B),
		.o_msgid(msgid_B),
		.recv_addr(recv_addr_B),
		.o_recv_status(recv_status_B),
		
		.i_macrocycle_b(i_macrocycle_b_up),	
		.o_rd_en_property(rdproperty_en_B),					//modified by guhao 20131220
		.o_rd_addr(rdproperty_B),								//modified by guhao 20131220
		.i_devicepro(devicepro_B),								//modified by guhao 20131220
		
		.i_query_plantinfo_dn(query_plantinfo_dn_up),		//modified by guhao 20131223
		.i_csme_en(i_csme_en_up),									//modified by guhao 20131223
		.i_is_device(is_device_up),								//modified by guhao 20131227

		.i_ptptime_second(i_ptptime_second_B),
		.i_ptptime_nanosecond(i_ptptime_nanosecond_B),
		.i_macro_start_time_s(macro_start_time_s_B),
		.i_macro_start_time_ns(macro_start_time_ns_B),
		
		/***********************************/
		.i_len_master_clock(i_len_master_clock_B),        //Modified by SYF 2014.5.23
		/***********************************/
				
		//20140213
		.o_alarm_data(o_alarm_data_B),
		.o_send_alarm_to_pdo(o_send_alarm_to_pdo_B),
		.o_pack_safe(o_pack_safe_B),
		//20140213
		
		//20140225, for transmit
		.o_recv_data_legal(Rx_dv_B_legal),
		.o_rd_en(rd_en_B)	
);

/*******************************end*********************************************/

/*********************analysis the receive data from C port********************/
PDU_analysis   PDU_analysis_C2host(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		
		.i_Rx_dv(i_Rx_dv_C),
		.i_recv_data(i_recv_data_C),
		
		.i_device_type(1'b1),        //Modified by SYF 2014.6.18
		
		.o_dest_mac(dest_mac_C),
		.o_pkg_type(pkg_type_C),
		.o_frt_type(frt_type_C),
		.o_msgid(msgid_C),
		.recv_addr(recv_addr_C),
		.o_recv_status(recv_status_C),
		
		.i_macrocycle_b(i_macrocycle_b_down),	
		.o_rd_en_property(rdproperty_en_C),					//modified by guhao 20131220
		.o_rd_addr(rdproperty_C),								//modified by guhao 20131220
		.i_devicepro(devicepro_C),								//modified by guhao 20131220
		
		.i_query_plantinfo_dn(query_plantinfo_dn_down),		//modified by guhao 20131223
		.i_csme_en(i_csme_en_down),									//modified by guhao 20131223
		.i_is_device(is_device_down),								//modified by guhao 20131227

		.i_ptptime_second(i_ptptime_second_C),
		.i_ptptime_nanosecond(i_ptptime_nanosecond_C),
		.i_macro_start_time_s(macro_start_time_s_C),
		.i_macro_start_time_ns(macro_start_time_ns_C),
		
		/***********************************/
		.i_len_master_clock(i_len_master_clock_C),        //Modified by SYF 2014.5.23
		/***********************************/
				
		//20140213
		.o_alarm_data(o_alarm_data_C),
		.o_send_alarm_to_pdo(o_send_alarm_to_pdo_C),
		.o_pack_safe(o_pack_safe_C),
		//20140213
		
		//20140225, for transmit
		.o_recv_data_legal(Rx_dv_C_legal),
		.o_rd_en(rd_en_C)	
);

/*******************************end*********************************************/

//Modified by SYF 2014.6.18
wire Rx_dv_D;
wire [3:0] recv_data_D;

assign Rx_dv_D = !i_device_type ? 1'b0 : i_Rx_dv_D;
assign recv_data_D = !i_device_type ? 1'b0 : i_recv_data_D;

/*********************analysis the receive data from D port********************/
PDU_analysis   PDU_analysis_D2host(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		
		.i_Rx_dv(Rx_dv_D),
		.i_recv_data(recv_data_D),
		
		.i_device_type(i_device_type),        //Modified by SYF 2014.6.18
		
		.o_dest_mac(dest_mac_D),
		.o_pkg_type(pkg_type_D),
		.o_frt_type(frt_type_D),
		.o_msgid(msgid_D),
		.recv_addr(recv_addr_D),
		.o_recv_status(recv_status_D),
		
		.i_macrocycle_b(i_macrocycle_b_down),	
		.o_rd_en_property(rdproperty_en_D),					//modified by guhao 20131220
		.o_rd_addr(rdproperty_D),								//modified by guhao 20131220
		.i_devicepro(devicepro_D),								//modified by guhao 20131220
		
		.i_query_plantinfo_dn(query_plantinfo_dn_down),		//modified by guhao 20131223
		.i_csme_en(i_csme_en_down),									//modified by guhao 20131223
		.i_is_device(is_device_down),								//modified by guhao 20131227

		.i_ptptime_second(i_ptptime_second_D),
		.i_ptptime_nanosecond(i_ptptime_nanosecond_D),
		.i_macro_start_time_s(macro_start_time_s_D),
		.i_macro_start_time_ns(macro_start_time_ns_D),
		
		/***********************************/
		.i_len_master_clock(i_len_master_clock_D),        //Modified by SYF 2014.5.23
		/***********************************/
				
		//20140213
		.o_alarm_data(o_alarm_data_D),
		.o_send_alarm_to_pdo(o_send_alarm_to_pdo_D),
		.o_pack_safe(o_pack_safe_D),
		//20140213
		
		//20140225, for transmit
		.o_recv_data_legal(Rx_dv_D_legal),
		.o_rd_en(rd_en_D)	
);

/*******************************end*********************************************/

/*********************analysis the receive data from host port********************/
PDU_analysis   PDU_analysis_host2A(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		
		.i_Rx_dv(i_Rx_dv_host_A),
		.i_recv_data(i_recv_data_host_A),
		
		.o_dest_mac(dest_mac_host_A),
		.o_pkg_type(pkg_type_host_A),
		.o_frt_type(frt_type_host_A),
		.o_msgid(msgid_host_A),
		.recv_addr(recv_addr_host_A)
);

PDU_analysis   PDU_analysis_host2B(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		
		.i_Rx_dv(i_Rx_dv_host_B),
		.i_recv_data(i_recv_data_host_B),
		
		.o_dest_mac(dest_mac_host_B) ,
		.o_pkg_type(pkg_type_host_B),
		.o_frt_type(frt_type_host_B) ,
		.o_msgid(msgid_host_B),
		.recv_addr(recv_addr_host_B)
);

PDU_analysis   PDU_analysis_host2C(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		
		.i_Rx_dv(i_Rx_dv_host_C),
		.i_recv_data(i_recv_data_host_C),
		
		.o_dest_mac(dest_mac_host_C) ,
		.o_pkg_type(pkg_type_host_C),
		.o_frt_type(frt_type_host_C) ,
		.o_msgid(msgid_host_C),
		.recv_addr(recv_addr_host_C)
);

PDU_analysis   PDU_analysis_host2D(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		
		.i_Rx_dv(i_Rx_dv_host_D),
		.i_recv_data(i_recv_data_host_D),
		
		.o_dest_mac(dest_mac_host_D) ,
		.o_pkg_type(pkg_type_host_D),
		.o_frt_type(frt_type_host_D) ,
		.o_msgid(msgid_host_D),
		.recv_addr(recv_addr_host_D)
);
/*******************************end*********************************************/

system_devices system_devices_A(							//modified by guhao 20131219, read system device property when initialization
	.aclr(!i_rst_n),
	.clock(i_clk),
	.data(device_property_up),               //Modified by SYF 2014.5.28
	.rdaddress(rdproperty_A),
	.rden(rdproperty_en_A),
	.wraddress(wraddr_devicepro_up),        //Modified by SYF 2014.5.28
	.wren(wr_en_devicepro_up),              //Modified by SYF 2014.5.28
	.q(devicepro_A)
);

system_devices system_devices_B(							//modified by guhao 20131219, read system device property when initialization
	.aclr(!i_rst_n),
	.clock(i_clk),
	.data(device_property_up),              //Modified by SYF 2014.5.28
	.rdaddress(rdproperty_B),
	.rden(rdproperty_en_B),
	.wraddress(wraddr_devicepro_up),        //Modified by SYF 2014.5.28
	.wren(wr_en_devicepro_up),              //Modified by SYF 2014.5.28
	.q(devicepro_B)
);
//Modifiec by SYF 2014.5.28
system_devices system_devices_C(							//modified by guhao 20131219, read system device property when initialization
	.aclr(!i_rst_n),
	.clock(i_clk),
	.data(device_property_down),            //Modified by SYF 2014.5.28
	.rdaddress(rdproperty_C),
	.rden(rdproperty_en_C),
	.wraddress(wraddr_devicepro_down),      //Modified by SYF 2014.5.28
	.wren(wr_en_devicepro_down),            //Modified by SYF 2014.5.28
	.q(devicepro_C)
);

system_devices system_devices_D(							//modified by guhao 20131219, read system device property when initialization
	.aclr(!i_rst_n),
	.clock(i_clk),
	.data(device_property_down),            //Modified by SYF 2014.5.28
	.rdaddress(rdproperty_D),
	.rden(rdproperty_en_D),
	.wraddress(wraddr_devicepro_down),      //Modified by SYF 2014.5.28
	.wren(wr_en_devicepro_down),            //Modified by SYF 2014.5.28
	.q(devicepro_D)
);
//*******************************

transmit_cache  transmit_cache_A(                 //Modified by SYF 2014.5.29
	.data(wr_cache_data_A),
	.rdaddress(rd_cache_addr_A),
	.rdclock(i_clk),
	.wraddress(wr_cache_addr_A),
	.wrclock(i_clk),
	.wren(wr_cache_en_A),
	.q(rd_cache_data_A)
	);
	
transmit_cache  transmit_cache_B(
	.data(wr_cache_data_B),
	.rdaddress(rd_cache_addr_B),
	.rdclock(i_clk),
	.wraddress(wr_cache_addr_B),
	.wrclock(i_clk),
	.wren(wr_cache_en_B),
	.q(rd_cache_data_B)
	);	
	
//Modified by SYF 2014.5.28
transmit_cache  transmit_cache_C(
	.data(wr_cache_data_C),
	.rdaddress(rd_cache_addr_C),
	.rdclock(i_clk),
	.wraddress(wr_cache_addr_C),
	.wrclock(i_clk),
	.wren(wr_cache_en_C),
	.q(rd_cache_data_C)
	);
	
transmit_cache  transmit_cache_D(
	.data(wr_cache_data_D),
	.rdaddress(rd_cache_addr_D),
	.rdclock(i_clk),
	.wraddress(wr_cache_addr_D),
	.wrclock(i_clk),
	.wren(wr_cache_en_D),
	.q(rd_cache_data_D)
	);		
//****************************

endmodule 