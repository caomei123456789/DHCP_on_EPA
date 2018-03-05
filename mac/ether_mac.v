/*******************************************************************
File name   :mii_interface.v
Function    :interfaces of mii_driver with csme or phy device
Author      :tongqing
Version     :V1.0
*******************************************************************/	
module ether_mac
(

 input wire i_clk,
 input wire i_rst_n,
 input wire [47:0] i_local_node_mac,

 input wire i_SendIrq,
 input wire [15:0] i_data_send,
 input wire [9:0] i_length,
 output wire [9:0] o_data_addr,
 output reg o_renew_pkg,

  input wire i_ErxDv,
  input wire [3:0] i_data_recv,
  output wire o_EtxEn,
  output wire [3:0] o_data_send,

 output wire [15:0] o_data_recv,
 output wire o_data_valid, 
 output wire [9:0] o_recv_addr,
 
 input wire i_csme_en,
 input wire  i_initDn,
// input wire i_main_clock_lost,
// input wire i_main_clock_state,
// input wire i_start_en

//20140224, gather
 input  wire i_send_alarm_to_pdo_A,
 input  wire i_send_alarm_to_pdo_B,
 input  wire i_pack_safe_A,
 input  wire i_pack_safe_B,
 input  wire [1:0]   i_port_id

);

//wire initDn;
wire sendDn;
wire recvEn;
//wire recvDn;
wire sendEn;
wire sendIdl;

reg [9:0] package_length;

wire SendIrq_rise;
reg  SendIrq_reg;
reg SendIrq_reg_dly;

		
/*********************************************************
 judge the package len.if the len is less than 60 bytes,
  then increase the len to 60 byte;otherwise,keep the len
*********************************************************/
always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
		package_length <= 10'h1e;
	else if ((i_length < 10'h1e)&& SendIrq_rise)
		package_length <= 10'h1e;
	else if ((i_length >= 10'h1e)&& SendIrq_rise)
		package_length <= i_length;
	else 
		package_length <= package_length;
end


always @ (posedge i_clk,negedge i_rst_n)
 begin
    if (!i_rst_n)
	 begin
		SendIrq_reg <= 1'b0;
		SendIrq_reg_dly <= 1'b0;	
	 end	
	else 
	begin
		SendIrq_reg <= i_SendIrq;
		SendIrq_reg_dly <= SendIrq_reg;
	end
end


assign   SendIrq_rise = !SendIrq_reg_dly && i_SendIrq; //rise!!
//assign   SendIrq_rise = i_SendIrq;//wangkai0351 for DHCP


/*******************************************************
  the signal "o_renew_pkg"=1 indicates a package has
  finished sending,to notice CSME to give a new package
********************************************************/
always @ (posedge i_clk,negedge i_rst_n)
begin
    if (!i_rst_n)
        o_renew_pkg <= 1'b0;
    else 
        o_renew_pkg <= sendIdl;
end

ethermac_send   send
(           .i_clk(i_clk),
            .i_rst_n(i_rst_n), 
				//.i_SendIrq(i_SendIrq),
            .i_SendIrq(SendIrq_rise),
            .i_data(i_data_send),
            .i_length(package_length),
            .o_sendDn(sendDn),
            .o_sendIdl(sendIdl),
            .o_data(o_data_send),
            .o_EtxEn(o_EtxEn),
            .o_data_addr(o_data_addr),
				.i_port_id(i_port_id)
);


ethermac_recv    recv(
		 .i_clk(i_clk),
		 .i_rst_n(i_rst_n), 
		 .i_local_node_mac(i_local_node_mac),
		 .i_data(i_data_recv), 
		 .i_ErxDv(i_ErxDv),

		 .o_data(o_data_recv),
		 .o_data_valid(o_data_valid),
		 .o_recv_addr(o_recv_addr),
		 
/************   sjj Nov_6th  ************/
       .i_length(package_length),
/************   sjj Nov_6th  ************/

		 .i_initDn(i_initDn),
		 .i_csme_en(i_csme_en),
//		 .i_main_clock_lost(i_main_clock_lost),
//		 .i_main_clock_state(i_main_clock_state),
//		 .i_start_en(i_start_en)

		 .i_send_alarm_to_pdo_A(i_send_alarm_to_pdo_A),
		 .i_send_alarm_to_pdo_B(i_send_alarm_to_pdo_B),
		 .i_pack_safe_A(i_pack_safe_A),
		 .i_pack_safe_B(i_pack_safe_B)
);


endmodule

