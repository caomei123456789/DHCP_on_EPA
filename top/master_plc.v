`include "../master_rtl/define/define.v"
module master_plc(
					input wire i_clk_50,
					//cpu
					input wire i_select,           //CER, 0:valid, 1:invalid
					input wire i_rd_cpu,				//rd_en link to /INIT ?wangkai0351
					input wire i_wr_cpu,				//wr_en
					input wire [12:0] i_addr_cpu,         //AR, A12~A0
					inout wire [15:0] b_data_cpu,         //DR, D15~D0
					//flash
					inout b_sda,
					output wire o_scl,
					//phy
					output wire o_phy_clk0,		
					output wire o_phy_clk1, 		
					inout wire  b_mdio,
					output wire o_mdc,
					output wire o_rst_phy0_n,
					output wire o_rst_phy1_n,
					//DMI
					input wire i_Rx_dv_A,
					input wire [3:0] i_recv_data_A,
					output wire o_Tx_en_A,			
					output wire [3:0]o_send_data_A,
					input wire i_Rx_dv_B,
					input wire [3:0]i_recv_data_B,
					output wire o_Tx_en_B,
					output wire [3:0]o_send_data_B,
					input wire i_Rx_dv_C,
					input wire [3:0]i_recv_data_C,
					output wire o_Tx_en_C,
					output wire [3:0]o_send_data_C,
					
					input wire i_Rx_dv_D,                     //Modified by SYF 2014.5.27
					input wire [3:0]i_recv_data_D,            //Modified by SYF 2014.5.27
					output wire o_Tx_en_D,                    //Modified by SYF 2014.5.27
					output wire [3:0]o_send_data_D,           //Modified by SYF 2014.5.27
					//LED
					output wire o_led_run,
					output wire o_led_rdt,
					output wire o_led_err,
					output wire o_macrocycle_b_up,//8
					output wire o_macrocycle_b_down,//9
					output wire o_rx_dv_A_test,
					output wire o_tx_dv_A_test,
					output wire o_recv_data_valid_int
);
parameter RESET_TIME = 32'd200;
assign o_rx_dv_A_test = i_Rx_dv_A;//10
assign o_tx_dv_A_test = o_Tx_en_A;//7
assign o_macrocycle_b_up = macrocycle_b_up;
assign o_macrocycle_b_down = macrocycle_b_down;
assign csme_en_A = commen_data_rd_done && ((device_type ? main_clock_state_up : main_clock_state_up_pt) || (device_type?start_en_already_A : start_en_already_A_pt));        //Modified by SYF 2014.5.28
assign csme_en_B = commen_data_rd_done && ((device_type ? main_clock_state_up : main_clock_state_up_pt) || (device_type?start_en_already_B : start_en_already_B_pt));        //Modified by SYF 2014.5.28

assign csme_en_C = commen_data_rd_done && (main_clock_state_down || main_clock_state_up_pt || start_en_already_C || start_en_already_C_pt);      //Modified by SYF 2014.5.28
assign csme_en_D = commen_data_rd_done && (main_clock_state_down || start_en_already_D);      //Modified by SYF 2014.5.28

assign slaver_num = 8'd16;
assign mac_rd_addr_D = device_type ? mac_rd_addr_D_tmp : 10'b0;
assign recv_addr_D = device_type ? recv_addr_D_tmp : 10'b0;
assign recv_data_D = device_type ? recv_data_D_tmp : 16'b0;
assign data_valid_D = device_type ? data_valid_D_tmp : 1'b0;
assign link_valid_CD = link_valid_C || link_valid_D;         //Modified by SYF 2014.6.3
assign link_valid_AB = link_valid_A || link_valid_B;         //Modified by SYF 2014.6.3

/********************************wangkai0351 for DHCP***************************************/
//assign o_Tx_en_A = device_type?Tx_en_dim_A:Tx_en_dim_A_up;//wangkai0351 for DHCP
//assign o_send_data_A = device_type?send_data_dim_A:send_data_dim_A_up;//wangkai0351 for DHCP
assign o_send_data_A = o_send_data_A_reg;
reg [3:0] o_send_data_A_reg;
always @(posedge i_clk, negedge i_rst_n)
begin
if(!i_rst_n)
	o_send_data_A_reg <= 4'h0;
	else if(Tx_en_dim_A_up)
	begin
		if(device_type!=16'h0000)
			o_send_data_A_reg <= send_data_dim_A;
		else if(device_type==16'h0000)
			o_send_data_A_reg <= send_data_dim_A_up;
	end
	else if(!Tx_en_dim_A_up)
		o_send_data_A_reg <= send_data_dhcp_A;
	else
		o_send_data_A_reg <= 4'h0;
end

assign o_Tx_en_A = o_Tx_en_A_reg;
reg o_Tx_en_A_reg;
always @(posedge i_clk, negedge i_rst_n)
begin
if(!i_rst_n)
	o_Tx_en_A_reg <= 1'b0;
	else if(Tx_en_dim_A_up)
	begin
		if(device_type!=16'h0000)
			o_Tx_en_A_reg <= Tx_en_dim_A;
		else if(device_type==16'h0000)
			o_Tx_en_A_reg <= Tx_en_dim_A_up;
	end
	else if(!Tx_en_dim_A_up)
		o_Tx_en_A_reg <= Tx_en_dhcp_A;
	else
		o_Tx_en_A_reg <= 1'b0;
end

//assign o_Tx_en_B = device_type?Tx_en_dim_B:Tx_en_dim_B_up;//wangkai0351 for DHCP
//assign o_send_data_B = device_type?send_data_dim_B:send_data_dim_B_up;//wangkai0351 for DHCP
assign o_send_data_B = o_send_data_B_reg;
reg [3:0] o_send_data_B_reg;
always @(posedge i_clk, negedge i_rst_n)
begin
if(!i_rst_n)
	o_send_data_B_reg <= 4'h0;
	else if(Tx_en_dim_B_up)
	begin
		if(device_type!=16'h0000)
			o_send_data_B_reg <= send_data_dim_B;
		else if(device_type==16'h0000)
			o_send_data_B_reg <= send_data_dim_B_up;
	end
	else if(!Tx_en_dim_B_up)
		o_send_data_B_reg <= send_data_dhcp_B;
	else
		o_send_data_B_reg <= 4'h0;
end

assign o_Tx_en_B = o_Tx_en_B_reg;
reg o_Tx_en_B_reg;
always @(posedge i_clk, negedge i_rst_n)
begin
if(!i_rst_n)
	o_Tx_en_B_reg <= 1'b0;
	else if(Tx_en_dim_B_up)
	begin
		if(device_type!=16'h0000)
			o_Tx_en_B_reg <= Tx_en_dim_B;
		else if(device_type==16'h0000)
			o_Tx_en_B_reg <= Tx_en_dim_B_up;
	end
	else if(!Tx_en_dim_B_up)
		o_Tx_en_B_reg <= Tx_en_dhcp_B;
	else
		o_Tx_en_B_reg <= 1'b0;
end

/********************************wangkai0351 for DHCP***************************************/

assign o_Tx_en_C = device_type?Tx_en_dim_C:Tx_en_dim_C_up;
assign o_send_data_C = device_type?send_data_dim_C:send_data_dim_C_up;

reg [31:0]cnt;
reg i_rst_n;
reg i_clk;

reg link_valid_A_1clk, link_valid_B_1clk;
reg link_valid_C_1clk, link_valid_D_1clk;
reg i_Rx_dv_A_1clk, i_Rx_dv_B_1clk;
reg i_Rx_dv_C_1clk, i_Rx_dv_D_1clk;          //Modified by SYF 2014.5.27

reg A_recv_data, B_recv_data;
reg C_recv_data, D_recv_data;             //Modified by SYF 2014.5.27
reg A_link_B, B_link_A;
reg C_link_D, D_link_C;         //Modified by SYF 2014.5.27	
//mm
wire mm_irq_up;                          //Modified by SYF 2014.5.27
wire [9:0]mm_len_up;                     //Modified by SYF 2014.5.27
wire mm_nxt_pkg_up;                      //Modified by SYF 2014.5.27
wire [15:0]mm_data_up;                   //Modified by SYF 2014.5.27
wire [9:0]mm_rd_addr_up;                 //Modified by SYF 2014.5.27
wire [2:0]mm_port_select;

wire mm_irq_down;                          //Modified by SYF 2014.5.27
wire [9:0]mm_len_down;                     //Modified by SYF 2014.5.27
wire mm_nxt_pkg_down;                      //Modified by SYF 2014.5.27
wire [15:0]mm_data_down;                   //Modified by SYF 2014.5.27
wire [9:0]mm_rd_addr_down;                 //Modified by SYF 2014.5.27

wire [15:0]dobjid;
wire [15:0]subidx;
wire emib_wr_en;
wire [15:0]mm_to_emib_data;
wire emib_rd_en;
wire [9:0] emib_to_mm_data_len;
wire [15:0]emib_to_mm_data;
wire mm_status;

wire csme_en_A;
wire csme_en_B;
wire csme_en_C;
wire csme_en_D;               //Modified by SYF 2014.5.28

wire mm_trig;
wire [31:0] main_clock_ip_up;
wire [31:0] main_clock_ip_down;    //Modifeid by SYF 2014.5.28
wire [31:0] main_clock_ip_up_pt;
wire [7:0] ptp_msgid;

wire link_valid_A; 
wire link_valid_B; 
wire link_valid_C; 
wire link_valid_D;   //Modified by SYF 2014.5.28
//DPRAM
wire  [15:0] wr_dpram_data_a_up;
wire  [15:0] rd_dpram_data_a_up;        //Modified by SYF 2014.5.20
wire  [15:0] wr_dpram_data_b_up;
wire  [15:0] rd_dpram_data_b_up;        //Modified by SYF 2014.5.20
wire  wr_dpram_en_a_up;
wire  rd_dpram_en_a_up;                   //Modified by SYF 2014.5.20
wire  wr_dpram_en_b_up;
wire rd_dpram_en_b_up;                   //Modified by SYF 2014.5.20 
wire [`DPRAM_ADDR_DEPTH-1:0] dpram_addr_a_up;
wire [`DPRAM_ADDR_DEPTH-1:0] dpram_addr_b_up;               //Modified by SYF 2014.5.20

wire  [15:0] wr_dpram_data_a_down;
wire  [15:0] rd_dpram_data_a_down;        //Modified by SYF 2014.5.20
wire  [15:0] wr_dpram_data_b_down;
wire  [15:0] rd_dpram_data_b_down;        //Modified by SYF 2014.5.20
wire  wr_dpram_en_a_down;
wire  rd_dpram_en_a_down;                   //Modified by SYF 2014.5.20
wire  wr_dpram_en_b_down;
wire  rd_dpram_en_b_down;                   //Modified by SYF 2014.5.20 
wire [`DPRAM_ADDR_DEPTH-1:0] dpram_addr_a_down;
wire [`DPRAM_ADDR_DEPTH-1:0] dpram_addr_b_down;               //Modified by SYF 2014.5.20

wire mm_rd_dpram_en;
wire [`DPRAM_ADDR_DEPTH-1:0] mm_rd_dpram_addr;                   //Modified by SYF 2014.5.20
wire rd_rsp_en;

wire macrocycle_b_up;               //Modified by SYF 2014.5.27
reg macrocycle_b_up_1clk;           //Modified by SYF 2014.5.27
wire macrocycle_b_down;               //Modified by SYF 2014.5.27
reg macrocycle_b_down_1clk;           //Modified by SYF 2014.5.27
wire commen_data_rd_done;
//EMIB		
wire [47:0] local_node_mac;
wire [31:0] local_node_ip;
wire write_emib_done;
wire read_emib_done;
wire write_emib_error;
wire read_emib_error;
//Modifieid by SYF 2014.3.13
wire [15:0] device_type;
wire [15:0] device_state;
wire [31:0] MacroCycle_time_uplayer;
wire [31:0] RealCycle_time_uplayer;
wire [31:0] Sendtime_offset_uplayer;
wire [15:0] out_data_len_uplayer_local;
wire [15:0] out_data_len_uplayer_up;
wire [15:0] out_data_len_uplayer_down;
wire [15:0] out_data_len_uplayer_net;           //Modified by SYF 2014.5.22
wire [31:0] MacroCycle_time_downlayer;
wire [31:0] RealCycle_time_downlayer;
wire [31:0] Sendtime_offset_downlayer;
wire [15:0] out_data_len_downlayer_local;
wire [15:0] out_data_len_downlayer_up;
wire [15:0] out_data_len_downlayer_down;
wire [15:0] out_data_len_downlayer_net;         //Modified by SYF 2014.5.22

//**************************************
wire [15:0] frt_linknum_up;                     //Modified by SYF 2014.4.25
wire [15:0] frt_linknum_down;                   //Modified by SYF 2014.4.25
wire [15:0] num_link_obj_uplayer_local;
wire [15:0] num_link_obj_downlayer_local;
wire [15:0] num_link_obj_uplayer_net;           //Modified by SYF 2014.5.20
wire [15:0] num_link_obj_downlayer_net;         //Modified by SYF 2014.5.20
wire [15:0] frt_linknum_net_up;                 //Modified by SYF 2014.5.20
wire [15:0] frt_linknum_net_down;               //Modified by SYF 2014.5.20
wire [15:0] num_device_uplayer;           		//Modified by SYF 2014.4.13
wire [15:0] num_device_downlayer;           		//Modified by SYF 2014.4.25
wire [15:0] device_setnum_up;                   //Modified by SYF 2014.4.25
wire [15:0] device_setnum_down;                 //Modified by SYF 2014.4.25

wire [15:0] o_linkobj_net_num_up;               //Modified by SYF 2014.3.5
wire [15:0] in_slave_len_net_up;                //Modofied by SYF 2014.3.6
wire [15:0] in_slave_offset_net_up;
wire [15:0] in_save_offset_net_up;
wire in_flag_index_up;

//Modified by SYF 2014.3.17
//link index
wire [15:0] in_link_device_type_up;              //Modified by SYF 2014.5.19
wire [15:0] in_slave_len_local_up;               //Modified by SYF 2014.5.21
wire [15:0] in_slave_offset_local_up;            //Modified by SYF 2014.5.21
wire [15:0] in_save_offset_local_up;             //Modified by SYF 2014.5.21
wire [15:0] in_link_device_type_down;            //Modified by SYF 2014.5.8
wire [15:0] in_slave_len_local_down;             //Modified by SYF 2014.5.21
wire [15:0] in_slave_offset_local_down;          //Modified by SYF 2014.5.21
wire [15:0] in_save_offset_local_down;           //Modified by SYF 2014.5.21
wire [15:0] o_linkobj_net_num_down;              //Modified by SYF 2014.3.5
wire [15:0] in_slave_len_net_down;               //Modofied by SYF 2014.3.6
wire [15:0] in_slave_offset_net_down;
wire [15:0] in_save_offset_net_down;
wire in_flag_index_down;
//End modified

//FRT
wire frt_irq_up;                  //Modified by SYF 2014.5.27 
wire [9:0]frt_len_up;             //Modified by SYF 2014.5.27
wire frt_nxt_pkg_up;              //Modified by SYF 2014.5.27
wire [15:0]frt_data_up;           //Modified by SYF 2014.5.27
wire [9:0]frt_rd_addr_up;         //Modified by SYF 2014.5.27
wire [1:0]frt_port_select;

wire frt_irq_down;                  //Modified by SYF 2014.5.27 
wire [9:0]frt_len_down;             //Modified by SYF 2014.5.27
wire frt_nxt_pkg_down;              //Modified by SYF 2014.5.27
wire [15:0]frt_data_down;           //Modified by SYF 2014.5.27
wire [9:0]frt_rd_addr_down;         //Modified by SYF 2014.5.27
//nfrt
wire nfrt_irq_up;                  //Modified by SYF 2014.5.27 
wire [9:0]nfrt_len_up;             //Modified by SYF 2014.5.27
wire nfrt_nxt_pkg_up;              //Modified by SYF 2014.5.27
wire [15:0]nfrt_data_up;           //Modified by SYF 2014.5.27
wire [9:0]nfrt_rd_addr_up;         //Modified by SYF 2014.5.27


wire dpram_index_irq;
wire dpram_index_dn;
wire [31:0]dpram_ip;
wire [15:0]frt_offset_len;
wire [15:0]frt_offset_data;
wire [15:0]frt_save_offset;
wire frt_cs;

//PTP			
wire ptp_irq_A;                   //Modified by SYF 2014.5.27
wire [9:0]ptp_len_A;              //Modified by SYF 2014.5.27
wire ptp_nxt_pkg_A;               //Modified by SYF 2014.5.27
wire [15:0]ptp_data_A;            //Modified by SYF 2014.5.27
wire [9:0]ptp_rd_addr_A;          //Modified by SYF 2014.5.27
	
wire [15:0] len_master_clock_A;   //Modified by SYF 2014.5.23
wire [15:0] len_master_clock_B;   //Modified by SYF 2014.5.23
wire [15:0] len_master_clock_C;   //Modified by SYF 2014.5.28
wire [15:0] len_master_clock_D;   //Modified by SYF 2014.5.28

wire ptp_irq_B;
wire [9:0]ptp_len_B;
wire ptp_nxt_pkg_B;
wire [15:0]ptp_data_B;
wire [9:0]ptp_rd_addr_B;

wire ptp_irq_C;                   //Modified by SYF 2014.5.27
wire [9:0]ptp_len_C;              //Modified by SYF 2014.5.27
wire ptp_nxt_pkg_C;               //Modified by SYF 2014.5.27
wire ptp_nxt_pkg_C_pt;               //Modified by SYF 2014.5.27
wire [15:0]ptp_data_C;            //Modified by SYF 2014.5.27
wire [9:0]ptp_rd_addr_C;          //Modified by SYF 2014.5.27
wire [9:0]ptp_rd_addr_C_pt;          //Modified by SYF 2014.5.27


wire ptp_irq_D;                   //Modified by SYF 2014.5.27
wire [9:0]ptp_len_D;              //Modified by SYF 2014.5.27
wire ptp_nxt_pkg_D;               //Modified by SYF 2014.5.27
wire [15:0]ptp_data_D;            //Modified by SYF 2014.5.27
wire [9:0]ptp_rd_addr_D;          //Modified by SYF 2014.5.27

wire [31:0] ptptime_second_A; 
wire [31:0] ptptime_second_B; 
wire [31:0] ptptime_second_C; 
wire [31:0] ptptime_second_D;   //Modified by SYF 2014.5.28
wire [31:0] ptptime_nanosecond_A; 
wire [31:0] ptptime_nanosecond_B; 
wire [31:0] ptptime_nanosecond_C; 
wire [31:0] ptptime_nanosecond_D;  //Modified by SYF 2014.5.28

wire [31:0]second_frt_send_A;
wire [31:0]nanosecond_frt_send_A;

wire [31:0]second_frt_send_B;
wire [31:0]nanosecond_frt_send_B;	

wire [31:0]second_frt_send_C;             //Modified by SYF 2014.5.28
wire [31:0]nanosecond_frt_send_C;         //Modified by SYF 2014.5.28

wire [31:0]second_frt_send_D;             //Modified by SYF 2014.5.28
wire [31:0]nanosecond_frt_send_D;	      //Modified by SYF 2014.5.28

wire get_time_en_frt0_s_A;
wire get_time_en_sync_s_A;	

wire get_time_en_frt0_s_B;
wire get_time_en_sync_s_B;

wire get_time_en_frt0_m_A;
wire get_time_en_sync_m_A;

wire get_time_en_frt0_m_B;
wire get_time_en_sync_m_B;

wire get_time_en_frt0_s_C;                //Modified by SYF 2014.5.28
wire get_time_en_sync_s_C;	               //Modified by SYF 2014.5.28

wire get_time_en_frt0_s_D;                //Modified by SYF 2014.5.28
wire get_time_en_sync_s_D;                //Modified by SYF 2014.5.28

wire get_time_en_frt0_m_C;                //Modified by SYF 2014.5.28
wire get_time_en_sync_m_C;                //Modified by SYF 2014.5.28

wire get_time_en_frt0_m_D;                //Modified by SYF 2014.5.28
wire get_time_en_sync_m_D;                //Modified by SYF 2014.5.28

wire [31:0]ptp_loop_ip;
wire ptp_spd_valid;
//main_clock_compete
wire mcc_irq_A;       //Modified by SYF 2014.5.27
wire mcc_irq_B;       //Modified by SYF 2014.5.27

wire [15:0]mcc_data_up;          //Modified by SYF 2014.5.27
wire [9:0]mcc_rd_addr_up;        //Modified by SYF 2014.5.27
wire [9:0]mcc_len_up;	         //Modified by SYF 2014.5.27
wire mcc_nxt_pkg_up;             //Modified by SYF 2014.5.27

wire mcc_irq_C;       //Modified by SYF 2014.5.27
wire mcc_irq_D;       //Modified by SYF 2014.5.27

wire [15:0]mcc_data_down;          //Modified by SYF 2014.5.27
wire [9:0]mcc_rd_addr_down;        //Modified by SYF 2014.5.27
wire [9:0]mcc_len_down;	           //Modified by SYF 2014.5.27
wire mcc_nxt_pkg_down;             //Modified by SYF 2014.5.27


wire main_clock_state_up;              //Modified by SYF 2014.5.28
wire main_clock_state_down;            //Modified by SYF 2014.5.28
wire main_clock_state_adv_up;          //Modified by SYF 2014.6.14
wire main_clock_state_adv_down;        //Modified by SYF 2014.6.14

wire main_clock_state_send;  //xg

//CSME
wire SyncReq_trig;

wire [31:0]frt_ind;
wire pdo_trig_up;            //Modified by SYF 2014.5.28
wire pdo_trig_down;          //Modified by SYF 2014.5.28
wire [31:0]frt_src_ip;
wire [7:0]frt_pri;
wire frt_rec_dn;

//BUS
wire mac_irq_A;              //Modified by SYF 2014.5.27
wire [9:0]mac_len_A;         //Modified by SYF 2014.5.27
wire mac_nxt_pkg_A;          //Modified by SYF 2014.5.27
wire [15:0]mac_data_A;       //Modified by SYF 2014.5.27
wire [9:0]mac_rd_addr_A;     //Modified by SYF 2014.5.27
wire [2:0]mac_port_select_A;

wire mac_irq_B;
wire [9:0]mac_len_B;
wire mac_nxt_pkg_B;
wire [15:0]mac_data_B;
wire [9:0]mac_rd_addr_B;

wire mac_irq_C;              //Modified by SYF 2014.5.27
wire [9:0]mac_len_C;         //Modified by SYF 2014.5.27
wire mac_nxt_pkg_C;          //Modified by SYF 2014.5.27
wire [15:0]mac_data_C;       //Modified by SYF 2014.5.27
wire [9:0]mac_rd_addr_C;     //Modified by SYF 2014.5.27
wire [2:0]mac_port_select_C;

wire mac_irq_C_pt;              //Modified by SYF 2014.5.27
wire [9:0]mac_len_C_pt;         //Modified by SYF 2014.5.27
wire mac_nxt_pkg_C_pt;          //Modified by SYF 2014.5.27
wire [15:0]mac_data_C_pt;       //Modified by SYF 2014.5.27
wire [9:0]mac_rd_addr_C_pt;     //Modified by SYF 2014.5.27
wire [2:0]mac_port_select_C_pt;

wire mac_irq_C_dmi;              //Modified by SYF 2014.5.27
wire [9:0]mac_len_C_dmi;         //Modified by SYF 2014.5.27
wire mac_nxt_pkg_C_dmi;          //Modified by SYF 2014.5.27
wire [15:0]mac_data_C_dmi;       //Modified by SYF 2014.5.27
wire [9:0]mac_rd_addr_C_dmi;     //Modified by SYF 2014.5.27
wire [2:0]mac_port_select_C_dmi;

wire mac_irq_D;              //Modified by SYF 2014.5.27
wire [9:0]mac_len_D;         //Modified by SYF 2014.5.27
wire mac_nxt_pkg_D;          //Modified by SYF 2014.5.27
wire [15:0]mac_data_D;       //Modified by SYF 2014.5.27
wire [9:0]mac_rd_addr_D;     //Modified by SYF 2014.5.27	

//MAC

wire [15:0] recv_data_A;
wire data_valid_A;
wire [9:0]recv_addr_A;  

wire [15:0] recv_data_B;
wire data_valid_B;
wire [9:0]recv_addr_B;         


wire GetTimeEn_send;
wire GetTimeEn_recv;

wire [3:0] data_recv_A;
wire [3:0] data_recv_B;
wire [3:0] data_recv_C;    //Modified by SYF 2014.5.28
wire [3:0] data_recv_D;    //Modified by SYF 2014.5.28

wire [3:0] data_send_A;    //Modified by SYF 2014.5.28
wire EtxEn_A;              //Modified by SYF 2014.5.28

wire [3:0] data_send_B;
wire EtxEn_B;

wire [3:0] data_send_C;    //Modified by SYF 2014.5.28
wire EtxEn_C;              //Modified by SYF 2014.5.28
wire [3:0] data_send_D;    //Modified by SYF 2014.5.28
wire EtxEn_D;              //Modified by SYF 2014.5.28

wire ErxDv_A;
wire ErxDv_B;
wire ErxDv_C;          //Modified by SYF 2014.5.28
wire ErxDv_D;          //Modified by SYF 2014.5.28

wire send_recvn_s_A;
wire send_recvn_m_A;

wire send_recvn_s_B;
wire send_recvn_m_B;

wire send_recvn_s_C;  //Modified by SYF 2014.5.28
wire send_recvn_m_C;  //Modified by SYF 2014.5.28

wire send_recvn_s_D;  //Modified by SYF 2014.5.28
wire send_recvn_m_D;  //Modified by SYF 2014.5.28

//DMI
wire [15:0]porta_recv_num;
wire [15:0]portb_recv_num;

wire recv_port_id;
//flash
wire [15:0] flash_wr_data;
wire [`ADDR_SZ-1:0] flash_wr_addr_offset;    //Modified by SYF 2014.5.20
wire [`ADDR_SZ-1:0] flash_data_len;          //Modified by SYF 2014.5.20
wire flash_rd_irq;

wire [15:0] flash_to_emib_wr_data;
wire flash_to_emib_rd_en;
wire [`ADDR_SZ-1:0] flash_to_emib_rd_addr;   //Modified by SYF 2014.5.20
wire flash_to_emib_read_done;
wire flash_wr_irq;
wire flash_wr_en;
wire [`ADDR_SZ-1:0] flash_wr_addr;           //Modified by SYF 2014.5.20
//flash channel
wire emib_wr_irq;
wire [15:0] emib_to_flash_wr_data;
wire [`ADDR_SZ-1:0] emib_to_flash_wr_addr_offset;   //Modified by SYF 2014.5.20
wire [`ADDR_SZ-1:0] emib_to_flash_data_len;         //Modified by SYF 2014.5.20
wire flash_to_emib_wr_en;
wire [`ADDR_SZ-1:0] flash_to_emib_wr_addr;          //Modified by SYF 2014.5.20
wire wr_dn;
wire dpram_wr_irq;
wire [15:0] dpram_to_flash_wr_data;
wire [`ADDR_SZ-1:0] dpram_to_flash_wr_addr_offset;    //Modified by SYF 2014.5.20
wire [`ADDR_SZ-1:0] dpram_to_flash_data_len;          //Modified by SYF 2014.5.20
wire flash_to_dpram_wr_en;
wire [`ADDR_SZ-1:0] flash_to_dpram_wr_addr;           //Modified by SYF 2014.5.20
wire [15:0] flash_to_dpram_wr_data;


wire new_ptptime_comp_done;
wire [31:0] new_ptptime_second;
wire [31:0] new_ptptime_nanosecond;

/****************CPU interface****************/

wire [`DPRAM_ADDR_DEPTH-1:0] addr_cpu;                //Modified by SYF 2014.5.20
wire [15:0]data_cpu;
wire rd_wr_cpu;
wire oe_cpu;
wire cpu_cs;
wire busy_cpu;

wire  [15:0] recv_data_C; 
wire  [15:0] send_data_C;               //Modified by SYF 2014.5.28
wire  [9:0]  recv_addr_C; 
wire  [9:0]  send_addr_C;                //Modified by SYF 2014.5.28
wire  [15:0] recv_data_D; 
wire  [15:0] send_data_D;               //Modified by SYF 2014.5.28
wire  [9:0]  recv_addr_D; 
wire  [9:0]  send_addr_D;                //Modified by SYF 2014.5.28

wire data_valid_C;       //Modified by SYF 2014.5.28
wire data_valid_D;       //Modified by SYF 2014.5.28
 
//ARP
wire arp_irq;
wire [9:0]arp_len;
wire arp_nxt_pkg;
wire [15:0]arp_data;
wire [9:0]arp_rd_addr;

/**********************end***********************/
wire cpu_err;
wire initDn;
wire master_state;
wire clk_100;
wire start_en;

wire start_en_already_A;
wire start_en_already_B;
wire start_en_already_C;            //Modified by SYF 2014.5.28
wire start_en_already_D;            //Modified by SYF 2014.5.28
wire main_clock_lost;
//*******************************************************************
wire [47:0] index_mac_up;						//modified by SYF 2014.5.21
wire [31:0] plant_ip_up;                  //modified by SYF 2014.5.21
wire [31:0] plant_toffset_up;             //modified by SYF 2014.5.21
wire [15:0] plant_datalen_up;             //modified by SYF 2014.5.21
wire [15:0] plant_interval_up;            //modified by SYF 2014.5.21
wire plant_index_irq_up;						//modified by SYF 2014.5.21
wire plant_index_done_up;						//modified by SYF 2014.5.21 
wire plant_index_error_up;						//modified by SYF 2014.5.21

wire [47:0] index_mac_down;				   //modified by SYF 2014.5.21
wire [31:0] plant_ip_down;                //modified by SYF 2014.5.21
wire [31:0] plant_toffset_down;           //modified by SYF 2014.5.21
wire [15:0] plant_datalen_down;           //modified by SYF 2014.5.21
wire [15:0] plant_interval_down;          //modified by SYF 2014.5.21
wire plant_index_irq_down;						//modified by SYF 2014.5.21
wire plant_index_done_down;				   //modified by SYF 2014.5.21 
wire plant_index_error_down;				   //modified by SYF 2014.5.21
//*******************************************************************
wire o_link_valid_up; 
wire o_link_valid_down;            //Modified by SYF 2014.5.28
wire opc_pkg_trig;
wire config_done;
wire config_status;
wire [15:0] write_emib_data;
wire write_emib_en;
wire [9:0] write_emib_len;
//Modified by SYF 2014.6.18
wire send_irq_opc;
wire [9:0]  send_addr_opc;
wire [15:0] send_data_opc;
wire [15:0] length_opc;
wire wr_dpram_en_b_up_opc;
wire [`DPRAM_ADDR_DEPTH-1:0] dpram_addr_b_up_opc;
wire [15:0] wr_dpram_data_b_up_opc;
wire [31:0] src_ip;
wire recv_MAC_data_from_A; 
wire recv_MAC_data_from_B; 
wire recv_MAC_data_from_C; 
wire recv_MAC_data_from_D;    //Modified by SYF 2014.5.28

wire recv_frt_main_from_A; 
wire recv_frt_main_from_B; 
wire recv_frt_main_from_C; 
wire recv_frt_main_from_D;    //Modified by SYF 2014.5.28

wire recv_ptp_time_from_A; 
wire recv_ptp_time_from_B; 
wire recv_ptp_time_from_C; 
wire recv_ptp_time_from_D;    //Modified by SYF 2014.5.28

wire main_clock_compete_from_A; 
wire main_clock_compete_from_B;
wire main_clock_compete_from_C;
wire main_clock_compete_from_D;   //Modified by SYF 2014.5.29

wire stop_send_remcc_up;       //Modified by SYF 2014.5.29
wire stop_send_remcc_down;     //Modified by SYF 2014.5.29
wire stop_send_remcc2_down;    //Modified by SYF 2014.6.11

wire Rx_dv_A_macrocycle; 
wire Rx_dv_B_macrocycle;
wire Rx_dv_C_macrocycle; 
wire Rx_dv_D_macrocycle;      //Modified by SYF 2014.5.29

wire  closing_csme_up;           //Modified by SYF 2014.5.29
wire  closing_csme_down;         //Modified by SYF 2014.5.29

wire frt_main_clock_status_A; 
wire frt_main_clock_status_B;
wire frt_main_clock_status_C; 
wire frt_main_clock_status_D;  //Modified by SYF 2014.6.3

wire [191:0] alarm_data_A;		//20140221
wire send_alarm_to_pdo_A;
wire pack_safe_A;
wire [191:0] alarm_data_B;
wire send_alarm_to_pdo_B;
wire pack_safe_B;	

//*****************************************************
wire [191:0] alarm_data_C;		//Modified by SYF 2014.5.28
wire send_alarm_to_pdo_C;
wire pack_safe_C;
wire [191:0] alarm_data_D;
wire send_alarm_to_pdo_D;
wire pack_safe_D;
wire [9:0]  mac_rd_addr_D_tmp;
wire [9:0]  recv_addr_D_tmp;
wire [15:0] recv_data_D_tmp;
wire data_valid_D_tmp;

wire config_nxt_pkg; 
wire config_irq;
wire config_trig;
wire [9:0] config_len;
wire [15:0] config_data;
wire [9:0] config_rd_addr;
wire sending_frt_down; 
wire sending_mm_down;
wire sending_ptp_C;
wire sending_ptp_D; 
wire sending_mcc_down;

wire sending_frt_up; 
wire sending_mm_up; 
wire sending_ptp_A; 
wire sending_ptp_B; 
wire sending_config; 
wire sending_arp; 
wire sending_mcc_up; 
wire sending_mcc_B;    //Modified by SYF 2014.5.27

wire main_ip_change_up;
wire main_ip_change_down;    //Modified by SYF 2014.5.28

wire link_valid_CD;          //Modified by SYF 2014.6.3
wire link_valid_AB;          //Modified by SYF 2014.6.3

wire o_net_br;
wire [31:0] timeoffset_nanosecond_up; 
wire [31:0] timeoffset_second_up;                  //Modified by SYF 2014.5.28
wire [31:0] timeoffset_nanosecond_down; 
wire [31:0] timeoffset_second_down;              //Modified by SYF 2014.5.28

wire [31:0] index_ip_up;    //Modified by SYF 2014.5.23
wire link_index_dn_local_up; 
wire link_index_irq_local_up;
wire link_index_err_local_up;    //Modified by SYF 2014.5.21

wire link_index_dn_net_up; 
wire link_index_irq_net_up;
wire link_index_err_net_up;      //Modified by SYF 2014.5.19

wire [31:0] index_ip_down;    //Modified by SYF 2014.5.23
wire link_index_dn_local_down;
wire link_index_irq_local_down;
wire link_index_err_local_down;                        //Modified by SYF 2014.5.21
wire link_index_dn_net_down; 
wire link_index_irq_net_down;
wire link_index_err_net_down;                              //Modified by SYF 2014.5.19
//wire config_finish;
wire [7:0]slaver_num;
wire [31:0]MacroCycle_time;
wire [31:0]RealCycle_time;
wire [31:0]Sendtime_offset;

//DHCP wangkai0351
reg default_ip_way;//1-设备IP由上位机组态，0-设备IP不由上位机组态
always @(posedge i_clk)
begin
	default_ip_way <= 1'b0;//先把开关设置为不由上位机组态
end
wire DHCP_begin_en;
wire DHCP_end_en;
wire [31:0] local_node_ip_DHCP;//DHCP service assign local node ip在主时钟竞争前
wire DHCP_server_en;//=1 该设备是DHCP服务器
wire [15:0] DHCP_data;
wire  [9:0]  DHCP_data_len;
wire  DHCP_irq;
wire [9:0]DHCP_rd_addr_up; 
wire DHCP_nxt_pkg_up;
wire [3:0] send_data_dhcp_A,send_data_dhcp_B,send_data_dhcp_C,send_data_dhcp_D;
wire Tx_en_dhcp_A,Tx_en_dhcp_B,Tx_en_dhcp_C,Tx_en_dhcp_D;
DHCP DHCP(
		.i_local_mac(local_node_mac),
		.i_recv_data_A(device_type?16'b0:recv_data_A),
		.i_recv_data_B(device_type?16'b0:recv_data_B),
		.i_recv_data_C(device_type?16'b0:recv_data_C),
		
		.i_recv_data_4_A(i_recv_data_A),
		.i_recv_data_4_B(i_recv_data_B),
		.i_recv_data_4_C(i_recv_data_C),
		
		.i_recv_addr_A(device_type?16'b0:recv_addr_A),
		.i_recv_addr_B(device_type?16'b0:recv_addr_B),
		.i_recv_addr_C(device_type?16'b0:recv_addr_C),
		
		.i_Rx_dv_A(i_Rx_dv_A),
		.i_Rx_dv_B(i_Rx_dv_B),
		.i_Rx_dv_C(i_Rx_dv_C),
		
		//for transmit
		.o_Tx_en_A(Tx_en_dhcp_A),
		.o_send_data_A(send_data_dhcp_A),
		.o_Tx_en_B(Tx_en_dhcp_B),
		.o_send_data_B(send_data_dhcp_B),
		
		.i_data_valid_A(device_type?16'b0:data_valid_A),
		.i_data_valid_B(device_type?16'b0:data_valid_B),
		.i_data_valid_C(device_type?16'b0:data_valid_C),
		
		//BUSCONVERT
		.o_send_DHCP_data(DHCP_data),
		.o_send_DHCP_len(DHCP_data_len),
		.o_send_DHCP_irq(DHCP_irq),
		.i_send_DHCP_addr(DHCP_rd_addr_up),//bus_convert_up输出
		.i_DHCP_nxt_pkg(DHCP_nxt_pkg_up),//bus_convert_up输出
		//counter
		.i_MacroCycle_time_uplayer(MacroCycle_time_uplayer),
		.i_macrocycle_b(macrocycle_b_up),
		.o_DHCP_end_en(DHCP_end_en),
      .i_link_valid_A(link_valid_A),
		.i_link_valid_B(link_valid_B),
      .i_link_valid_C(link_valid_C),
		.i_link_valid_D(link_valid_D),		
		.i_main_clock_ip_up(device_type?main_clock_ip_up:main_clock_ip_up_pt),
		.o_local_node_ip_DHCP(local_node_ip_DHCP),
		.i_main_clock_state(device_type?main_clock_state_up:main_clock_state_up_pt),
		.i_main_clock_compete_end(main_clock_compete_end),//wangkai0351 for DHCP
		/*** common pin***/
		.i_device_type(device_type),
		.i_clk(i_clk),//the system clock
		.i_rst_n(i_rst_n) // the reset signal , low effective

);
//DHCP end

always @(posedge i_clk)
begin
if(cnt <= RESET_TIME )
	cnt <= cnt + 1'b1;
else
	cnt <= cnt;
end

always @(posedge i_clk)
begin
if(cnt > RESET_TIME )
	i_rst_n <= 1'b1;
else
	i_rst_n <= 1'b0;
end

always @(posedge i_clk ,negedge i_rst_n)
	begin
		if(!i_rst_n)
		begin
			link_valid_A_1clk  <= 1'b0;
			link_valid_B_1clk  <= 1'b0;
		end
		else
		begin
			link_valid_A_1clk  <= link_valid_A;
			link_valid_B_1clk  <= link_valid_B;
		end
	end

always @(posedge i_clk ,negedge i_rst_n)
	begin
		if(!i_rst_n)
		begin
			i_Rx_dv_A_1clk  <= 1'b0;
			i_Rx_dv_B_1clk  <= 1'b0;
		end
		else
		begin
			i_Rx_dv_A_1clk  <= i_Rx_dv_A;
			i_Rx_dv_B_1clk  <= i_Rx_dv_B;
		end
	end	
		
//********************************************
//Modified by SYF 2014.5.27
always @(posedge i_clk ,negedge i_rst_n)
	begin
		if(!i_rst_n)
		begin
			link_valid_C_1clk  <= 1'b0;
			link_valid_D_1clk  <= 1'b0;
		end
		else
		begin
			link_valid_C_1clk  <= link_valid_C;
			link_valid_D_1clk  <= link_valid_D;
		end
	end

always @(posedge i_clk ,negedge i_rst_n)
	begin
		if(!i_rst_n)
		begin
			i_Rx_dv_C_1clk  <= 1'b0;
			i_Rx_dv_D_1clk  <= 1'b0;
		end
		else
		begin
			i_Rx_dv_C_1clk  <= i_Rx_dv_C;
			i_Rx_dv_D_1clk  <= i_Rx_dv_D;
		end
	end	


always @(posedge i_clk ,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		macrocycle_b_up_1clk  <= 1'b0;                            //Modified by SYF 2014.5.27
	end
	else
	begin
		macrocycle_b_up_1clk  <= macrocycle_b_up;                 //Modified by SYF 2014.5.27
	end
end

always @(posedge i_clk ,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		macrocycle_b_down_1clk  <= 1'b0;                            //Modified by SYF 2014.5.27
	end
	else
	begin
		macrocycle_b_down_1clk  <= macrocycle_b_down;                 //Modified by SYF 2014.5.27
	end
end		

always @(posedge i_clk_50)
begin
	i_clk <= ~i_clk;
end

always @(posedge i_clk ,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		A_link_B <= 1'b0;
	end	
	else if(!link_valid_A && link_valid_A_1clk)
	begin
		A_link_B <= 1'b0;	
	end
	else if(link_valid_A && !link_valid_B)
	begin
		A_link_B <= 1'b1;	
	end	
	else 
	begin
		A_link_B <= A_link_B;
	end
end

always @(posedge i_clk ,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		B_link_A <= 1'b0;
	end	
	else if(!link_valid_B && link_valid_B_1clk)
	begin
		B_link_A <= 1'b0;	
	end
	else if(link_valid_B && !link_valid_A)
	begin
		B_link_A <= 1'b1;	
	end	
	else 
	begin
		B_link_A <= B_link_A;	
	end
end

//*********************************************
//Modified by SYF 2014.5.27
always @(posedge i_clk ,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		C_link_D <= 1'b0;
	end	
	else if(!link_valid_C && link_valid_C_1clk)
	begin
		C_link_D <= 1'b0;	
	end
	else if(link_valid_C && !link_valid_D)
	begin
		C_link_D <= 1'b1;	
	end	
	else 
	begin
		C_link_D <= C_link_D;
	end
end

always @(posedge i_clk ,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		D_link_C <= 1'b0;
	end	
	else if(!link_valid_D && link_valid_D_1clk)
	begin
		D_link_C <= 1'b0;	
	end
	else if(link_valid_D && !link_valid_C)
	begin
		D_link_C <= 1'b1;	
	end	
	else 
	begin
		D_link_C <= D_link_C;	
	end
end
//***************************************
always @(posedge i_clk ,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		A_recv_data <= 1'b0;
		B_recv_data <= 1'b0;
	end	
	else if(!link_valid_A && link_valid_A_1clk)
	begin
		A_recv_data <= 1'b0;	
	end
	else if(!link_valid_B && link_valid_B_1clk)
	begin
		B_recv_data <= 1'b0;	
	end	
	else if(macrocycle_b_up_1clk && !macrocycle_b_up)               //Modified by SYF 2014.5.27
	begin
		A_recv_data <= 1'b0;
		B_recv_data <= 1'b0;	
	end
	else if((i_Rx_dv_A && !i_Rx_dv_A_1clk) && (i_Rx_dv_B && !i_Rx_dv_B_1clk))
	begin
		A_recv_data <= 1'b1;
		B_recv_data <= 1'b0;		
	end
	else if(i_Rx_dv_A && !i_Rx_dv_B)
	begin
		A_recv_data <= 1'b1;	
		B_recv_data <= 1'b0;	
	end
	else if(i_Rx_dv_B && !i_Rx_dv_A)
	begin
		B_recv_data <= 1'b1;	
		A_recv_data <= 1'b0;	
	end
	else 
	begin
		A_recv_data <= A_recv_data;
		B_recv_data <= B_recv_data;
	end
end

//**************************************************
//Modified by SYF 2014.5.27
always @(posedge i_clk ,negedge i_rst_n)
begin
	if(!i_rst_n)
	begin
		C_recv_data <= 1'b0;
		D_recv_data <= 1'b0;
	end	
	else if(!link_valid_C && link_valid_C_1clk)
	begin
		C_recv_data <= 1'b0;	
	end
	else if(!link_valid_D && link_valid_D_1clk)
	begin
		D_recv_data <= 1'b0;	
	end	
	else if(macrocycle_b_down_1clk && !macrocycle_b_down)                //Modified by SYF 2014.5.27
	begin
		C_recv_data <= 1'b0;
		D_recv_data <= 1'b0;	
	end
	else if((i_Rx_dv_C && !i_Rx_dv_C_1clk) && (i_Rx_dv_D && !i_Rx_dv_D_1clk))
	begin
		C_recv_data <= 1'b1;
		D_recv_data <= 1'b0;		
	end
	else if(i_Rx_dv_C && !i_Rx_dv_D)
	begin
		C_recv_data <= 1'b1;	
		D_recv_data <= 1'b0;	
	end
	else if(i_Rx_dv_D && !i_Rx_dv_C)
	begin
		D_recv_data <= 1'b1;	
		C_recv_data <= 1'b0;	
	end
	else 
	begin
		C_recv_data <= C_recv_data;
		D_recv_data <= D_recv_data;
	end
end
//*******************************************
//****************************************************

flash_interface flash_interface(
		/*** common pin***/
		.i_clk(i_clk),//the system clock
		.i_rst_n(i_rst_n), // the reset signal , low effective
		/***connect with EMIB***/
		.i_wr_irq(flash_wr_irq),// write interrupt,high effective
		.i_flash_data(flash_wr_data),//data for writing into flash
		.i_flash_addr_offset(flash_wr_addr_offset),
		.i_flash_data_len(flash_data_len),
		.i_rd_irq(flash_rd_irq),
		.o_flash_wr_en(flash_wr_en),
		.o_flash_waddr(flash_wr_addr),
		.o_wr_dn(wr_dn),
		/*********read****************************/
		.o_flash_data(flash_to_emib_wr_data),
		.o_flash_rd_en(flash_to_emib_rd_en),
		.o_flash_raddr(flash_to_emib_rd_addr),
		.o_flash_read_done(flash_to_emib_read_done),
		/*** connect with flash***/
		.o_scl(o_scl),
		.b_sda(b_sda)
);


flash_write_channel flash_write_channel(
      .i_clk(i_clk),//the system clock
		.i_rst_n(i_rst_n), 
		/*****emib***************/
		.i_emib_irq(emib_wr_irq),
		.i_emib_data(emib_to_flash_wr_data),//data for writing into flash
		.i_emib_addr_offset(emib_to_flash_wr_addr_offset),
		.i_emib_data_len(emib_to_flash_data_len),
      .o_emib_wr_en(flash_to_emib_wr_en),
		.o_emib_waddr(flash_to_emib_wr_addr),
		/*********dpram*****************/
		.i_dpram_irq(1'b0/*dpram_wr_irq*/),
		.i_dpram_data(dpram_to_flash_wr_data),//data for writing into flash
		.i_dpram_addr_offset(dpram_to_flash_wr_addr_offset),
		.i_dpram_data_len(dpram_to_flash_data_len),
		.o_dpram_wr_en(flash_to_dpram_wr_en),
		.o_dpram_waddr(flash_to_dpram_wr_addr),
		/********flash****************************/		
		.i_flash_wr_en(flash_wr_en),
		.i_flash_waddr(flash_wr_addr),
		.i_wr_dn(wr_dn),
      .o_flash_irq(flash_wr_irq),// write interrupt,high effective
		.o_flash_data(flash_wr_data),//data for writing into flash
		.o_flash_addr_offset(flash_wr_addr_offset),
		.o_flash_data_len(flash_data_len)
);


MM_MASTER MM_MASTER(
      .i_DHCP_end_en(DHCP_end_en),//wangkai0351 for DHCP
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		//frt
		.i_frt_cs(1'b1),
//*********MII interface signals****************	
		.i_recv_data(recv_MAC_data_from_A ? recv_data_A : (recv_MAC_data_from_B ? recv_data_B : 16'd0)),
		.i_data_valid(recv_MAC_data_from_A ? recv_valid_A : (recv_MAC_data_from_B ? data_valid_B : 1'd0)),
		.i_recv_addr(recv_MAC_data_from_A ? recv_addr_A : (recv_MAC_data_from_B ? recv_addr_B : 10'd0)),
		.o_mm_send_irq(mm_irq_up),                //Modified by SYF 2014.5.27
		.o_send_data(mm_data_up),                 //Modified by SYF 2014.5.27
		.i_send_addr(mm_rd_addr_up),              //Modified by SYF 2014.5.27
		.o_send_mm_len(mm_len_up),	               //Modified by SYF 2014.5.27
		.i_mm_next_pkg(mm_nxt_pkg_up),            //Modified by SYF 2014.5.27
//*********Send MM signal to emib****************			
		.o_dobjid(dobjid),
		.o_subidx(subidx),
		.o_wr_en(emib_wr_en),	
		.o_mm_to_emib_data(mm_to_emib_data),		
//********* MM signal from ptp****************	
		.i_ptp_loop_ip(ptp_loop_ip),
		.i_ptp_spd_valid(ptp_spd_valid),
//********* MM signal from emib****************		
		.o_rd_en(emib_rd_en),
		.i_mm_data_len(emib_to_mm_data_len),
		.i_emib_to_mm_data(emib_to_mm_data),
		.o_rd_emib(rd_rsp_en),
		
		//.i_local_node_ip(local_node_ip),//wangkai0351 for DHCP
		.i_local_node_ip(local_node_ip_DHCP),//wangkai0351 for DHCP
		.i_local_node_mac(local_node_mac),
	
		.i_read_error(read_emib_error),
		.i_write_error(write_emib_error) ,
		.i_write_done(write_emib_done),
		.i_read_done (read_emib_done),	
		
	   .o_mm_status(mm_status),
		.o_port_select(mm_port_select),
		.i_mm_trig(mm_trig),
		.o_csme_en(start_en),
		.i_main_ip_change(main_ip_change_up),    
		.i_main_clock_state(main_clock_state_up || main_clock_state_up_pt),                      //Modified by SYF 2014.5.28
		//**************************************
		.i_frt_linknum_up(num_link_obj_uplayer_local),                    //modified by SYF 2014.4.25
		.i_frt_linknum_down(num_link_obj_downlayer_local),                //modified by SYF 2014.4.25
		.o_frt_linknum_up(frt_linknum_up),                                //modified by SYF 2014.4.25
		.o_frt_linknum_down(frt_linknum_down),                            //modified by SYF 2014.4.25
		.i_frt_linknum_net_up(num_link_obj_uplayer_net),                  //Modified by SYF 2014.5.20
		.i_frt_linknum_net_down(num_link_obj_downlayer_net),              //Modified by SYF 2014.5.20
		.o_frt_linknum_net_up(frt_linknum_net_up),                        //Modified by SYF 2014.5.20
		.o_frt_linknum_net_down(frt_linknum_net_down),                    //Modified by SYF 2014.5.20
		.i_device_setnum_up(num_device_uplayer),                          //modified by SYF 2014.4.25
		.i_device_setnum_down(num_device_downlayer),                      //modified by SYF 2014.4.25
		.o_device_setnum_up(device_setnum_up),                            //modified by SYF 2014.4.25
		.o_device_setnum_down(device_setnum_down)                         //modified by SYF 2014.4.25
		);
wire [12:0] dpram_addr_cpu;
wire        wr_dpram_en_cpu;
wire [15:0]	wr_dpram_data_cpu;
wire        rd_dpram_en_cpu;
	dpram dpram(
			.i_clk_50(i_clk),      //Modified by SYF 2014.6.18
			.i_clk_100(clk_100),
			.i_rst_n(i_rst_n),
			.i_macrocycle_b(macrocycle_b_up),
			.i_device_type(device_type),            //Modified by SYF 2014.6.18
//****************************************************      //Modified by SYF 2014.5.20			
			.i_wr_en_frt_a_up(wr_dpram_en_a_up),
			.i_rd_en_frt_a_up(rd_dpram_en_a_up),
			.i_addr_frt_a_up(dpram_addr_a_up),
			.i_data_frt_a_up(wr_dpram_data_a_up),
		   .o_data_dpram_a_up(rd_dpram_data_a_up),
////////////////////////////////////////////////////////////////////////						
//			.i_wr_en_frt_b_up(device_type ? wr_dpram_en_b_up : wr_dpram_en_b_up_opc),
//			.i_rd_en_frt_b_up(rd_dpram_en_b_up),   
//			.i_addr_frt_b_up(device_type ? dpram_addr_b_up : dpram_addr_b_up_opc),
//			.i_data_frt_b_up(device_type ? wr_dpram_data_b_up : wr_dpram_data_b_up_opc),
//			.o_data_dpram_b_up(rd_dpram_data_b_up), 
   
			.i_wr_en_frt_b_up(device_type ?wr_dpram_en_b_up:wr_dpram_en_cpu),
			.i_rd_en_frt_b_up(device_type ?rd_dpram_en_b_up:rd_dpram_en_cpu),   
			.i_addr_frt_b_up(device_type ?dpram_addr_b_up:dpram_addr_cpu),
			.i_data_frt_b_up(device_type ?wr_dpram_data_b_up:wr_dpram_data_cpu),
			.o_data_dpram_b_up(rd_dpram_data_b_up),  
//*****************************************************
         .i_wr_en_frt_a_down(wr_dpram_en_a_down),
         .i_rd_en_frt_a_down(rd_dpram_en_a_down),             //Modified by SYF 2014.5.12
			.i_addr_frt_a_down(dpram_addr_a_down),
			.i_data_frt_a_down(wr_dpram_data_a_down),
			.o_data_dpram_a_down(rd_dpram_data_a_down),
			
			.i_wr_en_frt_b_down(wr_dpram_en_b_down),
			.i_rd_en_frt_b_down(rd_dpram_en_b_down),             //Modified by SYF 2014.5.12
			.i_addr_frt_b_down(dpram_addr_b_down),
			.i_data_frt_b_down(wr_dpram_data_b_down),
			.o_data_dpram_b_down(rd_dpram_data_b_down)               //Modified by SYF 2014.5.12
//******************************************************      //End Modifieid			
);	

//******************************************************
//Modified by SYF 2014.5.27

macrocycle macrocycle_up(
			.COM_Clk_in(i_clk),
			.COM_Reset_n_in(i_rst_n),
			.CPUIF_MacroCycle_in(MacroCycle_time_uplayer),  // value of macrocycle     //Modified by SYF 2014.5.19 //MacroCycle_time 
			.CPUIF_RealCycle_in(RealCycle_time_uplayer),  //  value of ptime          //Modified by SYF 2014.5.19 //MacroCycle_time 
			
//			.PTP_Time_Sec_in(recv_ptp_time_from_B ? ptptime_second_B : (recv_ptp_time_from_A ?ptptime_second_A:ptptime_second)),//s
//			.PTP_Time_NSec_in(recv_ptp_time_from_B ? ptptime_nanosecond_B : (recv_ptp_time_from_A?ptptime_nanosecond_A:ptptime_nanosecond)),//ns	
			.PTP_Time_Sec_in(ptptime_second),//s
			.PTP_Time_NSec_in(ptptime_nanosecond),//ns
       	.Multi_Time_Limited(),      // limit signal to stop send package in a macrocycle  
			.Multi_MacroCycle_b_out(macrocycle_b_up)   //signal of macrocycle         //Modified by SYF 2014.5.27
);


macrocycle macrocycle_down(
			.COM_Clk_in(i_clk),
			.COM_Reset_n_in(i_rst_n),
			.CPUIF_MacroCycle_in(MacroCycle_time_downlayer),  //**** value of macrocycle     //Modified by SYF 2014.5.27
			.CPUIF_RealCycle_in(RealCycle_time_downlayer),   //****  value of ptime ****         //Modified by SYF 2014.5.27
			
			.PTP_Time_Sec_in(recv_ptp_time_from_D ? ptptime_second_D : ptptime_second_C),//s               //Modified by SYF 2014.5.27
			.PTP_Time_NSec_in(recv_ptp_time_from_D ? ptptime_nanosecond_D : ptptime_nanosecond_C),//ns	  //Modified by SYF 2014.5.27
	
       	.Multi_Time_Limited(),      //**** limit signal to stop send package in a macrocycle  
			.Multi_MacroCycle_b_out(macrocycle_b_down)   //**** signal of macrocycle  
);

//*******************************************************
	emib  emib(
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),

/***************MM signals*************************/	
			.dobjid(dobjid),
			.subidx(subidx),
			.i_rd_en(emib_rd_en),
			.i_wr_en(emib_wr_en),
			.i_mm_data(mm_to_emib_data),
			.base_addr(),
			.o_mm_data(emib_to_mm_data),
			.i_rd_rsp_en(rd_rsp_en),
			.o_write_done(write_emib_done),
			.o_read_done(read_emib_done),
			.o_write_error(write_emib_error),
			.o_read_error(read_emib_error),		
			.o_mm_data_len(emib_to_mm_data_len),
			//***********************************
			.i_frt_linknum_up(frt_linknum_up),                       //modified by SYF 2014.4.25
			.i_frt_linknum_down(frt_linknum_down),                   //modified by SYF 2014.4.25
			.i_frt_linknum_net_up(frt_linknum_net_up),               //Modified by SYF 2014.5.20
		   .i_frt_linknum_net_down(frt_linknum_net_down),           //Modified by SYF 2014.5.20
			.i_device_setnum_up(device_setnum_up),                   //modified by SYF 2014.4.25			
			.i_device_setnum_down(device_setnum_down),               //modified by SYF 2014.4.25			
/***************OPC signals*************************/				
			.i_wr_ram_en(write_emib_en),
		   .i_opc_to_emib_data(write_emib_data),
		   .i_opc_data_len(write_emib_len),
			.i_config_done(config_done),
//			.o_config_done(config_finish),

/***************flash interface signals*************************/		
			.i_flash_raddr(flash_to_emib_wr_addr),
			.o_flash_rd_irq(flash_rd_irq),
			.i_flash_rd_en(flash_to_emib_wr_en),
			.o_flash_data(emib_to_flash_wr_data),
		
			.i_flash_waddr(flash_to_emib_rd_addr),
			.i_flash_data(flash_to_emib_wr_data),	
			.i_flash_wr_en(flash_to_emib_rd_en),
			.o_flash_wr_irq(emib_wr_irq),
			.i_read_flash_done(flash_to_emib_read_done),
			.o_flash_addr_offset(emib_to_flash_wr_addr_offset),
			.o_flash_data_len(emib_to_flash_data_len),
			
/***************plant index signals*************************/		 //modified by SYF 2014.5.21		
		   .i_emib_device_property_addr_up(`Device_Property_Up_Addr),
	      .i_plant_index_irq_up(plant_index_irq_up),
		   .o_plant_index_done_up(plant_index_done_up),
		   .o_plant_index_error_up(plant_index_error_up),
		
		   .i_frt_mac_up(index_mac_up),
		   .o_plant_ip_up(plant_ip_up),
		   .o_plant_toffset_up(plant_toffset_up),
		   .o_plant_datalen_up(plant_datalen_up),
		   .o_plant_interval_up(plant_interval_up),
      
		   .i_emib_device_property_addr_down(`Device_Property_Down_Addr),
         .i_plant_index_irq_down(plant_index_irq_down),
		   .o_plant_index_done_down(plant_index_done_down),
		   .o_plant_index_error_down(plant_index_error_down),
		
		   .i_frt_mac_down(index_mac_down),
		   .o_plant_ip_down(plant_ip_down),
		   .o_plant_toffset_down(plant_toffset_down),
		   .o_plant_datalen_down(plant_datalen_down),
		   .o_plant_interval_down(plant_interval_down),
/***************frt interface signals*************************/				
			.i_frt_ip_up(index_ip_up),
			.o_frt_type(),
			.i_frt_service_role(1'b1),	
			.o_link_device_type_up(in_link_device_type_up),            //Modified by SYF 2014.5.8
			.o_frt_offset_len_local_up(in_slave_len_local_up),         //Modified by SYF 2014.5.21
			.o_frt_data_offset_local_up(in_slave_offset_local_up),     //Modified by SYF 2014.5.21
			.o_frt_save_offset_local_up(in_save_offset_local_up),      //Modified by SYF 2014.5.21

			.i_frt_index_irq_local_up(link_index_irq_local_up),        //Modified by SYF 2014.5.21
			.o_frt_index_done_local_up(link_index_dn_local_up),        //Modified by SYF 2014.5.21
			.o_frt_index_error_local_up(link_index_err_local_up),		  //Modified by SYF 2014.5.21
	
	      .o_linkobj_net_num_up(o_linkobj_net_num_up),               //Modified by SYF 2014.3.5
			.i_frt_index_irq_net_up(link_index_irq_net_up),            //Modified by SYF 2014.3.5
			.o_frt_index_done_net_up(link_index_dn_net_up),            //Modified by SYF 2014.3.5
			.o_frt_index_error_net_up(link_index_err_net_up),	        //Modified by SYF 2014.3.5
			.o_frt_offset_len_net_up(in_slave_len_net_up),             //Modified by SYF 2014.3.6
			.o_frt_data_offset_net_up(in_slave_offset_net_up),
			.o_frt_save_offset_net_up(in_save_offset_net_up),
			.i_flag_index_up(in_flag_index_up), 
			.i_emib_num_link_obj_addr_up(`FRT_Num_Link_Object_Uplayer_Addr),   //Modified by SYF 2014.5.13
		   .i_emib_local_addr_up(`FRT_Link_Object_Local_Up_Addr),                             //Modified by SYF 2014.4.25   //12'h100
		   .i_emib_net_addr_up(`FRT_Link_Object_Net_Up_Addr),                                //Modified by SYF 2014.4.25	 //12'h300	

/***************commen_data signals*************************/	
	      .o_local_node_ip(local_node_ip),                     //Modified by SYF 2014.3.13
		   .o_local_node_mac(local_node_mac),
		   .o_device_type(device_type),
		   .o_device_state(device_state),			
		   .o_macro_cycle_time_uplayer(MacroCycle_time_uplayer),
		   .o_real_cycle_time_uplayer(RealCycle_time_uplayer),
		   .o_frt_send_time_uplayer(Sendtime_offset_uplayer),
		   .o_frt0_data_len_uplayer_local(out_data_len_uplayer_local),
		   .o_frt0_data_len_uplayer_up(out_data_len_uplayer_up),
		   .o_frt0_data_len_uplayer_down(out_data_len_uplayer_down),
			.o_frt0_data_len_uplayer_net(out_data_len_uplayer_net),            //Modified by SYF 2014.5.22
		   .o_macro_cycle_time_downlayer(MacroCycle_time_downlayer),
		   .o_real_cycle_time_downlayer(RealCycle_time_downlayer),
		   .o_frt_send_time_downlayer(Sendtime_offset_downlayer),
		   .o_frt0_data_len_downlayer_local(out_data_len_downlayer_local),
		   .o_frt0_data_len_downlayer_up(out_data_len_downlayer_up),
		   .o_frt0_data_len_downlayer_down(out_data_len_downlayer_down),
			.o_frt0_data_len_downlayer_net(out_data_len_downlayer_net),      //Modified by SYF 2014.5.22
			//***********************************************              //Modified by SYF 2014.4.25
		   .o_num_link_obj_uplayer_local(num_link_obj_uplayer_local),
			.o_num_link_obj_uplayer_net(num_link_obj_uplayer_net),         //Modified by SYF 2014.5.20
		   .o_num_device_uplayer(num_device_uplayer),
		   .o_num_link_obj_downlayer_local(num_link_obj_downlayer_local),
			.o_num_link_obj_downlayer_net(num_link_obj_downlayer_net),     //Modified by SYF 2014.5.20
		   .o_num_device_downlayer(num_device_downlayer),
		   //***********************************************
		   .o_commen_data_rd_done(commen_data_rd_done),                    //Modified by SYF 2014.3.17
		   .i_frt_ip_down(index_ip_down),
		   .i_frt_index_irq_local_down(link_index_irq_local_down),		    //Modified by SYF 2014.5.21
		   .o_frt_index_done_local_down(link_index_dn_local_down),         //Modified by SYF 2014.5.21
		   .o_frt_index_error_local_down(link_index_err_local_down),	    //Modified by SYF 2014.5.21
		   .o_link_device_type_down(in_link_device_type_down),             //Modified by SYF 2014.5.8
			.o_frt_offset_len_local_down(in_slave_len_local_down),          //Modified by SYF 2014.5.21
		   .o_frt_data_offset_local_down(in_slave_offset_local_down),	    //Modified by SYF 2014.5.21
		   .o_frt_save_offset_local_down(in_save_offset_local_down),		 //Modified by SYF 2014.5.21
		   .o_linkobj_net_num_down(o_linkobj_net_num_down),
		   .i_frt_index_irq_net_down(link_index_irq_net_down),	
		   .o_frt_index_done_net_down(link_index_dn_net_down),
		   .o_frt_index_error_net_down(link_index_err_net_down),
	      .o_frt_offset_len_net_down(in_slave_len_net_down),
		   .o_frt_data_offset_net_down(in_slave_offset_net_down),
		   .o_frt_save_offset_net_down(in_save_offset_net_down),
		   .i_flag_index_down(in_flag_index_down),
			.i_emib_num_link_obj_addr_down(`FRT_Num_Link_Object_Downlayer_Addr),   //Modified by SYF 2014.5.13
		   .i_emib_local_addr_down(`FRT_Link_Object_Local_Down_Addr),   //Modified by SYF 2014.4.25  //12'h600
		   .i_emib_net_addr_down(`FRT_Link_Object_Net_Down_Addr)	      //Modified by SYF 2014.4.25  //12'h800			
);			
//wire [15:0] com_num;
//*************************************************************************
//Modified by SYF 2014.5.27

pdo_slave  pdo_slave_up(		
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),
			.i_clk_100(clk_100),
			//wangkai0351 for DHCP
			.i_DHCP_end_en(DHCP_end_en),
			//state_ctrl
			.i_macrocycle_b(macrocycle_b_up),                            //Modified by SYF 2014.5.27
			
			//EMIB
			.i_device_type(device_type),                                 //Modified by SYF 2014.5.21
			.i_out_data_len_local(out_data_len_uplayer_local),           //Modified by SYF 2014.5.21
			.i_out_data_len_up(out_data_len_uplayer_up),                 //Modified by SYF 2014.5.21
			.i_out_data_len_down(out_data_len_uplayer_down),             //Modified by SYF 2014.5.21
			.i_out_data_len_net(out_data_len_uplayer_net),               //Modified by SYF 2014.5.22
			
			.o_index_ip(index_ip_up), 
			.o_link_index_irq_local(link_index_irq_local_up),               //Modified by SYF 2014.5.21
			.i_link_index_dn_local(link_index_dn_local_up),                 //Modified by SYF 2014.5.21
			.i_link_index_err_local(link_index_err_local_up),               //Modified by SYF 2014.5.21
        	
			.i_in_link_device_type(in_link_device_type_up),                 //Modified by SYF 2014.5.21  
			.i_in_slave_len_local(in_slave_len_local_up),                   //Modified by SYF 2014.5.21
			.i_in_slave_offset_local(in_slave_offset_local_up),             //Modified by SYF 2014.5.21
			.i_in_slave_save_offset_local(in_save_offset_local_up),			 //Modified by SYF 2014.5.21			
	      .i_linkobj_net_num(o_linkobj_net_num_up),                       //Modified by SYF 2014.5.21	
			
			.o_link_index_irq_net(link_index_irq_net_up),                   //Modified by SYF 2014.5.21  
			.i_link_index_dn_net(link_index_dn_net_up),                     //Modified by SYF 2014.5.21
			.i_link_index_err_net(link_index_err_net_up),                   //Modified by SYF 2014.5.21
			
			.i_in_slave_len_net(in_slave_len_net_up),                       //Modified by SYF 2014.5.21
			.i_in_slave_offset_net(in_slave_offset_net_up),                 //Modified by SYF 2014.5.21
			.i_in_slave_save_offset_net(in_save_offset_net_up),             //Modified by SYF 2014.5.21
		   .o_flag_index(in_flag_index_up),                                //Modified by SYF 2014.5.21	

						
			//dpram
			//.i_local_ip(local_node_ip),
			.i_local_ip(local_node_ip_DHCP),//wangkai0351 for DHCP
			.i_local_mac(local_node_mac),

			.i_write_dpram_trig(write_dpram_trig_up),             //Modified by SYF 2014.5.28
			.i_read_dpram_trig(read_dpram_trig_up),               //Modified by SYF 2014.5.28
			.i_pdo_trig(pdo_trig_up),                             //Modified by SYF 2014.5.28

			//************************************************		//Modified by SYF 2014.5.21
			.o_wr_dpram_en_up(wr_dpram_en_a_up),                  
			.o_dpram_addr_up(dpram_addr_a_up),
			.o_wr_dpram_data_up(wr_dpram_data_a_up),
			.o_rd_dpram_en(rd_dpram_en_a_up),
			.i_rd_dpram_data(rd_dpram_data_a_up),

			.o_wr_dpram_en_down(wr_dpram_en_b_down),       //wr_dpram_en2_b
			.o_dpram_addr_down(dpram_addr_b_down),         //dpram_addr2_b
			.o_wr_dpram_data_down(wr_dpram_data_b_down),   //wr_dpram_data2_b
         		
			.i_IO_data_In_Local_Addr(`IO_data_In_LocalUp_Addr), 
			.i_IO_data_Out_Local_Addr(`IO_data_Out_LocalUp_Addr),
			.i_IO_data_In_Net_Addr(`IO_data_In_NetUp_Addr), 
		   .i_IO_data_Out_Net_Addr(`IO_data_Out_NetUp_Addr),
			.i_IO_data_In_NetUp_Addr(`IO_data_In_NetUp_Addr),                 //Modified by SYF 2014.3.14         //`IO_data_In_NetUp_Addr
			.i_IO_data_In_NetDown_Addr(`IO_data_In_NetDown_Addr), 
			//************************************************

			//MM
			.i_csme_en(csme_en_A || csme_en_B),//switch of csme  //when i_csme_en is "1", begin to read DPRAM 
																				  //preparing for frt sending	
			//PTP
			.i_sync_data_s(device_type?(csme_en_A ? second_frt_send_A : second_frt_send_B):second_frt_send),//for FRT0 SYNC
			.i_sync_data_ns(device_type?(csme_en_A ? nanosecond_frt_send_A : nanosecond_frt_send_B):nanosecond_frt_send),//FOR FRT0 SYNC
 
			//BUSCONVERT
			.o_pdo_irq(frt_irq_up),               //Modified by SYF 2014.5.27
			.o_pdo_len(frt_len_up),               //Modified by SYF 2014.5.27
			.i_pdo_nxt_pkg(frt_nxt_pkg_up),       //Modified by SYF 2014.5.27
			.o_pdo_data(frt_data_up),             //Modified by SYF 2014.5.27
			.i_pdo_rd_addr(frt_rd_addr_up),       //Modified by SYF 2014.5.27
			
			//MII
			.i_recv_data(recv_MAC_data_from_A ? recv_data_A : (recv_MAC_data_from_B ? recv_data_B : ((recv_MAC_data_from_C && !device_type) ? recv_data_C : 16'd0))),
			.i_data_valid(recv_MAC_data_from_A ? data_valid_A : (recv_MAC_data_from_B ? data_valid_B : ((recv_MAC_data_from_C && !device_type) ? data_valid_C : 1'd0))),
			.i_recv_addr(recv_MAC_data_from_A ? recv_addr_A : (recv_MAC_data_from_B ? recv_addr_B : ((recv_MAC_data_from_C && !device_type) ? recv_addr_C : 10'd0))),
					

			.i_main_clock_state(device_type ?main_clock_state_up :main_clock_state_up_pt),  //xiugai                        //Modified by SYF 2014.5.27
			//.i_main_clock_state_adv(main_clock_state_adv_up),                          //Modified by SYF 2014.6.14
			
			//for test 
			.i_time_offset_s(timeoffset_second_up),                                    //Modified by SYF 2014.5.27
			.i_time_offset_ns(timeoffset_nanosecond_up),                               //Modified by SYF 2014.5.27                                                      //Modified by SYF 2014.5.28		
		
			.o_src_ip(src_ip),
			
			//20140221, support security info for pdo_slave to judge whether this package should be proceeded
			.i_alarm_data_A(alarm_data_A),
			.i_send_alarm_to_pdo_A(send_alarm_to_pdo_A),
			.i_alarm_data_B(alarm_data_B),
			.i_send_alarm_to_pdo_B(send_alarm_to_pdo_B),
			.i_ac_pri(ac_pri),
			.o_ac_send_en(ac_send_en),
			.i_data_valid_int(data_valid_int),
			.i_recv_work_mode(recv_work_mode),
			.o_recv_data_valid_int(o_recv_data_valid_int),
			.i_rd_dpram_en_cpu(rd_dpram_en_cpu)
			);
			
wire ac_send_en;
//reg macrocycle_b_dly;
//always @(posedge i_clk,negedge i_rst_n)
//begin
//	if(!i_rst_n)
//		macrocycle_b_dly <= 1'b0;
//	else 
//		macrocycle_b_dly <= macrocycle_b_up;
//end
//always @(posedge i_clk,negedge i_rst_n)
//begin
//	if(!i_rst_n)
//		ac_send_en <= 1'b0;
//	else if(!macrocycle_b_up && macrocycle_b_dly)
//		ac_send_en <= 1'b1;
//	else if(macrocycle_b_up && !macrocycle_b_dly)
//		ac_send_en <= 1'b0;
//	else 
//		ac_send_en <= ac_send_en;
//end

/********************************************************			
			
********************************************************
Modified by SYF 2014.5.27*/			

ptp_master ptp_master_up(
                    /************************/
                    /*common interface*/
                    /*************************/
                    .i_clk(i_clk),
                    .i_rst_n(i_rst_n),
                    /********************************************************/
                    /*interface for mac*/
                    /********************************************************/
                    .i_recv_data_A(device_type?recv_data_A:16'b0),
                    .i_data_valid_A(device_type?data_valid_A:1'b0),
                    .i_recv_addr_A(device_type?recv_addr_A:10'b0),
						  
                    .i_recv_data_B(device_type?recv_data_B:16'b0),
                    .i_data_valid_B(device_type?data_valid_B:1'b0),
                    .i_recv_addr_B(device_type?recv_addr_B:10'b0),						  
                    /********************************************************/
                    /*interface for hub*/
                    /********************************************************/                   
							.i_send_recvn_s_A(device_type?send_recvn_s_A_pt:send_recvn_s_A),
							.i_GetTimeEn_frt0_s_A(device_type?get_time_en_frt0_s_A_pt:get_time_en_frt0_s_A),
							.i_GetTimeEn_sync_s_A(device_type?get_time_en_sync_s_A_pt:get_time_en_sync_s_A),
							
							.i_send_recvn_s_B(device_type?send_recvn_s_B_pt:send_recvn_s_B),
							.i_GetTimeEn_frt0_s_B(device_type?get_time_en_frt0_s_B_pt:get_time_en_frt0_s_B),
							.i_GetTimeEn_sync_s_B(device_type?get_time_en_sync_s_B_pt:get_time_en_sync_s_B),
							
							.i_send_recvn_m_A(device_type?send_recvn_m_A_pt:send_recvn_m_A),
							.i_GetTimeEn_frt0_m_A(device_type?get_time_en_frt0_m_A_pt:get_time_en_frt0_m_A),
							.i_GetTimeEn_sync_m_A(device_type?get_time_en_sync_m_A_pt:get_time_en_sync_m_A),	

							.i_send_recvn_m_B(device_type?send_recvn_m_B_pt:send_recvn_m_B),
							.i_GetTimeEn_frt0_m_B(device_type?get_time_en_frt0_m_B_pt:get_time_en_frt0_m_B),
							.i_GetTimeEn_sync_m_B(device_type?get_time_en_sync_m_B_pt:get_time_en_sync_m_B),							
							  /*************************/
                    /*interface for csme*/
                    /*************************/
//                    .i_req_trig(SyncReq_trig),
						  .i_macrocycle_b(macrocycle_b_up),               //Modified by SYF 2014.5.27
						  /*************************/
                    /*interface for CSME and MacroCycle*/
                    /*************************/
						  .o_ptptime_second_A(ptptime_second_A),
                    .o_ptptime_nanosecond_A(ptptime_nanosecond_A),
						  
						  .o_ptptime_second_B(ptptime_second_B),
                    .o_ptptime_nanosecond_B(ptptime_nanosecond_B),						  
						  
						  .o_timeoffset_second_B(timeoffset_second_up),                 //Modified by SYF 2014.5.27
                    .o_timeoffset_nanosecond_B(timeoffset_nanosecond_up),         //Modified by SYF 2014.5.27
                    /****************************************/
                    /*interface for data_bus_control */
                    /***************************************/
						  .i_read_addr_A(ptp_rd_addr_A),          //Modified by SYF 2014.5.27
						  .i_next_pkg_A(ptp_nxt_pkg_A),           //Modified by SYF 2014.5.27
						  					  						  
						  .o_send_irq_A(ptp_irq_A),               //Modified by SYF 2014.5.27
                    .o_data_A(ptp_data_A),                  //Modified by SYF 2014.5.27
                    .o_len_A(ptp_len_A),                    //Modified by SYF 2014.5.27
						  
						  .i_read_addr_B(ptp_rd_addr_B),
						  .i_next_pkg_B(ptp_nxt_pkg_B),						  
						  
						  .o_send_irq_B(ptp_irq_B),
                    .o_data_B(ptp_data_B),
                    .o_len_B(ptp_len_B),
                    /*************************/
                    /*interface for FRT*/
                    /*************************/		
						  
			           .o_second_frt_send_A(second_frt_send_A),
					     .o_nanosecond_frt_send_A(nanosecond_frt_send_A),
						  
			           .o_second_frt_send_B(second_frt_send_B),
					     .o_nanosecond_frt_send_B(nanosecond_frt_send_B),
						  /**************************/
						  /*interface for PTP Send Length*/
						  /*************************/
						  .i_out_data_len_local(out_data_len_uplayer_local),           //Modified by SYF 2014.5.23
			           .i_out_data_len_up(out_data_len_uplayer_up),                 //Modified by SYF 2014.5.23
			           .i_out_data_len_down(out_data_len_uplayer_down),             //Modified by SYF 2014.5.23
			           .i_out_data_len_net(out_data_len_uplayer_net),               //Modified by SYF 2014.5.23
						  /**************************/
						  .o_len_master_clock_A(len_master_clock_A),                       //Modified by SYF 2014.5.23
						  .o_len_master_clock_B(len_master_clock_B),                       //Modified by SYF 2014.5.23
                    /*************************/
                    /*interface for MM*/
                    /*************************/	
                    /*************************/
                    /*interface for EMIB*/
                    /*************************/	
                    .i_loop_num(slaver_num),
                    //.i_local_ip(local_node_ip), wangkai0351 for DHCP
						  .i_local_ip(local_node_ip_DHCP),//wangkai0351 for DHCP
                    .i_local_mac(local_node_mac),
                    .i_dpram_valid(1'b1),
						
						  .i_initDn(initDn),
						  .i_main_clock_state(device_type?main_clock_state_up:1'b0),                 //Modified by SYF 2014.5.27
						  .i_main_ip_change(device_type?main_ip_change_up:1'b0),                     //Modified by SYF 2014.5.27
						  //********************************
						  .i_link_valid_A(link_valid_A),    
						  .i_link_valid_B(link_valid_B), 
						  .i_main_clock_ip(device_type?main_clock_ip_up:32'b0),                       //Modified by SYF 2014.5.27
						  
						  .o_start_en_already_A(start_en_already_A),
						  .o_start_en_already_B(start_en_already_B),
						  
						  .Tx_en_A(o_Tx_en_A),
						  .Tx_en_B(o_Tx_en_B),
						  //********************************
						  .i_recv_frt_main_from_A(recv_frt_main_from_A), 
						  .i_recv_frt_main_from_B(recv_frt_main_from_B),
						  	//********************************                                                              
						  .i_csme_en_up(1'b0),                                                                               //Modified by SYF 2014.8.19
						  .i_ptptime_second_up(recv_ptp_time_from_B ? ptptime_second_B : ptptime_second_A),                  //Modified by SYF 2014.8.19
						  .i_ptptime_nanosecond_up(recv_ptp_time_from_B ? ptptime_nanosecond_B : ptptime_nanosecond_A)       //Modified by SYF 2014.8.19			  
	);
	
ptp_master_up ptp_master_up_pt
(
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),
			
			//wangkai0351 for DHCP
			.i_DHCP_end_en(DHCP_end_en),

			
			//state
			.i_initDn(initDn),
			.i_main_clock_state(device_type?1'b0:main_clock_state_up_pt),

			//interface for csme
			.i_macrocycle_b(macrocycle_b_up),

			//main_clock_compete
			.i_main_ip_change(device_type?1'b0:main_ip_change_up_pt),
			.i_main_clock_ip(device_type?32'b0:main_clock_ip_up_pt),

			//emib
			.i_out_data_len(out_data_len),
			//.i_local_ip(local_node_ip),//wangkai0351 for DHCP
			.i_local_ip(local_node_ip_DHCP),//wangkai0351 for DHCP
			.i_local_mac(local_node_mac),

			//link_valid
			.i_link_valid_A(link_valid_A),
			.i_link_valid_B(link_valid_B),
			.i_link_valid_C(link_valid_C),

			//interface for mac
			.i_recv_data_A(device_type?16'b0:recv_data_A),
			.i_data_valid_A(device_type?16'b0:data_valid_A),
			.i_recv_addr_A(device_type?16'b0:recv_addr_A),

			.i_recv_data_B(device_type?16'b0:recv_data_B),
			.i_data_valid_B(device_type?1'b0:data_valid_B),
			.i_recv_addr_B(device_type?10'b0:recv_addr_B),

			.i_recv_data_C(device_type?16'b0:recv_data_C),
			.i_data_valid_C(device_type?1'b0:data_valid_C),
			.i_recv_addr_C(device_type?10'b0:recv_addr_C),

			//interface for dmi
			.i_send_recvn_s_A(device_type?1'b0:send_recvn_s_A_pt),
			.i_GetTimeEn_frt0_s_A(device_type?1'b0:get_time_en_frt0_s_A_pt),
			.i_GetTimeEn_sync_s_A(device_type?1'b0:get_time_en_sync_s_A_pt),
			.i_send_recvn_m_A(device_type?1'b0:send_recvn_m_A_pt),
			.i_GetTimeEn_frt0_m_A(device_type?1'b0:get_time_en_frt0_m_A_pt),
			.i_GetTimeEn_sync_m_A(device_type?1'b0:get_time_en_sync_m_A_pt),

			.i_send_recvn_s_B(device_type?1'b0:send_recvn_s_B_pt),
			.i_GetTimeEn_frt0_s_B(device_type?1'b0:get_time_en_frt0_s_B_pt),
			.i_GetTimeEn_sync_s_B(device_type?1'b0:get_time_en_sync_s_B_pt),
			.i_send_recvn_m_B(device_type?1'b0:send_recvn_m_B_pt),
			.i_GetTimeEn_frt0_m_B(device_type?1'b0:get_time_en_frt0_m_B_pt),
			.i_GetTimeEn_sync_m_B(device_type?1'b0:get_time_en_sync_m_B_pt),

			.i_send_recvn_s_C(device_type?1'b0:send_recvn_s_C_pt),
			.i_GetTimeEn_frt0_s_C(device_type?1'b0:get_time_en_frt0_s_C_pt),
			.i_GetTimeEn_sync_s_C(device_type?1'b0:get_time_en_sync_s_C_pt),
			.i_send_recvn_m_C(device_type?1'b0:send_recvn_m_C_pt),
			.i_GetTimeEn_frt0_m_C(device_type?1'b0:get_time_en_frt0_m_C_pt),
			.i_GetTimeEn_sync_m_C(device_type?1'b0:get_time_en_sync_m_C_pt),

			//interface for data_bus_control
			.i_read_addr_A(ptp_rd_addr_A),
			.i_next_pkg_A(ptp_nxt_pkg_A),
			.o_send_irq_A(ptp_irq_A_pt),
			.o_data_A(ptp_data_A_pt),
			.o_len_A(ptp_len_A_pt),

			.i_read_addr_B(ptp_rd_addr_B),
			.i_next_pkg_B(ptp_nxt_pkg_B),
			.o_send_irq_B(ptp_irq_B_pt),
			.o_data_B(ptp_data_B_pt),
			.o_len_B(ptp_len_B_pt),

			.i_read_addr_C(ptp_rd_addr_C_pt),
			.i_next_pkg_C(ptp_nxt_pkg_C_pt),
			.o_send_irq_C(ptp_irq_C_pt),
			.o_data_C(ptp_data_C_pt),
			.o_len_C(ptp_len_C_pt),

			//output-state
			.o_start_en_already_A(start_en_already_A_pt),
			.o_start_en_already_B(start_en_already_B_pt),
			.o_start_en_already_C(start_en_already_C_pt),

			//interface for CSME and MacroCycle
			.o_ptptime_second(ptptime_second),
			.o_ptptime_nanosecond(ptptime_nanosecond),

			//interface for FRT
			.o_second_frt_send(second_frt_send),
			.o_nanosecond_frt_send(nanosecond_frt_send)
);

wire ptp_irq_A_pt;                   //Modified by SYF 2014.5.27
wire [9:0]ptp_len_A_pt;              //Modified by SYF 2014.5.27
wire [15:0]ptp_data_A_pt;            //Modified by SYF 2014.5.27

wire ptp_irq_B_pt;                   //Modified by SYF 2014.5.27
wire [9:0]ptp_len_B_pt;              //Modified by SYF 2014.5.27
wire [15:0]ptp_data_B_pt;            //Modified by SYF 2014.5.27

wire ptp_irq_C_pt;                   //Modified by SYF 2014.5.27
wire [9:0]ptp_len_C_pt;              //Modified by SYF 2014.5.27
wire [15:0]ptp_data_C_pt;            //Modified by SYF 2014.5.27

wire start_en_already_A_pt;
wire start_en_already_B_pt;
wire start_en_already_C_pt;            //Modified by SYF 2014.5.28

wire [31:0] ptptime_second;
wire [31:0] ptptime_nanosecond;
wire [31:0] second_frt_send;
wire [31:0] nanosecond_frt_send;
ptp_master ptp_master_down(
                    /************************/
                    /*common interface*/
                    /*************************/
                    .i_clk(i_clk),
                    .i_rst_n(i_rst_n),
                    /********************************************************/
                    /*interface for mac*/
                    /********************************************************/
                    .i_recv_data_A(recv_data_C),
                    .i_data_valid_A(data_valid_C),
                    .i_recv_addr_A(recv_addr_C),
						  
                    .i_recv_data_B(recv_data_D),
                    .i_data_valid_B(data_valid_D),
                    .i_recv_addr_B(recv_addr_D),						  
                    /********************************************************/
                    /*interface for hub*/
                    /********************************************************/                   
							.i_send_recvn_s_A(device_type?send_recvn_s_C_pt:send_recvn_s_C),
							.i_GetTimeEn_frt0_s_A(device_type?get_time_en_frt0_s_C_pt:get_time_en_frt0_s_C),
							.i_GetTimeEn_sync_s_A(device_type?get_time_en_sync_s_C_pt:get_time_en_sync_s_C),
							
							.i_send_recvn_s_B(send_recvn_s_D),
							.i_GetTimeEn_frt0_s_B(get_time_en_frt0_s_D),
							.i_GetTimeEn_sync_s_B(get_time_en_sync_s_D),
							
							.i_send_recvn_m_A(device_type?send_recvn_m_C_pt:send_recvn_m_C),
							.i_GetTimeEn_frt0_m_A(device_type?get_time_en_frt0_m_C_pt:get_time_en_frt0_m_C),
							.i_GetTimeEn_sync_m_A(device_type?get_time_en_sync_m_C_pt:get_time_en_sync_m_C),	

							.i_send_recvn_m_B(send_recvn_m_D),
							.i_GetTimeEn_frt0_m_B(get_time_en_frt0_m_D),
							.i_GetTimeEn_sync_m_B(get_time_en_sync_m_D),							
							  /*************************/
                    /*interface for csme*/
                    /*************************/
						  .i_macrocycle_b(macrocycle_b_down),            //Modified by SYF 2014.5.27
						  /*************************/
                    /*interface for CSME and MacroCycle*/
                    /*************************/
						  .o_ptptime_second_A(ptptime_second_C),
                    .o_ptptime_nanosecond_A(ptptime_nanosecond_C),
						  
						  .o_ptptime_second_B(ptptime_second_D),
                    .o_ptptime_nanosecond_B(ptptime_nanosecond_D),						  
						  					  
						  .o_timeoffset_second_B(timeoffset_second_down),                       //Modified by SYF 2014.5.27
                    .o_timeoffset_nanosecond_B(timeoffset_nanosecond_down),               //Modified by SYF 2014.5.27
                    /****************************************/
                    /*interface for data_bus_control */
                    /***************************************/
						  .i_read_addr_A(ptp_rd_addr_C),               //Modified by SYF 2014.5.27
						  .i_next_pkg_A(ptp_nxt_pkg_C),                //Modified by SYF 2014.5.27
						  					  						  
						  .o_send_irq_A(ptp_irq_C),
                    .o_data_A(ptp_data_C),
                    .o_len_A(ptp_len_C),
						  
						  .i_read_addr_B(ptp_rd_addr_D),
						  .i_next_pkg_B(ptp_nxt_pkg_D),						  
						  
						  .o_send_irq_B(ptp_irq_D),
                    .o_data_B(ptp_data_D),
                    .o_len_B(ptp_len_D),
                    /*************************/
                    /*interface for FRT*/
                    /*************************/							  
			           .o_second_frt_send_A(second_frt_send_C),
					     .o_nanosecond_frt_send_A(nanosecond_frt_send_C),
						  
			           .o_second_frt_send_B(second_frt_send_D),
					     .o_nanosecond_frt_send_B(nanosecond_frt_send_D),
                    
						  /**************************/
						  /*interface for PTP Send Length*/
						  /*************************/
						  .i_out_data_len_local(out_data_len_downlayer_local),           //Modified by SYF 2014.5.27
			           .i_out_data_len_up(out_data_len_downlayer_up),                 //Modified by SYF 2014.5.27
			           .i_out_data_len_down(out_data_len_downlayer_down),             //Modified by SYF 2014.5.27
			           .i_out_data_len_net(out_data_len_downlayer_net),               //Modified by SYF 2014.5.27
						  /**************************/
						  .o_len_master_clock_A(len_master_clock_C),                     //Modified by SYF 2014.5.27
						  .o_len_master_clock_B(len_master_clock_D),                     //Modified by SYF 2014.5.27
                    
						  /*************************/ 
						  /*************************/
                    /*interface for MM*/
                    /*************************/	
                    /*************************/
                    /*interface for EMIB*/
                    /*************************/	
                    .i_loop_num(slaver_num),
                    //.i_local_ip(local_node_ip),//wangkai0351 for DHCP
						  .i_local_ip(local_node_ip_DHCP),//wangkai0351 for DHCP
                    .i_local_mac(local_node_mac),
                    .i_dpram_valid(1'b1),

						
						  .i_initDn(initDn),
						  .i_main_clock_state(main_clock_state_down),                    //Modified by SYF 2014.5.27       
						  .i_main_ip_change(main_ip_change_down),                        //Modified by SYF 2014.5.27
						  //********************************
						  .i_link_valid_A(link_valid_C),    
						  .i_link_valid_B(link_valid_D), 
						  .i_main_clock_ip(main_clock_ip_down),                          //Modified by SYF 2014.5.27
						  
						  .o_start_en_already_A(start_en_already_C),
						  .o_start_en_already_B(start_en_already_D),
						  
						  .Tx_en_A(o_Tx_en_C),
						  .Tx_en_B(o_Tx_en_D),
						  //********************************
						  .i_recv_frt_main_from_A(recv_frt_main_from_C), 
						  .i_recv_frt_main_from_B(recv_frt_main_from_D),
						  //********************************                                                              
						  .i_csme_en_up(csme_en_A || csme_en_B),                                                             //Modified by SYF 2014.8.19
						  .i_ptptime_second_up(recv_ptp_time_from_B ? ptptime_second_B : ptptime_second_A),                  //Modified by SYF 2014.8.19
						  .i_ptptime_nanosecond_up(recv_ptp_time_from_B ? ptptime_nanosecond_B : ptptime_nanosecond_A)       //Modified by SYF 2014.8.19
						  
	);		
//********************************************************************	
wire [9:0]len_sync;
wire [31:0]waydelay_second_dly;
wire [31:0]waydelay_nanosecond_dly	;
	
wire  write_dpram_trig_up, read_dpram_trig_up;              //Modified by SYF 2014.5.28
wire  write_dpram_trig_down, read_dpram_trig_down;          //Modified by SYF 2014.5.28
wire  nfrt_rd_dpram_trig, nfrt_wr_dpram_trig;
wire  o_send_mcc_A, o_send_mcc_B;  //sjj Nov_18th
wire  o_send_mcc_C, o_send_mcc_D;  //Modified by SYF 2014.5.29

//*********************************************************
//Modified by SYF 2014.5.27
main_clock_compete main_clock_compete_up(	
			.i_DHCP_end_en(DHCP_end_en),//wangkai0351 for DHCP
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),
			//state_ctrl
			.i_macrocycle_b(macrocycle_b_up),
			//dpram
			//.i_local_ip(local_node_ip),//wangkai0351 for DHCP
			.i_local_ip(local_node_ip_DHCP),//wangkai0351 for DHCP
			.i_local_mac(local_node_mac),
			//phy
			.i_initDn(initDn),
			//emib 
         .i_recv_data_A(device_type?recv_data_A:16'b0),             //Modified by SYF 2014.6.3
         .i_data_valid_A(device_type?data_valid_A:1'b0),           //Modified by SYF 2014.6.3
         .i_recv_addr_A(device_type?recv_addr_A:10'b0),             //Modified by SYF 2014.6.3
					
         .i_recv_data_B(device_type?recv_data_B:16'b0),
         .i_data_valid_B(device_type?data_valid_B:1'b0),
         .i_recv_addr_B(device_type?recv_addr_B:10'b0),	
			
			.i_csme_en(csme_en_A || csme_en_B),	
	
			.i_Rx_dv_A_macrocycle(Rx_dv_A_macrocycle),
			.i_Rx_dv_B_macrocycle(Rx_dv_B_macrocycle),
			.o_stop_send_remcc(stop_send_remcc_up),
			.o_closing_csme(closing_csme_up),
			.i_ptptime_second(link_valid_A ? ptptime_second_A : (link_valid_B ? ptptime_second_B : 32'd0)),
			.i_ptptime_nanosecond(link_valid_A ? ptptime_nanosecond_A : (link_valid_B ? ptptime_nanosecond_B : 32'd0)),	
			
			//bus interface signals 
			.o_mcc_send_irq_A(mcc_irq_A),         //Modified by SYF 2014.5.27
			//sjj Nov_18th
			.o_mcc_send_irq_B(mcc_irq_B),         //Modified by SYF 2014.5.27
			.o_send_mcc_A(o_send_mcc_A),
			.o_send_mcc_B(o_send_mcc_B),	
			.o_send_data(mcc_data_up),            //Modified by SYF 2014.5.27
			.i_send_addr(mcc_rd_addr_up),         //Modified by SYF 2014.5.27
			.o_send_mcc_len(mcc_len_up),	        //Modified by SYF 2014.5.27
			.i_mcc_nxt_pkg(mcc_nxt_pkg_up),       //Modified by SYF 2014.5.27
			//ptp,csme
			.o_main_clock_state(main_clock_state_up),               //Modified by SYF 2014.5.28
			//.o_main_clock_state_adv(main_clock_state_adv_up),       //Modified by SYF 2014.6.14
			.o_main_ip_change(main_ip_change_up),           //Modified by SYF 2014.5.28
			//.o_main_clock_state_send(main_clock_state_send),
			//*******************************
		   .i_frt_main_clock_status_A(frt_main_clock_status_A), 
		   .i_frt_main_clock_status_B(frt_main_clock_status_B),					
			.i_link_valid(link_valid_AB),     //Modified by SYF 2014.6.3
			.i_link_valid_A_real(link_valid_A),    
			.i_link_valid_B_real(link_valid_B), 

			.o_main_clock_ip(main_clock_ip_up),              //Modified by  SYF 2014.5.28
		   .i_csme_en_A(csme_en_A),
		   .i_csme_en_B(csme_en_B),
			.i_A_link_B(A_link_B),
			.i_B_link_A(B_link_A),		
			//*******************************
			.i_link_valid_C(1'b0),                           //Modified by SYF 2014.5.29
			.i_link_valid_D(1'b0)                            //Modified by SYF 2014.5.29	
);
wire main_clock_compete_end;
main_clock_compete_up main_clock_compete_up_pt
(			
         .i_DHCP_end_en(DHCP_end_en),//wangkai0351 for DHCP
			.o_main_clock_compete_end(main_clock_compete_end),//wangkai0351 for DHCP
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),
			//state_ctrl
			.i_macrocycle_b(macrocycle_b_up),
			//dpram
			//.i_local_ip(local_node_ip),//wagnkai0351 for DHCP
			.i_local_ip(local_node_ip_DHCP),//wangkai0351 for DHCP
			.i_local_mac(local_node_mac),
			//phy_init
			.i_initDn(initDn),
			//dmi
         .i_recv_data_A(device_type?16'b0:recv_data_A),
         .i_data_valid_A(device_type?1'b0:data_valid_A),
         .i_recv_addr_A(device_type?10'b0:recv_addr_A),

         .i_recv_data_B(device_type?16'b0:recv_data_B),
         .i_data_valid_B(device_type?1'b0:data_valid_B),
         .i_recv_addr_B(device_type?10'b0:recv_addr_B),

         .i_recv_data_C(device_type?16'b0:recv_data_C),
         .i_data_valid_C(device_type?1'b0:data_valid_C),
         .i_recv_addr_C(device_type?10'b0:recv_addr_C),

			//bus interface signals 
			.o_mcc_send_irq(mcc_irq),
			.o_send_data(mcc_data_up_pt),
			.i_send_addr(mcc_rd_addr_up),
			.o_send_mcc_len(mcc_len_up_pt),
			.i_mcc_nxt_pkg(mcc_nxt_pkg_up),

			//ptp,csme
			.o_main_clock_state(main_clock_state_up_pt),
			.o_main_ip_change(main_ip_change_up_pt),
			.o_main_clock_ip(main_clock_ip_up_pt),
			
			.i_link_valid_A(link_valid_A),
			.i_link_valid_B(link_valid_B),
			.i_link_valid_C(link_valid_C)
);

wire mcc_irq;       //Modified by SYF 2014.5.27
wire [15:0]mcc_data_up_pt;          //Modified by SYF 2014.5.27
wire [9:0]mcc_len_up_pt;	         //Modified by SYF 2014.5.27
wire main_clock_state_adv_up_pt;
wire main_ip_change_up_pt;
wire main_clock_state_up_pt;
//main_clock_compete main_clock_compete_down(			
//			.i_clk(i_clk),
//			.i_rst_n(i_rst_n),
//			//state_ctrl
//			.i_macrocycle_b(macrocycle_b_down),
//			//dpram
//			//.i_local_ip(local_node_ip),//wagnkai0351 for DHCP
//			.i_local_ip(local_node_ip_DHCP),//wangkai0351 for DHCP
//			.i_local_mac(local_node_mac),
//			//phy
//			.i_initDn(initDn),
//		//emib
//         .i_recv_data_A(recv_data_C),               //Modified by SYF 2014.6.3
//         .i_data_valid_A(data_valid_C),             //Modified by SYF 2014.6.3
//         .i_recv_addr_A(recv_addr_C),               //Modified by SYF 2014.6.3
//					
//         .i_recv_data_B(recv_data_D),
//         .i_data_valid_B(data_valid_D),
//         .i_recv_addr_B(recv_addr_D),			
//
////			.i_link_valid(o_link_valid_down),          //Modified by SYF 2014.6.3
//			.i_csme_en(csme_en_C || csme_en_D),	
//	
//			.i_Rx_dv_A_macrocycle(1'b0),               //Rx_dv_C_macrocycle           //Modified by SYF 2014.6.12
//			.i_Rx_dv_B_macrocycle(1'b0),               //Rx_dv_D_macrocycle           //Modified by SYF 2014.6.12
//			.o_stop_send_remcc(stop_send_remcc_down),
//			.o_stop_send_remcc2(stop_send_remcc2_down),     //Modified by SYF 2014.6.11
//			.o_closing_csme(closing_csme_down),
//			.i_ptptime_second(link_valid_C ? ptptime_second_C : (link_valid_D ? ptptime_second_D : 32'd0)),
//			.i_ptptime_nanosecond(link_valid_C ? ptptime_nanosecond_C : (link_valid_D ? ptptime_nanosecond_D : 32'd0)),	
//			
//			//bus interface signals 
//			.o_mcc_send_irq_A(mcc_irq_C),         //Modified by SYF 2014.5.27
//			//sjj Nov_18th
//			.o_mcc_send_irq_B(mcc_irq_D),         //Modified by SYF 2014.5.27
//			.o_send_mcc_A(o_send_mcc_C),
//			.o_send_mcc_B(o_send_mcc_D),	
//			.o_send_data(mcc_data_down),            //Modified by SYF 2014.5.27
//			.i_send_addr(mcc_rd_addr_down),         //Modified by SYF 2014.5.27
//			.o_send_mcc_len(mcc_len_down),	        //Modified by SYF 2014.5.27
//			.i_mcc_nxt_pkg(mcc_nxt_pkg_down),       //Modified by SYF 2014.5.27
//			//ptp,csme
//			.o_main_clock_state(main_clock_state_down),               //Modified by SYF 2014.5.28
//			.o_main_clock_state_adv(main_clock_state_adv_down),       //Modified by SYF 2014.6.14
//			.o_main_ip_change(main_ip_change_down),           //Modified by SYF 2014.5.28
//			//.o_main_clock_state_send(main_clock_state_send),
//			//*******************************
//			
//			.i_frt_main_clock_status_A(frt_main_clock_status_C), 
//		   .i_frt_main_clock_status_B(frt_main_clock_status_D),	
//			
//			.i_link_valid(link_valid_CD),       //Modified by SYF 2014.6.3
//			
//			.i_link_valid_A_real(link_valid_C),    
//			.i_link_valid_B_real(link_valid_D), 			
//			
////			.o_stop_send_mcc(stop_send_mcc),
//			.o_main_clock_ip(main_clock_ip_down),              //Modified by  SYF 2014.5.28
//			
//		   .i_csme_en_A(csme_en_C),
//		   .i_csme_en_B(csme_en_D),
//			
//			.i_A_link_B(C_link_D),
//			.i_B_link_A(D_link_C),		
//			//*******************************
//			.i_link_valid_C(link_valid_C),                           //Modified by SYF 2014.5.29
//			.i_link_valid_D(link_valid_D)                            //Modified by SYF 2014.5.29
//			
//);

//*************************************************************
//Modified by SYF 2014.5.27

master_csme master_csme_up(
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),
			//
			.i_macrocycle_b(macrocycle_b_up),                        //Modified by SYF 2014.5.27
			//.i_local_ip(local_node_ip),//wangkai0351 for DHCP
			.i_local_ip(local_node_ip_DHCP),//wangkai0351 for DHCP
			.i_frt_sendtime(Sendtime_offset_uplayer),                //Modified by SYF 2014.5.19    //Sendtime_offset
			//frt
			.o_ind(frt_ind),
			.o_frt_trig(pdo_trig_up),                                //Modified by SYF 2014.5.27
			.i_src_ip(frt_src_ip),
			.i_pri(frt_pri),
			.i_rec_dn(frt_rec_dn),
			//mm
			.i_csme_en(csme_en_A || csme_en_B ||(device_type?1'b0:csme_en_C)),    
			
			.i_mm_status(mm_status),
			.o_mm_trig(mm_trig),
			.o_config_trig(config_trig),
			.i_config_status(config_status),
			//ptp
			//************************************************
			//.o_SyncReq_trig(SyncReq_trig),
			.o_opc_trig(opc_pkg_trig),
			//evt
			.i_evt_status(),
			.o_evt_trig(),
			.o_write_dpram_trig(write_dpram_trig_up),         //Modified by SYF 2014.5.28
			.o_read_dpram_trig(read_dpram_trig_up),           //Modified by SYF 2014.5.28
			.i_main_clock_state(device_type?main_clock_state_up:main_clock_state_up_pt),         //Modified by SYF 2014.5.28
			//nfrt
			//.i_nfrt_rd_dpram_trig(nfrt_rd_dpram_trig),
			//.i_nfrt_wr_dpram_trig(nfrt_wr_dpram_trig)
);
					
					
master_csme master_csme_down(
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),
			
			//Macrocycle
			.i_macrocycle_b(macrocycle_b_down),                     //Modified by SYF 2014.5.27
			//.i_local_ip(local_node_ip),//wangkai0351 for DHCP
			.i_local_ip(local_node_ip_DHCP),//wangkai0351 for DHCP
			.i_frt_sendtime(Sendtime_offset_downlayer),             //Modified by SYF 2014.5.27
			
			//frt
			.o_frt_trig(pdo_trig_down),                             //Modified by SYF 2014.5.27
			
			//dpram
			.o_write_dpram_trig(write_dpram_trig_down),             //Modified by SYF 2014.5.27
			.o_read_dpram_trig(read_dpram_trig_down),               //Modified by SYF 2014.5.27
			.i_main_clock_state(main_clock_state_down),             //Modified by SYF 2014.5.29
			//mm
			.i_csme_en(csme_en_C || csme_en_D),   
);		
//************************************************************
					
//************************************************************
//Modified by SYF 2014.5.27
bus_convert bus_convert_up(             
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),

			//DHCP wangkai0351 for DHCP
			.i_DHCP_irq(DHCP_irq), 
			.i_DHCP_len(DHCP_data_len),
			.o_DHCP_nxt_pkg(DHCP_nxt_pkg_up),
			.i_DHCP_data(DHCP_data),
			.o_DHCP_rd_addr(DHCP_rd_addr_up),
			
			//mcc
			.i_mcc_irq(device_type?(mcc_irq_A || mcc_irq_B):mcc_irq), //Modified by SYF 2014.5.27
			.i_mcc_len(device_type?mcc_len_up:mcc_len_up_pt),
			.o_mcc_nxt_pkg(mcc_nxt_pkg_up),
			.i_mcc_data(device_type?mcc_data_up:mcc_data_up_pt),
			.o_mcc_rd_addr(mcc_rd_addr_up),
			
			//frt
			.i_frt_irq(frt_irq_up),
			.i_frt_len(frt_len_up),
			.o_frt_nxt_pkg(frt_nxt_pkg_up),
			.i_frt_data(frt_data_up),
			.o_frt_rd_addr(frt_rd_addr_up),
			
			//nfrt
			.i_nfrt_irq(ac_send_en),
			.i_nfrt_len(nfrt_len_up),
			.i_nfrt_data(nfrt_data_up),
			.o_nfrt_rd_addr(nfrt_rd_addr_up),
			
			//ptp
			.i_ptp_irq_A(device_type?ptp_irq_A:ptp_irq_A_pt),
			.i_ptp_len_A(device_type?ptp_len_A:ptp_len_A_pt),
			.o_ptp_nxt_pkg_A(ptp_nxt_pkg_A),
			.i_ptp_data_A(device_type?ptp_data_A:ptp_data_A_pt),
			.o_ptp_rd_addr_A(ptp_rd_addr_A),
			
			.i_ptp_irq_B(device_type?ptp_irq_B:ptp_irq_B_pt),
			.i_ptp_len_B(device_type?ptp_len_B:ptp_len_B_pt),
			.o_ptp_nxt_pkg_B(ptp_nxt_pkg_B),
			.i_ptp_data_B(device_type?ptp_data_B:ptp_data_B_pt),
			.o_ptp_rd_addr_B(ptp_rd_addr_B),		
		
			.i_ptp_irq_C(device_type?1'b0:ptp_irq_C_pt),
			.i_ptp_len_C(device_type?10'b0:ptp_len_C_pt),
			.o_ptp_nxt_pkg_C(ptp_nxt_pkg_C_pt),
			.i_ptp_data_C(device_type?16'b0:ptp_data_C_pt),
			.o_ptp_rd_addr_C(ptp_rd_addr_C_pt),
			
			//mm
			.i_mm_irq(mm_irq_up),
			.i_mm_len(mm_len_up),
			.o_mm_nxt_pkg(mm_nxt_pkg_up),
			.i_mm_data(mm_data_up),
			.o_mm_rd_addr(mm_rd_addr_up),
			.i_mm_port_select(),		

			//mac
			.o_mac_irq_A(mac_irq_A),
			.o_mac_len_A(mac_len_A),
			//.i_mac_nxt_pkg_A(mac_nxt_pkg_A && mac_nxt_pkg_B),   //Modified by SYF 2014.5.27
			.i_mac_nxt_pkg_A(mac_nxt_pkg_A),//wangkai0351 for DHCP
			.o_mac_data_A(mac_data_A),
			.i_mac_rd_addr_A(mac_rd_addr_A),
			.o_mac_port_select(mac_port_select_A),
						
			.o_mac_irq_B(mac_irq_B),
			.o_mac_len_B(mac_len_B),
			.i_mac_nxt_pkg_B(mac_nxt_pkg_B),
			.o_mac_data_B(mac_data_B),
			.i_mac_rd_addr_B(mac_rd_addr_B),
			
			.o_mac_irq_C(mac_irq_C_pt),
			.o_mac_len_C(mac_len_C_pt),
			.i_mac_nxt_pkg_C(mac_nxt_pkg_C),
			.o_mac_data_C(mac_data_C_pt),
			.i_mac_rd_addr_C(mac_rd_addr_C),
			
			.sending_DHCP(sending_DHCP),//wangkai0351 for DHCP
			.sending_DHCP_B(sending_DHCP_B),
			//sjj Nov_19th
			.sending_frt(sending_frt_up),           //Modified by SYF 2014.5.27
			.sending_mm(sending_mm_up),
			.sending_ptp_A(sending_ptp_A),           //Modified by SYF 2014.5.27
			.sending_ptp_B(sending_ptp_B),     
			.sending_mcc(sending_mcc_up),           //Modified by SYF 2014.5.27
			.sending_mcc_B(sending_mcc_B)	           //Modified by SYF 2014.5.27
);		
//*******************************************************************************

//*******************************************************************************
//Modified by SYF 2014.5.27							
bus_convert bus_convert_down(           
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),
			//frt
			.i_frt_irq(frt_irq_down),
			.i_frt_len(frt_len_down),
			.o_frt_nxt_pkg(frt_nxt_pkg_down),
			.i_frt_data(frt_data_down),
			.o_frt_rd_addr(frt_rd_addr_down),
			.i_frt_port_select(),
			//ptp
			.i_ptp_irq_A(ptp_irq_C),
			.i_ptp_len_A(ptp_len_C),
			.o_ptp_nxt_pkg_A(ptp_nxt_pkg_C),
			.i_ptp_data_A(ptp_data_C),
			.o_ptp_rd_addr_A(ptp_rd_addr_C),
			.i_ptp_port_select(),
			
			.i_ptp_irq_B(ptp_irq_D),
			.i_ptp_len_B(ptp_len_D),
			.o_ptp_nxt_pkg_B(ptp_nxt_pkg_D),
			.i_ptp_data_B(ptp_data_D),
			.o_ptp_rd_addr_B(ptp_rd_addr_D),			
			//mm
			.i_mm_irq(mm_irq_down),
			.i_mm_len(mm_len_down),
			.o_mm_nxt_pkg(mm_nxt_pkg_down),
			.i_mm_data(mm_data_down),
			.o_mm_rd_addr(mm_rd_addr_down),
			.i_mm_port_select(),	
			
			.i_mcc_irq(mcc_irq_C || mcc_irq_D),
			.i_mcc_len(mcc_len_down),
			.o_mcc_nxt_pkg(mcc_nxt_pkg_down),
			.i_mcc_data(mcc_data_down),
			.o_mcc_rd_addr(mcc_rd_addr_down),
			.i_mcc_port_select(),

			//mac
			.o_mac_irq_A(mac_irq_C_dmi),
			.o_mac_len_A(mac_len_C_dmi),
			.i_mac_nxt_pkg_A(mac_nxt_pkg_C && mac_nxt_pkg_D),
			.o_mac_data_A(mac_data_C_dmi),
			.i_mac_rd_addr_A(mac_rd_addr_C),
			.o_mac_port_select(mac_port_select_C),
			
			.o_mac_irq_B(mac_irq_D),
			.o_mac_len_B(mac_len_D),
			.i_mac_nxt_pkg_B(mac_nxt_pkg_D),
			.o_mac_data_B(mac_data_D),
			.i_mac_rd_addr_B(device_type ? mac_rd_addr_D : 10'b0),
			
			//sjj Nov_19th
			.sending_frt(sending_frt_down),
			.sending_mm(sending_mm_down),
			.sending_ptp_A(sending_ptp_C),
			.sending_ptp_B(sending_ptp_D),
			.sending_mcc(sending_mcc_down)
);			


assign mac_irq_C = device_type ? mac_irq_C_dmi :mac_irq_C_pt;
assign mac_data_C = device_type ? mac_data_C_dmi :mac_data_C_pt;
assign mac_len_C = device_type ? mac_len_C_dmi :mac_len_C_pt;		
//******************************************************************************

ether_mac ether_mac_A(
			/**************
			common pin
			*************/
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),
			.i_local_node_mac(local_node_mac),
			/***********************
			pins for data_bus
			***********************/
			.i_SendIrq((B_link_A && !sending_ptp_A && csme_en_A && !(device_type?main_clock_state_up:main_clock_state_up_pt)) ? mac_irq_B : mac_irq_A),      //Modified by SYF 2014.5.27
			//.i_SendIrq(mac_irq_A),//wangkai0351 for DHCP
			.i_data_send((B_link_A && !sending_ptp_A && csme_en_A && !(device_type?main_clock_state_up: main_clock_state_up_pt)) ? mac_data_B : mac_data_A),  //Modified by SYF 2014.5.27
    		//.i_data_send(mac_data_A),  //wangkai0351 for DHCP
			.i_length((B_link_A && !sending_ptp_A && csme_en_A && !(device_type?main_clock_state_up:main_clock_state_up_pt)) ? mac_len_B : mac_len_A),       //Modified by SYF 2014.5.27
			//.i_length(mac_len_A), //wangkai0351 for DHCP
			.o_data_addr(mac_rd_addr_A),         //Modified by SYF 2014.5.27
			.o_renew_pkg(mac_nxt_pkg_A),         //Modified by SYF 2014.5.27
			/***********************
			pins for DMI
			***********************/ 
			.i_ErxDv(device_type?ErxDv_A:i_Rx_dv_A),
			.i_data_recv(device_type?data_recv_A:i_recv_data_A),
			.o_EtxEn(EtxEn_A),                   //Modified by SYF 2014.5.28
			.o_data_send(data_send_A),           //Modified by SYF 2014.5.28
			/***************************
			pins for PTP FRT MM...
			****************************/
			.o_data_recv(recv_data_A),
			.o_data_valid(data_valid_A), 
			.o_recv_addr(recv_addr_A),
			.i_csme_en(csme_en_A || csme_en_B),//untapped
			.i_initDn(initDn),
			.i_send_alarm_to_pdo_A(send_alarm_to_pdo_A && safe_switch),
			.i_send_alarm_to_pdo_B(1'b0),                 //Modified by SYF 2014.6.18
			.i_pack_safe_A(pack_safe_A || !safe_switch),
			.i_pack_safe_B(1'b0),
			.i_port_id(2'b00)//Modified by SYF 2014.6.18
);
assign safe_switch = 1'b0;

ether_mac_B ether_mac_B(
			//**************
			//common pin
			//*************
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),
			.i_local_node_mac(local_node_mac),
			//***********************
			//pins for data_bus
			//***********************

			.i_SendIrq((A_link_B && !sending_ptp_B && csme_en_B && !(device_type?main_clock_state_up:main_clock_state_up_pt)) ? mac_irq_A : mac_irq_B),  //Modified by SYF 2014.5.27
			//.i_SendIrq(mac_irq_B),//wangkai0351 for DHCP
			.i_data_send((A_link_B && !sending_ptp_B && csme_en_B && !(device_type?main_clock_state_up:main_clock_state_up_pt)) ? mac_data_A : mac_data_B),  //Modified by SYF 2014.5.27
			//.i_data_send(mac_data_B),//wangkai0351 for DHCP
			.i_length((A_link_B && !sending_ptp_B && csme_en_B && !(device_type?main_clock_state_up:main_clock_state_up_pt)) ? mac_len_A : mac_len_B),    //Modified by SYF 2014.5.27
			//.i_length(mac_len_B), //wangkai0351 for DHCP
			
			.o_data_addr(mac_rd_addr_B),
			.o_renew_pkg(mac_nxt_pkg_B),
			//***********************
			//pins for DMI
			//*********************** 
			.i_ErxDv(device_type?ErxDv_B:i_Rx_dv_B),
			.i_data_recv(device_type?data_recv_B:i_recv_data_B),
			.o_EtxEn(EtxEn_B),
			.o_data_send(data_send_B),
			//***************************
			//pins for PTP FRT MM...
			//****************************
			.o_data_recv(recv_data_B),
			.o_data_valid(data_valid_B), 
			.o_recv_addr(recv_addr_B),
			.i_csme_en(csme_en_A || csme_en_B),   //untapped
			.i_initDn(initDn),
			
			.i_send_alarm_to_pdo_A(1'b0),                   //Modified by SYF 2014.6.18
			.i_send_alarm_to_pdo_B(send_alarm_to_pdo_B && safe_switch),
			.i_pack_safe_A(1'b0),                           //Modified by SYF 2014.6.18
			.i_pack_safe_B(pack_safe_B || !safe_switch),
			.i_port_id(2'b01)
);


ether_mac ether_mac_C(
			/**************
			common pin
			**************/
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),
			.i_local_node_mac(local_node_mac),
			/***********************
			pins for data_bus
			***********************/

			.i_SendIrq((D_link_C && !sending_ptp_C && csme_en_C && !(device_type?main_clock_state_down:main_clock_state_up_pt)) ? mac_irq_D : mac_irq_C ),        //Modified by SYF 2014.5.28
			.i_data_send((D_link_C && !sending_ptp_C && csme_en_C && !(device_type?main_clock_state_down:main_clock_state_up_pt)) ? mac_data_D : mac_data_C),    //Modified by SYF 2014.5.28
    		.i_length((D_link_C && !sending_ptp_C && csme_en_C && !(device_type?main_clock_state_down:main_clock_state_up_pt)) ? mac_len_D : mac_len_C),          //Modified by SYF 2014.5.28
			
			.o_data_addr(mac_rd_addr_C),
			.o_renew_pkg(mac_nxt_pkg_C),
			/***********************
			pins for DMI
			***********************/
			.i_ErxDv(device_type?ErxDv_C:i_Rx_dv_C),
			.i_data_recv(device_type?data_recv_C:i_recv_data_C),
			.o_EtxEn(EtxEn_C),
			.o_data_send(data_send_C),
			/***************************
			pins for PTP FRT MM...
			****************************/
			.o_data_recv(recv_data_C),
			.o_data_valid(data_valid_C), 
			.o_recv_addr(recv_addr_C),
			.i_csme_en(csme_en_C || csme_en_D),     //untapped
			.i_initDn(initDn),
			.i_send_alarm_to_pdo_A(send_alarm_to_pdo_C && safe_switch),
			.i_send_alarm_to_pdo_B(1'b0),                  //Modified by SYF 2014.6.18
			.i_pack_safe_A(pack_safe_C || !safe_switch),
			.i_pack_safe_B(1'b0),
			.i_port_id(2'b10)			//Modified by SYF 2014.6.18
);

//Modified by SYF 2014.6.18

//ether_mac_B ether_mac_D(
//			/**************
//			common pin
//			*************/
//			.i_clk(i_clk),
//			.i_rst_n(i_rst_n),
//			.i_local_node_mac(local_node_mac),
//			/***********************
//			pins for data_bus
//			***********************/
//
//			.i_SendIrq(!device_type ? send_irq_opc : (C_link_D && !sending_ptp_D && csme_en_D && !main_clock_state_down) ? mac_irq_C : mac_irq_D),          //Modified by SYF 2014.5.28
//			
//			.i_data_send(!device_type ? send_data_opc : (C_link_D && !sending_ptp_D && csme_en_D && !main_clock_state_down) ? mac_data_C : mac_data_D),      //Modified by SYF 2014.5.28
//
//			.i_length(!device_type ? length_opc : (C_link_D && !sending_ptp_D && csme_en_D && !main_clock_state_down) ? mac_len_C : mac_len_D),            //Modified by SYF 2014.5.28
//
//			.o_data_addr(mac_rd_addr_D_tmp),                //Modified by SYF 2014.6.18
//			.o_renew_pkg(mac_nxt_pkg_D),
//			/***********************
//			pins for DMI
//			***********************/ 
//			.i_ErxDv(ErxDv_D),
//			.i_data_recv(data_recv_D),
//			.o_EtxEn(EtxEn_D),
//			.o_data_send(data_send_D),
//			/***************************
//			pins for PTP FRT MM...
//			//****************************/
//			.o_data_recv(recv_data_D_tmp),                 //Modified by SYF 2014.6.18
//			.o_data_valid(data_valid_D_tmp),               //Modified by SYF 2014.6.18
//			.o_recv_addr(recv_addr_D_tmp),                 //Modified by SYF 2014.6.18
//			.i_csme_en(csme_en_C || csme_en_D),   //untapped
//			.i_initDn(initDn),
//			
//			.i_send_alarm_to_pdo_A(1'b0),                       //Modified by SYF 2014.6.18
//			.i_send_alarm_to_pdo_B(send_alarm_to_pdo_D && safe_switch),
//			.i_pack_safe_A(1'b0),                               //Modified by SYF 2014.6.18
//			.i_pack_safe_B(pack_safe_D || !safe_switch)
//);

phy_init phy_init(
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),
			.o_initDn(initDn),
			.b_mdio(b_mdio),
			.o_mdc(o_mdc),
			.o_phy_clk0(o_phy_clk0),
			.o_phy_clk1(o_phy_clk1),			
			.o_rst_phy0_n(o_rst_phy0_n),
		   .o_rst_phy1_n(o_rst_phy1_n)			
);

//*****************************************************
wire Tx_en_A,Tx_en_B,Tx_en_C,Tx_en_D;
wire [3:0] send_data_dim_A,send_data_dim_B,send_data_dim_C,send_data_dim_D;

dim dim_top(
		.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		
		.i_Rx_dv_A(i_Rx_dv_A),
		.i_recv_data_A(i_recv_data_A),
		
		.o_Tx_en_A(Tx_en_dim_A),
		.o_send_data_A(send_data_dim_A),
		
		.i_Rx_dv_B(i_Rx_dv_B),
		.i_recv_data_B(i_recv_data_B),
		
		.o_Tx_en_B(Tx_en_dim_B),
		.o_send_data_B(send_data_dim_B),

		.i_Rx_dv_C(i_Rx_dv_C),                  //Modified by SYF 2014.5.28
		.i_recv_data_C(i_recv_data_C),          //Modified by SYF 2014.5.28
		
		.o_Tx_en_C(Tx_en_dim_C),                  //Modified by SYF 2014.5.28
		.o_send_data_C(send_data_dim_C),          //Modified by SYF 2014.5.28
		
		.i_Rx_dv_D(i_Rx_dv_D),                  //Modified by SYF 2014.5.28
		.i_recv_data_D(i_recv_data_D),          //Modified by SYF 2014.5.28
		
		.o_Tx_en_D(Tx_en_dim_D),                  //Modified by SYF 2014.5.28
		.o_send_data_D(send_data_dim_D),          //Modified by SYF 2014.5.28

		.i_Rx_dv_host_A(EtxEn_A),               //Modified by SYF 2014.5.28
		.i_recv_data_host_A(data_send_A),       //Modified by SYF 2014.5.28
		
		.i_Rx_dv_host_B(EtxEn_B),
		.i_recv_data_host_B(data_send_B),		
		
		.i_Rx_dv_host_C(EtxEn_C),               //Modified by SYF 2014.5.28
		.i_recv_data_host_C(data_send_C),       //Modified by SYF 2014.5.28
		
		.i_Rx_dv_host_D(EtxEn_D),               //Modified by SYF 2014.5.28
		.i_recv_data_host_D(data_send_D),	    //Modified by SYF 2014.5.28
		
		.o_Tx_en_host_A(ErxDv_A),               
		.o_send_data_host_A(data_recv_A),	
		
		.o_Tx_en_host_B(ErxDv_B),
		.o_send_data_host_B(data_recv_B),

		.o_Tx_en_host_C(ErxDv_C),               //Modified by SYF 2014.5.28
		.o_send_data_host_C(data_recv_C),	    //Modified by SYF 2014.5.28
		
		.o_Tx_en_host_D(ErxDv_D),               //Modified by SYF 2014.5.28
		.o_send_data_host_D(data_recv_D),	    //Modified by SYF 2014.5.28
		
		.i_device_type(device_type),            //Modified by SYF 2014.6.18
		
		.o_get_time_en_frt0_s_A(get_time_en_frt0_s_A),  // frt0 time stamp
		.o_get_time_en_sync_s_A(get_time_en_sync_s_A), // sync time stamp
		.o_send_recvn_s_A(send_recvn_s_A),	//receive or send
		
		.o_get_time_en_frt0_m_A(get_time_en_frt0_m_A),  // frt0 time stamp
		.o_get_time_en_sync_m_A(get_time_en_sync_m_A), // sync time stamp
		.o_send_recvn_m_A(send_recvn_m_A),	//receive or send		
		
		.o_get_time_en_frt0_s_B(get_time_en_frt0_s_B),  // frt0 time stamp
		.o_get_time_en_sync_s_B(get_time_en_sync_s_B), // sync time stamp
		.o_send_recvn_s_B(send_recvn_s_B),	//receive or send
		
		.o_get_time_en_frt0_m_B(get_time_en_frt0_m_B),  // frt0 time stamp
		.o_get_time_en_sync_m_B(get_time_en_sync_m_B), // sync time stamp
		.o_send_recvn_m_B(send_recvn_m_B),	//receive or send
		
      .o_get_time_en_frt0_s_C(get_time_en_frt0_s_C),  //Modified by SYF 2014.5.28
		.o_get_time_en_sync_s_C(get_time_en_sync_s_C),  //Modified by SYF 2014.5.28
		.o_send_recvn_s_C(send_recvn_s_C),	            //Modified by SYF 2014.5.28
		
		.o_get_time_en_frt0_m_C(get_time_en_frt0_m_C),  //Modified by SYF 2014.5.28
		.o_get_time_en_sync_m_C(get_time_en_sync_m_C),  //Modified by SYF 2014.5.28
		.o_send_recvn_m_C(send_recvn_m_C),	            //Modified by SYF 2014.5.28

		.o_get_time_en_frt0_s_D(get_time_en_frt0_s_D),  //Modified by SYF 2014.5.28
		.o_get_time_en_sync_s_D(get_time_en_sync_s_D),  //Modified by SYF 2014.5.28
		.o_send_recvn_s_D(send_recvn_s_D),	            //Modified by SYF 2014.5.28
		
		.o_get_time_en_frt0_m_D(get_time_en_frt0_m_D),  //Modified by SYF 2014.5.28
		.o_get_time_en_sync_m_D(get_time_en_sync_m_D),  //Modified by SYF 2014.5.28
		.o_send_recvn_m_D(send_recvn_m_D),	            //Modified by SYF 2014.5.28
				 
		.i_main_clock_state_up(main_clock_state_up),         //Modified by SYF 2014.5.28
		.i_main_clock_state_down(main_clock_state_down),     //Modified by SYF 2014.5.28
/************** sjj Oct_30th******************/
		//MM
		.i_csme_en_up(csme_en_A || csme_en_B),  //switch of csme	//Modified by SYF 2014.5.28
		.i_csme_en_down(csme_en_C || csme_en_D),//switch of csme	//Modified by SYF 2014.5.28
		//MII
		.i_recv_data(recv_MAC_data_from_A ? recv_data_A : (recv_MAC_data_from_B ? recv_data_B : 16'd0)),
		.i_data_valid(recv_MAC_data_from_A ? data_valid_A : (recv_MAC_data_from_B ? data_valid_B : 1'd0)),
		.i_recv_addr(recv_MAC_data_from_A ? recv_addr_A : (recv_MAC_data_from_B ? recv_addr_B : 10'd0)),
/************** sjj Oct_30th******************/	
/************** sjj Nov_1st******************/
		.i_macrocycle_b_up(macrocycle_b_up),            //Modified by SYF 2014.5.28
		.i_macrocycle_b_down(macrocycle_b_down),		   //Modified by SYF 2014.5.28
		.i_local_node_mac(local_node_mac), 
/************** sjj Nov_1st******************/		
		.o_msgid(ptp_msgid),
/***********************    sjj Oct_23rd   *******************/
		//.i_local_ip(local_node_ip),//wangkai0351 for DHCP
		.i_local_ip(local_node_ip_DHCP),//wangkai0351 for DHCP
		.i_src_ip(src_ip),
/***********************    sjj Oct_23rd   *******************/

/********  sjj Nov_6th  **********/
		.i_SendIrq(mac_irq_A),                     //Modified by SYF 2014.5.27
		.i_data_send(mac_data_A),                  //Modified by SYF 2014.5.27
		.i_mac_rd_addr(mac_rd_addr_A),             //Modified by SYF 2014.5.27
		.i_lenth(mac_len_A),                       //Modified by SYF 2014.5.27
/********  sjj Nov_6th  **********/


/********  sjj Nov_19th  **********/
		.i_send_mcc_A(o_send_mcc_A),
		.i_send_mcc_B(o_send_mcc_B),
		
		.i_send_mcc_C(o_send_mcc_C),                //Modified by SYF 2014.5.28
		.i_send_mcc_D(o_send_mcc_D),	              //Modified by SYF 2014.5.28
	
		.i_sending_frt_up(sending_frt_up),             //Modified by SYF 2014.5.28
		.i_sending_frt_down(sending_frt_down),             //Modified by SYF 2014.5.28
		.i_sending_mm(sending_mm_up),               //Modified by SYF 2014.5.27
		
		.i_sending_mcc_up(sending_mcc_up),		     //Modified by SYF 2014.5.28
	   .i_sending_mcc_down(sending_mcc_down),      //Modified by SYF 2014.5.28
		
		.i_sending_ptp_A(sending_ptp_A),            //Modified by SYF 2014.5.27
		.i_sending_ptp_B(sending_ptp_B),		
		.i_sending_ptp_C(sending_ptp_C),            //Modified by SYF 2014.5.28
		.i_sending_ptp_D(sending_ptp_D),            //Modified by SYF 2014.5.28
		
		.i_sending_config(sending_config),
		.i_sending_arp(sending_arp),
/********  sjj Nov_19th  **********/


/********  sjj Nov_28th  **********/
		.i_link_valid_A(link_valid_A), 
		.i_link_valid_B(link_valid_B), 
		.i_start_en_already(start_en_already_A || start_en_already_A_pt),
		.i_link_valid_C(link_valid_C),              //Modified by SYF 2014.5.28
		.i_link_valid_D(link_valid_D),              //Modified by SYF 2014.5.28
/********  sjj Nov_28th  **********/
		
		
/********  sjj Nov_16th  **********/
      .mm_packet_trig(mm_packet_trig),
/********  sjj Nov_16th  **********/

		.recv_frt_main_from_A(recv_frt_main_from_A), 
		.recv_frt_main_from_B(recv_frt_main_from_B),
		
		.recv_MAC_data_from_A(recv_MAC_data_from_A), 
		.recv_MAC_data_from_B(recv_MAC_data_from_B),

		.recv_ptp_time_from_A(recv_ptp_time_from_A), 
		.recv_ptp_time_from_B(recv_ptp_time_from_B),
		
		.main_clock_compete_from_A(main_clock_compete_from_A),
		.main_clock_compete_from_B(main_clock_compete_from_B),		
		
		.i_csme_en_A(csme_en_A),
		.i_csme_en_B(csme_en_B),
		
		.recv_frt_main_from_C(recv_frt_main_from_C),          //Modified by SYF 2014.5.28
		.recv_frt_main_from_D(recv_frt_main_from_D),          //Modified by SYF 2014.5.28
		
		.recv_MAC_data_from_C(recv_MAC_data_from_C),          //Modified by SYF 2014.5.28
		.recv_MAC_data_from_D(recv_MAC_data_from_D),          //Modified by SYF 2014.5.28
 
		.recv_ptp_time_from_C(recv_ptp_time_from_C),          //Modified by SYF 2014.5.28
		.recv_ptp_time_from_D(recv_ptp_time_from_D),          //Modified by SYF 2014.5.28
		
		.main_clock_compete_from_C(main_clock_compete_from_C),   //Modified by SYF 2014.5.28
		.main_clock_compete_from_D(main_clock_compete_from_D),   //Modified by SYF 2014.5.28
		
		.i_csme_en_C(csme_en_C),                                 //Modified by SYF 2014.5.28
		.i_csme_en_D(csme_en_D),	                              //Modified by SYF 2014.5.28

		
		.i_link_valid_up(o_link_valid_up),                       //Modified by SYF 2014.5.28
		.i_link_valid_down(o_link_valid_down),                   //Modified by SYF 2014.5.28
		
		.o_Rx_dv_A_macrocycle(Rx_dv_A_macrocycle),
		.o_Rx_dv_B_macrocycle(Rx_dv_B_macrocycle),
		.o_Rx_dv_C_macrocycle(Rx_dv_C_macrocycle),               //Modified by SYF 2014.5.28
		.o_Rx_dv_D_macrocycle(Rx_dv_D_macrocycle),               //Modified by SYF 2014.5.28
		.i_stop_send_remcc_up(stop_send_remcc_up),               //Modified by SYF 2014.5.28
		.i_stop_send_remcc_down(stop_send_remcc_down),           //Modified by SYF 2014.5.28
		.i_stop_send_remcc2_down(stop_send_remcc2_down),         //Modified by SYF 2014.6.11
		.i_closing_csme_up(closing_csme_up),                     //Modified by SYF 2014.5.28
		.i_closing_csme_down(closing_csme_down),                 //Modified by SYF 2014.5.28

      /*************************************/
		.i_len_master_clock_A(len_master_clock_A),                            //Modified by SYF 2014.5.23
		.i_len_master_clock_B(len_master_clock_B),                            //Modified by SYF 2014.5.23
		.i_len_master_clock_C(len_master_clock_C),                            //Modified by SYF 2014.5.28
		.i_len_master_clock_D(len_master_clock_D),                            //Modified by SYF 2014.5.28
		
		.frt_main_clock_status_A(frt_main_clock_status_A),                     //Modified by SYF 2014.6.3
		.frt_main_clock_status_B(frt_main_clock_status_B),                     //Modified by SYF 2014.6.3
		.frt_main_clock_status_C(frt_main_clock_status_C),                     //Modified by SYF 2014.6.3
		.frt_main_clock_status_D(frt_main_clock_status_D),                     //Modified by SYF 2014.6.3
		/*************************************/
		.o_plant_src_mac_up(index_mac_up),                                   //modified by SYF 2014.5.28
		.i_plant_ip_up(plant_ip_up),                                         //modified by SYF 2014.5.28
		.i_plant_toffset_up(plant_toffset_up),                               //modified by SYF 2014.5.28
		.i_plant_datalen_up(plant_datalen_up),                               //modified by SYF 2014.5.28
   	.i_plant_interval_up(plant_interval_up),                             //modified by SYF 2014.5.28        
		.o_plant_index_irq_up(plant_index_irq_up),                           //modified by SYF 2014.5.28
		.i_plant_index_done_up(plant_index_done_up),                         //modified by SYF 2014.5.28
		.i_plant_index_error_up(plant_index_error_up),                       //modified by SYF 2014.5.28
		
		.o_plant_src_mac_down(index_mac_down),                                   //modified by SYF 2014.5.28
		.i_plant_ip_down(plant_ip_down),                                         //modified by SYF 2014.5.28
		.i_plant_toffset_down(plant_toffset_down),                               //modified by SYF 2014.5.28
		.i_plant_datalen_down(plant_datalen_down),                               //modified by SYF 2014.5.28
   	.i_plant_interval_down(plant_interval_down),                             //modified by SYF 2014.5.28        
		.o_plant_index_irq_down(plant_index_irq_down),                           //modified by SYF 2014.5.28
		.i_plant_index_done_down(plant_index_done_down),                         //modified by SYF 2014.5.28
		.i_plant_index_error_down(plant_index_error_down),                       //modified by SYF 2014.5.28
		
		.i_commen_data_rd_done(commen_data_rd_done),								//modified by guhao 20131223
		
		
		.i_ptptime_second_A(ptptime_second_A),
		.i_ptptime_nanosecond_A(ptptime_nanosecond_A),
		
		.i_ptptime_second_B(ptptime_second_B),
		.i_ptptime_nanosecond_B(ptptime_nanosecond_B),		
		
		.i_ptptime_second_C(ptptime_second_C),                             //Modified by SYF 2014.5.28
		.i_ptptime_nanosecond_C(ptptime_nanosecond_C),                     //Modified by SYF 2014.5.28
		
		.i_ptptime_second_D(ptptime_second_D),                             //Modified by SYF 2014.5.28
		.i_ptptime_nanosecond_D(ptptime_nanosecond_D),                     //Modified by SYF 2014.5.28
		
		//20140221, attack alarm information
		.o_alarm_data_A(alarm_data_A),
		.o_send_alarm_to_pdo_A(send_alarm_to_pdo_A),
		.o_pack_safe_A(pack_safe_A),
		.o_alarm_data_B(alarm_data_B),
		.o_send_alarm_to_pdo_B(send_alarm_to_pdo_B),
		.o_pack_safe_B(pack_safe_B),
		
		//Modified by SYF 2014.5.28
		.o_alarm_data_C(alarm_data_C),
		.o_send_alarm_to_pdo_C(send_alarm_to_pdo_C),
		.o_pack_safe_C(pack_safe_C),
		.o_alarm_data_D(alarm_data_D),
		.o_send_alarm_to_pdo_D(send_alarm_to_pdo_D),
		.o_pack_safe_D(pack_safe_D)
);
wire Tx_en_dim_A,Tx_en_dim_B,Tx_en_dim_C;
wire Tx_en_dim_A_up,Tx_en_dim_B_up,Tx_en_dim_C_up;
wire [3:0] send_data_dim_A_up,send_data_dim_B_up,send_data_dim_C_up;

dim_up dim_top_pt
(
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),
			.i_main_clock_state_up(main_clock_state_up_pt),
			.i_macrocycle_b_up(macrocycle_b_up),
			.i_local_node_mac(local_node_mac),

			.i_sendtrig_A(mac_irq_A),
			.i_sendtrig_B(mac_irq_B),
			.i_sendtrig_C(mac_irq_C),
			//.i_sendtrig_C(mac_irq_C_pt),

			.i_Rx_dv_A(i_Rx_dv_A),
			.i_recv_data_A(i_recv_data_A),
			.i_Rx_dv_host_A(EtxEn_A),
			.i_recv_data_host_A(data_send_A),
			.o_Tx_en_A(Tx_en_dim_A_up),
			.o_send_data_A(send_data_dim_A_up),

			.i_Rx_dv_B(i_Rx_dv_B),
			.i_recv_data_B(i_recv_data_B),
			.i_Rx_dv_host_B(EtxEn_B),
			.i_recv_data_host_B(data_send_B),
			.o_Tx_en_B(Tx_en_dim_B_up),
			.o_send_data_B(send_data_dim_B_up),

			.i_Rx_dv_C(i_Rx_dv_C),
			.i_recv_data_C(i_recv_data_C),
			.i_Rx_dv_host_C(EtxEn_C),
			.i_recv_data_host_C(data_send_C),
			.o_Tx_en_C(Tx_en_dim_C_up),
			.o_send_data_C(send_data_dim_C_up),

			.o_get_time_en_frt0_s_A(get_time_en_frt0_s_A_pt),
			.o_get_time_en_sync_s_A(get_time_en_sync_s_A_pt),
			.o_send_recvn_s_A(send_recvn_s_A_pt),
			.o_get_time_en_frt0_m_A(get_time_en_frt0_m_A_pt),
			.o_get_time_en_sync_m_A(get_time_en_sync_m_A_pt),
			.o_send_recvn_m_A(send_recvn_m_A_pt),

			.o_get_time_en_frt0_s_B(get_time_en_frt0_s_B_pt),
			.o_get_time_en_sync_s_B(get_time_en_sync_s_B_pt),
			.o_send_recvn_s_B(send_recvn_s_B_pt),
			.o_get_time_en_frt0_m_B(get_time_en_frt0_m_B_pt),
			.o_get_time_en_sync_m_B(get_time_en_sync_m_B_pt),
			.o_send_recvn_m_B(send_recvn_m_B_pt),

			.o_get_time_en_frt0_s_C(get_time_en_frt0_s_C_pt),
			.o_get_time_en_sync_s_C(get_time_en_sync_s_C_pt),
			.o_send_recvn_s_C(send_recvn_s_C_pt),
			.o_get_time_en_frt0_m_C(get_time_en_frt0_m_C_pt),
			.o_get_time_en_sync_m_C(get_time_en_sync_m_C_pt),
			.o_send_recvn_m_C(send_recvn_m_C_pt),

			.i_link_valid_A(link_valid_A), 
			.i_link_valid_B(link_valid_B), 
			.i_link_valid_C(link_valid_C)
);
wire get_time_en_frt0_s_A_pt;
wire get_time_en_sync_s_A_pt;	

wire get_time_en_frt0_s_B_pt;
wire get_time_en_sync_s_B_pt;

wire get_time_en_frt0_m_A_pt;
wire get_time_en_sync_m_A_pt;

wire get_time_en_frt0_m_B_pt;
wire get_time_en_sync_m_B_pt;

wire get_time_en_frt0_s_C_pt;                //Modified by SYF 2014.5.28
wire get_time_en_sync_s_C_pt;	               //Modified by SYF 2014.5.28

wire get_time_en_frt0_m_C_pt;                //Modified by SYF 2014.5.28
wire get_time_en_sync_m_C_pt;                //Modified by SYF 2014.5.28

wire send_recvn_s_A_pt;
wire send_recvn_m_A_pt;

wire send_recvn_s_B_pt;
wire send_recvn_m_B_pt;

wire send_recvn_s_C_pt;  //Modified by SYF 2014.5.28
wire send_recvn_m_C_pt;  //Modified by SYF 2014.5.28

pll pll (
.inclk0(i_clk_50),
.c0(clk_100)
);

 led_display  led_display(
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),
			.i_work_rdt(device_type ? main_clock_state_up: main_clock_state_up_pt),
			.i_dpram_valid(1'b1),
			.i_csme_en(csme_en_A || csme_en_B || (device_type?1'b0:csme_en_C)),
			.i_cpu_err(cpu_err),
			.LED_RUN(o_led_run),
			.LED_ERR(o_led_err),
			.LED_RDT(o_led_rdt)
);
/*
link_valid_top link_valid_top(		
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),
			.i_initDn(initDn),
			.b_mdio(b_mdio),
			.i_Rx_dv_A(i_Rx_dv_A),                     //Modified by SYF 2014.6.16
			.i_Rx_dv_B(i_Rx_dv_B),                     //Modified by SYF 2014.6.16
			.i_Rx_dv_C(i_Rx_dv_C),                     //Modified by SYF 2014.6.16
			.i_Rx_dv_D(i_Rx_dv_D),                     //Modified by SYF 2014.6.16
			.o_link_valid_A(link_valid_A),
			.o_link_valid_B(link_valid_B),
			.o_link_valid_C(link_valid_C),                        //Modified by SYF 2014.5.28
			.o_link_valid_D(link_valid_D),			               //Modified by SYF 2014.5.28
			.o_link_valid_AB(o_link_valid_up),                    //Modified by SYF 2014.5.28
			.o_link_valid_CD(o_link_valid_down)                  //Modified by SYF 2014.5.28
			//.i_mdc(i_clk)			
);*/
link_valid_top link_valid_top(		
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),
			.i_initDn(initDn),
			.b_mdio(b_mdio),
			.i_Rx_dv_A(i_Rx_dv_A),                     //Modified by SYF 2014.6.16
			.i_Rx_dv_B(i_Rx_dv_B),                     //Modified by SYF 2014.6.16
			.i_Rx_dv_C(i_Rx_dv_C),                     //Modified by SYF 2014.6.16
			.i_Rx_dv_D(i_Rx_dv_D),                     //Modified by SYF 2014.6.16
			.o_link_valid_A(link_valid_A),
			.o_link_valid_B(link_valid_B),
			.o_link_valid_C(link_valid_C),                        //Modified by SYF 2014.5.28
			.o_link_valid_D(link_valid_D),			               //Modified by SYF 2014.5.28
			.o_link_valid_AB(o_link_valid_up),                    //Modified by SYF 2014.5.28
			.o_link_valid_CD(o_link_valid_down),                  //Modified by SYF 2014.5.28
			.i_mdc(o_mdc)			
);
wire [31:0] ac_ip;
wire [7:0]  ac_pri;
CPU_top CPU_top(
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),
			
			//Parallel-Port control signal
			.i_CER_pre(i_select),
			.i_rd_cpu_pre(i_rd_cpu),
			.i_wr_cpu_pre(i_wr_cpu),
			.i_addr_cpu(i_addr_cpu),
			.b_data_cpu(b_data_cpu),
			///////////////////////////////
			.i_EPA_data_valid(EPA_data_valid),
			.i_macrocycle_b(macrocycle_b_up),
			.i_init_done(initDn),
			.i_csme(csme_en_A || csme_en_B || csme_en_C || csme_en_D),
			.i_synchronous(start_en_already_A || start_en_already_B || start_en_already_C || start_en_already_D || start_en_already_A_pt || start_en_already_B_pt || start_en_already_C_pt),
			.i_device_type(device_type),
			.i_main_clock_state(main_clock_state_up || main_clock_state_up_pt),
			
			.o_ready(o_ready),
			.o_INTn(o_INTn),
			.o_ac_ip(ac_ip),
			.o_ac_pri(ac_pri),
			.o_ac_data_len(ac_data_len),
			.i_ac_send_en(ac_send_en),
			//.o_safe_switch(safe_switch),
			//CPU-DPRAM
			.o_dpram_addr(dpram_addr_cpu),
			.o_wr_dpram_en(wr_dpram_en_cpu),
			.o_wr_dpram_data(wr_dpram_data_cpu),
			.o_rd_dpram_en(rd_dpram_en_cpu),
			.i_rd_dpram_data(rd_dpram_data_b_up),
			.o_ac_addr(ac_addr),
			.o_wr_ac_en(wr_ac_en),
			.o_wr_ac_data(wr_ac_data),
			.i_rd_ac_data(rd_ac_data),
			.o_data_valid_int(data_valid_int),
			.o_recv_work_mode(recv_work_mode)
);
wire  [9:0]  ac_data_len;
wire  [8:0]  ac_addr;
wire         wr_ac_en;
wire  [15:0] wr_ac_data;
wire  [15:0] rd_ac_data;
wire safe_switch;
wire data_valid_int;
wire recv_work_mode;

nfrt_top nfrt_top(
			//Global signal
			.i_clk(i_clk),
			.i_clk_100(clk_100),
			.i_rst_n(i_rst_n),
			//emib
			//.i_local_ip(local_node_ip),//wangkai0351 for DHCP
			.i_local_ip(local_node_ip_DHCP),//wangkai0351 for DHCP
			.i_local_mac(local_node_mac),
			//recv data
			.i_recv_data(recv_MAC_data_from_A ? recv_data_A : (recv_MAC_data_from_B ? recv_data_B : 16'd0)),
			.i_data_valid(recv_MAC_data_from_A ? data_valid_A : (recv_MAC_data_from_B ? data_valid_B : 1'd0)),
			.i_recv_addr(recv_MAC_data_from_A ? recv_addr_A : (recv_MAC_data_from_B ? recv_addr_B : 10'd0)),
			//////////////////////////
			.i_macrocycle_b(macrocycle_b_up),                      //Modified by SYF 2014.5.27
			.i_ac_ip(ac_ip),
			.i_ac_send_en(ac_send_en),
			.i_out_data_len_local(ac_data_len),
			.i_nfrt_rd_addr_up(nfrt_rd_addr_up),
			.o_pdo_data(nfrt_data_up),
			.o_nfrt_len_up(nfrt_len_up),
			.i_ac_addr(ac_addr),
			.i_wr_ac_en(wr_ac_en),
			.i_wr_ac_data(wr_ac_data),
			.o_rd_ac_data(rd_ac_data)
);

endmodule